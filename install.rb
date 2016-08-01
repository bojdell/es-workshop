#!/usr/bin/ruby

##
# This script downloads and installs the following software into the directory `lib/`:
#   - Elasticsearch 2.3.4
#   - Kibana 4.5.3 (w/ Sense plugin)
##

require 'json'
require 'net/http'
require 'uri'
require 'rbconfig'
require 'zip'
require 'colorize'
require 'rubygems/package'

INSTALL_DIR = 'lib'
ES_INSTALL_URI = URI.parse('https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/zip/elasticsearch/2.3.4/elasticsearch-2.3.4.zip')
KIBANA_INSTALL_URI_MAC     = URI.parse('https://download.elastic.co/kibana/kibana/kibana-4.5.3-darwin-x64.tar.gz')
KIBANA_INSTALL_URI_WINDOWS = URI.parse('https://download.elastic.co/kibana/kibana/kibana-4.5.3-windows.zip')
KIBANA_INSTALL_URI_LINUX   = URI.parse('https://download.elastic.co/kibana/kibana/kibana-4.5.3-linux-x64.tar.gz')

ES_OPTS = '
http.cors.enabled: true
http.cors.allow-methods: OPTIONS, HEAD, GET
http.cors.allow-origin: /https?:\/\/localhost(:[0-9]+)?/
'

host_os = RbConfig::CONFIG['host_os']
@os_type = case host_os
  when /darwin|mac os/
    :mac
  when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
    :windows
  when /linux/
    :linux
  else
    raise "Unknown OS type: #{host_os.inspect}"
end

@in_progress = false

def spinner(action, path)
  Thread.new do
    while @in_progress do
      '/-\\|'.each_char do |spin_state|
        log_action(action, path, spin_state, true)
        sleep 0.1
      end
    end
    log_action(action, path, 'COMPLETED'.green)
  end
end

def log_action(action, path, status, overwrite = false)
  print ('%-13s %-20s: %s' % [action, path.cyan, status]) + (overwrite ? "\r" : "\n")
  $stdout.flush
end

def unpack(archive_path, out_dir)
  @in_progress = true
  spinner_thread = spinner('Unpacking', archive_path)

  case File.extname(archive_path)
  when '.zip'
    unzip(archive_path, out_dir)
  when '.gz'
    untar(archive_path, out_dir)
  end

  @in_progress = false
  spinner_thread.join

  FileUtils.rm(archive_path)
  log_action('Removing', archive_path, 'COMPLETED'.green)
end

def unzip(archive_path, out_dir)
  Zip::File.open(archive_path) do |zip_file|
    zip_file.each do |file|
      out_path = File.join(out_dir, file.name)
      FileUtils.mkdir_p(File.dirname(out_path))
      zip_file.extract(file, out_path) unless File.exist?(out_path)
    end
  end
end

def download(uri, out_file)
  request = Net::HTTP::Get.new(uri)

  Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
    @in_progress = true
    spinner_thread = spinner('Downloading', out_file)

    http.request(request) do |response|
      open(out_file, 'w') do |io|
        response.read_body do |chunk|
          io.write(chunk)
        end
      end
    end

    @in_progress = false
    spinner_thread.join
  end
end

# based heavily on http://dracoater.blogspot.com/2013/10/extracting-files-from-targz-with-ruby.html
def untar(archive_path, out_dir)
  tar_longlink = '././@LongLink'
  destination = out_dir

  Gem::Package::TarReader.new( Zlib::GzipReader.open(archive_path) ) do |tar|
    dest = nil
    tar.each do |entry|
      if entry.full_name == tar_longlink
        dest = File.join destination, entry.read.strip
        next
      end
      dest ||= File.join destination, entry.full_name
      if entry.directory?
        FileUtils.rm_rf dest unless File.directory? dest
        FileUtils.mkdir_p dest, :mode => entry.header.mode, :verbose => false
      elsif entry.file?
        FileUtils.rm_rf dest unless File.file? dest
        File.open dest, "wb" do |f|
          f.print entry.read
        end
        FileUtils.chmod entry.header.mode, dest, :verbose => false
      elsif entry.header.typeflag == '2' #Symlink!
        File.symlink entry.header.linkname, dest
      end
      dest = nil
    end
  end
end

def install_es(install_path)
  es_dir = File.join(install_path, File.basename(ES_INSTALL_URI.path, '.*'))
  if Dir.exists?(es_dir)
    puts "== Detected directory #{es_dir} - assuming Elasticsearch is installed there. ==".green
    return
  end

  out_file = File.join(install_path, File.basename(ES_INSTALL_URI.path))
  download(ES_INSTALL_URI, out_file)
  unpack(out_file, install_path)

  # prepend custom config settings to elasticsearch.yml
  es_config_path = File.join(es_dir, 'config/elasticsearch.yml')
  config_copy = es_config_path + '.copy'

  File.open(config_copy, 'w') do |output|
    output.puts ES_OPTS
    File.foreach(es_config_path) do |line|
      output.puts line
    end
  end

  FileUtils.rm(es_config_path)
  File.rename(config_copy, es_config_path)
  log_action('Configuring', es_config_path, 'COMPLETED')

  puts "== Successfully installed Elasticsearch into '#{install_path}' ==".green
end

def install_kibana(install_path)
  kibana_dir_glob = File.join(INSTALL_DIR, 'kibana-4.5.3*')
  if Dir.glob(kibana_dir_glob).any?
    puts "== Detected directory matching #{kibana_dir_glob} - assuming Kibana is installed there. ==".green
    return
  end

  kibana_uri = case @os_type
  when :mac
    KIBANA_INSTALL_URI_MAC
  when :windows
    KIBANA_INSTALL_URI_WINDOWS
  when :linux
    KIBANA_INSTALL_URI_LINUX
  end

  out_file = File.join(install_path, File.basename(kibana_uri.path))

  download(kibana_uri, out_file)
  unpack(out_file, install_path)

  # TODO: install Sense kibana plugin

  puts "== Successfully installed Kibana into '#{install_path}' ==".green
end

Dir.mkdir(INSTALL_DIR)      unless Dir.exists?(INSTALL_DIR)
install_es(INSTALL_DIR)
install_kibana(INSTALL_DIR)
