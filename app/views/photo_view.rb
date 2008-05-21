#!/usr/bin/ruby
# photo_view.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:29
# Modified: Wednesday, May 21, 2008 @ 20:39

class PhotoView < FXImageFrame
  MAX_WIDTH = 200
  MAX_HEIGHT = 200

  def initialize(p, photo)
    super(p, nil)
    load_image(photo.path)
  end

  def load_image(path)
    File.open(path, "rb") do |io|
      self.image = FXJPGImage.new(app, io.read)
    end
    scale_to_thumbnail
  end

  def scaled_width
    [image.width,MAX_WIDTH].min
  end

  def scaled_height
    [image.height,MAX_HEIGHT].min
  end

  def aspect_ratio
    image.width.to_f/image.height
  end

  def scale_to_thumbnail
    if image.width > image.height
      image.scale(scaled_width, scaled_width/aspect_ratio, 1)
    else
      image.scale(scaled_height*aspect_ratio, scaled_height, 1)
    end
  end


end
