#!/usr/bin/ruby
# photo.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:06
# Modified: Wednesday, May 21, 2008 @ 19:50

class Photo
  attr_reader :path

  def initialize(path)
    @path = path
  end
end
