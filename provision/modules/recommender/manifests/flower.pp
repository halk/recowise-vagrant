class recommender::flower {
    apache::vhost { 'flower.msc.koklu.me':
        docroot                => '/vagrant/framework',
        port                   => 80,
        manage_docroot         => false,
        redirect_source        => ['/'],
        redirect_dest          => ['http://flower.msc.koklu.me:5555/'],
        redirect_status        => ['permanent'],
        require                => Exec['install pip requirements']
    }

    supervisord::program { 'flower':
        command     => '/home/vagrant/.virtualenvs/framework/bin/flower --port=5555 -A worker --broker=amqp://framework:framework@localhost:5672/framework',
        directory   => '/vagrant/framework',
        priority    => 100,
        user        => 'vagrant',
        environment => {
            'HOME' => '/home/vagrant',
            'PATH' => join(['/home/vagrant/.virtualenvs/framework/bin:', hiera('zsh::exec_path')])
        },
        stdout_logfile => '/vagrant/framework/log/flower.log',
        stderr_logfile => '/vagrant/framework/log/flower.err',
        require     => Apache::Vhost['flower.msc.koklu.me']
    }
}
