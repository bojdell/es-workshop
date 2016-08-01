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

INSTALL_DIR = 'lib/'
ES_INSTALL_URI = URI.parse('https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/zip/elasticsearch/2.3.4/elasticsearch-2.3.4.zip')
KIBANA_INSTALL_URI_MAC     = URI.parse('https://download.elastic.co/kibana/kibana/kibana-4.5.3-darwin-x64.tar.gz')
KIBANA_INSTALL_URI_WINDOWS = URI.parse('https://download.elastic.co/kibana/kibana/kibana-4.5.3-windows.zip')
KIBANA_INSTALL_URI_LINUX   = URI.parse('https://download.elastic.co/kibana/kibana/kibana-4.5.3-linux-x64.tar.gz')

host_os = RbConfig::CONFIG['host_os']
@os_type = case host_os
  when /darwin|mac os/
    :mac
  when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
    :windows
  when /linux/
    :linux
  else
    raise "Unknown os type: #{host_os.inspect}"
end

@in_progress = false

def spinner(msg)
  Thread.new do
    while @in_progress do
      '/-\\|'.each_char do |c|
        print "#{msg}: #{c}\r"
        $stdout.flush
        sleep 0.1
      end
    end
    print "#{msg}: #{'COMPLETED'.green}\r"
    $stdout.flush
    puts
  end
end

def unpack(archive_path, out_dir)
  @in_progress = true
  spinner_thread = spinner('%-11s %s' % ['Unpacking', archive_path.cyan])

  case File.extname(archive_path)
  when '.zip'
    unzip(archive_path, out_dir)
  when '.gz'
    untar(archive_path, out_dir)
  end

  @in_progress = false
  spinner_thread.join

  FileUtils.rm(archive_path)
  puts '%-11s %s: %s' % ['Removing', archive_path.cyan, 'COMPLETED'.green]
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

def download(uri)
  request = Net::HTTP::Get.new(uri)
  out_file = File.join(INSTALL_DIR, File.basename(uri.path))

  Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
    @in_progress = true
    spinner_thread = spinner('%-11s %s' % ['Downloading', out_file.cyan])

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

  out_file
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
  out_file = download(ES_INSTALL_URI)
  unpack(out_file, install_path)

  # TODO: edit elasticsearch.yml

  puts "== Successfully installed Elasticsearch into #{install_path} ==".green
end

def install_kibana(install_path)
  kibana_uri = case @os_type
  when :mac
    KIBANA_INSTALL_URI_MAC
  when :windows
    KIBANA_INSTALL_URI_WINDOWS
  when :linux
    KIBANA_INSTALL_URI_LINUX
  end

  out_file = download(kibana_uri)
  unpack(out_file, install_path)

  # TODO: install Sense kibana plugin

  puts "== Successfully installed Kibana into #{install_path} ==".green
end

Dir.mkdir(INSTALL_DIR) unless Dir.exists?(INSTALL_DIR)
install_es(INSTALL_DIR)
install_kibana(INSTALL_DIR)
