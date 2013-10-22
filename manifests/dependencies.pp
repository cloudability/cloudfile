class cloudfile::dependencies {
  package {
    "cloudfile_fog":
      name     => "fog",
      ensure   => hiera("dependencies")["fog"],
      provider => "gem";

    "cloudfile_excon":
      name     => "excon",
      ensure   => hiera("dependencies")["excon"],
      provider => "gem";
  }
}