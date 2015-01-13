define cloudfile (
  $access_key_id     = "",
  $secret_access_key = "",
  $source            = $name,
  $overwrite         = false,
  $path
) {
  class { 'cloudfile::dependencies': }

  cloudfile_type { $title:
    name              => $name,
    access_key_id     => $access_key_id,
    secret_access_key => $secret_access_key,
    source            => $source,
    path              => $path,
    overwrite         => $overwrite,
    require           => Class["cloudfile::dependencies"],
  }
}
