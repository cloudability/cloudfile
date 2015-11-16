Puppet::Type.type(:cloudfile_type).provide(:s3) do
  confine(feature: :awssdk)

  desc('Get a file from an S3 bucket on AWS.')

  def create
    Puppet.debug("let's download some stuff")
    ensure_writable

    access_key_id = @resource[:access_key_id]
    secret_access_key = @resource[:secret_access_key]
    if access_key_id && secret_access_key
      Puppet.debug("creating connection to aws with keys [#{access_key_id}, #{secret_access_key[0..2]}..#{secret_access_key[-3..-1]}]")
      creds = Aws::Credentials.new(access_key_id, secret_access_key)
      connection = Aws::S3::Client.new(
        region: 'us-east-1',
        credentials: creds
      )
    else
      Puppet.debug('creating connection to aws anonymously')
      connection = Aws::S3::Client.new()
    end

    b, k = bucket_and_file(@resource[:source])

    Puppet.debug("getting file [#{k}]")
    output_file = local_artifact_name
    Puppet.debug("writing file #{output_file}")
    File.open(output_file, 'w') do |f|
      resp = connection.get_object({bucket: b, key: k}, target: f) 
    end
  end

  def destroy
    Puppet.debug("Nuke it from orbit! [#{@resource[:path]}]")
    File.unlink(local_artifact_name)
  end

  def exists?
    return false if @resource.overwrite?

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
    b, f = resource.sub('s3://', '').split('/', 2)
  end
end
