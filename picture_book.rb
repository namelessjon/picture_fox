#!/usr/bin/ruby
# picture_book.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:25
# Modified: Wednesday, May 21, 2008 @ 22:30
$:.unshift File.join(File.dirname(__FILE__),"app/models")
$:.unshift File.join(File.dirname(__FILE__),"app/views")
require 'rubygems'
require 'fox16'

include Fox

require 'photo'
require 'album'
require 'album_list'
require 'album_view'
require 'album_list_view'

class PictureBook < FXMainWindow
  def initialize(app)
    super(app, "Picture Book", :width => 600, :height => 400)
    add_menu_bar
    @album = Album.new("My Album")
    @album_list = AlbumList.new
    @album_list << @album

    # create a splitter to let us resize list and display area
    splitter = FXSplitter.new(self, :opts => SPLITTER_HORIZONTAL|LAYOUT_FILL)

    @album_list_view = AlbumListView.new(splitter, 
                            LAYOUT_FILL, @album_list)
    @album_view = AlbumView.new(splitter, @album)
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end


  # adds a menu bar with a few options
  def add_menu_bar
    # menubar across the top, the width of the whole screen
    menu_bar = FXMenuBar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X)

    # will hold all the commands
    file_menu = FXMenuPane.new(self)

    # add a file menu to the menubar
    FXMenuTitle.new(menu_bar, "File", :popupMenu => file_menu)

    # now setup some actual menu commands
    # First, the one which will display our select box
    import_cmd = FXMenuCommand.new(file_menu, "Import ...")
    import_cmd.connect(SEL_COMMAND) do
      dialog = FXFileDialog.new(self, "Import Photos")
      dialog.selectMode = SELECTFILE_MULTIPLE
      dialog.patternList = ["JPEG Images (*.jpg, *.jpeg)"]
      if dialog.execute != 0
        import_photos(dialog.filenames)
      end
    end

    # a seperator
    FXMenuSeparator.new(file_menu)

    # And an exit command
    exit_cmd = FXMenuCommand.new(file_menu, "Exit")
    exit_cmd.connect(SEL_COMMAND) do
      exit
    end
  end

  def import_photos(filenames)
    filenames.each do |fn|
      p = Photo.new(fn)
      @album << p
      @album_view.add_photo(p)
    end
    @album_view.create
  end


end

if __FILE__ == $0
  FXApp.new do |app|
    PictureBook.new(app)
    app.create
    app.run
  end
end
