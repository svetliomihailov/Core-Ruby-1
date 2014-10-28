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

  def test_track_create
    track = Track.new "KAYTRANADA feat. Shay Lia", "Leave me alone", "So Bad", "Dance"
    track_2 = Track.new artist: "KAYTRANADA feat. Shay Lia",
                        name: "Leave me alone",
                        album: "So Bad",
                        genre: "Dance"

    track_3 = Track.new @config["two"]
    track_4 = Track.new "ba'", "wa"
  end
end
