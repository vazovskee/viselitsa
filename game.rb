if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require 'unicode_utils/downcase'

class Game
  attr_reader :letters, :errors, :good_letters, :bad_letters, :status

  def initialize(word)
    @letters = get_letters(word)
    @errors = 0
    @good_letters = []
    @bad_letters = []
    @status = 0
  end

  def get_letters(word)
    abort 'Вы не ввели слово для игры' if word.nil? || word.empty?
    UnicodeUtils.downcase(word).split('')
  end

  def ask_next_letter
    letter = ''

    while (letter == '') || (letter !~ /[[:alpha:]]/) || (letter.size > 1)
      puts "\n Введите следующую букву:"
      letter = UnicodeUtils.downcase(STDIN.gets.chomp)
    end
    next_step(letter)
  end

  def next_step(letter)
    similar_letters = { 'е' => 'ё', 'ё' => 'е',
                        'и' => 'й', 'й' => 'и' }

    return if @status == -1 || @status == 1

    return if @good_letters.include?(letter) || @bad_letters.include?(letter)

    if @letters.include?(letter) ||
       (similar_letters.include?(letter) &&
         @letters.include?(similar_letters[letter]))

      @good_letters << letter

      if similar_letters.include?(letter)
        @good_letters << similar_letters[letter]
      end

      @status = 1 if (@letters - @good_letters).empty?
    else
      @bad_letters << letter

      @errors += 1

      @status = -1 if @errors >= 7
    end
  end
end
