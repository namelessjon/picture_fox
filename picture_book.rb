#!/usr/bin/ruby
# picture_book.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:25
# Modified: Wednesday, May 21, 2008 @ 19:51
$:.unshift File.join(File.dirname(__FILE__),"app/models")
$:.unshift File.join(File.dirname(__FILE__),"app/views")
require 'rubygems'
require 'fox16'

include Fox

require 'photo'
require 'photo_view'

class PictureBook < FXMainWindow
  def initialize(app)
    super(app, "Picture Book", :width => 600, :height => 400)
    photo = Photo.new("/home/jon/temp_img/6986933-lg.jpg")
    photo_view = PhotoView.new(self, photo)
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
