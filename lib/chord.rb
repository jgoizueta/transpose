class Chord
  PATTERN = /\b([A-G])(b|#)?((?:maj|min|[Mm+°])?(?:6|5)?(?:aug|d[io]m|ø|sus4)?7?\*?(?:\(\*\))?)/
  # PATTERN = /\b([A-G])(b|#)?((?:maj|min|[Mm+°])?(?:6|5)?(?:aug|d[io]m|ø)?7?\*?(?:\(\*\))?)\b/ # => sharp not recognized
  PITCHES = %w(C C# D D# E F F# G G# A A# B)
  ENHARMONICS = {
    'Cb' => 'B',
    'Db' => 'C#',
    'Eb' => 'D#',
    'E#' => 'F',
    'Fb' => 'E',
    'Gb' => 'F#',
    'Ab' => 'G#',
    'Bb' => 'A#',
    'B#' => 'C'
  }

  def initialize(note, options = {})
    @note = note
    @accidental = options[:accidental]
    @modifiers = options[:modifiers]
    @accidental = nil if @accidental.to_s.strip.empty?
    @modifiers = nil if @modifiers.to_s.strip.empty?
  end

  attr_reader :note, :accidental, :modifiers

  def to_s
    "#{root}#{@modifiers}"
  end

  def self.from_text(text)
    match = PATTERN.match(text)
    if match
      note = match[1]
      accidental = match[2]
      modifiers = match[3]
      Chord.new note, accidental: accidental, modifiers: modifiers
    end
  end

  def root
    "#{@note}#{@accidental}"
  end

  def transpose(semi)
    r = PITCHES[(pitch + semi) % PITCHES.size]
    Chord.from_text "#{r}#{@modifiers}"
  end

  def normalized
    Chord.from_text "#{ENHARMONICS[root] || root}#{@modifiers}"
  end

  def pitch
    PITCHES.index normalized.root
  end
end
