class Track
  attr_accessor :artist, :name, :album, :genre

  def initialize(*args)
    if args.length == 4
      @artist = args[0]
      @name = args[1]
      @album = args[2]
      @genre = args[3]
    elsif args.length == 1
      fail(ArgumentError, "You need to provide artist, name, album and genre of the track.
They may be formated as a hash or as 4 separate arguments in that order") \
        unless args[0].instance_of? Hash
      @artist = args[0][:artist]
      @name = args[0][:name]
      @album = args[0][:albun]
      @genre = args[0][:genre]
    else
      fail(ArgumentError, "You need to provide artist, name, album and genre of the track.
They may be formated as a hash or as 4 separate arguments in that order")
    end
  end
end

class Playlist
  
end