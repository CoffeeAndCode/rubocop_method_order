# frozen_string_literal: true

require_relative './method_node_collection'
require_relative './public_method_node_collection'

module RuboCopMethodOrder
  # This object collects every method definition found during a cop run and will
  # attempt to split them by scope and context. If a method is disabled by a
  # Rubocop comment it is not added to the collector. A method is also only
  # collected once.
  class MethodCollector
    attr_reader :all_method_nodes,
                :nodes_by_scope

    def initialize(should_skip_method:)
      @all_method_nodes = []
      @should_skip_method = should_skip_method
      @nodes_by_scope = {}
    end

    def collect(def_node, scope_name = 'global')
      return if @should_skip_method.call(def_node)
      return if @all_method_nodes.include?(def_node)

      @all_method_nodes << def_node

      unless @nodes_by_scope.key?(scope_name)
        @nodes_by_scope[scope_name] = new_node_collection(scope_name)
      end
      @nodes_by_scope[scope_name].push(def_node)
    end

    def collect_nodes_from_class(class_node)
      base_scope_name = "CLASS:#{scope_for_node(class_node)}"

      mode = :public
      child_nodes_from_container(class_node).each do |node|
        if node.type == :def
          collect(node, "#{base_scope_name}:#{mode}_methods")
        elsif node.type == :defs
          collect(node, "#{base_scope_name}:class_methods")
        end

        mode = node.method_name if scope_change_node?(node)
      end
    end

    def collect_nodes_from_module(module_node)
      base_scope_name = "MODULE:#{scope_for_node(module_node)}"

      child_nodes_from_container(module_node).each do |node|
        if node.type == :def
          collect(node, "#{base_scope_name}:public_methods")
        elsif node.type == :defs
          collect(node, "#{base_scope_name}:class_methods")
        end
      end
    end

    private

    def child_nodes_from_container(node)
      begin_node = node.child_nodes.select { |x| x&.type == :begin }.first
      begin_node.nil? ? node.child_nodes : begin_node.child_nodes
    end

    def new_node_collection(scope_name)
      if scope_name.match?(/:public_methods$/)
        PublicMethodNodeCollection.new
      else
        MethodNodeCollection.new
      end
    end

    def scope_change_node?(node)
      node.type == :send && %i[private protected].include?(node.method_name)
    end

    def scope_for_node(node)
      "#{node.source_range.begin_pos}-#{node.source_range.end_pos}"
    end
  end
end
