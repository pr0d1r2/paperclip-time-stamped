require 'rubygems'
require 'active_record'
require 'paperclip'

ActiveRecord::Base.class_eval do

  def self.has_timestamped_paperclip_attachment(name)

    define_method("#{name}_url") do |*style|
      send(name).url(style.first)
    end

    define_method("#{name}_path") do |*style|
      send(name).path(style.first)
    end

    define_method("#{name}_timestamp") do |*style|
      send("#{name}?", style.first) ? File.mtime(send("#{name}_path", style.first)).to_i.to_s : '1000000000'
    end

    define_method("timestamped_#{name}_url") do |*style|
      [send("#{name}_url", style.first), '?', send("#{name}_timestamp", style.first)].join
    end

    define_method("#{name}?") do |*style|
      send(name).exists? && (style.empty? || File.file?(send("#{name}_path", style.first)))
    end

  end

end
