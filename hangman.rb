def display_guessing_status(word = '', chosen_letters = [])
  current_status = ''
  word.each_char do |c|
    if chosen_letters.include?(c)
      current_status << c
    else
      current_status << '_'
    end
  end
  result = current_status.chars.join(' ')

  p "Current status: #{result}"
end

def display_game_status(word, chosen_letters, remaining_incorrect_guesses)
  result = display_guessing_status(word, chosen_letters)
  p "Letters chosen: #{chosen_letters.join(', ')}"
  p "Incorrect guesses left: #{remaining_incorrect_guesses}"
  result
end

def valid?(char)
  char.length == 1 && ('a'..'z').to_a.include?(char.downcase)
end

def main
  remaining_incorrect_guesses = 7
  won = false

  #setup the game
  begin
    words = File.readlines('words.txt').map { |w| w.gsub("\n", '') }
    word = words.shuffle.find { |w| (5..12).to_a.include?(w.length) }
  rescue MissingFileError
    p 'File missing'
  rescue => e
    p e
  end

  chosen_letters = %w[]

  p 'Game started.'
  display_game_status(word, chosen_letters, remaining_incorrect_guesses)

  # Every turn, allow the player to make a guess of a letter.
  # It should be case insensitive.
  # Update the display to reflect whether the letter was correct or incorrect.
  # If out of guesses, the player should lose
  p "Guess a letter:"
  char = gets.chomp

  # main loop
  until char.downcase == 'quit' || char.downcase == 'exit'
    if valid?(char)
      char.downcase!
      p "Guessed: #{char}"

      # Skip if already guessed
      if chosen_letters.include?(char)
        p "Letter already guessed, choose another one: "
      else
        chosen_letters << char

        unless word.include?(char)
          remaining_incorrect_guesses -= 1
          break if remaining_incorrect_guesses == 0
          p "Wrong letter: choose again"
        end
      end

      # Always display the current status
      result = display_game_status(word, chosen_letters, remaining_incorrect_guesses)
      unless result.include?('_')
        won = true
        break
      end
    else
      p "Invalid input"
    end
    char = gets.chomp
  end

  # Conclude the game
  if won
    p 'Congratulations!'
  else
    p "Unfortunately you have no chances left"
    p "The word is: #{word}"
  end

end

main
