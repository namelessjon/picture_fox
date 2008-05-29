#!/usr/bin/ruby
# thumbnail_view.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:29
# Modified: Thursday, May 29, 2008 @ 02:01

class ThumbnailView < FXImageFrame
  def initialize(p, photo)
    super(p, nil)
    load_image(photo)
  end

  def load_image(photo)
    self.image = FXPNGImage.new(app, photo.thumbnail)
  end
end
