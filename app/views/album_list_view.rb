#!/usr/bin/ruby
# album_list_view.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 22:14
# Modified: Wednesday, May 21, 2008 @ 22:28

class AlbumListView < FXList

  attr_reader :album_list

  def initialize(p, opts, album_list)
    super(p, :opts => opts)
    @album_list = album_list
    @album_list.each {|a| self << a }
  end

  def <<(album)
    appendItem(album.title)
  end
end