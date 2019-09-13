# frozen_string_literal: true

require "securerandom"

ELASTICSEARCH_VERSION = "6.8.3"
ELASTICSEARCH_MAJOR_VERSION = ELASTICSEARCH_VERSION.split(".").first
THEHIVE_VERSION = "3.4.0-1"
CORTEX_VERSION = "3.0.0-1"
JAVA_VERSION = "11"
JAVA_HOME = "/usr/lib/jvm/java-#{JAVA_VERSION}-openjdk-amd64/bin/"

execute "curl https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -" do
  not_if "apt-key list | grep Elasticsearch"
end
execute "curl https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY | sudo apt-key add -" do
  not_if "apt-key list | grep TheHive"
end

remote_file "/etc/apt/sources.list.d/elastic-#{ELASTICSEARCH_MAJOR_VERSION}.x.list"
remote_file "/etc/apt/sources.list.d/thehive-project.list"

execute "sudo apt install -y apt-transport-https"
execute "sudo apt-get update"
package "openjdk-#{JAVA_VERSION}-jre-headless"

# install elasticsearch
package "elasticsearch" do
  version ELASTICSEARCH_VERSION
end

remote_file "/etc/elasticsearch/elasticsearch.yml"

file "/etc/environment" do
  action :edit
  block do |content|
    unless content =~ /^JAVA_HOME/
      content << "JAVA_HOME=\"#{JAVA_HOME}\"\n"
    end
  end
end

execute "JAVA_HOME=#{JAVA_HOME}" do
  not_if "echo $JAVA_HOME | grep openjdk"
end

# install thehive & cortex
package "thehive" do
  version THEHIVE_VERSION
end
package "cortex" do
  version CORTEX_VERSION
end

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
execute "sudo chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/"
execute "sudo chown -R thehive:thehive /etc/thehive"
execute "sudo chown -R thehive:thehive /opt/thehive"
execute "sudo chown -R cortex:cortex /etc/cortex"
execute "sudo chown -R cortex:cortex /opt/cortex"

# enable services
execute "sudo systemctl daemon-reload"
%w[elasticsearch cortex thehive].each do |name|
  execute "sudo systemctl enable #{name}"
  execute "sudo systemctl start #{name}"
end
