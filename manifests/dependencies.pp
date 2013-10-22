class cloudfile::dependencies {
  package {
    "cloudfile_fog":
      name => "fog",
      ensure => hiera("fog_version"),
      provider => "gem";

    "cloudfile_excon":
      name => "excon",
      ensure => hiera("excon_version"),
      provider => "gem";
  }
}