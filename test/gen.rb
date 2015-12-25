require_relative '../lib/chord'
require_relative '../lib/transposer'

tests = [
  ['big_girl.txt', -3, 5],
  ['hows_the_family.txt', 3, 5],
  ['loving_cup.crd.txt', 7, -2, 9],
  ['Moondance.tab', 4, 5],
  ['moonlightshadow.txt', 4, 5],
  ['pisces_fish.txt', 4, 5],
  ['somebodies_anniversary.txt', 4],
  ['sunrise_sunrise.txt', 3],
  ['ThatLuckyOldSun.txt', -5, 7]
]

tests.each do |file, *semis|
  tab_dir = File.join('test', 'tabs')
  out_dir = File.join('test', 'transposed')
  input = File.join(tab_dir, file)
  semis.each do |semi|
    if semi < 0
      suffix = "_m#{-semi}"
    else
      suffix = "_p#{semi}"
    end
    ext = File.extname(file)
    base = File.basename(file, ext)
    out_file = "#{base}#{suffix}#{ext}"
    t = Transposer.new(semi)
    File.open(File.join(out_dir, out_file), 'w') do |output|
      t.transpose input, output
    end
  end
end
