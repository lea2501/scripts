#!/bin/ksh

# Section: games
print -n "install games?: (y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./install_ports_games.ksh
fi

# Section: quakeinjector
print -n "install quakeinjector?: (y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./install_quakeinjector.ksh
fi

# Section: Add user to games group
print -n "Add user to games group?: (y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./add_user_to_games_group.ksh
fi