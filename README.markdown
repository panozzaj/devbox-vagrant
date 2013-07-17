# devbox-vagrant

This is my first pass at a repeatable method to create a solid dev environment on AWS. This readme is part reminder to myself, part blog post, part explanation of several technologies.

# Overview

The goal is to be able to create or rebuild a development-friendly box on demand.

Currently we're using:

 - [vagrant](https://github.com/mitchellh/vagrant) to manage the box creation with:
    - [vagrant-aws](https://github.com/mitchellh/vagrant-aws)
    - [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus)
 - [chef-solo](http://docs.opscode.com/chef_solo.html) for provisioning (installing things on the box)
 - [Berkshelf](https://github.com/RiotGames/berkshelf) (think Bundler for Chef - manages package dependencies and versions)

The nice thing with this setup is that we can create boxes locally and run them with Virtualbox and SSH in to see how things are working. When the setup seems to be working, we can spin up an EC2 instance of a similarly configured box with basically no effort.

# Usage

You'll probably need to have bundler and some kind of ruby with rvm installed. Run `bundle`.

Next, run `berks install --path cookbooks` to get the chef packages downloaded locally. To install cookbooks from the internet, manage them in the `Berksfile`. Looks very close to Bundler.

Now, you can run `vagrant up` to create a new box from the Vagrantfile in a VM that Virtualbox runs.

For Vagrantfile changes, you can run `vagrant provision` to make any necessary changes.

When happy, you can run `vagrant up --provider=aws` to create a box using AWS.

When you want to shut down the box, `vagrant destroy`. You can't currently `vagrant halt` an AWS-provisioned box, but you can do this for a VM instead of destroying it. Be sure to shut down EC2 instances or be charged for them.

## Random

One thing that threw me about vagrant-aws was that the keypair that I needed to create was in the main AWS console, not in my security settings.

Installing everything I need for every project seems like overkill. It might be nice to have one base box that has the absolute essentials, and then extend it with project-specific stuff. [veewee](https://github.com/jedi4ever/veewee) looks like an interesting project for building boxes. [This looks like a good example](http://seletz.github.io/blog/2012/01/17/creating-vagrant-base-boxes-with-veewee/). One of the downsides appears to be a larger base box size, but it might be worth it and I might be mistaken.
