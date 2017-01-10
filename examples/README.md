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
