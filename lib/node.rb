# frozen_string_literal: true

# Defines the node class
class Node
  attr_reader   :value,
                :children
  attr_accessor :is_word
  def initialize(value)
    @value = value
    @is_word = false
    @children = []
  end
end
