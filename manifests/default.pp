exec { 'apt-get update':
	command => '/usr/bin/apt-get update && touch /home/vagrant/updated.lock',
	creates => '/home/vagrant/updated.lock',
	timeout => 0
}

package { 'git':
	ensure => present,
	require => Exec['apt-get update']
}

package { 'build-essential':
	ensure => present,
	require => Exec['apt-get update']
}

file { '/home/vagrant/.nvmrc':
    source => '/vagrant/files/nvmrc',
    owner  => 'vagrant',
    group  => 'vagrant'
}

exec { 'install nvm':
    cwd     => '/home/vagrant',
    command => '/usr/bin/git clone https://github.com/creationix/nvm.git /home/vagrant/.nvm',
    user    => 'vagrant',
    group   => 'vagrant',
	require => Package['git'],
    creates => '/home/vagrant/.nvm/nvm.sh'
}

exec { 'install node 0.10':
    cwd     => '/home/vagrant',
    command => '/bin/bash /vagrant/files/install-node.sh',
    user   => 'vagrant',
    group   => 'vagrant',
	require => [Package['build-essential'], Exec['install nvm'], File['/home/vagrant/.nvmrc']]
}

exec { 'install jsbin':
    cwd     => '/home/vagrant',
    command => '/usr/bin/git clone https://github.com/jsbin/jsbin.git',
    user    => 'vagrant',
    group   => 'vagrant',
	require    => [Package['git'], Exec['install node 0.10']],
    creates => '/home/vagrant/jsbin/package.json'
}

exec { 'install jsbin modules':
    cwd     => '/home/vagrant/jsbin',
    command => '/bin/bash /vagrant/files/install-jsbin-packages.sh',
    user   => 'vagrant',
    group   => 'vagrant',
	require => [Exec['install jsbin']],
    creates => '/home/vagrant/jsbin/node_modules/'
}

file { '/home/vagrant/start-jsbin.sh':
    source  => '/vagrant/files/start-jsbin.sh',
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => 711,
    require => Exec['install jsbin modules']
}

