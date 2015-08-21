class magento::install (
    $db_name, $db_user, $db_pass, $backend_frontname, $admin_user, $admin_pass, $admin_email,
    $admin_firstname, $admin_lastname, $base_url, $language, $currency
) {
    exec { 'create-composer-project':
        unless  => 'ls /vagrant/demo/pub/index.php',
        cwd     => '/vagrant/demo',
        command => "/usr/local/bin/composer install",
        user    => 'vagrant',
        environment => 'HOME=/home/vagrant',
        creates => '/vagrant/demo/pub/index.php'
    }

    percona::database { $db_name:
        ensure => present
    }

    percona::rights { "${db_user}@localhost/${db_name}":
        priv     => 'all',
        password => $db_pass
    }

    exec { 'install-magento':
        unless  => 'ls /vagrant/demo/app/etc/config.php',
        cwd     => '/vagrant/demo/setup',
        command => "php index.php install \
    --db_host=localhost \
    --db_name=${db_name} \
    --db_user=${db_user} \
    --db_pass=${db_pass} \
    --backend_frontname=${backend_frontname} \
    --admin_username=${admin_user} \
    --admin_password=${admin_pass} \
    --admin_email=${admin_email} \
    --admin_firstname=${admin_firstname} \
    --admin_lastname=${admin_lastname} \
    --base_url='${base_url}' \
    --base_url_secure='${base_url}' \
    --language=${language} \
    --currency=${currency} \
    --use_rewrites=true \
    --use_secure=false \
    --use_secure_admin=false \
    --use_sample_data=true \
    --cleanup_database",
        user    => 'vagrant',
        require => [Exec['create-composer-project'], Percona::Database[$db_name], Percona::Rights["${db_user}@localhost/${db_name}"]]
    }

    file_line { 'disable FPC':
        path   => '/vagrant/demo/app/etc/config.php',
        line   => '    \'full_page\' => 0,',
        match  => '    \'full_page\' => 1,',
        require => Exec['install-magento']
    }
}
