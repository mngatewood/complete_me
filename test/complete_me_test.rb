# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'
require './lib/complete_me'

class CompleteMeTest < Minitest::Test
  def setup
    @complete_me = CompleteMe.new
  end

  def test_it_exists

    assert_instance_of CompleteMe, @complete_me
  end

  def test_it_adds_nodes
    actual = @complete_me.add_node('a', @complete_me.root.children).value
    assert_equal 'a', actual
  end

  def test_it_adds_character
    @complete_me.add_character('a', @complete_me.root.children)
    assert_equal 'a', @complete_me.root.children[0].value
  end

  def test_it_doesnt_add_duplicates
    @complete_me.add_character('a', @complete_me.root.children)
    @complete_me.add_character('a', @complete_me.root.children)
    assert_equal 1, @complete_me.root.children.count
  end

  def test_it_counts_words
    @complete_me.add_word('cat')
    @complete_me.add_word('can')
    @complete_me.add_word('cost')
    @complete_me.add_word('lap')
    @complete_me.add_word('astro')
    @complete_me.add_word('dinosaur')
    @complete_me.add_word('zebra')
    assert_equal 7, @complete_me.count
  end

  def test_it_populates
    dictionary = File.read('/usr/share/dict/words')
    @complete_me.populate(dictionary)
    assert_equal 235_886, @complete_me.count
  end

  def test_it_finds_words
    @complete_me.add_word('cat')

    assert @complete_me.include?('cat')
    refute @complete_me.include?('asmflkasmfkla')
  end

  def test_it_suggests_words
    @complete_me.add_word('cazimi')
    @complete_me.add_word('caza')
    @complete_me.add_word('cay')
    @complete_me.add_word('cayman')
    @complete_me.add_word('cayenne')
    @complete_me.add_word('cayenned')
    @complete_me.add_word('caxon')
    @complete_me.add_word('caxiri')

    expected = ['cazimi', 'caza', 'cay', 'cayman', 'cayenne', 'cayenned', 'caxon', 'caxiri'].sort

    assert_equal expected, @complete_me.suggest('ca')
  end

  def test_it_handles_empty_input_for_suggest
    actual = @complete_me.suggest('')

    assert_equal [], actual
  end

  def test_it_handles_no_matches_for_suggest
    actual = @complete_me.suggest('etewdjdkd')

    assert_equal [], actual
  end

  def test_it_weighs_words_on_user_input
    @complete_me.populate(File.read('/usr/share/dict/words'))
    actual = @complete_me.suggest('piz')
    expected = ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"]

    assert_equal expected, actual

    @complete_me.select('piz', 'pizzeria')

    actual2 = @complete_me.suggest('piz')
    expected2 = ["pizzeria", "pize", "pizza", "pizzicato", "pizzle"]

    assert_equal expected2, actual2
  end
end
