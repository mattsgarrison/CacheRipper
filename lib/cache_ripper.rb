require 'mp3info'

class CacheRipper
  attr_accessor :os, :cache_path, :output_path, :mp3_list

  def initialize(output = File.expand_path($0)+"/mp3s/", cache=nil)
    @os = detect_os
    @cache_path = cache
    @cache_path ||= detect_cache
    @output_path = output
    @mp3_list = []
    get_mp3_list
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

  def detect_cache
    path = nil
    if @os == :windows
      path = File.expand_path ENV['LocalAppData']
      path += "/Google/Chrome/User Data/Default/Cache/"
    elsif @os == :linux
      path = File.expand_path "~/.cache/google-chrome/" #tested against Ubuntu 11.10 and Chrome 10 (yeah, out of date VM)
    elsif @os == :osx
      path = File.expand_path "~/Library/Caches/Google/Chrome/Default/Cache/" # tested against Chrome 15 on 10.7.0
    end
    path
  end

  def get_mp3_list
    Dir.glob(@cache_path+"*") do |f|
      #puts f
      begin
        Mp3Info.open(f) do |mp3|          
          if(!mp3.tag.empty?)
            mp3.tag[:file] = File.expand_path f
            @mp3_list.push mp3.tag
          end
        end
      rescue
        #puts "Error"
      end
    end
  end

end

