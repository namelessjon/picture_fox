class AlbumListView < FXList

  attr_reader :album_list
  attr_accessor :switcher

  def initialize(p, opts={})
    super(p, opts)
  end

  # adds an album to the list view, inserting an appropriate entry in the list 
  # panel to the left and also instantiating a new view to hold all the photos
  # in the album.
  def <<(album)
    appendItem(album.title)
    AlbumView.new(switcher, album)
  end

  # assigns an album list to the view, instantiating new views as appropriate.
  def album_list=(albums)
    @album_list = albums
    @album_list.each {|a| self << a }
  end
end
