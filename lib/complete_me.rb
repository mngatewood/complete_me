# frozen_string_literal: true

require './lib/node'
require 'csv'

# defines the Trie class
class CompleteMe
  attr_accessor :root, :count, :suggest_rank_hash

  def initialize
    @root = Node.new('*')
    @count = 0
    @suggest_rank_hash = {}
  end

  def populate(dictionary)
    words = dictionary.split("\n")
    words.each { |word| insert(word) }
  end

  def suggest(word_prefix)
    if @suggest_rank_hash.key?(word_prefix)
      temp_order_hash = @suggest_rank_hash[word_prefix].sort_by do |key, value|
        [-value, key]
      end
      temp_order_hash.to_h.keys
    else
      trie_search(word_prefix)
    end
  end

  def insert(word)
    letters = word.chars
    base = @root

    letters.each { |letter| base = node_validator(letter, base.children) }

    @count += 1
    base.is_word = true
  end

  def select(search_string, chosen_suggestion)
    if @suggest_rank_hash.key?(search_string)
      @suggest_rank_hash[search_string][chosen_suggestion] += 1
    else
      collect_suggested(search_string, chosen_suggestion)
    end
  end

  def trie_search(word_prefix)
    return [] if word_prefix.empty?

    unvisited_nodes = []
    word_suggestions = []
    collected_characters = []

    unvisited_nodes << find_node(word_prefix)
    prefix_letters = word_prefix.chars
    collected_characters << prefix_letters.take(word_prefix.length - 1)

    return [] unless unvisited_nodes.first

    until unvisited_nodes.empty?
      node = unvisited_nodes.pop
      if node == :bouncer_node
        collected_characters.pop
        next
      end

      collected_characters << node.value
      unvisited_nodes << :bouncer_node
      word_suggestions << collected_characters.join if node.is_word

      node.children.each { |node_object| unvisited_nodes << node_object }
    end
    word_suggestions.sort
  end

  def add_node(node_value, current_child)
    Node.new(node_value).tap do |created_node|
      current_child << created_node
    end
  end

  def check_for_node(node_value, current_child)
    current_child.find do |node_object|
      node_object.value == node_value
    end
  end

  def node_validator(node_value, current_child)
    node_or_nil = check_for_node(node_value, current_child)
    if node_or_nil.is_a?(Node)
      node_or_nil
    else
      add_node(node_value, current_child)
    end
  end

  def collect_suggested(search_string, chosen_suggestion)
    suggestion_array = suggest(search_string)
    @suggest_rank_hash[search_string] = {}
    suggestion_array.each do |suggestion|
      @suggest_rank_hash[search_string][suggestion] = 0
    end
    @suggest_rank_hash[search_string][chosen_suggestion] += 1
  end

  def find_node(word)
    letters = word.chars
    current_child = @root

    letters.all? do |letter|
      current_child = check_for_node(letter, current_child.children)
    end
    current_child
  end

  def delete_word(word)
    word_string = word
    iteration_counter = 0
    # Split word to be deleted into an array of characters
    # Grab the node where the final letter of the word ends
    until word_string.empty?
      previous_node = find_node(word_string)
      current_node = find_node(word_string.chop!)
      iteration_counter += 1

      if iteration_counter == 1
        if previous_node.children.length < 1
          current_node.children.delete(previous_node)
        else
          break
        end
      else
        if previous_node.children.length < 1 && previous_node.is_word == false
          current_node.children.delete(previous_node)
        else
          break
        end
      end
    end
    @count -= 1
  end

  def populate_with_csv(csv_file, column_header)
    csv = CSV.read(csv_file, :headers=>true)
    csv.each do |row|
      insert(row[column_header])
    end
  end
end
