#config
require 'colorize'
require 'io/console'
game_state = true
randomNumber = rand(1..100)
guesses = 0
scoreboard = {}

#functions
def scoreboardShow(scoreboard)
    #if scoreboard not empty, show scoreboard
    if scoreboard != {}
    
    #sorts the scoreboard by value
        scoreboard = scoreboard.sort_by {|k, v| v}
    #prints the scoreboard

        puts "The scoreboard is:".colorize(:green)
        scoreboard.each do |key, value|
            puts "#{key} - #{value}"
        end
    end
end

def scoreboardAdd(scoreboard, guesses)
    #adds the player to the scoreboard
    puts "Enter your name to save your score".colorize(:green)
    name = gets.chomp
    scoreboard[name] = guesses
    end

def endGame(scoreboard)
    puts "You have exited the game".colorize(:red)
    scoreboardShow(scoreboard)
    puts "Thanks for playing!".colorize(:green)
    exit
end
#game
while game_state
    puts "Guess a number between 1 and 100".colorize(:yellow)
    guess = gets.chomp
    guessedNumber = Integer(guess) rescue false
    if guessedNumber == false
        if guess == "finish"
            endGame(scoreboard)
        end
    else
        guess = guess.to_i
        if guess == randomNumber
            guesses += 1
            puts "You win!".colorize(:green)
            puts "You guessed the number in #{guesses} guesses".colorize(:green)
            scoreboardAdd(scoreboard, guesses)
            puts "Do you want to play again? (y/n)".colorize(:yellow)
            answer = gets.chomp
            if answer == "y"
                randomNumber = rand(1..100)
                guesses = 0
                $stdout.clear_screen
            else
                endGame(scoreboard)
            end
        elsif guess > randomNumber
            puts "Too high!".colorize(:red)
            guesses += 1
        elsif guess < randomNumber
            puts "Too low!".colorize(:light_blue)
            guesses += 1
        end
    end
    end
