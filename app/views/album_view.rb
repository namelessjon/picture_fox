#!/usr/bin/ruby
# album_view.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 20:03
# Modified: Wednesday, May 21, 2008 @ 20:11
require 'photo_view'

class AlbumView < FXMatrix

  attr_reader :album

  def initialize(p, album)
    # LAYOUT_FILL is fairly ronseal!
    super(p, :opts => LAYOUT_FILL)
    @album = album
    @album.each {|p| add_photo(p) }
  end

  def add_photo(photo)
    PhotoView.new(self, photo)
  end
end
