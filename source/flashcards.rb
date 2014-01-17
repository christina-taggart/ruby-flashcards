# Main file for

require 'csv'

class Deck

  def initialize
    @deck = []
    @score = 0
    add_cards_to_deck
    ARGV.clear
    play_game
  end

  def add_cards_to_deck
    abort("No file to load") if !File.exists?(ARGV[0])

    CSV.foreach(ARGV[0]) do |csv| #foreach gets every row
      @deck << Card.new(csv[0], csv[1], csv[2])
    end

    # @deck #delete me

    #------How to do it with File--------
    # questions =File.open("flashcard_samples.csv", "r")
    # questions.each {|line| card_to_push = line.chomp.split(",")
    #   @deck << Card.new(card_to_push[0], card_to_push[1], card_to_push[2])
    # }
  end

  def play_game
    counter = 1
    p counter
    until @deck.length == counter
      @deck = @deck.shuffle
      @deck.each do |flashcard|
        ask_question(flashcard)
        counter += 1
      end
    end
  end

  def ask_question(flashcard)
    number_of_attempts = 3

    puts ""
    puts "Here is your question. Type \"exit\" to stop playing at anytime or \"score\" to view your current score ."
    puts "---------"
    puts flashcard.question
    user_answer = gets.chomp

    while number_of_attempts > 0
      if user_answer.downcase == flashcard.answer.downcase
        award_points(flashcard)
        number_of_attempts = 0
      elsif user_answer == "exit"
        abort("Thanks for playing")
      elsif user_answer == "score"
        puts "You currently have #{@score} points. Great Job!"
        puts flashcard.question
        user_answer = gets.chomp
      elsif user_answer.downcase != flashcard.answer.downcase
        number_of_attempts -= 1
        puts "You got the answer wrong. You have #{number_of_attempts} more attempts." if number_of_attempts > 0
        if number_of_attempts > 0
          puts flashcard.question
          user_answer = gets.chomp
        else
          puts "Sorry, you got it wrong and are out of attempts. No points for you. The correct answer is '#{flashcard.answer}'"
        end
      end
    end
  end

  def award_points(flashcard)
    case
      when flashcard.difficulty == "easy"
        points_for_turn = 1
        @score += points_for_turn
      when flashcard.difficulty == "medium"
        points_for_turn = 3
        @score += points_for_turn
      when flashcard.difficulty == "hard"
        points_for_turn = 5
        @score += points_for_turn
      else
        puts "ERROR"
    end
    puts "Congrats, you got it right and earned #{points_for_turn} points. Your total score is #{@score}"
  end

  def create_flashcard
    puts "Please enter a question"
    question_to_add = gets.chomp
    puts "What is this question's answer?"
    answer_to_add = gets.chomp
    puts "Is this question, easy, medium or hard in terms of difficulty"
    difficulty_to_add = gets.chomp

    CSV.open("flashcard_samples.csv", "ab") do |csv| #add each line to end of csv - no foreach method
      csv << [question_to_add, answer_to_add, difficulty_to_add]
    end

    #------How to do it with File--------
    # test = File.open("flashcard_samples.csv", "a+")
    # test.puts "#{question_to_add}, #{answer_to_add}, #{difficulty_to_add}"

  end


end





class Card

  attr_reader :question, :answer, :difficulty

  def initialize(question, answer, difficulty)
    @question = question
    @answer = answer
    @difficulty = difficulty
  end

end


our_deck = Deck.new
# our_deck.create_flashcard




