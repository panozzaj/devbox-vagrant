# encoding: utf-8

# the plugin that enables us to run on AWS
Vagrant.require_plugin 'vagrant-aws'

# "A Vagrant plugin that ensures the desired version of Chef is installed
# via the platform-specific Omnibus packages. This proves very useful when
# using Vagrant with provisioner-less baseboxes OR cloud images."
#Vagrant.require_plugin 'vagrant-omnibus'

Vagrant.configure('2') do |config|
  # bootstrap chef on the vagrant box
  #config.omnibus.chef_version = :latest

  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  config.vm.network :forwarded_port, guest: 3000, host: 33000

  # use our local SSH keys on the guest box
  # this is nice for pulling down Github stuff, etc.
  config.ssh.forward_agent = true

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = 'vagrant-dev-box-1'

    aws.ami = 'ami-7747d01e'

    override.ssh.username = 'ubuntu'
    override.ssh.private_key_path = './vagrant-dev-box-1.pem'
  end

  # see https://github.com/mitchellh/vagrant/issues/1303
  config.vm.provision :shell do |shell|
    shell.inline = "touch $1 && chmod 0440 $1 && echo $2 > $1"
    shell.args = %q{/etc/sudoers.d/root_ssh_agent "Defaults    env_keep += \"SSH_AUTH_SOCK\""}
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['cookbooks', 'my_cookbooks']
    chef.data_bags_path = "data_bags"

    # Adding recipes
    #chef.add_recipe 'apt'

    # generally useful for building software
    #chef.add_recipe 'build-essential'

    # my preferred shell
    #chef.add_recipe 'zsh'

    # databases
    #chef.add_recipe 'mysql::server'
    #chef.add_recipe 'postgresql::server'
    #chef.add_recipe 'sqlite'

    # version control systems
    chef.add_recipe 'git'

    # dev tools
    #chef.add_recipe 'vim'
    #chef.add_recipe 'rvm'
    #chef.add_recipe 'rvm::vagrant'
    #chef.add_recipe 'rvm::system'

    # custom recipes
    chef.add_recipe 'ssh_known_hosts'
    #chef.add_recipe 'demo'
    chef.add_recipe 'dotfiles'
    chef.add_recipe 'change_shell'

    chef.json = {
      dotfiles: {
        group: 'vagrant',
        host: 'precise64',
        repo_url: 'git@github.com:panozzaj/conf.git',
        dotfiles_directory_name: 'conf',
        platform: 'ubuntu-12.04',
        setup_script_name: 'setup',
        user: 'vagrant'
      },
      git: {
        prefix: "/usr/local"
      },
      mysql: {
        basedir: "/usr",
        conf_dir: "/etc/mysql",
        confd_dir: "/etc/mysql/conf.d",
        data_dir: "/var/lib/mysql",
        grants_path: "/etc/mysql/grants.sql",
        mysql_bin: "/usr/bin/mysql",
        mysqladmin_bin: "/usr/bin/mysqladmin",
        pid_file: "/var/run/mysqld/mysqld.pid",
        root_group: "root",
        server_debian_password: "password",
        server_repl_password: "password",
        server_root_password: "password",
        service_name: "mysql",
        socket: "/var/run/mysqld/mysqld.sock"
      },
      postgresql: {
        config: {
          listen_addresses: "*",
          port: "5432"
        },
        password: {
          postgres: "password"
        },
        pg_hba: [{
            addr: nil,
            db: "postgres",
            method: "trust",
            type: "local",
            user: "postgres"
          }, {
            addr: "0.0.0.0/0",
            db: "all",
            method: "md5",
            type: "host",
            user: "all"
          }, {
            addr: "::1/0",
            db: "all",
            method: "md5",
            type: "host",
            user: "all"
          }
        ]
      },
      rvm: {
        rubies:      ['2.0.0'],
        default_ruby: '2.0.0',
        global_gems:  [
          { name: 'bundler' },
          { name: 'rake' }
        ]
      }
    } # end chef.json
  end
end
