#! /bin/bash

# global variables
PSQL="psql -X --username=postgres --dbname=number_guess --tuples-only --no-align -c"
RANDOM_NUMBER=$((RANDOM % 1000 + 1))
COUNT=10
ATTEMPTS_LEFT=$((COUNT))


# welcome message
echo -e "\n~~~~~ Number Guessing Game ~~~~~\n"

# read username
echo Enter your username: 
read USERNAME

# check if user exists in the database
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")
if [[ -z $USER_ID ]]
then 
    USER_ID=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME') RETURNING user_id;")
    echo -e "\nWelcome $USERNAME! It looks like this is your first time here.\n"
else 
    echo -e "\nUser ($USER_ID) exists." 
    GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id=$USER_ID;")
    BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID;")
    echo -e "\nWelcome back $USERNAME! You have played $GAMES_PLAYED, and your best game took $BEST_GAME guesses.\n"
fi 

# game over 
GAME_OVER() {
    echo -e "\nIt wasn't this time. The correct number was $RANDOM_NUMBER.\nTry again later!"
}

# main function
# GUESSING_GAME() {
    

#     while [[ $COUNT -gt 0 ]]
#     do 
#         echo -e "\nEnter an integer between 1 and 1000:" 
#         read USER_NUMBER
        

#         if [[ ! $USER_NUMBER =~ ^[0-9]+$ || $USER_NUMBER -lt 1 || $USER_NUMBER -gt 1000 ]]
#         then 
#             while [[ ! $USER_NUMBER =~ ^[0-9]+$ || $USER_NUMBER -lt 1 || $USER_NUMBER -gt 1000 ]]
#             do 
#                 echo -e "\nInvalid value. Please, enter a number between 1 and 1000:" 
#                 read USER_NUMBER
#             done
#         fi


#         if [[ $USER_NUMBER == $RANDOM_NUMBER ]]
#         then
#             echo -e "\nCongratulations, you win!"
#             exit
#         else 
#             ATTEMPTS_LEFT=$((ATTEMPTS_LEFT - 1))
#             if [[ $ATTEMPTS_LEFT == 0 ]]
#             then 
#                 GAME_OVER
#             else 
#                 echo -e "\nWrong asnwer. You have $ATTEMPTS_LEFT attempts left." 
#             fi
#         fi

#         COUNT=$((COUNT - 1))
#     done 
# }

# GUESSING_GAME

