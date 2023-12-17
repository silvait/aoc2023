def overlap?(a, b)
    a.eql?(b) || a.cover?(b.first) || b.cover?(a.first)
end

def map_overlap(src, dst, delta)
   range_start = src.begin < dst.begin ? dst.begin : src.begin 
   range_end = src.end < dst.end ? src.end : dst.end
   (range_start + delta..range_end + delta)
end

def find_gaps(main_range, range_array)
    gaps = []
    sorted_ranges = range_array.sort_by(&:begin)
    current_start = main_range.begin
  
    sorted_ranges.each do |range|
      gaps << (current_start..range.begin - 1) if range.begin > current_start
      current_start = [current_start, range.end + 1].max
    end
  
    gaps << (current_start..main_range.end) if current_start < main_range.end
    gaps
end

def map_it(name, mappings, current)
    current.filter_map do |s| 
        candidates = mappings[name].filter_map do |d| 
           map_overlap(s, d[:src_ranges], d[:delta]) if overlap?(d[:src_ranges], s) 
        end

        candidates << find_gaps(s, mappings[name].map { |x| x[:src_ranges]})
        candidates
    end.flatten
end

def create_mappings(filename)
    mappings = {}
    current = nil

    File.readlines(filename).each do |l|
        next if l.strip.empty?

        if l.start_with? 'seeds:'
            _, seed_str = l.split(': ')

            mappings["seeds"] = seed_str.split(' ').map(&:to_i).each_slice(2).map do |start, length| 
                (start..start + length - 1)
            end
        elsif l.include? 'map:'
            current = l.strip.sub(' map:', '')
        else 
            dst_start, src_start, length = l.split(' ').map(&:to_i)
            src_ranges = (src_start..src_start + length - 1)
            mappings[current] = [] if mappings[current].nil?
            mappings[current] << { src_ranges:, delta: dst_start - src_start }
        end
    end

    mappings
end

mappings = create_mappings('input.txt')

results = mappings["seeds"].flat_map do |seed|
    soils = map_it("seed-to-soil", mappings, [seed])
    fertilizers = map_it("soil-to-fertilizer", mappings, soils)
    waters = map_it("fertilizer-to-water", mappings, fertilizers)
    lights = map_it("water-to-light", mappings, waters)
    temperatures = map_it("light-to-temperature", mappings, lights)
    humidities = map_it("temperature-to-humidity", mappings, temperatures)
    locations = map_it("humidity-to-location", mappings, humidities)
end 

puts results.sort_by(&:begin).first.begin