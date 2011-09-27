require 'mp3info'

class CacheRipper
  attr_accessor :os, :cache_path, :output_path, :mp3_list

  def initialize(cache=nil)
    @os = detect_os
    @cache_path = cache
    @cache_path ||= detect_cache
    @mp3_list = []
    @threads = []
    #get_mp3_list
  end

  def detect_os
    os = nil
    platform = RUBY_PLATFORM
    if platform.index('darwin')
      os = :osx
    elsif platform.index('mingw32')
      os = :windows
    elsif platform.index('linux')
      os = :linux
    end
    os
  end
  # Chromium's code for disk caching is detailed here:
  #   http://www.chromium.org/developers/design-documents/network-stack/disk-cache
  #
  # Useful blog post:
  #   http://blog.eastfist.com/2011/01/01/accessing-content-from-google-chrome-cache/
  def detect_cache
    path = nil
    if @os == :windows
      path = File.expand_path ENV['LocalAppData']
      path = File.join(path, "/Google/Chrome/")
    elsif @os == :linux
      path = File.expand_path "~/.cache/google-chrome/" #tested against Ubuntu 11.10 and Chrome 10 (yeah, out of date VM)
    elsif @os == :osx
      #                        ~/Library/Caches/Google/Chrome/ 
      path = File.expand_path "~/Library/Caches/Google/Chrome/" # tested against Chrome 15 on 10.7.0
    end
    path
  end

  def get_mp3_list
    puts "get_mp3_list"
    #puts @cache_path
    begin
      # Glob the recusive paths of the root cache directory.
      Dir.glob(File.join(@cache_path,"**","*")) do |f|
        #puts f
        #attempt to do this concurrently since this is very slow
        Thread.new { open_mp3(f) }
      end
    rescue
      puts "Error"
    end
  end

  def open_mp3(file)    
    #puts file
    Mp3Info.open(f) do |mp3|
      puts "Opening MP3"
      puts mp3
      if(!mp3.tag.empty? && (File.size(f) > 900000)) #setting a lower filesize limit to prevent grabbing "sample" mp3s from Amazon or whatever.  We only want full songs!
        puts "MP3 Found"
        puts mp3
        mp3.tag[:file] = File.expand_path f
        mp3.tag[:name] = mp3.tag['artist'] + " - " + mp3.tag['title'] + ".mp3"
        friendly_filename(mp3.tag[:name])
        @mp3_list.push mp3.tag
      end
    end
  end

  #attempt to make the filenames more cross platform friendly if the ID3 info contains weird chars
  def friendly_filename(filename)
      filename.gsub(/[^\w\s_-]+/, '')
      filename.gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
      filename.gsub(/\s/, '_')
  end

end

