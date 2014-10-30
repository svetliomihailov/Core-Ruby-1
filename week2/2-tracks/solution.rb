require 'yaml'

class Track
  attr_accessor :artist, :name, :album, :genre

  def initialize(*args)
    if args.length == 4
      @artist, @name, @album, @genre = args[0], args[1], args[2], args[3]
    elsif args.length == 1
      # TODO: this will be changed when the HashWithIndifferentAccess is made!
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
end

class Playlist
  def self.from_yaml(path)
    tracks = []
    new_tracks = YAML.load_file(path)
    new_tracks.each { |_k, v| tracks << Track.new(v) }
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
    f_tracks = []
    @tracks.each { |e| f_tracks << e if e.name.include?(name) } 
    Playlist.new f_tracks
  end

  def find_by_artist(artist)
    f_tracks = []
    @tracks.each { |e| f_tracks << e if e.artist.include?(artist) } 
    Playlist.new f_tracks
  end

  def find_by_album(album)
    f_tracks = []
    @tracks.each { |e| f_tracks << e if e.album.include?(album) } 
    Playlist.new f_tracks
  end

  def find_by_genre(genre)
    f_tracks = []
    @tracks.each { |e| f_tracks << e if e.genre.include?(genre) } 
    Playlist.new f_tracks
  end

  def shuffle
    # Give me a new playlist that shuffles the tracks of the current one.
  end

  def random
    # Give me a random track.
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
