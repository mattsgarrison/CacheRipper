class Ripper
  attr_accessor :cache_path, :os, :output_dir

  def initialize( output = File.expand_path($0) )
    detect_os
    @output_dir = output        
  end

  def detect_os
    if RUBY_PLATFORM.index('darwin')
      @os = 'OSX'
    elsif RUBY_PLATFORM.index('mswin32')
      @os = 'Windows'
    elsif RUBY_PLATFORM.index('linux')
      @os = 'Linux'
    else 
      @os = nil
    end
  end
end


