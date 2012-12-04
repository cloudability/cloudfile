Puppet::Type.type(:cloudfile).provide(:s3) do
  desc('Get a file from an S3 bucket on AWS.')

  def create
    Puppet.debug("let's download some stuff")
    ensure_writable

    Puppet.debug('requiring fog')
    # require fog here so we can install the gem before ruby/puppet tries to
    # load it
    require 'fog'

    access_key_id = @resource[:access_key_id]
    secret_access_key = @resource[:secret_access_key]
    if access_key_id && secret_access_key
      Puppet.debug("creating connection to aws with keys [#{access_key_id}, #{secret_access_key}]")
      connection = Fog::Storage.new(
        :provider              => 'AWS',
        :aws_access_key_id     => access_key_id,
        :aws_secret_access_key => secret_access_key
      )
    else
      Puppet.debug('creating connection to aws anonymously')
      connection = Fog::Storage.new(
        :provider => 'AWS'
      )
    end

    b, f = bucket_and_file(@resource[:source])

    Puppet.debug("getting bucket [#{b}]")
    directory = connection.directories.get(b)
    raise Puppet::Error, "Did not find bucket #{b}" unless directory

    Puppet.debug("getting file [#{f}]")
    file = directory.files.get(f)
    raise Puppet::Error, "Did not find file #{f} in bucket #{b}" unless file

    output_file = local_artifact_name
    Puppet.debug("writing file #{output_file}")
    File.open(output_file, 'w') do |f|
      f.write(file.body)
    end
  end

  def destroy
    Puppet.debug("Nuke it from orbit! [#{@resource[:path]}]")
    File.unlink(local_artifact_name)
  end

  def exists?
    search = local_artifact_name
    found = File.exists?(search)
    Puppet.debug("Is it there? [#{search} == #{found}]")
    found
  end

  private

  def ensure_writable(search = nil)
    search = @resource[:path] unless search
    if File.exists?(search)
      raise Puppet::Error, "Path exists but is not writable [#{search}]" unless File.writable?(search)
    else
      parent = Pathname.new(search).parent
      raise Puppet::Error, "Unable to write to path [#{path}]" unless File.writable?(parent)
    end
  end

  # if the provided path is a dir, use the downloaded filename as the output
  # filename
  def local_artifact_name
    if File.directory?(@resource[:path])
      b, f = bucket_and_file(@resource[:source])
      artifact = File.join(@resource[:path], f)
    else
      artifact = @resource[:path]
    end
  end

  def bucket_and_file(resource)
    b, f = resource.split('/', 2)
  end
end
