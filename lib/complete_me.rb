# frozen_string_literal: true

require './lib/node'

# defines the Trie class
class CompleteMe
  attr_accessor :root,
                :count,
                :weight_hash

  def initialize
    @root = Node.new('*')
    @count = 0
    @weight_hash = Hash.new
  end

  def populate(dictionary)
    words = dictionary.split("\n")
    words.each do |word|
      add_word(word)
    end
  end

  def suggest(word_prefix)
    if @weight_hash.key?(word_prefix)
      suggestion_hash = @weight_hash[word_prefix].sort_by do |key, value|
        [-value, key]
      end
      suggestion_hash.to_h.keys
    else
      tree_search(word_prefix)
    end
  end

  def tree_search(word_prefix)
    if word_prefix.length < 1
      return []
    end
    unvisited_nodes = []
    word_suggestions = []
    current_string = []

    unvisited_nodes << find_word(word_prefix)
    current_string << word_prefix.chars.take(word_prefix.length - 1)

    unless unvisited_nodes.first
      return []
    end

    until unvisited_nodes.empty?
      node = unvisited_nodes.pop
      if node == :guard_node
        current_string.pop
        next
      end
      current_string << node.value
      unvisited_nodes << :guard_node
      if node.is_word
        word_suggestions << current_string.join
      end
      node.children.each do |node_object|
        unvisited_nodes << node_object
      end
    end
      word_suggestions.sort
  end

  def select(search_string, chosen_suggestion)
    if @weight_hash.keys.include?(search_string)
      @weight_hash[search_string][chosen_suggestion] += 1
    else
      store(search_string, chosen_suggestion)
    end
  end

  # Private Methods

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

  def store(search_string, chosen_suggestion)
    suggestion_array = suggest(search_string)
    @weight_hash[search_string] = {}
    suggestion_array.each do |suggestion|
      @weight_hash[search_string][suggestion] = 0
    end
    @weight_hash[search_string][chosen_suggestion] += 1
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
end
