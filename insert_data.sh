#! /bin/bash

if [[ $1 == "test" ]]; then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
  if [[ $YEAR != "year" ]]; then
    # Check if winner team exists in teams table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER';")
    if [[ -z $WINNER_ID ]]; then
      $PSQL "INSERT INTO teams(name) VALUES ('$WINNER');"
    fi

    # Check if opponent team exists in teams table
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT';")
    if [[ -z $OPPONENT_ID ]]; then
      $PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');"
    fi

    # Retrieve IDs again after possible insertion
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT';")

    # Insert data into games table
    $PSQL "INSERT INTO games(winner_id, opponent_id, winner_goals, opponent_goals, year, round) VALUES ($WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, $YEAR, '$ROUND');"
  fi
done
