# See examples/README.md to see how to build and run this

FROM ubuntu:16.04

# Uncomment & edit the next 3 lines if you're behind a proxy:
# ENV http_proxy="http://proxy.example.com:8080"
# ENV https_proxy=${http_proxy}
# ENV no_proxy="localhost,127.0.0.1"
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/chef/bin:/opt/chef/embedded/bin \
    APT_ARGS="-y --no-install-recommends --no-upgrade" \

# Install chef-client
RUN DEBIAN_FRONTEND=noninteractive \ 
    apt-get update -y && \
    apt-get install $APT_ARGS \
      ca-certificates \
      curl && \
    curl -L --progress-bar https://www.chef.io/chef/install.sh | bash -s -- -P chefdk

# Some optional but recommended packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install $APT_ARGS \
    git \
    vim \
    unzip \

# RUN curl -LO https://omnitruck.chef.io/install.sh && bash ./install.sh -P chefdk && rm install.sh
RUN chef gem install oneview-sdk --no-document # Ignore the warning about the path not containing gem executables

RUN mkdir -p /chef-repo/.chef
RUN mkdir -p /chef-repo/cookbooks
RUN echo 'cookbook_path ["#{File.dirname(__FILE__)}/../cookbooks"]' > .chef/knife.rb
WORKDIR /chef-repo/cookbooks/
RUN knife cookbook site download compat_resource
RUN tar -xzf compat_resource-*.tar.gz && rm compat_resource*.tar.gz
RUN git clone https://github.com/HewlettPackard/oneview-chef oneview
WORKDIR /chef-repo/cookbooks/oneview
RUN gem install bundler --force
RUN bundle install
RUN mkdir -p /recipes
ENV ONEVIEWSDK_SSL_ENABLED=false
RUN cp -r /examples/image_streamer/*.rb oneview/recipes/
RUN cp -r /examples/*.rb oneview/recipes/

# Clean and remove not required packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get autoremove -y && \
    rm -rf /var/cache/apt/archives/*

CMD "/bin/bash"

# When you run this image, you'll need to set the following environment variables:
# ONEVIEWSDK_URL
# ONEVIEWSDK_USER
# ONEVIEWSDK_PASSWORD

# And if you're running Image Streamer examples, you'll need to set this too:
# I3S_URL
