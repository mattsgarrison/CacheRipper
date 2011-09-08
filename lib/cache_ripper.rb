require 'mp3info'

class CacheRipper
  attr_accessor :os, :cache_path, :output_path, :mp3_list
  
  def initialize(output = File.expand_path($0)+"/mp3s/")
    @os = detect_os
    @cache_path = detect_cache
    @output_path = output
    #get_mp3_list
  end

  def detect_os
    os = "what os?"
    platform = RUBY_PLATFORM    
    if platform.index('darwin')
      os = :osx
    elsif platform.index('mingw32')
      os = :windows
    elsif platform.index('linux')
      os = :linux
    else 
      os = nil
    end
    os
  end
  
  def detect_cache
    path = nil
    if @os == :windows
      path = File.expand_path(ENV['LocalAppData'])
      path += "/Google/Chrome/User Data/Default/Application Cache/Cache/"
    elsif @os == :linux
      path = "~/.cache/google-chrome/" #tested against Ubuntu 11.10 and Chrome 10 (yeah, out of date VM)
    elsif @os == :osx
      path = "~/Library/Caches/Google/Chrome/Default/Cache/"
    end
    path
  end
  
  def get_mp3_list    

    Dir.glob(@cache_path+"*") do |f|
      
        begin
          Mp3Info.open(f) do |mp3|
            puts mp3.tag
          end
          #if mp3.tag != nil
          #puts File.expand_path(f)
          #puts mp3.tag
          #end
        rescue
          #puts "Error"
        end
        
      end
    end      
  
end

r = CacheRipper.new
puts r
puts r.os
puts r.cache_path
puts r.output_path
r.get_mp3_list