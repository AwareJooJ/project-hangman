require_relative 'Player'

class Game
  MAX_GUESSES = 6
  DICTIONARY = File.readlines('words.txt').map(&:chomp).select { |word| word.length.between?(5, 12) }

  def initialize
    @player = Player.new
    @player.select_name
    @word = ""
    @guessed_letters = []
    @num_of_guesses = 0
    @guess = ""
    @temp_word = []
  end

  def play
    word = DICTIONARY.sample
    @word = word.split("")
    @player.select_name
    puts "Welcome, #{@player.name}! Let's play Hangman!"
    @temp_word = Array.new(@word.length, "_")

    while @num_of_guesses < MAX_GUESSES && @temp_word.include?("_")
      puts "Word: #{@temp_word.join(" ")}"
      puts "Guessed letters: #{@guessed_letters.join(", ")}"
      puts "You have #{MAX_GUESSES - @num_of_guesses} guesses left."
      puts "Enter a letter:"
      @guess = gets.chomp.downcase
      if @guess.length != 1 || !@guess.match?(/[a-z]/)
        puts "Please enter a single letter."
        next
      elsif @guessed_letters.include?(@guess)
        puts "You already guessed that letter."
        next
      else
        if @word.include?(@guess)
          puts "Good guess!"
          @word.each_with_index do |letter, index|
            @temp_word[index] = letter if letter == @guess
          end
        else
          puts "Sorry, that letter is not in the word."
          @guessed_letters << @guess
          @num_of_guesses += 1
        end
      end
      check_status(@temp_word, @word, @num_of_guesses)
    end
  end

  def check_status(temp_word, word, num_of_guesses)
    if temp_word == word
      puts "Congratulations, #{@player.name}! You guessed the word: #{word.join("")}!"
    elsif num_of_guesses >= MAX_GUESSES
      puts "Sorry, you've run out of guesses. The word was: #{word.join("")}."
    end
  end

end