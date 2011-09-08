require 'minitest/spec'
require 'minitest/autorun'
require 'cache_ripper.rb'

describe CacheRipper do
  before do
    @ripper = CacheRipper.new
  end
  
  it "can be created with an output directory" do
    @ripper = CacheRipper.new('c:/temp')
    @ripper.must_be_instance_of(CacheRipper)
    @ripper.output_path.wont_be_nil
  end
  
  it "can be created with no arguments" do
    #default output directory to current_dir/mp3s
    @ripper = CacheRipper.new
    @ripper.must_be_instance_of(CacheRipper)
    @ripper.output_path.wont_be_nil
  end
  
  it "will have successfully detected the Operating System" do
    # to determine the proper path
    @ripper.os.wont_be_nil
  end
  
  it "will build Chrome's cache location" do    
    @ripper.cache_path.wont_be_nil       
  end
  
  it "will have found a valid cache location" do
    Dir.exists?(@ripper.cache_path).wont_equal(false)
  end
    
  it "will iterate through the cache and check if ID3 tags can be found and store them" do
    #this could return nil if no MP3s exist...check that no error was thrown I guess?
    @ripper.get_mp3_list
  end
  
  it "will move any MP3s it finds in the cache to the output location" do
   #using the ID3 artist and title info
  end
  
end