class Chord

  PATTERN = %r{
    \b
    ([A-G])(b|\#)?
    ((?:maj|min|[Mm+°])?(?:6|5)?(?:aug|d[io]m|ø|sus4)?7?(?:\*|\(\*\))?)
    (?:\/([A-Ga-g])(b|\#)?)?
    # cannot place a \b here because it prevents recognizing # as sharp
  }x
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
    @bass = options[:bass]
    @bass_accidental = options[:bass_accidental]
    @accidental = nil if @accidental.to_s.strip.empty?
    @modifiers = nil if @modifiers.to_s.strip.empty?
    @bass = nil if @bass.to_s.strip.empty?
    @bass_accidental = nil if @bass_accidental.to_s.strip.empty?
  end

  attr_reader :note, :accidental, :modifiers, :bass, :bass_accidental

  def to_s
    if @bass
      bass_suffix = "/#{@bass}#{@bass_accidental}"
    end
    "#{root}#{@modifiers}#{bass_suffix}"
  end

  def self.from_text(text)
    match = PATTERN.match(text)
    if match
      Chord.new(
        match[1],
        accidental: match[2],
        modifiers: match[3],
        bass: match[4],
        bass_accidental: match[5]
      )
    end
  end

  def root
    "#{@note}#{@accidental}"
  end

  def bass_root
    if @bass
      "#{@bass}#{@bass_accidental}"
    end
  end

  def transpose(semi)
    r = PITCHES[(pitch + semi) % PITCHES.size]
    t = "#{r}#{@modifiers}"
    if @bass
      br = PITCHES[(bass_pitch + semi) % PITCHES.size]
      t << "/#{br}"
    end
    Chord.from_text t
  end

  def normalized
    n = "#{ENHARMONICS[root] || root}#{@modifiers}"
    if @bass
      n << "/#{Chord.from_text(bass_root.upcase).normalized}"
    end
    Chord.from_text n
  end

  def pitch
    PITCHES.index normalized.root
  end

  def bass_pitch
    @bass && PITCHES.index(normalized.bass_root)
  end
end
