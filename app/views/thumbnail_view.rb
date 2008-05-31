class ThumbnailView < FXImageFrame

  attr_accessor :photo

  def initialize(p, photo)
    super(p, nil, :opts => FRAME_RAISED|LAYOUT_CENTER_X|LAYOUT_CENTER_Y|LAYOUT_FILL, 
         :width => 128, :height => 128)
    self.photo = photo
    load_image
  end

  def load_image
    self.image = FXPNGImage.new(app, photo.thumbnail)
  end
end
