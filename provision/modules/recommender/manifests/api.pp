class recommender::api {
    apache::vhost { 'api.msc.koklu.me':
        docroot                => '/vagrant/framework/api',
        port                   => 80,
        manage_docroot         => false,
        wsgi_daemon_process    => 'api user=vagrant group=vagrant threads=5',
        wsgi_script_aliases    => {'/' => '/vagrant/framework/api.wsgi'},
        wsgi_process_group     => 'api',
        wsgi_application_group => '%{GLOBAL}',
        require                => Python::Virtualenv['/vagrant/framework']
    }
}
