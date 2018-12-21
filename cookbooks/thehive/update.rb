execute 'sudo apt-get update'

%w[cortex thehive].each do |name|
  package name
end

remote_file '/usr/lib/systemd/system/thehive.service'

execute 'sudo systemctl daemon-reload'
%w[cortex thehive].each do |name|
  execute "sudo systemctl enable #{name}"
  execute "sudo systemctl start #{name}"
end
