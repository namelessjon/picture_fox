#!/usr/bin/ruby
# album_list_view.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 22:14
# Modified: Monday, May 26, 2008 @ 15:01

class AlbumListView < FXList

  attr_reader :album_list

  def initialize(p, album_list, opts={})
    super(p, opts)
    @album_list = album_list
    @album_list.each {|a| self << a }
  end

  def <<(album)
    appendItem(album.title)
    currentItem = numItems - 1
  end
end
