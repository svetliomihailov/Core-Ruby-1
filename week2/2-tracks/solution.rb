require 'yaml'

class Hash
  def with_indifferent_access
    HashWithIndifferentAccess.new(self)
  end
end

class HashWithIndifferentAccess < Hash
  attr_reader :h

  def initialize(hash)
    fail ArgumentError, "Only accepts hash tables" unless hash.instance_of?(Hash)
    @h = {}
    hash.each do |k, v|
      ks = k.instance_of?(Symbol) ? k.to_s : k
      @h.merge! ks => v
    end 
  end

end

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

  alias_method :eql?, :==

  def hash
    (@artist + @name + @album + @genre).hash
  end
end

class Playlist
  attr_reader :tracks

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
    Playlist.new @tracks.select { |e| block.call(e) }
  end

  def find_by(*filters)
    new_tracks = []
    filters.each do |f|
      if new_tracks.length.zero?
        new_tracks = @tracks.select { |t| f.call(t) if f.respond_to?(:call) }
      else
        new_tracks &= @tracks.select { |t| f.call(t) if f.respond_to?(:call) }
      end
    end
    Playlist.new new_tracks
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
    s = ''
    @tracks.each { |t| s += t.to_s + "\n\n" }
    s
  end

  def &(other)
    fail ArgumentError, 'The argument needs to be of Playlist type' \
      unless other.instance_of?(Playlist)
    Playlist.new @tracks & other.tracks
  end

  def |(other)
    fail ArgumentError, 'The argument needs to be of Playlist type' \
      unless other.instance_of?(Playlist)
    Playlist.new @tracks | other.tracks
  end

  def -(other)
    fail ArgumentError, 'The argument needs to be of Playlist type' \
      unless other.instance_of?(Playlist)
    Playlist.new @tracks - other.tracks
  end

  def ==(other)
    fail ArgumentError, 'The argument needs to be of Playlist type' \
      unless other.instance_of?(Playlist)
    @tracks == other.tracks
  end
end

class AwesomeArtistsFilter
  AWESOME_ARTISTS = %w(Iron\ Maiden Metallica Linkin\ Park)

  def call(track)
    AWESOME_ARTISTS.include? track.artist
  end
end

class AwesomeSongsFilter
  AWESOME_SONGS = %w(One Nothing\ else\ matters)

  def call(track)
    AWESOME_SONGS.include? track.name
  end
end
