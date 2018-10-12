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
  attr_accessor :version

  MAX_ERRORS = 7
  SIMILAR_LETTERS = { 'е' => 'ё', 'ё' => 'е',
                      'и' => 'й', 'й' => 'и' }.freeze

  def initialize(word)
    @letters = get_letters(word)
    @errors = 0
    @good_letters = []
    @bad_letters = []
    @status = :in_progress # :won, :lost
  end

  def get_letters(word)
    abort 'Вы не ввели слово для игры' if word.nil? || word.empty?
    UnicodeUtils.downcase(word).split('')
  end

  def max_errors
    MAX_ERRORS
  end

  def errors_left
    MAX_ERRORS - @errors
  end

  def ask_next_letter
    letter = ''

    until letter.size == 1 && letter =~ /[[:alpha:]]/
      puts "\n Введите следующую букву:"
      letter = UnicodeUtils.downcase(STDIN.gets.chomp)
    end
    next_step(letter)
  end

  def good?(letter)
    @letters.include?(letter) ||
      (SIMILAR_LETTERS.include?(letter) &&
        @letters.include?(SIMILAR_LETTERS[letter]))
  end

  def add_letter_to(letters, letter)
    letters << letter

    if SIMILAR_LETTERS.include?(letter)
      letters << SIMILAR_LETTERS[letter]
    end
  end

  def solved?
    (@letters - @good_letters).empty?
  end

  def repeated?(letter)
    @good_letters.include?(letter) || @bad_letters.include?(letter)
  end

  def lost?
    @status == :lost || @errors >= MAX_ERRORS
  end

  def in_progress?
    @status == :in_progress
  end

  def won?
    @status == :won
  end

  def next_step(letter)
    return if @status == :lost || @status == :won
    return if repeated?(letter)

    if good?(letter)
      add_letter_to(@good_letters, letter)

      @status = :won if solved?
    else
      add_letter_to(@bad_letters, letter)

      @errors += 1

      @status = :lost if lost?
    end
  end
end
