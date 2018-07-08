# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'
require './lib/trie'
require 'pry'

class TrieTest < Minitest::Test
  def test_it_exists
    trie = Trie.new
    assert_instance_of Trie, trie
  end

  def test_it_adds_nodes
    trie = Trie.new
    actual = (trie.add_node('a', trie.root.children)).value
    assert_equal 'a', actual
  end

  def test_it_adds_character
    trie = Trie.new
    trie.add_character('a', trie.root.children)
    assert_equal 'a', trie.root.children[0].value
  end

  def test_it_doesnt_add_duplicates
    trie = Trie.new
    trie.add_character('a', trie.root.children)
    trie.add_character('a', trie.root.children)
    assert_equal 1, trie.root.children.count
  end

  def test_it_adds_a_words
    trie = Trie.new
    trie.add_word('cat')
    trie.add_word('can')
    trie.add_word('cost')
    trie.add_word('lap')
    trie.add_word('astro')
    trie.add_word('dinosaur')
    trie.add_word('zebra')
    assert_equal 5, trie.root.children.count
  end
end
