CardsRank = 'A, K, Q, T, 9, 8, 7, 6, 5, 4, 3, 2, J'.split(', ').reverse
Mapping = {}

CardsRank.zip('a'..'m').each do |r, v|
  Mapping[r] = v
end

def count_types(hand)
  letters = Hash.new(0)
  letters = hand.each_char.reduce(letters) { |h, c| h[c] += 1; h}
  counts = letters.values.sort.reverse.join

  if hand.include?('J') && hand != 'JJJJJ'
    other_counts = letters.keys.select { |x| x != 'J'}.map do |x|
      new_hand = hand.sub('J', x)
      count_types(new_hand)
    end.sort.reverse.first

    return other_counts
  end

  counts
end

def get_hand_type(hand)
  count = count_types(hand)

  if count == '5'
    '6'
  elsif count == '41'
    '5'
  elsif count == '32'
    '4'
  elsif count == '311'
    '3'
  elsif count == '221'
    '2'
  elsif count == '2111'
    '1'
  elsif count == '11111'
    '0'
  else
    print "ERROR: #{hand} #{count}"
  end
end

def grade_hand(hand)
  type = get_hand_type(hand)
  order = hand.chars.map { |c| Mapping[c] }.join

  "#{type}#{order}"
end

parsed = File.readlines('input.txt').map do |l|
  hand_str, bid_str = l.strip.split(' ')
  { bid: bid_str.to_i, hand: hand_str }
end

results = parsed.map do |h|
 { hand: h[:hand], value: grade_hand(h[:hand]), bid: h[:bid] }
end

scores = results.sort_by { |x| x[:value] }.each_with_index.map do |x, i|
  (i + 1) * x[:bid]
end
p scores.reduce(&:+)
