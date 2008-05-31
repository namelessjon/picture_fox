class ThumbnailView < FXImageFrame
  def initialize(p, photo)
    super(p, nil)
    load_image(photo)
  end

  def load_image(photo)
    self.image = FXPNGImage.new(app, photo.thumbnail)
  end
end
