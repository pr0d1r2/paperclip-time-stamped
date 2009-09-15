require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'active_record_connectionless'

class PaperclipTimeStamped < ActiveRecord::Base

  has_timestamped_paperclip_attachment :name

end


describe "PaperclipTimeStamped" do

  before(:each) do
    @paperclip_time_stamped = PaperclipTimeStamped.new
    @name = mock(Object)
  end

  it 'name_url should be delegated to name.url' do
    @name.should_receive(:url).with(:small).and_return('url')
    @paperclip_time_stamped.should_receive(:name).and_return(@name)
    @paperclip_time_stamped.name_url(:small).should == 'url'
  end

  it 'name_path should be delegated to name.path' do
    @name.should_receive(:path).with(:small).and_return('path')
    @paperclip_time_stamped.should_receive(:name).and_return(@name)
    @paperclip_time_stamped.name_path(:small).should == 'path'
  end

  it 'name? should be delegated to name.exists?' do
    @name.should_receive(:exists?).and_return(true)
    @paperclip_time_stamped.should_receive(:name).and_return(@name)
    @paperclip_time_stamped.name?.should be_true
  end

  describe 'name_timestamp' do
    it 'should return 1000000000 when there is no name' do
      @paperclip_time_stamped.should_receive(:name?).and_return(false)
      @paperclip_time_stamped.name_timestamp(:small).should == '1000000000'
    end

    it 'should return name file timestamp when it exist' do
      @paperclip_time_stamped.should_receive(:name?).and_return(true)
      @paperclip_time_stamped.should_receive(:name_path).with(:small).and_return('path')
      File.should_receive(:mtime).with('path').and_return(2000000000)
      @paperclip_time_stamped.name_timestamp(:small).should == '2000000000'
    end
  end

  it 'timestamped_name_url should return name url with timestamp' do
    @paperclip_time_stamped.should_receive(:name_url).with(:small).and_return('name_url')
    @paperclip_time_stamped.should_receive(:name_timestamp).with(:small).and_return('1000000000')
    @paperclip_time_stamped.timestamped_name_url(:small).should == 'name_url?1000000000'
  end

end
