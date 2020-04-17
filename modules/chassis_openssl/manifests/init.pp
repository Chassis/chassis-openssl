# A Chassis extension to install and configure OpenSSL
class chassis_openssl (
	$config,
) {
	if ( ! defined( File["/etc/nginx/sites-available/${name}.d"] ) ) {
		file { "/etc/nginx/sites-available/${::fqdn}.d":
			ensure  => directory,
			require => Package['nginx']
		}
	}

	file { "/etc/nginx/sites-available/${::fqdn}.d/ssl":
		content => template('chassis_openssl/site.nginx.conf.ssl.erb'),
		require => File[ "/etc/nginx/sites-available/${::fqdn}.d" ],
		notify  => Service['nginx'],
	}

	openssl::certificate::x509 { $::fqdn:
		country      => 'CH',
		organization => 'Example.com',
		commonname   => $::fqdn,
		altnames     => $::config[hosts],
		extkeyusage  => [ 'serverAuth', 'clientAuth' ],
		cnf_tpl      => 'chassis_openssl/cert.cnf.erb',
		days         => 3650,
		owner        => 'www-data',
		group        => 'www-data',
	}
	-> file { "/vagrant/${::fqdn}.cert":
		ensure  => present,
		replace => $config['chassis_openssl']['cert']['replace'],
		source  => "/etc/ssl/certs/${::fqdn}.crt",
		mode    => '0644',
	}
	-> file { "/vagrant/${::fqdn}.key":
		ensure  => present,
		replace => $config['chassis_openssl']['key']['replace'],
		source  => "/etc/ssl/certs/${::fqdn}.key",
		mode    => '0644',
	}
}
