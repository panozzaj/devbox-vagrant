# see http://nickcharlton.net/posts/test-environments-with-vagrant-and-chef.html

dotfiles = node['dotfiles']

home_dir = "/home/#{dotfiles['user']}"

repo_url = dotfiles['repo_url']
user = dotfiles['user']
group = dotfiles['group']
dotfiles_directory_name = dotfiles['dotfiles_directory_name']

# pull down dotfiles
git "#{home_dir}/#{dotfiles_directory_name}" do
  repository repo_url
  reference "master"
  #enable_submodules true
  user user
  group group
  action :checkout
end

# For some reason, the Chef git recipe decides to check out
# master in a detached head, which causes any changes that
# we make that we want to push up not quite work right.
# So check out the master branch
bash "Ensure we have master of dotfiles" do
  cwd File.join(home_dir, dotfiles_directory_name)
  user user
  group group
  code "git checkout master"
end

script_name = "#{dotfiles_directory_name}/#{dotfiles['setup_script_name']}"
bash "Run dotfile setup script" do
  cwd home_dir
  user user
  group group
  code "./#{script_name} '#{dotfiles['platform']}' '#{dotfiles['host']}'"
end
