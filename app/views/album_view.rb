#!/usr/bin/ruby
# album_view.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 20:03
# Modified: Wednesday, May 21, 2008 @ 22:01
require 'photo_view'

class AlbumView < FXMatrix

  attr_reader :album

  def initialize(p, album)
    # LAYOUT_FILL is fairly ronseal!
    super(p, :opts => LAYOUT_FILL|MATRIX_BY_COLUMNS)
    @album = album
    @album.each {|p| add_photo(p) }
  end

  def add_photo(photo)
    PhotoView.new(self, photo)
  end

  # layout gets called on each resize automagically by fxruby
  def layout
    # number of columns = the most we can fit on one row, or 1 if that is 
    # too small
    self.numColumns = [width/PhotoView::MAX_WIDTH,1].max
    super
  end
end
