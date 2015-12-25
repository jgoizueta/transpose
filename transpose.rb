# TODO:
# 1. from to
# 2. adjust space after chord
# 3. support tabs ---- (from to normalization %, + if > /2) avoid negative results
# 4. tests
# 5. gem with bin command with -o option, etc.

require_relative 'lib/chord'
require_relative 'lib/transposer'

file = ARGV.shift
if ARGV.size == 2
  from = ARGV.shift
  to   = ARGV.shift
  semi = Transposer.semitones(from, to)
else
  semi = ARGV.shift.to_i
end

if semi != 0
  t = Transposer.new(semi)
  t.transpose file
end
