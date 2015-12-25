# TODO:
# 0. test corpus
# 1. from to
# 2. adjust space after chord
# 3. support tabs ---- (from to normalization %, + if > /2)
# 4. tests
# 5. gem with bin command

require_relative 'lib/chord'
require_relative 'lib/transposer'

file = ARGV.shift
if ARGV.size == 2
  from = ARGV.shift
  to   = ARGV.shift
  semi = Chord.from_text(to).pitch - Chord.from_text(from).pitch
else
  semi = ARGV.shift.to_i
end

if semi != 0
  t = Transposer.new(semi)
  t.transpose file
end
