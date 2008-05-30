#!/usr/bin/ruby
# album.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:07
# Modified: Friday, May 30, 2008 @ 21:31
require 'dm-validations'
require 'dm-timestamps'

class Album
  include DataMapper::Resource

  property :id,     Integer,  :serial => true
  property :title,  String,   :nullable => false, :unique => true
  property :description, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :photos
end
