class cloudfile::dependencies {
  package { 'cloudfile_gems':
    ensure => installed,
    name => ['fog'],
    provider => 'gem',
  }
}
