# encoding: utf-8

# the plugin that enables us to run on AWS
Vagrant.require_plugin "vagrant-aws"

# "A Vagrant plugin that ensures the desired version of Chef is installed
# via the platform-specific Omnibus packages. This proves very useful when
# using Vagrant with provisioner-less baseboxes OR cloud images."
Vagrant.require_plugin "vagrant-omnibus"

Vagrant.configure("2") do |config|
  # bootstrap chef on the vagrant box
  config.omnibus.chef_version = :latest

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.ssh.forward_agent = true

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe :apt

    # databases
    chef.add_recipe 'mysql::server'
    chef.add_recipe 'postgresql::server'
    chef.add_recipe 'sqlite'

    # version control systems
    chef.add_recipe 'mercurial'
    chef.add_recipe 'git'
    chef.add_recipe 'subversion'

    # dev tools
    chef.add_recipe 'vim'
    #chef.add_recipe 'rvm::vagrant'
    #chef.add_recipe 'rvm::system'

    chef.json = {
      mysql: {
        server_root_password: "password",
        server_repl_password: "password",
        server_debian_password: "password",
        service_name: "mysql",
        basedir: "/usr",
        data_dir: "/var/lib/mysql",
        root_group: "root",
        mysqladmin_bin: "/usr/bin/mysqladmin",
        mysql_bin: "/usr/bin/mysql",
        conf_dir: "/etc/mysql",
        confd_dir: "/etc/mysql/conf.d",
        socket: "/var/run/mysqld/mysqld.sock",
        pid_file: "/var/run/mysqld/mysqld.pid",
        grants_path: "/etc/mysql/grants.sql"
      },
      subversion: {
        repo_dir: "/srv/svn",
        repo_name: "repo",
        server_name: "svn",
        user: "subversion",
        password: "subversion"
      },
      #rbenv: {
      #  user_installs: [
      #    {
      #      user: "vagrant",
      #      rubies: [
      #        "1.9.3-p392",
      #        "2.0.0-p0"
      #      ],
      #      global: "1.9.3-p392"
      #    }
      #  ]
      #},
      git: {
        prefix: "/usr/local"
      },
      postgresql: {
        config: {
          listen_addresses: "*",
          port: "5432"
        },
        pg_hba: [
          {
            type: "local",
            db: "postgres",
            user: "postgres",
            addr: nil,
            method: "trust"
          },
          {
            type: "host",
            db: "all",
            user: "all",
            addr: "0.0.0.0/0",
            method: "md5"
          },
          {
            type: "host",
            db: "all",
            user: "all",
            addr: "::1/0",
            method: "md5"
          }
        ],
        password: {
          postgres: "password"
        }
      }
    }
  end

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = "vagrant-dev-box-1"

    aws.ami = "ami-7747d01e"

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = './vagrant-dev-box-1.pem'
  end
end
