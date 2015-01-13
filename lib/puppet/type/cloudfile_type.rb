Puppet::Type.newtype(:cloudfile_type) do
  @doc = 'Gets a file from the cloud and places it on local disk.'

  ensurable do
    defaultvalues
    defaultto(:present)
  end

  newparam(:access_key_id) do
    desc 'AWS access key ID.'
  end

  newparam(:secret_access_key) do
    desc 'AWS secret access key.'
  end

  newparam(:overwrite, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Whether to overwrite an existing file'
  end

  newparam(:source) do
    desc 'Source where file can be found. Expected to be in the format of <s3 bucket>/<filename>'
    isnamevar
  end

  newparam(:path) do
    desc 'Full path where this file is to be stored. If a directory is given, the downloaded filename will be used.'
    isrequired
  end
end
