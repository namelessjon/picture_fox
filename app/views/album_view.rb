#!/usr/bin/ruby
# album_view.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 20:03
# Modified: Friday, May 30, 2008 @ 23:14
require 'thumbnail_view'

class AlbumView < FXScrollWindow

  attr_reader :album

  def initialize(p, album)
    # LAYOUT_FILL is fairly ronseal!
    super(p, :opts => LAYOUT_FILL)
    @album = album
    FXMatrix.new(self, :opts => LAYOUT_FILL|MATRIX_BY_COLUMNS)
    @album.photos.each {|photo| add_photo(photo) }
  end

  
  def add_photo(photo)
    # contentWindow is the content of the FXScrollWindow
    # Thanks to the FXMatrix.new(self ...) declaration up there, it's that FXMatrix
    # See FXRuby, pg 52
    ThumbnailView.new(contentWindow, photo)
  end

  # layout gets called on each resize automagically by fxruby
  def layout
    # number of columns = the most we can fit on one row, or 1 if that is 
    # too small
    contentWindow.numColumns = [width/Photo::ThumbSize,1].max
    super
  end
end
