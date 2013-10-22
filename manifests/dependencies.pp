class cloudfile::dependencies {
  package { "cloudfile_fog":
    name => "fog",
    ensure => hiera("fog_version"),
    provider => "gem",
  }
}