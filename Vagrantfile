# -*- mode: ruby -*-
# vi: set ft=ruby :
ES_PORT     = ENV["ES_PORT"]     || 9292
KIBANA_PORT = ENV["KIBANA_PORT"] || 5555
TD_PORT     = ENV["TD_PORT"]     || 24224

Vagrant.configure("2") do |config|
  config.vm.box     = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  [ES_PORT, KIBANA_PORT, TD_PORT].each do |port|
    config.vm.network "forwarded_port", guest: port, host: port
  end

  config.vm.provision "docker" do |d|
    d.run "elasticsearch",
          image: "arcus/elasticsearch",
          args:  "-name elasticsearch -p #{ES_PORT}:9200"
    d.run "kibana",
          image: "arcus/kibana",
          args:  "-name kibana -p #{KIBANA_PORT}:80 -e ES_PORT=#{ES_PORT} -e ES_HOST=localhost"
  end

  config.vm.provision "shell", inline: "cd /vagrant && docker build -t td-agent ."

  config.vm.provision "docker" do |d|
    d.run "td-agent",
          image: "td-agent",
          args:  "-name td-agent -p #{TD_PORT}:24224 -link elasticsearch:es"
  end
end
