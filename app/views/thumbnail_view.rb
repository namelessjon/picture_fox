class ThumbnailView < FXImageFrame

  attr_accessor :photo

  def initialize(p, photo)
    super(p, nil)
    self.photo = photo
    load_image
  end

  def load_image
    self.image = FXPNGImage.new(app, photo.thumbnail)
  end
end
