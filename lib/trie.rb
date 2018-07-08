# frozen_string_literal: true

require './lib/node'

# defines the Trie class
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

  def populate(dictionary)
    words = dictionary.split("\n")
    words.each do |word|
      add_word(word)
    end
  end

  def find_character(letter, current_child)
    current_child.find do |node_object|
      letter == node_object.value
    end
  end

  def include?(word)
    find_word(word) do |found, current_child|
      return found && current_child.is_word
    end
  end

  def find_word(word)
    letters = word.chars
    current_child = @root

    word_found = letters.all? do |letter|
      current_child = find_character(letter, current_child.children)
    end

    if block_given?
      yield(word_found, current_child)
    end

    current_child
  end

  def find_words_starting_with(prefix)
    unvisited_nodes = []
    words = []
    current_string = []

    unvisited_nodes << find_word(prefix)
    current_string << prefix.chars.take(prefix.size - 1)

    return [] unless unvisited_nodes.first

    until unvisited_nodes.empty?
      node = unvisited_nodes.pop

      current_string.pop && next if node == :guard_node

      current_string << node.value
      unvisited_nodes << :guard_node

      words << current_string.join if node.is_word
      require "pry"; binding.pry
      node.children.each { |current_node| unvisited_nodes << current_node }
    end

    words
  end
end
