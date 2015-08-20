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

    exec { 'install pip':
        unless  => 'which pip',
        command => 'easy_install -U pip',
        require => Package['python-setuptools']
    }

    python::pip { 'install virtualenvwrapper':
        pkgname => 'virtualenvwrapper',
        ensure  => 'present',
        require => Exec['install pip']
    }

    exec { 'mkvirtualenv':
        unless      => 'ls /home/vagrant/.virtualenvs/framework',
        cwd         => '/vagrant/framework',
        command     => "bash -c 'source /usr/local/bin/virtualenvwrapper.sh && mkvirtualenv framework'",
        environment => 'WORKON_HOME=/home/vagrant/.virtualenvs',
        user        => 'vagrant',
        require     => Python::Pip['install virtualenvwrapper']
    }

    exec { 'install pip requirements':
        unless      => 'ls /home/vagrant/.virtualenvs/framework/bin/celery',
        cwd         => '/vagrant/framework',
        command     => "bash -c 'source /usr/local/bin/virtualenvwrapper.sh && workon framework && pip install -r requirements.txt'",
        environment => 'WORKON_HOME=/home/vagrant/.virtualenvs',
        user        => 'vagrant',
        require     => [Package['libxml2-dev'], Package['libxslt1-dev'], Exec['mkvirtualenv']]
    }

    file { '/vagrant/framework/config/config.xml':
        ensure => 'present',
        source => '/vagrant/framework/config/config.xml.dist',
        owner => 'vagrant',
        group => 'vagrant'
    }
}
