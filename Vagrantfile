# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'pathname'

$dir = File.dirname(File.expand_path(__FILE__))

configValues = YAML.load_file("#{$dir}/provision/config.yaml")
data         = configValues['vagrantfile-local']

def box_url(config, data, provider)
    # detect local boxes (required for MSc DVD submission)
    local_box = sprintf('%s/../Virtual Machine/recowise_%s_%s.box', $dir, provider, data['vm']['box_version'])

    if File.exists? local_box
        config.vm.box_url = local_box
    # use boxes on Atlas
    else
        config.vm.box_url = "#{data['vm']['box_url']}"
        config.vm.box_version = "#{data['vm']['box_version']}"
    end
end

Vagrant.configure('2') do |config|
    config.vm.box     = "#{data['vm']['box']}"

    config.vm.network :private_network, ip: "#{data['vm']['network']['private_network']}"

    if data['vm']['network']['forwarded_port']
        data['vm']['network']['forwarded_port'].each do |i, port|
            if port['guest'] != '' && port['host'] != ''
                config.vm.network :forwarded_port, guest: port['guest'].to_i, host: port['host'].to_i
            end
        end
    end

    config.vm.provider :virtualbox do |virtualbox|
        box_url(config, data, 'virtualbox')
        virtualbox.customize ['modifyvm', :id, '--memory', "#{data['vm']['memory']}"]
        virtualbox.customize ['modifyvm', :id, '--cpus',   "#{data['vm']['cpus']}"]
        virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    config.vm.provider :vmware_fusion do |vmware, override|
        box_url(config, data, 'vmware_fusion')
        vmware.vmx['displayName'] = config.vm.box
        vmware.vmx['memsize']     = "#{data['vm']['memory']}"
        vmware.vmx['numvcpus']    = "#{data['vm']['cpus']}"
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
