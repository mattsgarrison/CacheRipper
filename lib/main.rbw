require 'tk'
require 'tkextlib/tile'
require 'fileutils'
$: << File.dirname(__FILE__)
require 'cache_ripper'

#r = CacheRipper.new
#puts r.cache_path
#puts r.mp3_list

class CacheRipperGuiClient 
  
  def copy_mp3(tag_hash)
    #puts "Attempting to open #{@output_dir}"
    if File.directory?(@output_dir)
      # output directory exists, lets do this
      cache_file = tag_hash[:file]
      save_file = @output_dir + tag_hash[:name] 
      #puts cache_file
      #puts save_file
      FileUtils.copy_entry(cache_file, save_file)
    else
      #puts "output directory didn't exist or couldn't be written, create it or throw an error"
      begin
        Dir.mkdir(File.expand_path(@ripper.output_path))             
      rescue
        Tk::messageBox :message => "Couldn't write to default save location. Please select a new folder in File->Save Location..."
      end
    end
  end
  
  def find_mp3s(songs)
    @ripper = CacheRipper.new(@cache_dir)
    
    @ripper.mp3_list.each do |tag_hash|      
      song = tag_hash["artist"] +" - " + tag_hash["title"]
      songs.push(song)
    end    
  end
  
  def rip_selection
    @list.curselection.each do |i|
      copy_mp3 @ripper.mp3_list[i]
    end
    
    #open file explorer to show ripped files?
  end  
  
  def choose_output
    @output_dir = Tk::chooseDirectory    
  end
      
  def initialize()
    @output_dir = File.expand_path($0)+"/mp3s/"
    @cache_dir = nil
    @song_names = []
    

    TkOption.add '*tearOff', 0 #required before adding menubars    
    $win = TkRoot.new do
      title 'Chrome Cache Ripper'
      minsize 400,400      
    end  
    #warn users for the slow load time
    Tk::messageBox :message => 'This takes a bit to load, be patient.'
    
    find_mp3s @song_names
    $listnames = TkVariable.new(@song_names)
    
    $menubar = TkMenu.new($win)
    $win['menu'] = $menubar
    file = TkMenu.new($menubar)
    #edit = TkMenu.new($menubar)
    $menubar.add :cascade, :menu => file, :label => 'File'
    #$menubar.add :cascade, :menu => edit, :label => 'Edit'
    file.add :command, :label => 'Save Location...', :command => proc{choose_output}
    file.add :command, :label => 'Exit', :command => proc{Process.exit;}
    #edit.add :command, :label => 'Cache Search Location...', :command => proc{choose_cache}
    
    @label = TkLabel.new($win) do
      text "Ctrl-Click the songs you want, then click Rip"
      pack
    end
           
    @list = TkListbox.new($win) do
      listvariable $listnames
      selectmode 'extended'
      pack('side'=>'left', 'fill'=>'both', 'expand'=>'true')
    end

    @scroll = TkScrollbar.new($win) do
        orient 'vertical'
        #place('height' => 150, 'x' => 110, 'y' => 200)
        pack('side'=>'left', 'fill'=>'y')
    end
    # Add scroll behaviors
    @list.yscrollcommand(proc { |*args|
      @scroll.set(*args)      
    })
    @scroll.command(proc { |*args|
      @list.yview(*args)
    })
   
    @button_rip = TkButton.new($win) do
      text 'Rip Selected'
      pack('side'=>'bottom', 'padx'=>'10', 'pady'=>'10')
    end    
    @button_rip.command{rip_selection}
    
    # Zebra strip the listbox
    0.step(@song_names.length-1, 2) do |i| 
      @list.itemconfigure i, :background, "#f0f0ff"
    end
    
    Tk.mainloop
  end
end


CacheRipperGuiClient.new()