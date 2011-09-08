require 'tk'
require 'tkextlib/tile'
$: << File.dirname(__FILE__)
require 'cache_ripper'

#r = CacheRipper.new
#puts r.cache_path
#puts r.mp3_list

class CacheRipperGuiClient 
  attr_accessor :ripper, :output_dir, :cache_dir, :song_names

  
  def find_mp3s
    Tk::messageBox :message => 'This takes a bit, be patient.'
    if !@output_dir            
      @ripper = CacheRipper.new()
    elsif
      @ripper = CacheRipper.new(@output_dir, @cache_dir)
    end        
    
    @ripper.mp3_list.each do |tag_hash|
      #puts tag_hash
      song = tag_hash["artist"] +" - " + tag_hash["title"]      
      @song_names.push(song)
    end
    
  end
  
  def choose_output
    #@cache_dir = Tk::chooseDirectory        
    puts @cache_dir
  end
  
  def choose_cache
    @output_dir = Tk::chooseDirectory
    puts @output_dir 
  end
    
  def initialize()
    @output_dir = nil
    @cache_dir = nil
    @song_names = []
    
    root = TkRoot.new do
      title 'Chrome Cache Ripper'
      minsize 400,400      
    end
    
    @label = TkLabel.new(root) do
      text "Ctrl-Click the songs you want, then click Rip"
      pack
    end
    
    

    @button_get_mp3s = TkButton.new(root) do
      text 'Get MP3s'
      pack
    end
    @button_get_mp3s.command{find_mp3s}
    @button_choose_output = TkButton.new(root) do
      text 'Set Output Directory'
      pack{ side 'right'}
    end    
    @button_choose_output.command{choose_output}
    @button_choose_cache = TkButton.new(root) do
      text 'Set Cache Source Directory'
      pack{ side 'left'}
    end   
    @button_choose_cache.command{choose_cache}
        
    
    $tree = Tk::Tile::Treeview.new(root)    
    $tree['columns'] = 'size modified'
    $tree.column_configure( 'size', :width => 100, :anchor => 'center')
    $tree.heading_configure( 'size', :text => 'Size')
    $tree.column_configure( 'modified', :width => 100, :anchor => 'center')
    $tree.heading_configure( 'modified', :text => 'Modified')
    $tree.pack
    item = $tree.insert('', 'end', :text => 'Tutorial', :values => ['1','2'])
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    item = $tree.insert('', 'end', :text => 'Tutorial')
    $tree.insert( item, 'end', :text => 'Tree')
    Tk.mainloop
  end
end


CacheRipperGuiClient.new()