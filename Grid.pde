//COMPLETE THIS METHODS IN THIS CLASS

import java.util.Random;

public class Grid {
    // In the physical SET game, cards are placed on the table.
    // The table contains the grid of cards and is typically called the board.
    //
    // Note that the minimum number of cards that guarantees a set is 21,
    // so we create an array with enough columns to accommodate that.
    Card[][] board = new Card[MAX_COLS][ROWS];

    ArrayList < Location > selectedLocs = new ArrayList < Location > (); // Locations selected by the player
    ArrayList < Card > selectedCards = new ArrayList < Card > (); // Cards selected by the player 
    // (corresponds to the locations)  
    int cardsInPlay; // Number of cards visible on the board

    public Grid() {
        cardsInPlay = 0;
    }

    // GRID MUTATION PROCEDURES

    // 1. Highlight (or remove highlight) selected card
    // 2. Add (or remove) the location of the card in selectedLocs
    // 3. Add the card to (or remove from) the list of selectedCards
    public void updateSelected(int col, int row) {
        Card card = board[col][row];

        if (selectedCards.contains(card)) {
            int index = selectedCards.indexOf(card);
            selectedLocs.remove(index);
            selectedCards.remove(card);
            //score--;
        } else {
            selectedLocs.add(new Location(col, row));
            selectedCards.add(card);
        }
    }

    //   Precondition: A Set has been successfully found
    //   Postconditions: 
    //      * The number of columns is adjusted as needed to reflect removal of the set
    //      * The number of cards in play is adjusted as needed
    //      * The board is mutated to reflect removal of the set
    public void removeSet() {
        // Remove cards at selectedLocs
        for (Location loc: selectedLocs) {
            board[loc.getCol()][loc.getRow()] = deck.deal(); // Replace selected cards with new random cards
        }

        // Consolidate board if necessary
        if (cardsInPlay > 12) {
            int lastCol = currentCols - 1;
            for (Location loc: selectedLocs) {
                int row = loc.getRow();
                int col = loc.getCol();
                while (col < lastCol) {
                    board[col][row] = board[col + 1][row];
                    col++;
                }
                board[lastCol][row] = null;
            }
            // Checks if board contains null and solves the bug (happens when two of the selected cards are on the same row, with one at the previously added column)
            for (int i = 0; i < lastCol; i++) {
                for (int j = 0; j < 3; j++) {
                    if (board[i][j] == null) {
                        board[i][j] = deck.deal();
                    }
                }
            }
            currentCols--; // Update currentCols correspondingly
            cardsInPlay -= 3; // Update cardsInPlay correspondingly
        }
    }


    // Precondition: Three cards have been selected by the player
    // Postcondition: Game state, score, game message mutated, selected cards list cleared
    public void processTriple() {
        if (selectedCards.size() >= 3 && (isSet(selectedCards.get(0), selectedCards.get(1), selectedCards.get(2)))) { // If a set is found by the player
            score += 10;
            removeSet(); // Replace the selected cards
            if (isGameOver()) { // Check if deck size is enough to support another round
                // GAME OVER
                score += timerScore(); // Add bonus score if finished under 300 seconds
                message = 7; // Change the message to "GAME OVER"
                state = state.GAME_OVER; // Change the state of the game
            } else {
                // NOT GAME OVER
                state = State.PLAYING;
                message = 1; // Change the message to "SET FOUND"
            }
        } else if (!(selectedCards.size() < 3)) { // If 3 cards are selected but they are not a set
            score -= 5; // Deduct scores from player
            state = State.PLAYING;
            message = 2; // Change the message to "SORRY, NOT A SET!"
        }
        clearSelected(); // Clear the selectedLocs and selectedCards arrays
    }


    // DISPLAY BOARD ON THE SCREEN
    public void display() {
        int cols = cardsInPlay / 3;
        for (int col = 0; col < cols; col++) {
            for (int row = 0; row < ROWS; row++) {
                if (board[col][row] != null) {
                    board[col][row].display(col, row);
                }
            }
        }
    }

    public void highlightSelectedCards() {
        color highlight;
        if (state == State.FIND_SET) {
            highlight = FOUND_HIGHLIGHT;
            selectedLocs = findSet();
            if (selectedLocs.size() == 0) {
                message = 6;
                return;
            }
        } else if (selectedLocs.size() < 3) {
            highlight = SELECTED_HIGHLIGHT;
        } else {
            highlight = isSet(selectedCards.get(0), selectedCards.get(1), selectedCards.get(2)) ?
                CORRECT_HIGHLIGHT :
                INCORRECT_HIGHLIGHT;
        }
        for (Location loc: selectedLocs) {
            drawHighlight(loc, highlight);
        }
    }

    public void drawHighlight(Location loc, color highlightColor) {
        stroke(highlightColor);
        strokeWeight(5);
        noFill();
        int col = loc.getCol();
        int row = loc.getRow();
        rect(GRID_LEFT_OFFSET + col * (CARD_WIDTH + GRID_X_SPACER),
            GRID_TOP_OFFSET + row * (CARD_HEIGHT + GRID_Y_SPACER),
            CARD_WIDTH,
            CARD_HEIGHT);
        stroke(#000000);
        strokeWeight(1);
    }
  
    // DEALING CARDS
    // Preconditions: cardsInPlay contains the current number of cards on the board
    //                the array board contains the cards that are on the board
    // Postconditions: board has been updated to include the card
    //                the number of cardsInPlay has been increased by one
    public void addCardToBoard(Card card) {
        int colToAdd = cardsInPlay / 3; 
        int rowToAdd = cardsInPlay % 3; 
        board[colToAdd][rowToAdd] = card; 
        cardsInPlay++;
    }

    public void addColumn() {
        // Check if there are no more cards in the deck
        if (deck.size() == 0) {
            message = 5; // Indicates that there are no more cards in the deck
            return; // Break out of the method
        }

        // Check if there are no sets on the board
        if (findSet().size() == 0) {
            score += 5; // Add five points to the player's score
            for (int i = 0; i < 3; i++) {
                grid.addCardToBoard(deck.deal());
            }
            currentCols++;
            message = 3; // Indicates that cards have been added to the board 
        } else {
            score -= 5; // Subtract five points from the player's score
            message = 4; // Indicates that there is a set on the board
        }

    }

    // GAME PROCEDURES

    public boolean isGameOver() {
        return (deck.size() == 0);
        // return false;
    }

    public boolean tripleSelected() {
        return (selectedLocs.size() == 3);
    }

    // Preconditions: --
    // Postconditions: The selected locations and cards ArrayLists are empty
    public void clearSelected() {
        selectedLocs.clear();
        selectedCards.clear();
    }

    // findSet(): If there is a set on the board, existsSet() returns an ArrayList containing
    // the locations of three cards that form a set, an empty ArrayList (not null) otherwise
    // Preconditions: --
    // Postconditions: No change to any state variables
    public ArrayList < Location > findSet() {
        ArrayList < Location > locs = new ArrayList < Location > ();
        for (int i = 0; i < currentCols * 3 - 2; i++) {
            for (int j = i + 1; j < currentCols * 3 - 1; j++) {
                for (int k = j + 1; k < currentCols * 3; k++) {
                    if (isSet(board[col(i)][row(i)], board[col(j)][row(j)], board[col(k)][row(k)])) {
                        locs.add(new Location(col(i), row(i)));
                        locs.add(new Location(col(j), row(j)));
                        locs.add(new Location(col(k), row(k)));
                        return locs;
                    }
                }
            }
        }
        return new ArrayList < Location > (); // NullPointerException
    }

    // UTILITY FUNCTIONS FOR GRID CLASS
    public int col(int n) {
        return n / 3;
    }

    public int row(int n) {
        return n % 3;
    }

    public int rightOffset() {
        return GRID_LEFT_OFFSET + currentCols * (CARD_WIDTH + GRID_X_SPACER);
    }
    
    public void shuffleCards() {
        // Create a duplicate of the board
        Card[][] temp = new Card[currentCols][ROWS];
        for (int i = 0; i < currentCols; i++) {
            for (int j = 0; j < ROWS; j++) { // currentCols - 1
                temp[i][j] = board[i][j];
            }
        }

        // Shuffle the duplicate board
        Random random = new Random();
        for (int i = temp.length - 1; i > 0; i--) {
            for (int j = temp[i].length - 1; j > 0; j--) {
                int rand_i = random.nextInt(i + 1);
                int rand_j = random.nextInt(j + 1);

                // Swap the Cards
                Card tempCard = temp[i][j];
                temp[i][j] = temp[rand_i][rand_j];
                temp[rand_i][rand_j] = tempCard;
            }
        }

        // Assign the shuffled board back to the original board
        board = temp;
        score -= 2;
    }

}
