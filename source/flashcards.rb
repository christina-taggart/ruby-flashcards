Card = Struct.new(:question, :answer)

class CardParser
  attr_accessor :cards
  def initialize(file_name = "flashcard_samples.txt", fields = 2)
    @file_name = file_name
    @fields = fields
    @cards = []
    @intermediate_state = nil
    parse
  end

  def parse
    db_to_array
    array_to_card
  end

  def db_to_array
    @intermediate_state = File.read(@file_name).split("\n").reject(&:empty?)
  end

  def array_to_card
    @intermediate_state.each_slice(@fields).each do |fields|
      @cards << Card.new(fields[0], fields[1])
    end
  end
end


class Controller

  def initialize(deck = CardParser.new.cards)
    @deck = deck.shuffle
    send_to_view
  end

  def send_to_view
    Game.new(@deck)
  end

end

class Game
  attr_reader :view, :deck, :card, :try_num
  def initialize(deck, view = View.new)
    @view = view
    @deck = deck
    @card = nil
    @try_num = 3
    ask_question
  end

  def get_card
    @card = @deck.pop
  end

  def check_deck
    if @deck.empty?
      view.game_over
      exit
    end
  end

  def prepare_question
    reset_tries
    check_deck
    get_card
  end

  def ask_question
    prepare_question
    view.print_question(@card.question)
    ask_for_answer
  end

  def ask_for_answer
    view.ask_for_answer
    verify(gets.chomp)
  end

  def verify(answer)
    if answer == @card.answer
      correct_answer
    else
      @try_num -= 1
      incorrect_answer
    end
  end

  def correct_answer
    view.correct_answer
    ask_question
  end

  def incorrect_answer
    if @try_num > 0
      view.tries_left(@try_num)
      ask_for_answer
    else
      view.question_failed(@card.answer)
      keep_playing?
    end
  end

  def keep_playing?
    view.ask_keep_playing?
    y_n = gets.chomp
    if y_n == "y"
      ask_question
    elsif y_n == "n"
      view.thank_player
    else
      view.wrong_input
      keep_playing?
    end
  end

  def reset_tries
    @try_num = 3
  end

end

class View

  def initialize
  end

  def game_over
    puts "Game over, man! GAME OVER!!"
  end

  def print_question(question)
    puts "Definition"
    puts "#{question}"
  end

  def ask_for_answer
    print "Guess: "
  end

  def correct_answer
    puts "Correct!\n"
  end

  def tries_left(try_num)
    puts "Incorrect! You have #{try_num} tries left. \n"
  end

  def question_failed(answer)
    puts "Sorry, you didn't get that one! The answer is: \"#{answer}\""
  end

  def ask_keep_playing?
    puts "Keep playing? y/n: "
  end

  def thank_player
    puts "Thanks for playing!"
  end

  def wrong_input
    puts "Input not recognized. Try again."
  end

end


Controller.new