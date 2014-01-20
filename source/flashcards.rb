class Card
  attr_reader :term, :definition
  attr_accessor :attempts

  def initialize(params = {})
    @term = params[:term]
    @definition = params[:definition]
    @attempts = 0
  end

  def determine_correctness(answer)
    @term == answer
  end
end

class Deck
  attr_reader :cards
  attr_accessor :completed

  def initialize(filename)
    @completed = []
    get_cards(filename)
  end

  def get_cards(filename)
    @cards = []
    create_cards(parse_file(filename))
  end

  def parse_file(filename)
    trimmed_array = []
    File.open('flashcard_samples.txt', 'r+') do |f|
      trimmed_array = f.select { |line| line.chomp! != "" }
    end
    trimmed_array.each_slice(2).to_a
  end

  def create_cards(card_data)
    card_data.each do |card|
      params = {}
      params[:definition] = card[0]
      params[:term] = card[1]
      @cards << Card.new(params)
    end
  end

  def top_card
    @cards[0]
  end
end

class Game
  attr_reader :deck, :game_over
  def initialize(deck)
    @deck = deck
    @give_up = false
  end

  def determine_correctness(response)
    if response == "give up"
      @give_up = true
      :give_up
    else
      is_correct = @deck.top_card.determine_correctness(response)
      update_deck(is_correct)
      is_correct ? :correct : :incorrect
    end
  end

  def update_deck(is_correct)
    @deck.top_card.attempts += 1
    is_correct ?  @deck.completed << @deck.cards.shift : @deck.cards.rotate!
  end

  def game_over?
    @give_up || @deck.cards.empty?
  end

  def report
    not_answered = @deck.cards.length
    first_try = @deck.completed.select {|card| card.attempts == 1}.length
    second_try = @deck.completed.select {|card| card.attempts == 2}.length
    third_plus_try = @deck.completed.select {|card| card.attempts >= 3}.length
    {first_try: first_try, second_try: second_try, third_plus_try: third_plus_try, not_answered: not_answered}
  end
end




module View

  def self.display_question(question)
    puts "Definition:"
    puts question
    puts
  end

  def self.ask_input
    print "Guess (or type 'give up'):"
    gets.chomp
  end

  def self.give_message(message)
    case message
      when :correct then puts "Correct!"
      when :incorrect then puts "Wrong!"
      when :give_up then puts "You've given up."
    end
  end

  def self.give_report(report)
    puts "You got #{report[:first_try]} on the first try"
    puts "You got #{report[:second_try]} on the second try"
    puts "You got #{report[:third_plus_try]} right after three or more tries"
    puts "There are #{report[:not_answered]} that haven't been answered correctly" if report[:not_answered] > 0
  end
end

class Controller
  def initialize(game)
    @game = game
  end

  def display_next_question(card)
    next_question = card.definition
    View::display_question(next_question)
  end

  def run!
    until @game.game_over?
      display_next_question(@game.deck.top_card)
      response = ask_for_input # view to c
      message = @game.determine_correctness(response) # c to m
      display_feedback(message) # view
    end
    View::give_report(@game.report)
  end

  def ask_for_input
    View::ask_input
  end

  def display_feedback(message)
    View::give_message(message)
  end
end


# Driver

deck = Deck.new('flashcard_samples.txt')
game = Game.new(deck)
# deck.cards.each do |card|
#   p "----------------------------------------------"
#   p "#{card.term}"
#   p "#{card.definition}"
# end

controller = Controller.new(game)

controller.run!