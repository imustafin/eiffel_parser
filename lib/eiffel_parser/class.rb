# frozen_string_literal: true

module EiffelParser
  # Representation of Eiffel class
  class Class
    include Utils

    def initialize(lines)
      @global = parse_tree(lines)
    end

    def features
      feature_blocks = @global
        .filter { |k, _v| k.start_with?("feature") }
        .flat_map(&:last)

      feature_trees = parse_tree(feature_blocks)

      feature_trees
        .map { |f| Feature.new(f.first, f.last) }
    end

    def name
      prefixed = ["deferred class", "expanded class", "class"]
      @global
        .find { |k, _v| prefixed.any? { |p| k.start_with?(p) } }
        .last
        .first.strip
    end
  end
end
