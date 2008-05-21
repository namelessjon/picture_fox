#!/usr/bin/ruby
# picture_book.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:25
# Modified: Wednesday, May 21, 2008 @ 19:27

require 'rubygems'
require 'fox16'

include Fox

class PictureBook < FXMainWindow
  def initialize(app)
    super(app, "Picture Book", :width => 600, :height => 400)
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
