# Tracks

Music is awesome, everybody gets it. Let's model a small part of a music player
functionality -- its ability to manage tracks.

# Track

First, model the track class. It should store the fields
`:artist, :name, :album, :genre`.


```ruby
class Track
  # Your code goes here.
end

track.respond_to? :artist #=> true
track.respond_to? :name   #=> true
track.respond_to? :album  #=> true
track.respond_to? :genre  #=> true

track.respond_to? :artist= #=> true
track.respond_to? :name=   #=> true
track.respond_to? :album=  #=> true
track.respond_to? :genre=  #=> true

# I wanna be able to initialize a track like this:
track = Track.new "KAYTRANADA feat. Shay Lia", "Leave me alone", "So Bad", "Dance"

# To make it more clear, I also wanna instantiate it like this:
track = Track.new artist:"KAYTRANADA feat. Shay Lia",
                  name: "Leave me alone",
                  album: "So Bad",
                  genre: "Dance"

# If I miss a field, I want a gentle reminder that I need to pass it. Hint,
# look up [Hash#fetch][].
track = Track.new artist:"KAYTRANADA feat. Shay Lia",
                  name: "Leave me alone",
                  album: "So Bad",
                  genre: "Dance"
```

## Playlist

Playlist is an ordered collection of tracks. A neat functionality is that we
can search tracks.

I want you to test out an idea. Implement `Playlist#each`, that returns an
enumerator if no block given. That way, we can get all the benefits of
including Enumerable, without polluting the class with a ton of methods.

```ruby
class Playlist
  def from_path(path)
    # Your code goes here.
  end

  def initialize(*tracks)
    # Your code goes here.
  end

  def each
    # Your code goes here.
  end

  def find(&block)
    # Filter the playlist by a block. Should return a new Playlist.
  end

  def find_by(*filters)
    # Filter is any object that responds to the method #call. #call accepts one
    # argument, the track it should match or not match.
    #
    # Should return a new Playlist.
  end

  def find_by_name(name)
    # Filter the playlist by a block. Should return a new Playlist.
  end

  def find_by_artist(artist)
    # Finds all the tracks by the artist
  end

  def find_by_album(album)
    # Finds all the tracks from the album.
  end

  def find_by_genre(genre)
    # Finds all the tracks by genre.
  end

  def shuffle
    # Give me a new playlist that shuffles the tracks of the current one.
  end

  def random
    # Give me a random track.
  end

  def to_s
    # It should return a nice tabular representation of all the tracks.
    Checkout the String method for something that can help you with that.
  end

  def &(playlist)
    # Your code goes here. This _should_ return new playlist.
  end

  def |(playlist)
    # Your code goes here. This _should_ return new playlist.
  end

  def -(playlist)
    # Your code goes here. This _should_ return new playlist.
  end
end

# I wanna be able to initialize a playlist like this:
playlist = Playlist.new(track1, track2, track3)

# To make things more interesting, I wanna be able to initialize it like this
# too:
playlist = Playlist.new([track1, track2, track3])

# I wanna choose only the jazzy house tracks.
jazz_playlist & house_playlist

# I wanna exclude any house tracks from my playlist.
jazz_playlist - house_playlist

# I wanna combine my soul and funk tracks.
soul_playlist | house_playlist

# I wanna be able to filter the tracks by a block.
playlist.find_by { |track| ["Led Zeppellin", "The Doors"].include? track.artist }

# I wanna be able by a filter object.
class AwesomeRockFilter
  AWESOME_ARTISTS = %w(Led\ Zeppellin The\ Doors Black\ Sabbath)

  def call(track)
    AWESOME_ARTIST.include? track.artist
  end
end

playlist.find_by AwesomeRockFilter.new

# Because of the interface, I wanna be able to filter it out with a proc too.
awesome_rock_filter = proc do |track|
  awesome_artists = %w(Led\ Zeppellin The\ Doors Black\ Sabbath)
  awesome_artist.include? track.artist
end

playlist.find_by awesome_rock_filter
```

[Hash#fetch]: http://ruby-doc.org/core-2.1.4/Hash.html#fetch
