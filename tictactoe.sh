#!/bin/bash

SAVEFILE=savefile.txt


restart(){
    echo "======================="
    echo "TicTacToe game in Bash"
    Arr=()
    Ocount=0
    Xcount=0
    if [ -f "$SAVEFILE" ]; then
        readarray -d ' ' -t Arr < $SAVEFILE
        Ocount=$(grep -o "O" $SAVEFILE | wc -l)
        Xcount=$(grep -o "X" $SAVEFILE | wc -l)
    else
        Arr=(. . . . . . . . .)
    fi

    if [[ "$Ocount" > "$Xcount" ]]; then
        player=2
    else
        player=1
    fi
    gamestatus=1
    echo "======================="
}


printinfo(){
    echo "======================="
    echo "Player $1's turn: ($2)"
    echo "r\c 0 1 2"
    echo "0   ${Arr[0]} ${Arr[1]} ${Arr[2]}"
    echo "1   ${Arr[3]} ${Arr[4]} ${Arr[5]}"
    echo "2   ${Arr[6]} ${Arr[7]} ${Arr[8]}"
    echo ""
    echo "  Commands:"
    echo "      1. set [row] [column]"
    echo "      2. restart"
    echo "      3. exit"
    echo "======================="
}


printgameover(){
    echo "======================="
    echo "Game Over"
    player=$(($1%2 + 1))
    echo "Player $player ($2) wins!!!"
    echo ""
    echo "  Commands:"
    echo "      1. restart"
    echo "      2. exit"
}


set(){
    if [[ $1 =~ [0-9] ]] && [[ $2 =~ [0-9] ]] ; then
        idx=$(($1*3 + $2))
        if [[ ${Arr[$idx]} == "." ]]; then 
            Arr[$idx]=$3
            player=$((player%2 + 1))
        else
            echo "Incorrect field. Please try again."
        fi
    else
        echo "Incorrect value. Please try again."
    fi
}


checkmatch(){
    if [ ${Arr[$1]} != "." ] && [ ${Arr[$1]} == ${Arr[$2]} ] && [ ${Arr[$2]} == ${Arr[$3]} ]; then
        gamestatus=0
    fi
}


checkgame(){
    checkmatch 0 1 2
    checkmatch 3 4 5
    checkmatch 6 7 8
    checkmatch 0 3 6
    checkmatch 1 4 7
    checkmatch 2 5 8
    checkmatch 0 4 8
    checkmatch 2 4 6
}

removesavefile(){
    if [ -f "$SAVEFILE" ]; then
        rm $SAVEFILE
    fi  
}

exitgame(){
    printf "%s " "${Arr[@]}" > $SAVEFILE
}



restart

while true 
do
    echo ""
    if [ $player == 1 ]; then 
        sym=O
    else 
        sym=X
    fi

    printinfo $player $sym

    while true
    do
        read -r cmd a b
        if [ $cmd == "set" ]; then
            set $a $b $sym
            break
        elif [ $cmd == "restart" ]; then
            removesavefile
            restart
            break
        elif [ $cmd == "exit" ]; then
            exitgame
            exit 0
        else
            echo "Incorrect command. Please try again."
        fi
    done

    checkgame

    if [ $gamestatus != 1 ]; then
        printgameover $player $sym
        removesavefile
        while true 
        do
            read -r cmd n
            if [ $cmd == "restart" ]; then
                restart
                break
            elif [ $cmd == "exit" ]; then
                exit 0
            fi
        done
    fi
done