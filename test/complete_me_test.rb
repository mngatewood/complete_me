
require 'simplecov'
SimpleCov.start

require "minitest"
require "minitest/emoji"
require "minitest/autorun"
require "../complete_me/lib/complete_me"

class CompleteMeTest < Minitest::Test
  attr_reader :cm
  def setup
    @cm = CompleteMe.new
  end

  def test_starting_count
    assert_equal 0, cm.count
  end

  def test_inserts_single_word
    cm.insert("pizza")
    assert_equal 1, cm.count
  end

  def test_inserts_multiple_words
    cm.populate("pizza\ndog\ncat")
    assert_equal 3, cm.count
  end

  def test_counts_inserted_words
    insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])
    assert_equal 5, cm.count
  end

  def test_suggests_off_of_small_dataset
    insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])
    assert_equal ["pizza"], cm.suggest("p")
    assert_equal ["pizza"], cm.suggest("piz")
    assert_equal ["zombies"], cm.suggest("zo")
    assert_equal ["a", "aardvark"], cm.suggest("a").sort
    assert_equal ["aardvark"], cm.suggest("aa")
  end

  def test_inserts_medium_dataset
    cm.populate(medium_word_list)
    assert_equal medium_word_list.split("\n").count, cm.count
  end

  def test_suggests_off_of_medium_dataset
    cm.populate(medium_word_list)
    assert_equal ["williwaw", "wizardly"], cm.suggest("wi").sort
  end

  def test_selects_off_of_medium_dataset
    cm.populate(medium_word_list)
    cm.select("wi", "wizardly")
    assert_equal ["wizardly", "williwaw"], cm.suggest("wi")
  end

  def test_works_with_large_dataset
    cm.populate(large_word_list)
    assert_equal ["doggerel", "doggereler", "doggerelism", "doggerelist", "doggerelize", "doggerelizer"], cm.suggest("doggerel").sort
    cm.select("doggerel", "doggerelist")
    assert_equal "doggerelist", cm.suggest("doggerel").first
  end

  def test_it_deletes_rwords
    cm.populate(large_word_list)

    cm.select('piz', 'pizzeria')
    cm.delete_word('pizzeria')

    expected = ["pize", "pizza", "pizzicato", "pizzle"]
    actual = cm.suggest('piz')

    assert_equal expected, actual
  end

  def test_it_can_do_addresses
    complete_me = CompleteMe.new
    complete_me.populate(File.read('./test/address.txt'))
    actual = complete_me.suggest('3161')
    expected = ["3161 Arapahoe St", "3161 N Eliot St", "3161 N Fulton St", "3161 N Hanover St", "3161 N Quitman St", "3161 W Avondale Dr", "3161 W Custer Pl", "3161 W Ohio Ave"]
    assert_equal actual, expected
  end

  def insert_words(words)
    cm.populate(words.join("\n"))
  end

  def medium_word_list
    File.read("./test/medium.txt")
  end

  def large_word_list
    File.read("/usr/share/dict/words")
  end
end
