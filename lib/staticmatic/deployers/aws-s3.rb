require 'aws/s3'
require 'yaml'

class StaticExe < Thor

  desc "s3_deploy DIRECTORY", "Deploys your static website an Amazon's S3 bucket"
  method_option :env, :type => :string, :aliases => "-e"
  method_option :skip_build, :type => :boolean, :aliases => "-k"
  def s3_deploy(directory = '.')
    return if needs_setup? directory
    
    invoke :build, directory unless options[:skip_build]
    
    if Dir[site_path(directory,'*')].empty?
      say 'Your build/ folder is empty', :red
      say 'Nothing to do.'
      return
    end
    
    say 'Uploading to Amazon S3...', :cyan
    say 'Establishing connection to Amazon S3...'
    amazon_config = YAML::load File.read(amazon_config_path directory)
    AWS::S3::Base.establish_connection!(amazon_config['AccessKeys'])
    
    env = options[:env] || 'development'
    bucket_name = amazon_config['Buckets'][env]
    
    say "Grabbing #{env} bucket '#{bucket_name}'"
    buckets = AWS::S3::Service.buckets
    unless buckets.map {|b| b.name}.include? bucket_name
      say 'The bucket ', :red
      say "'#{bucket_name}' "
      say 'does not exist!', :red
      say 'Nothing to do.'
      return
    end

    Dir[site_path(directory,'*')].each do |file|
      contents = File.read file
      s3path = file.sub(%r{^\./build/},'')
      
      say "      upload ", :cyan; say s3path
      AWS::S3::S3Object.store(s3path, contents, bucket_name, :access => :public_read)
    end
    say 'Done.'
  end
  
  private
  
  def amazon_config_path(directory)
    File.join(directory, 'config','amazon.yml')
  end
  
  def needs_setup?(directory)
    config_file = amazon_config_path(directory)
    
    unless File.exists? config_file
      say 'You need an Amazon S3 config file.', :red
      response = ask 'Would you like to generate one now? [Y/n]'

      if response == '' || response.downcase == 'y'
        copy_file lib_path('deployers/config/amazon.yml'), config_file
        say 'Done.'
        say 'Edit this config file to specify your Amazon S3 access keys, ' +
            'and then try again.'
        say 'For more information, visit http://aws.amazon.com/s3/'
      end
      return true
    end
  end
end
