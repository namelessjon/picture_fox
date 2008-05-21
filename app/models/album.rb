#!/usr/bin/ruby
# album.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:07
# Modified: Wednesday, May 21, 2008 @ 19:14

module PictureBook
  class Album

    attr_reader :title

    def initialize(title,photos=[])
      @title = title
      @photes = photoes
    end

    def <<(photo)
      @photos << photo
    end

    def each
      @photos.each { |p| yield p }
    end
  end
end
