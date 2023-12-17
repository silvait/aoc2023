require 'rgeo'
require 'set'

def parse_tiles(filename)
  File.readlines(filename).each_with_index.flat_map do |line, row|
    line.strip.chars.each_with_index.filter_map do |cell, col|
      if cell == '.'
        nil
      else
        { cell:, location: [row, col] }
      end
    end
  end
end

North = [-1, 0]
South = [1, 0]
East = [0, 1]
West = [0, -1]

def get_adjancent_tiles(type, location, tiles)
  directions = case type
  when '|'
    [North, South]
  when '-'
    [West, East]
  when 'L'
    [North, East]
  when 'J'
    [West, North]
  when '7'
    [West, South]
  when 'F'
    [South, East]
  end

  row, col = location
  directions.map { |r, c| tiles[[row + r, col + c]] }
end

def point_inside_polygon?(point, polygon, factory)
  point = factory.point(point[0], point[1])
  polygon.contains?(point)
end

StartTileType = '7'

def build_map(tiles)
  cache = {}
  tiles.each { |t| cache[t[:location]] = t }

  map = { }

  starting_tile = tiles.find { |c| c[:cell] == 'S' }
  map = { start: starting_tile }

  starting_tile[:cell] = StartTileType
  tiles_to_visit = [starting_tile]
  visited = Set.new

  until tiles_to_visit.empty?
    current_tile = tiles_to_visit.pop

    neighbors = get_adjancent_tiles(current_tile[:cell], current_tile[:location], cache)

    neighbors.each do |n|
      map[n[:location]] = neighbors

      tiles_to_visit << n unless visited.include? n[:location]
    end

    visited << current_tile[:location]
  end

  factory = RGeo::Cartesian.simple_factory
  linear_ring = factory.linear_ring(visited.map { |coord| factory.point(*coord) })
  polygon = factory.polygon(linear_ring)

  count = 0
  (0..140).each do |row|
    (0..140).each do |col|
      if point_inside_polygon?([row, col], polygon, factory)
        count += 1
      end
    end
  end
  count
end

tiles = parse_tiles('input.txt')
steps = build_map(tiles)
puts steps
