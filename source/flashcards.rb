# Main file for

class Card
  attr_reader :term, :definition

  def initialize(params = {})
    @term = params[:term]
    @definition = params[:definition]
  end

  def determine_correctness(answer)
    @term == answer
  end
end

class Deck
  attr_reader :cards

  def initialize(filename)
    trimmed_array = []
    File.open('flashcard_samples.txt', 'r+') do |f|
      trimmed_array = f.select { |line| line.chomp! != "" }
    end

    card_args = trimmed_array.each_slice(2).to_a

    @cards = []

    card_args.each do |card|
      params = {}
      params[:definition] = card[0]
      params[:term] = card[1]
      @cards << Card.new(params)
    end

  end
end

module View

  def self.display_question(question)
    puts "Definition:"
    puts question
    puts
  end

  def self.ask_input
    print "Guess:"
    gets.chomp
  end

  def self.give_correctness(is_correct)
    puts is_correct ? "Correct!" : "Incorrect!"
  end

  def give_report(report)
    puts format_report(report)
  end

  def format_report(report)
  end
end

class Controller
  def initialize(deck)
    @deck = deck
  end

  def display_next_question(card)
    next_question = card.definition
    View::display_question(next_question)
  end

  def run!
    counter = 0
    @deck.cards.each do |card|
      if counter <= 9
        display_next_question(card)
        response = ask_for_input
        break if response == "give up"
        determine_correctness(card, response)
        counter += 1
      end
      break if response == "give up"
    end
  end

  def ask_for_input
    View::ask_input
  end

  def determine_correctness(card,answer)
    is_correct = card.determine_correctness(answer)
    View::give_correctness(is_correct)
    is_correct
  end

end






# Driver

deck = Deck.new('flashcard_samples.txt')
# deck.cards.each do |card|
#   p "----------------------------------------------"
#   p "#{card.term}"
#   p "#{card.definition}"
# end

controller = Controller.new(deck)

controller.run!