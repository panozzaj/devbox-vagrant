# see http://nickcharlton.net/posts/test-environments-with-vagrant-and-chef.html

dotfiles = node['dotfiles']

home_dir = "/home/#{dotfiles['user']}"

# pull down dotfiles
repo_url = dotfiles['repo_url']
user = dotfiles['user']
group = dotfiles['group']
dotfiles_directory_name = dotfiles['dotfiles_directory_name']

git "#{home_dir}/#{dotfiles_directory_name}" do
  repository repo_url
  reference "master"
  enable_submodules true
  user user
  group group
  action :checkout
end

script_name = "#{dotfiles_directory_name}/#{dotfiles['setup_script_name']}"
bash "Run dotfile setup script" do
  cwd home_dir
  user user
  group group
  code "./#{script_name} '#{dotfiles['platform']}' '#{dotfiles['host']}'"
end
