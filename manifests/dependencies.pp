class cloudfile::dependencies (
  $deps = {
    'aws-sdk'   => 'present',
    'excon'     => 'present'
  }
) {

  package {
    "aws-sdk":
      ensure   => $deps["aws-sdk"],
      provider => "gem";

    "cloudfile_excon":
      name     => "excon",
      ensure   => $deps["excon"],
      provider => "gem";
  }
}
