# frozen_string_literal: true

require './lib/node'

# defines the Trie method
class Trie
  attr_accessor :root,
                :count
                
  def initialize
    @root = Node.new('*')
    @count = 0
  end

# ----------------- ADDITION METHODS ---------------------------------------

  def add_node(new_character, current_child)
    Node.new(new_character).tap do |created_node|
      current_child << created_node
    end
  end

  def add_character(new_character, current_child)
    check_for_node = current_child.find do |node_object|
      node_object.value == new_character
    end

    if check_for_node.is_a?(Node)
      check_for_node
    else
      add_node(new_character, current_child)
    end
  end

  def add_word(word)
    letters = word.chars
    base = @root

    letters.each do |letter|
      base = add_character(letter, base.children)
    end

    base.is_word = true
    @count += 1
  end

  # ----------------- INFORMATION METHODS ---------------------------------
end
