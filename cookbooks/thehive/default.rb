# frozen_string_literal: true

require "securerandom"

remote_file "/etc/apt/sources.list.d/elastic-5.x.list"
remote_file "/etc/apt/sources.list.d/thehive-project.list"

# install jvm
execute "sudo add-apt-repository -y ppa:openjdk-r/ppa"
execute "sudo apt-get update"
package "openjdk-8-jre-headless"

# install elasticsearch
execute "sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key D88E42B4"
execute "sudo apt install -y apt-transport-https"
execute "sudo apt-get update"
package "elasticsearch"

remote_file "/etc/elasticsearch/elasticsearch.yml"

# install thehive & cortex
execute "curl https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY | sudo apt-key add -"
execute "sudo apt-get update"
package "thehive"
package "cortex"

template "/etc/thehive/application.conf" do
  variables(secret: SecureRandom.hex)
end

template "/etc/cortex/application.conf" do
  variables(secret: SecureRandom.hex)
end

# install cortex analyzers
"python-pip python2.7-dev python3-pip python3-dev ssdeep libfuzzy-dev libfuzzy2 libimage-exiftool-perl libmagic1 build-essential git libssl-dev".split.each do |name|
  package name
end

execute "sudo pip install -U pip setuptools && sudo pip3 install -U pip setuptools"

git "/opt/cortex/Cortex-Analyzers" do
  repository "https://github.com/CERT-BDF/Cortex-Analyzers"
end

execute "install analyzers" do
  cwd "/opt/cortex/"
  command 'for I in $(find Cortex-Analyzers -name "requirements.txt"); do sudo -H pip2 install -r $I; done'
  command 'for I in $(find Cortex-Analyzers -name "requirements.txt"); do sudo -H pip3 install -r $I || true; done'
end

# set proper user:group
execute "sudo chown -R elasticsearch:elasticsearch /etc/elasticsearch/"
execute "sudo chown -R thehive:thehive /etc/thehive"
execute "sudo chown -R thehive:thehive /opt/thehive"
execute "sudo chown -R cortex:cortex /etc/cortex"
execute "sudo chown -R cortex:cortex /opt/cortex"

execute "sudo systemctl daemon-reload"
%w[elasticsearch cortex thehive].each do |name|
  execute "sudo systemctl enable #{name}"
  execute "sudo systemctl start #{name}"
end
