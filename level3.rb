require 'set'

def is_symbol_char?(c) 
    return false if c =~ /\d/ 
    return c != '.' && c != "\n"
end

def is_adjacent_to_symbol?(grid, row, col)
    neighbors = [
        [row - 1, col - 1],
        [row - 1, col],
        [row - 1, col + 1],
        [row, col - 1],
        [row, col + 1],
        [row + 1, col -1],
        [row + 1, col],
        [row + 1, col + 1],
    ].select { |r,c| r >= 0 && c >= 0 && r < grid.length && c < grid[r].length }

    neighbors.any? { |r, c| is_symbol_char?(grid[r][c]) }
end

def get_adjacent_symbols(grid, row, col)
    neighbors = [
        [row - 1, col - 1],
        [row - 1, col],
        [row - 1, col + 1],
        [row, col - 1],
        [row, col + 1],
        [row + 1, col -1],
        [row + 1, col],
        [row + 1, col + 1],
    ].select { |r,c| r >= 0 && c >= 0 && r < grid.length && c < grid[r].length }

    neighbors
        .map { |r, c| ({ r:, c:, value: grid[r][c] }) }
        .select { |c| is_symbol_char?(c[:value]) }
        .map { |s| "#{s[:value]},#{s[:r].to_s},#{s[:c].to_s}" }
end

grid = File.readlines('input.txt')

numbers = grid.each_with_index.flat_map do |row, r|
    is_part = false
    scanning = false
    start_i = 0
    end_i = 0

    nums = []
    adjacent_symbols = Set.new

    row.chars.each_with_index do |el, c|
        if el =~ /\d/ 
            if !scanning
                scanning = true
                start_i = c
            end


            if is_adjacent_to_symbol?(grid, r, c)
                is_part = true
                adjacent_symbols.merge(get_adjacent_symbols(grid, r, c))
            end
        else 
            if scanning 
                end_i = c - 1
                nums << { start_pos: [r, start_i], end_pos: [r, end_i], value: row[start_i..end_i].to_i, is_part:, adjacent_symbols: }
                scanning = false
                is_part = false
                adjacent_symbols = Set.new
            end
        end
    end

    nums
end 

gears = {}

numbers
    .select { |n| n[:is_part] }
    .select do |n|
        n[:adjacent_symbols].any? { |s| s.start_with?('*') }
    end
    .each do |n| 
        n[:adjacent_symbols].each do |s| 
            next unless s.start_with?('*')

            if gears.key?(s) 
                gears[s] = gears[s] << n[:value]
            else
                gears[s] = [n[:value]]
            end
        end
    end

p gears 
puts gears
    .map { |k,v| v.length < 2 ?  0 :  v.inject(1, :*) }
    .inject(0, :+)

