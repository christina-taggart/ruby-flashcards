Card = Struct.new(:question, :answer)

class CardParser
  attr_accessor :cards
  # getting all the cards, passing to model
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


# class DeckBuilder
#   attr_accessor :deck

#   def initialize(cards = CardParser.new.cards)
#     @deck =  cards.shuffle
#   end
# end

class Controller

  def initialize(deck = CardParser.new.cards)
    @deck = deck.shuffle
    send_to_view
  end

  def send_to_view
    View.new(@deck)
  end

end

class View

  def initialize(deck)
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
      puts "Game over, man! GAME OVER!!"
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
    puts "Definition"
    puts "#{@card.question}"
    ask_for_answer
  end

  def ask_for_answer
    print "Guess: "
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
    puts "Correct!\n"
    ask_question
  end

  def incorrect_answer
    if @try_num > 0
      puts "Incorrect! You have #{@try_num} tries left.\n"
      ask_for_answer
    else
      puts "Sorry, you didn't get that one! The answer is: \"#{@card.answer}\""
      keep_playing?
    end
  end

  def keep_playing?
    print "Keep Playing? y/n: "
    y_n = gets.chomp
    if y_n == "y"
      ask_question
    elsif y_n == "n"
      puts "Thanks for playing!"
    else
      puts "Wut. Try that again."
      keep_playing?
    end
  end

  def reset_tries
    @try_num = 3
  end

end

class Verify

end



# puts CardParser.new.cards
# puts "---------------------"
Controller.new