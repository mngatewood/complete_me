# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'

class NodeTest < Minitest::Test
  def test_it_exists
    node = Node.new('*')
    assert_instance_of Node, node
  end

  def test_it_has_a_value
    node = Node.new('*')
    assert_equal '*', node.value
  end

  def test_it_isnt_a_word_by_default
    node = Node.new('*')
    refute node.is_word
  end

  def test_it_has_no_children_by_default
    node = Node.new('*')
    assert node.children.empty?
  end

  def test_is_word_can_be_changed
    node = Node.new('*')
    node.is_word = true
    assert node.is_word
  end
end
