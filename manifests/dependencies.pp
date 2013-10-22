class cloudfile::dependencies {
  $deps = hiera("dependencies")

  package {
    "fog":
      ensure   => $deps["fog"],
      provider => "gem";

    "cloudfile_excon":
      name     => "excon",
      ensure   => $deps["excon"],
      provider => "gem";
  }
}