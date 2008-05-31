#!/usr/bin/ruby
# picture_fox.rb
# Jonathan D. Stott <jonathan.stott@gmail.com>
$:.unshift File.join(File.dirname(__FILE__),"app/models")
$:.unshift File.join(File.dirname(__FILE__),"app/views")
require 'rubygems'
require 'fox16'
include Fox

gem 'dm-core', '0.9.1'
require 'data_mapper'

DataMapper.setup(:default, 'sqlite3:///pictures.db')

require 'photo'
require 'album'
require 'album_view'
require 'album_list_view'

DataMapper.repository(:default).auto_upgrade!

class PictureFox < FXMainWindow
  def initialize(app)
    super(app, "Picture Fox", :width => 600, :height => 400)
    add_menu_bar

    @albums = Album.all.entries
    if @albums.empty?
      Album.create(:title => "My Photos")
      @albums = Album.all.entries
    end

    # create a splitter to let us resize list and display area
    splitter = FXSplitter.new(self, :opts => SPLITTER_HORIZONTAL|LAYOUT_FILL)

    @album_list_view = AlbumListView.new(splitter, :width => 100, 
                            :opts => LAYOUT_FILL)

    add_album_list_context_menu
    
    # allow us to switch between albums!
    @switcher = FXSwitcher.new(splitter, :opts => LAYOUT_FILL)
    
    @switcher.connect(SEL_UPDATE) do
      if @album_list_view.currentItem > -1
        @switcher.current = @album_list_view.currentItem 
      end
    end

    @album_list_view.switcher = @switcher
    @album_list_view.album_list = @albums
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
    new_album_command.connect(SEL_COMMAND, method(:new_album_menu_item))

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
        current_album.photos << p
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

  # provides the functionality behind the 'New Album' menu entry
  def new_album_menu_item(sender, selector, data)
    album_title = FXInputDialog.getString("My Album", self,
                                           "New Album", "Name:")
    if album_title
      while true
        album = Album.new(:title => album_title)
        if album.save
          @album_list_view << album
          break
        else
          s=[]
          s << "There were problems with that album."
          album.errors.each do |e|
            s << " - #{e}"
          end
          album_title = FXInputDialog.getString(album.title, self,
                                        "Oops! ", s.join("\n"))
          break if album_title.nil?
        end
      end
    end
  end

  # adds our context menu to the album list
  def add_album_list_context_menu
    @album_list_view.connect(SEL_RIGHTBUTTONRELEASE) do |sender, sel, event|
      # if we moved, we probably didn't want a menu!
      unless event.moved?
        index = sender.getItemAt(event.win_x, event.win_y)
        unless index.nil?
          album = Album.first(:title => sender.getItemText(index))
          FXMenuPane.new(self) do |m|
            rename = FXMenuCommand.new(m, "Rename Album")
            rename.connect(SEL_COMMAND) do
              name = rename_album(album)
              @album_list_view.setItemText(index, name) unless name.nil?
            end
            m.create
            m.popup(nil, event.root_x, event.root_y)
            app.runModalWhileShown(m)
          end
        end
      end
    end
  end

  # defines the rename menu command option
  def rename_album(album)
    album_title = FXInputDialog.getString(album.title, self,
                                           "Rename Album", "Name:")
    if album_title
      while true
        album.attribute_set(:title, album_title)
        if album.save
          return album_title
        else
          s=[]
          s << "There were problems with that title."
          album.errors.each do |e|
            s << " - #{e}"
          end
          album_title = FXInputDialog.getString(album.title, self,
                                        "Oops! ", s.join("\n"))
          return nil if album_title.nil?
        end
      end
    end
  end

  # finds an album from the given event
  def get_album_from_event(sender, event)
    #index = sender.getItemAt(event.win_x, event.win_y)
    #return nil if index.nil?
    entry = sender.getItem(event)
    album = Album.first(:title => entry.text)
  end

end

if __FILE__ == $0
  FXApp.new do |app|
    PictureFox.new(app)
    app.create
    app.run
  end
end
