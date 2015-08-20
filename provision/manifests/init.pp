# set default path for execution
Exec { path => hiera('zsh::exec_path') }

# set DNS entries locally to speed up resolution
host { 'msc.koklu.me':
  ensure => 'present',
  host_aliases => [
    'magento.msc.koklu.me', 'itemsimilarity.msc.koklu.me',
    'flower.msc.koklu.me', 'api.msc.koklu.me'
  ],
  ip => '127.0.0.1'
}

# required for PPAs
package { 'software-properties-common':
    ensure => 'present'
}

# modules
include apt
include apache
include hiera2define
include golang
include magento
include '::mongodb::server'
include neo4j
include percona
include php
include python
include rabbitmq
include recommender
include redis
include ruby
include supervisord
include timezone
include vim
include zsh

# specify dependency tree
Class['apt']
    -> Class['apache']
    -> Class['hiera2define']
    -> Class['percona']
    -> Class['php']
    -> Class['ruby']
    -> Class['rabbitmq']
    -> Class['recommender']
    -> Class['magento']
