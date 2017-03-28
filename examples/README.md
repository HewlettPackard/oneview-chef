# Examples
The examples in this directory are meant to be used as a reference for your own cookbook(s). Some examples are directly lift-able, but others may require modifications to make them work in your environment.

### Getting started
If you're new to Chef and interrested in running some examples but don't know how, here's what you'll need to do:

1. Download and install the [ChefDK package](https://downloads.chef.io/chefdk)
2. Create a chef-repo directory and cd into it:
   ```bash
   $ mkdir chef-repo
   $ cd chef-repo
   ```

3. Create a cookbooks directory and download the oneview cookbook into it:
   ```bash
   $ mkdir cookbooks
   $ cd cookbooks
   $ git clone https://github.com/HewlettPackard/oneview-chef.git oneview

   # You'll also need the compat_resource cookbook:
   $ knife cookbook site download compat_resource
   $ tar -xvzf compat_resource-*.tar.gz
   ```

4. Create a wrapper cookbook named "my_oneview" and copy the examples into it:
   ```bash
   $ chef generate cookbook my_oneview
   $ echo "depends 'oneview'" >> my_oneview/metadata.rb
   $ cp -r oneview/examples/*.rb my_oneview/recipes/
   ```

5. Create a knife.rb file to tell Chef where to find your cookbooks:
   ```bash
   $ cd ..
   # Should now be in the chef-repo directory

   $ mkdir .chef
   $ echo 'cookbook_path ["#{File.dirname(__FILE__)}/../cookbooks"]' > .chef/knife.rb
   ```

6. Set your OneView credentials in the environment variables:
   ```bash
   # (Replace the following with your OneView URL and credentials)
   $ export ONEVIEWSDK_URL="https://my-oneview.example.com"
   $ export ONEVIEWSDK_USER="Administrator"
   $ export ONEVIEWSDK_PASSWORD="Password123"

   # And if you want to turn off SSL (because of self-signed certs)
   $ export ONEVIEWSDK_SSL_ENABLED=false
   ```

7. Run the Chef client and specify an example recipe to execute:
   ```bash
   # Description of options:
   #  -z : Run chef-client in zero mode (aka local-mode)
   #  -o : Override the runlist, specifying a specific recipe to run
   #       (Replace "connection_template" with the name of the recipe you'd like to run)
   $ chef-client -z -o my_oneview::connection_template
   ```

### Running Examples with Docker
If you'd rather run the examples in a Docker container, you can use the Dockerfile at the top level of this repo.
All you need is Docker and git (optional).

1. Clone this repo and cd into it:
   ```bash
   $ git clone https://github.com/HewlettPackard/oneview-chef.git
   $ cd oneview-chef
   ```

   Note: You can navigate to the repo url and download the repo as a zip file if you don't want to use git

2. Build the docker image: `$ docker build -t chef-oneview .`

   Note: If you're behind a proxy, please edit the Dockerfile before building, uncommenting/adding the necessary ENV directives for your environment.

3. Now you can run any of the example recipes in this directory:
   ```bash
   # Run the container, passing in your credentials to OneView and specifying which example recipe to run.
   # Description of chef-client options:
   #  -z : Run chef-client in zero mode (aka local-mode)
   #  -o : Override the runlist, specifying a specific recipe to run
   #       (Replace "connection_template" with the name of the recipe you'd like to run)
   $ docker run -it \
     -e ONEVIEWSDK_URL='https://ov.example.com' \
     -e ONEVIEWSDK_USER='Administrator' \
     -e ONEVIEWSDK_PASSWORD='secret123' \
     chef-oneview chef-client -z -o oneview::connection_template
   ```

   The Image Streamer examples are flattened into the same cookbook, so to run an Image Streamer example recipe:
   ```bash
   # Note that we need an additional (I3S_URL) environment variable set
   # (Replace "plan_script" with the name of the recipe you'd like to run)
   $ docker run -it \
     -e ONEVIEWSDK_URL='https://ov.example.com' \
     -e ONEVIEWSDK_USER='Administrator' \
     -e ONEVIEWSDK_PASSWORD='secret123' \
     -e I3S_URL='https://i3s.example.com' \
     chef-oneview chef-client -z -o oneview::plan_script
   ```

That's it! If you'd like to modify a recipe, simply modify the recipe file (on the host), then re-build the image and run it.
