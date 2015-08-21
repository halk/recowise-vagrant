class magento::vhost {
    # adding vhost

    apache::vhost { 'magento.msc.koklu.me':
        docroot         => '/vagrant/demo/pub',
        default_vhost   => true,
        port            => 80,
        override        => 'all',
        custom_fragment => "\tSetEnv MAGE_MODE \"developer\"\n\tProxyPassMatch ^/(.*\\.php(/.*)?)$ fcgi://127.0.0.1:9000/vagrant/demo/pub/$1",
        manage_docroot  => false
    }
}
