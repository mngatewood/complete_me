# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'
require './lib/complete_me'
require 'pry'

class CompleteMeTest < Minitest::Test
  def test_it_exists
    @complete_me = CompleteMe.new
    assert_instance_of CompleteMe, @complete_me
  end

  def test_it_adds_nodes
    @complete_me = CompleteMe.new
    actual = @complete_me.add_node('a', @complete_me.root.children).value
    assert_equal 'a', actual
  end

  def test_it_adds_character
    @complete_me = CompleteMe.new
    @complete_me.node_validator('a', @complete_me.root.children)
    assert_equal 'a', @complete_me.root.children[0].value
  end

  def test_it_doesnt_add_duplicates
    @complete_me = CompleteMe.new
    @complete_me.node_validator('a', @complete_me.root.children)
    @complete_me.node_validator('a', @complete_me.root.children)
    assert_equal 1, @complete_me.root.children.count

  end

  def test_it_counts_words
    @complete_me = CompleteMe.new
    @complete_me.insert('cat')
    @complete_me.insert('can')
    @complete_me.insert('cost')
    @complete_me.insert('lap')
    @complete_me.insert('astro')
    @complete_me.insert('dinosaur')
    @complete_me.insert('zebra')
    assert_equal 7, @complete_me.count
  end

  def test_it_populates
    @complete_me = CompleteMe.new
    dictionary = File.read('/usr/share/dict/words')
    @complete_me.populate(dictionary)
    assert_equal 235_886, @complete_me.count
  end

  def test_it_suggests_words
    @complete_me = CompleteMe.new
    @complete_me.insert('cazimi')
    @complete_me.insert('caza')
    @complete_me.insert('cay')
    @complete_me.insert('cayman')
    @complete_me.insert('cayenne')
    @complete_me.insert('cayenned')
    @complete_me.insert('caxon')
    @complete_me.insert('caxiri')

    expected = ['cazimi', 'caza', 'cay', 'cayman', 'cayenne', 'cayenned', 'caxon', 'caxiri'].sort

    assert_equal expected, @complete_me.suggest('ca')
  end

  def test_it_handles_empty_input_for_suggest
    @complete_me = CompleteMe.new
    actual = @complete_me.suggest('')

    assert_equal [], actual
  end

  def test_it_handles_no_matches_for_suggest
    @complete_me = CompleteMe.new
    actual = @complete_me.suggest('etewdjdkd')
    assert_equal [], actual
  end

  def test_it_counts_suggests
    @complete_me = CompleteMe.new
    @complete_me.insert('pize')
    @complete_me.insert('pizza')
    @complete_me.insert('pizzeria')
    @complete_me.insert('pizzicato')
    @complete_me.insert('pizzle')
    @complete_me.select('piz', 'pizzeria')
    @complete_me.select('piz', 'pizzeria')
    @complete_me.select('piz', 'pizzeria')
    assert_equal 3, @complete_me.suggest_rank_hash['piz']['pizzeria']
  end

  def test_it_weighs_words_on_user_input
    @complete_me = CompleteMe.new
    @complete_me.populate(File.read('/usr/share/dict/words'))
    actual = @complete_me.suggest('piz')
    expected = ['pize', 'pizza', 'pizzeria', 'pizzicato', 'pizzle']

    assert_equal expected, actual

    @complete_me.select('piz', 'pizzeria')

    actual2 = @complete_me.suggest('piz')
    expected2 = ['pizzeria', 'pize', 'pizza', 'pizzicato', 'pizzle']

    assert_equal expected2, actual2
  end

  def test_it_populates_csv
    #skip
    complete_me = CompleteMe.new
    complete_me.populate_with_csv('./test/addresses.csv', 'FULL_ADDRESS')

    assert_equal 312_749, complete_me.count

    expected = ["3161 N Eliot St",
                "3161 N Fulton St",
                "3161 N Hanover St",
                "3161 N Quitman St",
                "3161 N Saint Paul St",
                "3161 N Wyandot St",
                "3161 N York St"]
    assert_equal expected, complete_me.suggest('3161 N ')
  end
end
