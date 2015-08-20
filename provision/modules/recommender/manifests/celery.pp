class recommender::celery {
    rabbitmq_user { 'framework':
        admin    => true,
        password => 'framework'
    }

    rabbitmq_vhost { 'framework':
        ensure  => 'present',
        require => Rabbitmq_user['framework']
    }

    rabbitmq_user_permissions { 'framework@framework':
        configure_permission => '.*',
        read_permission      => '.*',
        write_permission     => '.*',
        require              => Rabbitmq_vhost['framework']
    }

    supervisord::program { 'celery.event':
        command     => '/home/vagrant/.virtualenvs/framework/bin/celery worker -A worker.event -n event -Q event --loglevel=INFO --broker=amqp://framework:framework@localhost:5672/framework',
        directory   => '/vagrant/framework',
        priority    => 200,
        user        => 'vagrant',
        environment => {
            'HOME' => '/home/vagrant',
            'PATH' => join(['/home/vagrant/.virtualenvs/framework/bin:', hiera('zsh::exec_path')])
        },
        stderr_logfile => '/vagrant/framework/log/celery_event.log',
        require     => Rabbitmq_user_permissions['framework@framework']
    }

    supervisord::program { 'celery.recommend':
        command     => '/home/vagrant/.virtualenvs/framework/bin/celery worker -A worker.recommend -n recommend -Q recommend --loglevel=INFO --broker=amqp://framework:framework@localhost:5672/framework',
        directory   => '/vagrant/framework',
        priority    => 200,
        user        => 'vagrant',
        environment => {
            'HOME' => '/home/vagrant',
            'PATH' => join(['/home/vagrant/.virtualenvs/framework/bin:', hiera('zsh::exec_path')])
        },
        stderr_logfile => '/vagrant/framework/log/celery_recommend.log',
        require     => Rabbitmq_user_permissions['framework@framework']
    }
}
