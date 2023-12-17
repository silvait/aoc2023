def hash_step(step)
  step.chars.reduce(0) do |current, c|
    ((current + c.ord) * 17) % 256
  end
end

boxes = {}
line = File.readlines('input.txt').first

line.strip.split(',').map do |step|
  if step.end_with? '-'
    label = step[..-2]
    box_id = hash_step(label)

    if boxes[box_id].nil?
      boxes[box_id] = []
    end

    boxes[box_id] = boxes[box_id].reject { |x| x[:label] == label }
  elsif step.include? '='
    label, lens = step.split('=')
    box_id = hash_step(label)
    lens = lens.to_i

    if boxes[box_id].nil?
      boxes[box_id] = []
    end

    if boxes[box_id].any? { |x| x[:label] == label}
      boxes[box_id] = boxes[box_id].map { |x| x[:label] == label ? { label:, lens: } : x}
    else
      boxes[box_id] << { lens:, label: }
    end
  end
end

puts (boxes.reduce(0) do |power, (box_id, cells)|
  unless cells.nil?
    cells.each_with_index do |l, index|
      power += (box_id +  1) * (index + 1) * l[:lens]
    end
  end

  power
end)
