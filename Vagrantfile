# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

dir = File.dirname(File.expand_path(__FILE__))

configValues = YAML.load_file("#{dir}/provision/config.yaml")
data         = configValues['vagrantfile-local']

Vagrant.configure('2') do |config|
    config.vm.box     = "#{data['vm']['box']}"
    config.vm.box_url = "#{data['vm']['box_url']}"
    config.vm.box_version = "#{data['vm']['box_version']}"

    config.vm.network :private_network, ip: "#{data['vm']['network']['private_network']}"

    if data['vm']['network']['forwarded_port']
        data['vm']['network']['forwarded_port'].each do |i, port|
            if port['guest'] != '' && port['host'] != ''
                config.vm.network :forwarded_port, guest: port['guest'].to_i, host: port['host'].to_i
            end
        end
    end

    if data['vm']['provider']['chosen'].empty? || data['vm']['provider']['chosen'] == 'virtualbox'
        ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'
        config.vm.provider :virtualbox do |virtualbox|
            virtualbox.customize ["modifyvm", :id, "--name",   "#{data['vm']['box']}"]
            virtualbox.customize ['modifyvm', :id, '--memory', "#{data['vm']['memory']}"]
            virtualbox.customize ['modifyvm', :id, '--cpus',   "#{data['vm']['cpus']}"]
            virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "#{data['vm']['provider']['virtualbox']['modifyvm']['natdnshostresolver1']}"]
        end
    end

    if data['vm']['provider']['chosen'] == 'vmware'
        ENV['VAGRANT_DEFAULT_PROVIDER'] = 'vmware_fusion'

        config.vm.provider :vmware_fusion do |vmware, override|
            vmware.vmx['displayName'] = config.vm.box
            vmware.vmx['memsize']     = "#{data['vm']['memory']}"
            vmware.vmx['numvcpus']    = "#{data['vm']['cpus']}"
        end
    end

    config.vm.provision :puppet do |puppet|
        puppet.facter = {
            'provisioner_type' => ENV['VAGRANT_DEFAULT_PROVIDER'],
            'vm_target_key'    => 'vagrantfile-local'
        }
        puppet.manifests_path = "#{data['vm']['provision']['puppet']['manifests_path']}"
        puppet.manifest_file  = "#{data['vm']['provision']['puppet']['manifest_file']}"
        puppet.module_path    = "#{data['vm']['provision']['puppet']['module_path']}"

        if !data['vm']['provision']['puppet']['options'].empty?
          puppet.options = data['vm']['provision']['puppet']['options']
        end
  end
end
