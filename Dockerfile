# See examples/README.md to see how to build and run this

FROM ubuntu:18.04

# Uncomment & edit the next 3 lines if you're behind a proxy:
# ENV http_proxy="http://proxy.example.com:8080"
# ENV https_proxy=${http_proxy}
# ENV no_proxy="localhost,127.0.0.1"
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/chef/bin:/opt/chef/embedded/bin"

# Install chef-client
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -y && \
    apt-get install -y --no-install-recommends --no-upgrade && \
    apt-get install -y ca-certificates curl git vim bash openssl && \
    apt-get install -y ruby-dev && \
    apt-get install -y gcc make && \
    curl -L --progress-bar https://www.chef.io/chef/install.sh | bash -s -- -v 13.12.3

# Some optional but recommended packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends --no-upgrade \
    # apt-get autoremove -y \
    git \
    vim \
    unzip

RUN gem install oneview-sdk # Ignore the warning about the path not containing gem executables

RUN mkdir -p /chef-repo/.chef/
RUN mkdir -p /chef-repo/cookbooks
WORKDIR /chef-repo
RUN touch knife.rb
RUN echo 'cookbook_path ["#{File.dirname(__FILE__)}/../cookbooks"]' > .chef/knife.rb
WORKDIR /chef-repo/cookbooks/
RUN knife cookbook site download compat_resource --force
RUN tar -xzf compat_resource-*.tar.gz && rm compat_resource*.tar.gz
RUN git clone https://github.com/HewlettPackard/oneview-chef.git oneview
WORKDIR /chef-repo/cookbooks/oneview/
RUN gem install bundler --force
# RUN gem install nokogiri -v 1.6.7.1
# RUN gem install foodcritic
# RUN bundle install
RUN mkdir recipes
ENV ONEVIEWSDK_SSL_ENABLED=false
RUN cp -r examples/image_streamer/*.rb recipes/
RUN cp -r examples/*.rb recipes/

# Clean and remove not required packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/cache/apt/archives/* /var/cache/apt/lists/* /tmp/* /root/cache/.

CMD "/bin/bash"

# When you run this image, you'll need to set the following environment variables:
# ONEVIEWSDK_URL
# ONEVIEWSDK_USER
# ONEVIEWSDK_PASSWORD

# And if you're running Image Streamer examples, you'll need to set this too:
# I3S_URL
