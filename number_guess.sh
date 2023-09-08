#! /bin/bash

# global variables
PSQL="psql -X --username=postgres --dbname=number_guess --tuples-only --no-align -c"
RANDOM_NUMBER=$((RANDOM % 1000 + 1)) # random number between 1 and 1000 
USERNAME=''
USER_ID=0
GAMES_PLAYED=0
BEST_GAME=0
USER_NUMBER=0
NUMBER_OF_GUESSES=0


# game over 
GAME_OVER() {
    if [[ -z $1 ]]
    then 
        echo '\nError\n'
        exit
    else 
        GAMES_PLAYED=$1
        INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (user_id, guesses) VALUES ($USER_ID, $GAMES_PLAYED);" )
        echo -e "\nYou guessed it in $GAMES_PLAYED tries. The secret number was $RANDOM_NUMBER.\n"
    fi
}

# guessing game
GUESSING_GAME() {
    echo -e "\nGuess the secret number between 1 and 1000:"

    until [[ $USER_NUMBER == $RANDOM_NUMBER ]]
    do 
       read USER_NUMBER
       NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))

        if [[ ! $USER_NUMBER =~ ^[0-9]+$ ]] 
        then 
            echo "That's not an integer, guess again:"          
            else if [[ $USER_NUMBER -lt 1 || $USER_NUMBER -gt 1000 ]] 
            then 
                echo "Invalid integer. Please, type a number between 1 and 1000:"
                else if [[ $USER_NUMBER == $RANDOM_NUMBER ]] 
                then
                    GAME_OVER $NUMBER_OF_GUESSES
                    exit                                        
                    else if [[ $USER_NUMBER -lt $RANDOM_NUMBER ]] 
                    then 
                        echo "It's greater than that. Try again:"
                    else 
                        echo "It's lower than that. Try again:"
                    fi
                fi
            fi
        fi          
    done 
}


#main menu 
MAIN_MENU() {
    # welcome message
    echo -e "\n~~~~~ Number Guessing Game ~~~~~\n"

    # read username
    echo Enter your username: 
    read USERNAME

    # check if user exists in the database
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")
    if [[ -z $USER_ID ]] 
    then 
        INSERT_USER_RESULT=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME');")
        USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")
        echo -e "\nWelcome $USERNAME! It looks like this is your first time here.\n"
    else 
        GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id=$USER_ID;")
        BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID;")
        echo -e "\nWelcome back $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.\n"
    fi 

    # call guessing game function
    GUESSING_GAME
}

# call main menu 
MAIN_MENU