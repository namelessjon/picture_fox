#!/usr/bin/ruby
# photo.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:06
# Modified: Thursday, May 29, 2008 @ 02:23
require 'dm-types'
require 'dm-validations'
require 'dm-timestamps'
require 'pathname'
require 'fileutils'
require 'ruby-debug'

class Photo
  include DataMapper::Resource

  ThumbSize = 128

  before :valid?, :expand_path
  before :valid?, :calculate_crypt_sums
  before :create, :set_width_and_height

  after :create, :make_thumbnail

  # @@thumbnail_root = "#{ENV['HOME']}/.thumbnails/normal"
  @@thumbnail_root = 'thumbs'

  property :id,         Integer, :serial => true
  property :path,       FilePath, :length => 200, :nullable => false
  property :md5,        String, :length => 32, :nullable => false
  property :sha1,       String, :length => 40, :nullable => false
  property :created_at, DateTime
  property :updated_at, DateTime
  property :height,     Integer
  property :width,      Integer

  # returns the thumbnail root for the whole class
  def self.thumbnail_root
    @@thumbnail_root
  end

  # sets the thumbnail root
  def self.thumbnail_root=(root)
    @@thumbnail_root = root
  end

  # returns the canonical absolute URI of the file (RFC 2396)
  def uri
    "file://#{path}"
  end

  # returns a binary dump of the contents
  def contents
    path.read
  end

  # returns the aspect ratio of the image
  def aspect_ratio
    self.width.to_f/self.height
  end

  # returns the base filename of the thumbnail.
  # This is the md5sum of the absolute uri of the file
  def thumbnail_name
    require 'digest/md5'
    "#{Digest::MD5.hexdigest(uri)}.png"
  end
  
  # returns a path to the thumbnail.
  # http://jens.triq.net/thumbnail-spec/index.html
  def thumbnail_path
    Pathname.new(File.join(@@thumbnail_root, thumbnail_name))
  end

  # returns the contents of the thumbnail
  def thumbnail
    # we might not have a thumbnail.  Maybe it got deleted?
    begin
      thumbnail_path.read
    rescue Errno::ENOENT
      make_thumbnail
      retry
    end
  end
  
  # returns an array of thumbnail dimensions
  def thumbnail_dimensions
    if height > width
      resize_height = [Photo::ThumbSize, height].min
      resize_width = resize_height*aspect_ratio
    else
      resize_width = [Photo::ThumbSize, width].min
      resize_height = resize_width/aspect_ratio
    end
    puts "h: #{resize_height}"
    puts "w: #{resize_width}"
    return [resize_width, resize_height]
  end

  protected
  def calculate_crypt_sums(context)
    require 'digest/md5'
    require 'digest/sha1'
    c = contents
    self.md5 = Digest::MD5.hexdigest(c)
    self.sha1 = Digest::SHA1.hexdigest(c)
  end

  def expand_path(context = :default)
    self.path = path.realpath
  end

  # check to see if our thumbnail is fresh
  def fresh_thumbnail?
    thumbnail_path.exist? and thumbnail_path.mtime > path.mtime
  end


  # makes a thumbnail image, as per 
  # http://jens.triq.net/thumbnail-spec/index.html
  def make_thumbnail(context=:default)
    # first, check to see if we need, if we don't then just go!
    return true if fresh_thumbnail?
    # make our thumbnail directory, just in case it isn't there
    Photo.make_thumbnail_root

    # actually make the thumbnail
    construct_thumbnail_image
  end

  def construct_thumbnail_image
    # make a temporary path so our creation is as atomic as possible
    tmp_path = File.join(@@thumbnail_root, 
      "#{@@thumbnail_root.hash}-#{Time.now.to_i}")

    # make the thumbnail
    require 'image_science'
    debugger
    ImageScience.with_image(path) do |img|
      w, h = thumbnail_dimensions
      img.resize(w, h) do |thumb|
        thumb.save tmp_path
      end
    end

    # rename the tmp image to the real one!
    FileUtils.mv tmp_path, thumbnail_path
  end


  def set_width_and_height(context = :default)
    require 'image_science'
    debugger
    ImageScience.with_image(path) do |img|
      self.width = img.width
      self.height = img.height
    end
  end


  def self.make_thumbnail_root
    FileUtils.mkdir_p @@thumbnail_root
  end

end
