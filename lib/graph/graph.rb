require_relative '../../lib/graph/reader'
require_relative '../../lib/graph/connection'

class Graph
  INFTY = 1.0/0.0

  def initialize
    @node_hash = Hash.new
  end

  def to_s
    graph_string = '{Graph}'
    @node_hash.each do |node, node_hash|
      graph_string << "\n{#{node}"
      unless node_hash.empty?
        graph_string << add_to_string(node_hash)
      end
      graph_string << '}'
    end
    graph_string
  end

  # @param [Hash]
  # @return [String]
  def add_to_string(node_hash)
    nodes_and_dist = ' => '
    node_hash.each do |port, dist|
      nodes_and_dist << "{#{port}: #{dist}}, "
    end
    nodes_and_dist[0..-3]
  end

# Adds a connection between two nodes in the graph, creating them if necessary.
#
# @param [String] first_port
# @param [String] second_port
# @param [Integer] distance
  def add_connection(first_port, second_port, distance)
    add_if_non_existing(first_port)
    add_if_non_existing(second_port)
    @node_hash[first_port][second_port] = distance
    @node_hash[second_port][first_port] = distance
  end

# Gets the value of a connection (or route) between two nodes (or airports).
#
# @param [String] first_port
# @param [String] second_port
# @return [Integer]
  def get_connection(first_port, second_port)
    case
      when one_does_not_exist(first_port, second_port) then
        -1
      when first_port == second_port then
        0
      else
        @node_hash[first_port][second_port]
    end
  end

# Adds a note to the graph without connection. The distance to any other node is infinite.
#
# @param [String] port_name
  def add_node(port_name)
    @node_hash[port_name] = Hash.new(INFTY)
  end

# Creates the graph using the provided JSON file.
  def create_graph_from_json
    read_me = Reader.new
    graph_hash = read_me.get_graph_hash
    graph_hash.each do |route|
      add_connection(route['ports'][0], route['ports'][1], route['distance'])
    end
  end

# Gets the URL addition for the JSON graph.
  def get_url_addition
    url_add = ''
    @node_hash.each do |node, node_hash|
      node_hash.each do |dest_node, distance|
        connector = Connection.new(node, dest_node, distance)

      end
    end

    url_add = ''
    read_me = Reader.new
    read_me.get_graph_hash.each do |route|
      url_add << route['ports'][0] << '-' << route['ports'][1] << ',+'
    end
    url_add[0..-3]
  end

  private

# Checks if at least one of the nodes does not exist in the graph.
#
# @param [String] first_port
# @param [String] second_port
  def one_does_not_exist(first_port, second_port)
    !@node_hash.include? first_port or !@node_hash.include? second_port
  end

# Adds a node to the graph if it does not exist yet.
#
# @param [String] port
  def add_if_non_existing(port)
    unless @node_hash.include? port
      add_node(port)
    end
  end

end