#!/usr/bin/ruby
# picture_book.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:25
# Modified: Wednesday, May 21, 2008 @ 20:10
$:.unshift File.join(File.dirname(__FILE__),"app/models")
$:.unshift File.join(File.dirname(__FILE__),"app/views")
require 'rubygems'
require 'fox16'

include Fox

require 'photo'
require 'album'
require 'album_view'

class PictureBook < FXMainWindow
  def initialize(app)
    super(app, "Picture Book", :width => 600, :height => 400)
    @album = Album.new("My Album")
    @album << Photo.new("/home/jon/temp_img/6986933-lg.jpg")
    @album << Photo.new("/home/jon/temp_img/XQTdQMQu942b5w9qHVMVJhEX_500.jpg")
    @album_view = AlbumView.new(self, @album)
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

if __FILE__ == $0
  FXApp.new do |app|
    PictureBook.new(app)
    app.create
    app.run
  end
end
