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

  def test_track_methods_respond
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

  def test_track_equal
    assert_equal true, new_track == Track.new('KAYTRANADA feat. Shay Lia', \
                                              'Leave me alone', \
                                              'So Bad', 'Dance')
  end

  def test_playlist_create
    assert_raises(TypeError) { Playlist.new 'bla' }
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
    cnt, pl = 0, Playlist.from_yaml('tracks.yml')
    pl2 = pl.find { |e| e.artist.include?('Metallica') }
    pl2.each do |e|
      assert_equal 'Metallica', e.artist
      cnt += 1
    end
    assert_equal 2, cnt
  end

  def test_playlist_find_by_name
    cnt, pl = 0, Playlist.from_yaml('tracks.yml')
    pl2 = pl.find_by_name('Numb')
    pl2.each do |e|
      assert_equal 'Numb', e.name
      cnt += 1
    end
    assert_equal 1, cnt
  end

  def test_playlist_find_by_artist
    cnt, pl = 0, Playlist.from_yaml('tracks.yml')
    pl2 = pl.find_by_artist('Metallica')
    pl2.each do |e|
      assert_equal 'Metallica', e.artist
      cnt += 1
    end
    assert_equal 2, cnt
  end

  def test_playlist_find_by_album
    cnt, pl = 0, Playlist.from_yaml('tracks.yml')
    pl2 = pl.find_by_album('...And Justice for All')
    pl2.each do |e|
      assert_equal '...And Justice for All', e.album
      cnt += 1
    end
    assert_equal 1, cnt
  end

  def test_playlist_find_by_genre
    cnt, pl = 0, Playlist.from_yaml('tracks.yml')
    pl2 = pl.find_by_genre('power ballad')
    pl2.each do |e|
      assert_equal 'power ballad', e.genre
      cnt += 1
    end
    assert_equal 1, cnt
  end

  def test_playlist_random
    pl = Playlist.from_yaml('tracks.yml')
    tr = pl.random
    tr2 = pl.random
    assert_equal true, tr.instance_of?(Track)
    assert_equal true, tr2.instance_of?(Track)
  end

  def test_playlist_shuffle
    pl = Playlist.from_yaml('tracks.yml')
    pl2 = pl.shuffle
    assert_equal false, pl == pl2
  end
end
