# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'
require './lib/trie'

class TrieTest < Minitest::Test
  def setup
    @trie = Trie.new
  end

  def test_it_exists
    assert_instance_of Trie, @trie
  end

  def test_it_adds_nodes
    actual = (@trie.add_node('a', @trie.root.children)).value
    assert_equal 'a', actual
  end

  def test_it_adds_character
    @trie.add_character('a', @trie.root.children)
    assert_equal 'a', @trie.root.children[0].value
  end

  def test_it_doesnt_add_duplicates
    @trie.add_character('a', @trie.root.children)
    @trie.add_character('a', @trie.root.children)
    assert_equal 1, @trie.root.children.count
  end

  def test_it_adds_a_words
    @trie.add_word('cat')
    @trie.add_word('can')
    @trie.add_word('cost')
    @trie.add_word('lap')
    @trie.add_word('astro')
    @trie.add_word('dinosaur')
    @trie.add_word('zebra')
    assert_equal 5, @trie.root.children.count
  end

  def test_it_counts_words
    @trie.add_word('cat')
    @trie.add_word('can')
    @trie.add_word('cost')
    @trie.add_word('lap')
    @trie.add_word('astro')
    @trie.add_word('dinosaur')
    @trie.add_word('zebra')
    assert_equal 7, @trie.count
  end

  # def test_it_populates
  #   dictionary = File.read('/usr/share/dict/words')
  #   @trie.populate(dictionary)
  #   assert_equal 235_886, @trie.count
  # end
  #
  # def test_it_finds_words
  #   dictionary = File.read('/usr/share/dict/words')
  #   @trie.populate(dictionary)
  #
  #   assert @trie.include?('cat')
  #   refute @trie.include?('asmflkasmfkla')
  # end

  def test_it_suggests_words
    # dictionary = File.read('/usr/share/dict/words')
    # @trie.populate(dictionary)
    @trie.add_word("cazimi")
    @trie.add_word("caza")
    @trie.add_word("cay")
    @trie.add_word("cayman")
    @trie.add_word("cayenne")
    @trie.add_word("cayenned")
    @trie.add_word("caxon")
    @trie.add_word("caxiri")
    @trie.find_words_starting_with('ca')
  end

  # def test_it_suggests_words
  #
  #   dictionary = File.read('/usr/share/dict/words')
  #   @trie.populate(dictionary)
  #   expected = []
  #
  #   assert_equal expected, @trie.suggest('piz')
  # end
end
