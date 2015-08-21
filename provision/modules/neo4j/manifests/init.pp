class neo4j (
  $limits = 40000
) {

    apt::key { '66D34E951A8C53D90242132B26C95CF201182252':
        ensure     => present,
        key_source => 'http://debian.neo4j.org/neotechnology.gpg.key',
        notify     => Exec['neo4j::apt-get update'],
    }

    file { 'neo4j::apt-source':
        path    => '/etc/apt/sources.list.d/neo4j.list',
        content => 'deb http://debian.neo4j.org/repo stable/',
        require => Apt::Key['66D34E951A8C53D90242132B26C95CF201182252'],
        notify  => Exec['neo4j::apt-get update']
    }

    exec { 'neo4j::apt-get update':
        command     => 'apt-get update',
        path        => '/usr/bin',
        refreshonly => true,
    }

    package { 'neo4j':
        ensure  => present,
        require => [Exec['neo4j::apt-get update'], File['/etc/security/limits.d/neo4j.conf']]
    }

    file { '/etc/security/limits.d/neo4j.conf':
        ensure  => present,
        content => template('neo4j/limits.conf.rb')
    }

    service { 'neo4j-service':
        ensure  => 'running',
        enable  => 'true',
        require => Package['neo4j']
    }

    file_line { 'neo4j::global access':
        path   => '/etc/neo4j/neo4j-server.properties',
        line   => 'org.neo4j.server.webserver.address=0.0.0.0',
        match  => '^#org\.neo4j\.server\.webserver\.address=0\.0\.0\.0',
        notify => Service['neo4j-service']
    }

    file_line { 'neo4j::disable auth':
        path   => '/etc/neo4j/neo4j-server.properties',
        line   => 'dbms.security.auth_enabled=false',
        match  => '^dbms\.security\.auth_enabled=true',
        notify => Service['neo4j-service']
    }

    file_line { 'neo4j::enable logging':
        path   => '/etc/neo4j/neo4j-server.properties',
        line   => 'org.neo4j.server.http.log.enabled=true',
        match  => '^org\.neo4j\.server\.http\.log\.enabled=false',
        notify => Service['neo4j-service']
    }

    file_line { 'neo4j::enable query logging':
        path   => '/etc/neo4j/neo4j-http-logging.xml',
        line   => '      <pattern>%h %l %user [%t{dd/MMM/yyyy:HH:mm:ss Z}] "%r" %s %b "%i{Referer}" "%i{User-Agent}" %D\nRequest: %fullRequest\nResponse: %fullResponse</pattern>',
        match  => '"%i{User-Agent}" %D</pattern>',
        notify => Service['neo4j-service']
    }
}
