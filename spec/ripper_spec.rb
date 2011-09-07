require 'minitest/spec'
require 'minitest/autorun'
require 'ripper.rb'

describe Ripper do
  before do
    @ripper
  end
  
  it "can be created with an output directory" do
    @ripper = Ripper.new('c:/temp')
    @ripper.output_dir.wont_be_nil
  end
  
  it "can be created with no arguments" do
    #default output directory to current_dir/mp3s
    @ripper = Ripper.new
    @ripper.output_dir.wont_be_nil
  end
  
  it "will detect the Operating System" do
    # to determine the proper path
    
  end
  
  it "will find the Chrome's cache location" do
    # to determine the remainder of the path
  end
  
  it "will create a glob of the cache directory" do
    
  end
  
  it "will iterate through the glob and check if ID3 tags can be found" do
    
  end
  
  it "will move any MP3s it finds in the cache to the output location" do
   #using the ID3 artist and title info
  end
  
  
  
end