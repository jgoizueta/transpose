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
            new_chord = transposed_chord(chord)
            transposed << new_chord
            line = adjust(after, chord, new_chord)
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

  def adjust(line, from, to)
    if line
      d = from.size - to.size
      if d != 0
        if d > 0
          line = ' '*d + line
        else
          prefix = line[0, -d]
          # TODO: if prefix.size < -d could try to remove inner whitespace
          # or to keep record of space to be removed from the same line later
          if prefix && prefix.match(/\A\s+\Z/)
            line = line[prefix.size..-1]
          end
        end
      end
    end
    line
  end

  def self.semitones(from, to)
    Chord.from_text(to).pitch - Chord.from_text(from).pitch
  end
end
