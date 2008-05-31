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
