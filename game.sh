#!/bin/bash

word_list=($(grep '^\w\w\w\w\w$' /usr/share/dict/words | tr '[a-z]' '[A-Z]'))

chosen_word=${word_list[$(($RANDOM % ${#word_list[@]}))]}

game_end=false
attempt_count=0
max_attempts=6

if [[ $1 == "unlimit" ]]; then
    max_attempts=2000
fi

while [[ $game_end != true ]]; do
    attempt_count=$(( $attempt_count + 1 ))

    if [[ $attempt_count -le $max_attempts ]]; then
        echo "Enter your guess ($attempt_count / $max_attempts):"
        read player_guess
        player_guess=$(echo $player_guess | tr '[a-z]' '[A-Z]')

        if [[ " ${word_list[*]} " =~ " $player_guess " ]]; then
            display=""
            remaining_letters=""

            if [[ $chosen_word == $player_guess ]]; then
                echo "You guessed right!"
                for ((i = 0; i < ${#chosen_word}; i++)); do
                    display+="\033[30;102m ${player_guess:$i:1} \033[0m"
                done
                printf "$display\n"
                game_end=true
            else
                for ((i = 0; i < ${#chosen_word}; i++)); do
                    if [[ "${chosen_word:$i:1}" != "${player_guess:$i:1}" ]]; then
                        remaining_letters+=${chosen_word:$i:1}
                    fi
                done
                for ((i = 0; i < ${#chosen_word}; i++)); do
                    if [[ "${chosen_word:$i:1}" != "${player_guess:$i:1}" ]]; then
                        if [[ "$remaining_letters" == *"${player_guess:$i:1}"* ]]; then
                            display+="\033[30;103m ${player_guess:$i:1} \033[0m"
                            remaining_letters=${remaining_letters/"${player_guess:$i:1}"/}
                        else
                            display+="\033[30;107m ${player_guess:$i:1} \033[0m"
                        fi
                    else
                        display+="\033[30;102m ${player_guess:$i:1} \033[0m"
                    fi
                done
                printf "$display\n"
            fi
        else
            echo "Please enter a valid word with 5 letters!";
            attempt_count=$(( $attempt_count - 1 ))
        fi
    else
        echo "You lose! The word is:"
        echo $chosen_word
        game_end=true
    fi
done
