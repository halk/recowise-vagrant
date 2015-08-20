class recommender::engines {
    # in common

    file { '/usr/local/src/go':
        ensure => 'directory',
        owner => 'vagrant',
        group => 'vagrant'
    }

    file { '/usr/local/src/go/bin':
        ensure => 'directory',
        owner => 'vagrant',
        group => 'vagrant'
    }

    file { ['/usr/local/src/go/src', '/usr/local/src/go/src/github.com', '/usr/local/src/go/src/github.com/halk']:
        ensure => 'directory',
        owner => 'vagrant',
        group => 'vagrant'
    }

    file { '/usr/local/src/go/src/github.com/halk/in-common':
        ensure => link,
        target => '/vagrant/engines/inCommon',
        owner => 'vagrant',
        group => 'vagrant'
    }

    exec { 'install-gom':
        unless  => 'which gom',
        command => 'go get github.com/mattn/gom',
        require => File['/usr/local/src/go/src/github.com/halk/in-common']
    }

    exec { 'gom-install':
        unless  => 'test -d _vendor',
        cwd     => '/vagrant/engines/inCommon',
        command => 'gom install',
        require => Exec['install-gom']
    }

    supervisord::program { 'inCommon':
        command     => '/bin/bash run.sh',
        directory   => '/vagrant/engines/inCommon',
        priority    => 100,
        user        => 'vagrant',
        environment => {
            'HOME'   => '/home/vagrant',
            'PATH'   => hiera('zsh::exec_path'),
            'GOPATH' => '/usr/local/src/go'
        },
        stdout_logfile => '/vagrant/engines/inCommon/log/inCommon.log',
        stderr_logfile => '/vagrant/engines/inCommon/log/inCommon.err',
        require     => File['/usr/local/src/go/src/github.com/halk/in-common'],
        stopasgroup => true
    }

    # item similarity

    exec { 'itemSimilarity-composer-install':
        unless  => 'ls /vagrant/engines/itemSimilarity/vendor',
        cwd     => '/vagrant/engines/itemSimilarity',
        command => "/usr/local/bin/composer install",
        user    => 'vagrant',
        environment => 'HOME=/home/vagrant',
        creates => '/vagrant/engines/itemSimilarity/vendor'
    }

    file { '/vagrant/engines/itemSimilarity/config/config.php':
        ensure => 'present',
        source => '/vagrant/engines/itemSimilarity/config/config.php.dist',
        owner => 'vagrant',
        group => 'vagrant'
    }

    file { '/vagrant/engines/itemSimilarity/phpunit.xml':
        ensure => 'present',
        source => '/vagrant/engines/itemSimilarity/phpunit.xml.dist',
        owner => 'vagrant',
        group => 'vagrant'
    }

    apache::vhost { 'itemsimilarity.msc.koklu.me':
        docroot         => '/vagrant/engines/itemSimilarity/web',
        default_vhost   => true,
        port            => 80,
        override        => 'all',
        custom_fragment => "\tProxyPassMatch ^/(.*\\.php(/.*)?)$ fcgi://127.0.0.1:9000/vagrant/engines/itemSimilarity/web/$1",
        manage_docroot  => false
    }
}
