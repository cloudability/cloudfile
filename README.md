# Cloudfile

Puppet module that provides a custom type for downloading files from a cloud
provider. Currently only S3 is supported.

## Examples

### Single file download without credentials

    cloudfile { 'my_bucket/myfile':
      path => '/tmp',
    }

which is equivalent to:

    cloudfile { 'myfile yay':
      source => 'my_bucket/myfile',
      path   => '/tmp/myfile',
    }

### Multiple file download with credentials

    cloudfile { ['my_bucket/myfile1', 'another_bucket/somefile']:
      access_key_id     => 'long key from amazon',
      secret_access_key => 'longer key from amazon',
      path              => '/tmp',
    }

## Related Projects

I would've used the [s3file module from
branan](https://github.com/branan/puppet-module-s3file) but I needed
authentication.
