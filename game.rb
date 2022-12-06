require 'colorize'
require 'io/console'
require 'json'
require 'table_print'
require 'curses'
#functions


Score = Struct.new(:name, :guesses, :date)


#scoreboard show
def scoreboardShow(scoreboard)
    if scoreboard != []
        puts "SCOREBOARD".colorize(:yellow)
        scoreboard.sort_by! { |score| score.guesses }
        tp scoreboard, :name, :guesses, :date
        
    end
    scoreboardSave(scoreboard)
    puts "Press Enter to continue".colorize(:yellow)
    a = gets()
    end



#scoreboard add score
def scoreboardAdd(scoreboard, guesses)
    #adds the player to the scoreboard
    puts "Enter your name to save your score".colorize(:green)
    name = gets.chomp
    if checkIfYourScoreBeaten(scoreboard, guesses, name)
        puts "You've beaten your personal score !".colorize(:green)
    end
    if checkIfBestScoreBeaten(scoreboard, guesses)
        puts "You've beaten the best score !".colorize(:green)
    end
    scoreboard.append(Score.new(name, guesses, Time.now.strftime("%d/%m/%Y %H:%M")))
end

#end functions
def endGame()
    puts "You have exited the game".colorize(:red)
    puts "Thanks for playing!".colorize(:green)
    exit
end


#load scoreboard from file
def scoreboardLoad()
    if File.exist?("scoreboard.json") and File.size?("scoreboard.json") > 0
        file = File.read('scoreboard.json')
        return JSON.parse(file, object_class: Score)
    else
        return []
    end
end

#save scoreboard to file
def scoreboardSave(scoreboard)
    sb = []
    for i in 0..scoreboard.length-1
        sb[i] = scoreboard[i].to_h
    end
    File.write('scoreboard.json', JSON.dump(sb))
end

def checkIfYourScoreBeaten(scoreboard, guesses, name)
    if scoreboard.length == 0
        return false
    end
    for i in 0..scoreboard.length-1
        if guesses < scoreboard[i].guesses and scoreboard[i].name == name
            return true
        end
    end
    return false
end

def checkIfBestScoreBeaten(scoreboard, guesses)
    if scoreboard.length == 0
        return true
    end
    for i in 0..scoreboard.length-1
        if guesses < scoreboard[i].guesses
            return true
        end
    end
    return false
end

#game function (main game loop)
def game()
#config
game_state = true
randomNumber = rand(1..100)
guesses = 0
scoreboard = scoreboardLoad()
$stdout.clear_screen
# game loop
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
                break
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
end

def show_menu()
#menu
Curses.init_screen
Curses.cbreak
Curses.noecho
Curses.stdscr.keypad(true)

at_exit do
    Curses.close_screen
end



menu = Curses::Menu.new([
    Curses::Item.new("1","Play"),
    Curses::Item.new("2","Scoreboard"),
    Curses::Item.new("3","Exit")
])


menu.post

while ch = Curses.getch
    begin
      case ch
      when Curses::KEY_UP, ?k
        menu.up_item
      when Curses::KEY_DOWN, ?j
        menu.down_item
      when 10, ?\n, ?\r
        break
      end
    rescue Curses::RequestDeniedError
    end
  end
choice = menu.current_item.name
menu.unpost
Curses.close_screen
return choice
end

#main
puts "Welcome to the number guessing game!".colorize(:green)
sleep(1)
while true
choice = show_menu()
case choice
when "1"
    game()
when "2"
    scoreboardShow(scoreboardLoad())
when "3"
    endGame()
end
end

