# TODO:
# * expand tabulators to spaces with option for tab with
# * support tablature notation:
#    - detect tab lines
#    - adjust semitones:
#          semi %= Chord::PITCHES.size
#          semi -= Chord::PITCHES.size if semi > Chord::PITCHES.size/2
#          semi += Chord::PITCHES.size while semi + min_fret < 0
#    - add semitones to fret positions, adjust line alignment
# * tests
# * gem with bin command with -o option, etc.

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
