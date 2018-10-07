require_relative 'game.rb'
require_relative 'result_printer.rb'
require_relative 'word_reader.rb'

current_path = File.dirname(__FILE__)

printer = ResultPrinter.new

reader = WordReader.new

word = reader.read_from_file("#{current_path}/data/words.txt")

game = Game.new(word)

while game.status.zero?
  printer.print_status(game)
  game.ask_next_letter
end

printer.print_status(game)
