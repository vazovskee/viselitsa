require_relative 'lib/game.rb'
require_relative 'lib/result_printer.rb'
require_relative 'lib/word_reader.rb'

VERSION = "Игра виселица (v 4.0)\n".freeze

current_path = File.dirname(__FILE__)

reader = WordReader.new
words_file_name = "#{current_path}/data/words.txt"
word = reader.read_from_file(words_file_name)

game = Game.new(word)
game.version = VERSION

printer = ResultPrinter.new(game)

while game.in_progress?
  printer.print_status(game)
  game.ask_next_letter
end

printer.print_status(game)
