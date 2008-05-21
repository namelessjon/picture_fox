#!/usr/bin/ruby
# photo_view.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:29
# Modified: Wednesday, May 21, 2008 @ 19:56

class PhotoView < FXImageFrame
  def initialize(p, photo)
    super(p, nil)
    load_image(photo.path)
  end

  def load_image(path)
    File.open(path, "rb") do |io|
      self.image = FXJPGImage.new(app, io.read)
    end
  end
end
