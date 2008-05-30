#!/usr/bin/ruby
# picture_book.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
# Created: Wednesday, May 21, 2008 @ 19:25
# Modified: Friday, May 30, 2008 @ 20:03
$:.unshift File.join(File.dirname(__FILE__),"app/models")
$:.unshift File.join(File.dirname(__FILE__),"app/views")
require 'rubygems'
require 'fox16'

gem 'dm-core', '0.9.1'
require 'data_mapper'

DataMapper.setup(:default, 'sqlite3:///pictures.db')

include Fox



require 'photo'
require 'album'
require 'album_list'
require 'album_view'
require 'album_list_view'

Photo.auto_migrate!

class PictureBook < FXMainWindow
  def initialize(app)
    super(app, "Picture Book", :width => 600, :height => 400)
    add_menu_bar
    @album = Album.new("My Album")
    @album_list = AlbumList.new
    @album_list << @album

    # create a splitter to let us resize list and display area
    splitter = FXSplitter.new(self, :opts => SPLITTER_HORIZONTAL|LAYOUT_FILL)

    @album_list_view = AlbumListView.new(splitter, @album_list, :width => 100, 
                            :opts => LAYOUT_FILL)
    
    # allow us to switch between albums!
    @switcher = FXSwitcher.new(splitter, :opts => LAYOUT_FILL)
    
    @switcher.connect(SEL_UPDATE) do
      if @album_list_view.currentItem > -1
        @switcher.current = @album_list_view.currentItem 
      end
    end
    
    @album_view = AlbumView.new(@switcher, @album)
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
      dialog.patternList = ["JPEG Images (*.jpg, *.jpeg)", 
                            "GIF Images (*.gif)"]
      if dialog.execute != 0
        import_photos(dialog.filenames)
      end
    end

    # A new album command!
    new_album_command = FXMenuCommand.new(file_menu, "New Album ...")
    new_album_command.connect(SEL_COMMAND) do
      album_title = FXInputDialog.getString("My Album", self,
                                           "New Album", "Name:")
      if album_title
        album = Album.new(album_title)
        @album_list << album
        @album_list_view << album
        AlbumView.new(@switcher, album)

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
      p = Photo.new(:path => fn)
      if p.save
        current_album << p
        current_album_view.add_photo(p)
      else
        string = "Errors on the photo:\n"
        p.errors.each do |e|
          string << " - #{e}\n"
        end
        FXMessageBox.warning(self, MBOX_OK, "I can has problems :(", string) 
      end
    end
    current_album_view.create
  end

  # the view of the current album we're looking at
  def current_album_view
    @switcher.childAtIndex(@switcher.current)
  end

  # the actual current album!
  def current_album
    current_album_view.album
  end


end

if __FILE__ == $0
  FXApp.new do |app|
    PictureBook.new(app)
    app.create
    app.run
  end
end
