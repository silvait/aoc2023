require 'set'

def move_beam(beam)
  row, col = beam[:location]
  direction = beam[:direction]

  new_location = case direction
  when 'north'
    [row - 1, col]
  when 'east'
    [row, col + 1]
  when'south'
    [row + 1, col]
  when 'west'
    [row, col - 1]
  end

  { location: new_location, direction: }
end

def process_collision(beam, tile)
  direction = beam[:direction]
  location = beam[:location]

  case tile
  when '.'
    [beam]
  when '-'
    if ['north', 'south'].include? direction
      [
        { location:, direction: "east" },
        { location:, direction: "west" }
      ]
    else
      [beam]
    end
  when '|'
    if ['east', 'west'].include? direction
      [
        { location:, direction: "north" },
        { location:, direction: "south" }
      ]
    else
      [beam]
    end
  when '/'
    new_direction = case direction
    when 'north'
      'east'
    when 'east'
      'north'
    when 'south'
      'west'
    when 'west'
      'south'
    end

    [{ location:, direction: new_direction }]
  when '\\'
    new_direction = case direction
    when 'north'
      'west'
    when 'east'
      'south'
    when 'south'
      'east'
    when 'west'
      'north'
    end

    [{ location:, direction: new_direction }]
  end
end

def navigate_grid(initial_beam, grid)
  beams = [initial_beam]
  energized_tiles = Set.new

  until beams.empty?
    current_beam = beams.shift
    location = current_beam[:location]

    next if grid[location].nil?
    next if energized_tiles.include? current_beam

    energized_tiles << current_beam

    new_beams = process_collision(current_beam, grid[location])
    new_beams.each { |b| beams << move_beam(b) }
  end

  energized_tiles
end

def calculate_energized_tiles(beam, grid)
  energized_tiles = navigate_grid(beam, grid)
  energized_tiles.map { |x| x[:location] }.uniq.length
end

def create_initial_beams(last_row, last_col)
  north_beams = (0..last_col).map { |x| { location: [last_row, x], direction: 'north'} }
  east_beams = (0..last_row).map { |x| { location: [x, 0], direction: 'east'} }
  west_beams = (0..last_row).map { |x| { location: [x, last_col], direction: 'west'} }
  south_beams = (0..last_col).map { |x| { location: [0, x], direction: 'south'} }

  north_beams + east_beams + south_beams + west_beams
end

filename = ARGV.first

grid = File.readlines(filename).each_with_index.reduce({}) do |grid, (line, row)|
  line.strip.chars.each_with_index do |tile, col|
    grid[[row, col]] = tile
    grid[:last_col] = col
  end

  grid[:last_row] = row
  grid
end

beams = create_initial_beams(grid[:last_row], grid[:last_col])
puts beams.map { |b| calculate_energized_tiles(b, grid) }.max
