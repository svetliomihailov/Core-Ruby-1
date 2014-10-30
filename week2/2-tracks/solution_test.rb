require 'minitest/autorun'
require 'yaml'

require_relative 'solution'

class SolutionTest < Minitest::Test
  def setup
    @config = YAML.load_file('tracks.yml')
  end

  def teardown
    @config = nil
  end

  def test_track_create_with_bad_args
    assert_raises(ArgumentError) { Track.new 'bla', 'blabla' }
    assert_raises(ArgumentError) { Track.new 'bla' }
  end

  def new_track
    Track.new 'KAYTRANADA feat. Shay Lia', 'Leave me alone', \
              'So Bad', 'Dance'
  end

  def test_track_methods
    tr = new_track
    assert_respond_to tr, :artist
    assert_respond_to tr, :name
    assert_respond_to tr, :album
    assert_respond_to tr, :genre
    assert_respond_to tr, :artist=
    assert_respond_to tr, :name=
    assert_respond_to tr, :album=
    assert_respond_to tr, :genre=
  end

  def test_playlist_create
    assert_raises(TypeError) { Playlist.new "bla" }
  end

  def test_playlist_each
    pl = Playlist.new new_track, new_track
    assert_equal true, pl.each.is_a?(Enumerator)
  end

  def test_playlist_load_from_yaml
    pl = Playlist.from_yaml('tracks.yml')
    pl.each do |tr|
      assert_equal true, tr.instance_of?(Track)
    end
    assert_raises(Errno::ENOENT) { Playlist.from_yaml('tr.yml') }
  end

  def test_playlist_find
    pl = Playlist.from_yaml('tracks.yml')

    pl2 = pl.find do |e| 
      e.artist.include?('Metallica')
    end
    
    pl2.each { |e| assert_equal 'Metallica', e.artist }
  end
end
