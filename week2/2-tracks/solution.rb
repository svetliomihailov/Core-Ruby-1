require 'yaml'

class Track
  attr_accessor :artist, :name, :album, :genre

  def initialize(*args)
    if args.length == 4
      @artist, @name, @album, @genre = args[0], args[1], args[2], args[3]
    elsif args.length == 1
      fail ArgumentError, 'Hash with artist, name, album and genre required' \
        unless args[0].instance_of? Hash
      @artist = args[0][:artist] ? args[0][:artist] : args[0]['artist']
      @name = args[0][:name] ? args[0][:artist] : args[0]['name']
      @album = args[0][:albun] ? args[0][:artist] : args[0]['album']
      @genre = args[0][:genre] ? args[0][:artist] : args[0]['genre']
    else
      fail ArgumentError, 'You need to provide artist, name, album and genre.'
    end
  end

  def to_s
    "Title:    #{@name}\nArtist:   #{@artist}\n" + \
    "Album:    #{@album}\nGenre:    #{@genre}"
  end

  def ==(other)
    @artist == other.artist && @name == other.name && \
    @album == other.album && @genre == other.genre
  end
end

class Playlist
  def self.from_yaml(path)
    tracks = []
    new_tracks = YAML.load_file(path)
    new_tracks.each { |e| tracks << Track.new(e) }
    Playlist.new tracks
  end

  def initialize(*args)
    @tracks = []
    args.flatten.each do |e|
      fail TypeError, 'Track objects required' unless e.instance_of? Track
      @tracks << e
    end
  end

  def each
    if block_given?
      @tracks.each { |e| yield e }
    else
      return @traks.enum_for(:each) { size }
    end
  end

  def find(&block)
    f_tracks = []
    @tracks.each { |e| f_tracks << e if block.call(e) }
    Playlist.new f_tracks
  end

  def find_by(*filters)
    # Filter is any object that responds to the method #call. #call accepts one
    # argument, the track it should match or not match.
    #
    # Should return a new Playlist.
  end

  def find_by_name(name)
    Playlist.new @tracks.select { |e| e.name.include?(name) }
  end

  def find_by_artist(artist)
    Playlist.new @tracks.select { |e| e.artist.include?(artist) }
  end

  def find_by_album(album)
    Playlist.new @tracks.select { |e| e.album.include?(album) }
  end

  def find_by_genre(genre)
    Playlist.new @tracks.select { |e| e.genre.include?(genre) }
  end

  def shuffle
    Playlist.new @tracks.shuffle
  end

  def random
    @tracks[Random.rand(@tracks.length)]
  end

  def to_s
    # It should return a nice tabular representation of all the tracks.
    # Checkout the String method for something that can help you with that.
  end

  def &(other)
    # Your code goes here. This _should_ return new playlist.
  end

  def |(other)
    # Your code goes here. This _should_ return new playlist.
  end

  def -(other)
    # Your code goes here. This _should_ return new playlist.
  end
end
