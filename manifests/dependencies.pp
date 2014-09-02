class cloudfile::dependencies (
  $deps = {
    'fog'   => 'present',
    'excon' => 'present'
  }
) {

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
