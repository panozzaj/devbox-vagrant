#puts 'here in demo default recipe'
#puts `ssh-keyscan -t rsa,dsa HOST 2>&1 | sort -u - ~/.ssh/known_hosts > ~/.ssh/tmp_hosts`
#puts `cat ~/.ssh/tmp_hosts >> ~/.ssh/known_hosts`
##`ssh-keyscan -H github.com,207.97.227.239 > /home/vagrant/.ssh/known_hosts`
#`cd ~`
#`git clone --recursive git@github.com:panozzaj/conf.git`

execute "git clone git@github.com:panozzaj/conf.git" do
  cwd node[:devstack][:dir]
  user node[:devstack][:user]
  group node[:devstack][:group]
  not_if { File.directory?("#{node[:devstack][:dir]}/devstack") }
end
