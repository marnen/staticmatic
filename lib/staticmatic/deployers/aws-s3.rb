require 'aws/s3'
require 'yaml'

class StaticExe < Thor

  desc "s3_deploy DIRECTORY", "Deploys your static website an Amazon's S3 bucket"
  method_option :env, :type => :string, :aliases => "-e"
  method_option :skip_build, :type => :boolean, :aliases => "-k"
  def s3_deploy(directory = '.')
    return if needs_setup? directory
    
    invoke :build, directory unless options[:skip_build]
    
    if build_files(directory).empty?
      say 'Your build/ folder is empty', :red
      say 'Nothing to do.'
      return
    end
    
    amazon_config = YAML::load File.read(amazon_config_path directory)
    env = options[:env] || 'development'
    bucket_name = amazon_config['Buckets'][env]
    
    connect_to_amazon_s3(amazon_config,env,bucket_name)

    build_files(directory).each do |file|
      contents = File.read file
      s3path = file.sub(%r{^\./build/},'')
      
      say "      upload ", :cyan; say s3path
      AWS::S3::S3Object.store(s3path, contents, bucket_name, :access => :public_read)
    end
    say 'Done.'
  end
  
  desc "s3_upload FILE [FILE ...]", "Upload select files to your Amazon S3 bucket."
  method_option :directory, :type => :string, :aliases => "-d", :default => '.'
  method_option :env, :type => :string, :aliases => "-e"
  method_option :skip_build, :type => :boolean, :aliases => "-k"
  def s3_upload(*files)
    return if needs_setup? options[:directory]
    
    if files.length == 0
      say 'No files selected.', :red
      say 'Nothing to do.'
      return
    end
    
    amazon_config = YAML::load File.read(amazon_config_path '.')
    env = options[:env] || 'development'
    bucket_name = amazon_config['Buckets'][env]
    
    connect_to_amazon_s3(amazon_config,env,bucket_name)
    
    files.each do |file|
      
      unless File.exists? file
        say "      Does not exist ", :red; say file; next
      end
      
      contents = File.read file
      s3path = file.sub(%r{^(\./)?build/},'')
    
      say "      upload ", :cyan; say s3path
      AWS::S3::S3Object.store(s3path, contents, bucket_name, :access => :public_read)
    end
  end
  
  private
  
  def connect_to_amazon_s3(config,env,bucket_name)
    say 'Uploading to Amazon S3...', :cyan
    say 'Establishing connection to Amazon S3...'
    AWS::S3::Base.establish_connection!(config['AccessKeys'])
    
    say "Grabbing #{env} bucket '#{bucket_name}'"
    buckets = AWS::S3::Service.buckets
    unless buckets.map {|b| b.name}.include? bucket_name
      say 'The bucket ', :red
      say "'#{bucket_name}' "
      say 'does not exist!', :red
      say 'Nothing to do.'
      return
    end
  end
  
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
