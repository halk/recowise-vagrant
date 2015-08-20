class zsh( $exec_path ) {
    # install zsh
    package { 'zsh':
        ensure => installed
    }

    # install git for oh my zsh
    package { 'git':
        ensure => present,
    }

    # clone oh my zsh
    exec { 'ohmyzsh::git clone':
        creates => '/home/vagrant/.oh-my-zsh',
        command => '/usr/bin/git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh',
        user    => 'vagrant'
    }

    file { '/home/vagrant/.zshrc':
        ensure  => file,
        content => template('zsh/zshrc.rb')
    }

    user { 'vagrant':
        ensure => present,
        shell  => '/bin/zsh'
    }
}