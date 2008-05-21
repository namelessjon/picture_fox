#!/usr/bin/ruby
# album_list.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:14
# Modified: Wednesday, May 21, 2008 @ 19:50

class AlbumList

  def intialize
    @albums = []
  end

  def <<(album)
    @albums << album
  end

  def delete(album)
    @albums.delete(album)
  end

  def each
    @albums.each {|a| yield a}
  end
end
