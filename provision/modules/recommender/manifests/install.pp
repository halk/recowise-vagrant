class recommender::install {
    package { 'python-setuptools':
        ensure => 'present'
    }

    package { 'libxml2-dev':
        ensure => 'present'
    }

    package { 'libxslt1-dev':
        ensure => 'present'
    }

    python::virtualenv { '/vagrant/framework':
        ensure  => 'present',
        version => 'system',
        requirements => '/vagrant/framework/requirements.txt',
        venv_dir => '/home/vagrant/.virtualenvs/framework',
        owner => 'vagrant',
        group => 'vagrant',
        cwd => '/vagrant/framework'
    }

    file { '/vagrant/framework/config/config.xml':
        ensure => 'present',
        source => '/vagrant/framework/config/config.xml.dist',
        owner => 'vagrant',
        group => 'vagrant'
    }
}
