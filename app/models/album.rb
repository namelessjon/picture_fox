#!/usr/bin/ruby
# album.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:07
# Modified: Wednesday, May 21, 2008 @ 20:09

class Album

  attr_reader :title

  def initialize(title,photos=[])
    @title = title
    @photos = photos
  end

  def <<(photo)
    @photos << photo
  end

  def each
    @photos.each { |p| yield p }
  end
end
