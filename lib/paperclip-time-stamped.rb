require 'rubygems'
require 'active_record'

ActiveRecord::Base.class_eval do

  def self.has_timestamped_paperclip_attachment(name)

    define_method("#{name}_url") do |style|
      send(name).url(style)
    end

    define_method("#{name}_path") do |style|
      send(name).path(style)
    end

    define_method("#{name}_timestamp") do |style|
      send("#{name}?") ? File.mtime(send("#{name}_path", style)).to_i.to_s : '1000000000'
    end

    define_method("timestamped_#{name}_url") do |style|
      [send("#{name}_url", style), '?', send("#{name}_timestamp", style)].join
    end

    define_method("#{name}?") do
      send(name).exists?
    end

  end

end
