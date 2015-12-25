require_relative 'chord'

class Transposer

  VALIDINTERCHORDS = /\A(\s*\/\s*|\s*\|\s*|\s+|\s*\(repeat\)\s*)\Z/

  def initialize(semi)
    @semi = semi
  end

  def check_text(text)
    if text && !text.empty? && !text.match(VALIDINTERCHORDS)
      @lyrics = true
    end
  end

  def transposed_chord(chord)
    c = Chord.from_text(chord)
    if c.accidental || c.modifiers
      @actual_chords = true
    end
    c.transpose(@semi).to_s
  end

  def transpose(file, output = STDOUT)
    File.open(file, 'r') do |input|
      input.each_line do |line|
        line.chomp!
        original_line = line
        @actual_chords = false
        @lyrics = false
        transposed = ''
        loop do
          before, chord, after = line.partition(Chord::PATTERN)
          if chord.empty?
            check_text before
            transposed << before
            break
          else
            check_text before
            transposed << before
            transposed << transposed_chord(chord)
            line = after
          end
        end
        if @lyrics && !@actual_chords
          output.puts original_line
        else
          output.puts transposed
        end
      end
    end
  end

  def self.semitones(from, to)
    Chord.from_text(to).pitch - Chord.from_text(from).pitch
  end
end
