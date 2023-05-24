//DON'T CHANGE ANYTHING HERE

// GENERAL NOTES
// The purpose of using mousePressed() and mouseReleased() instead of
// mouseClicked() is to adhere to the idea that confirmation of a clicked
// button should include a release over the button as well. This is fairly
// standard in the behavior of SUBMIT buttons in web browsers.
//
// The strategy for handling button events is to gather information about
// where a mouse was pressed and released and only if the two align is a
// button action actually taken.

// When a non-button is clicked, use -1 to indicate none selected
int mousex = -1;
int mousey = -1;
// clickedRow and clickedCol are an integrity check to make sure that
// the user truly intends to toggle a particular cell.  The cell where
// the mouse was pressed needs to be the same as the cell where the
// mouse was released in order for a toggle to happen.
int clickedRow = -1;
int clickedCol = -1;
int buttonSelected = -1;
int buttonReleased = -1;


void mousePressed() {
    if (between(mouseX, GRID_LEFT_OFFSET, grid.rightOffset()) &&
        between(mouseY, GRID_TOP_OFFSET, GRID_BOTTOM)) {
        int xPos = (mouseX - GRID_LEFT_OFFSET) % (CARD_WIDTH + GRID_X_SPACER);
        int yPos = (mouseY - GRID_TOP_OFFSET) % (CARD_HEIGHT + GRID_Y_SPACER);

        if ((between(xPos, CARD_WIDTH + 1, CARD_WIDTH + GRID_X_SPACER) ||
                between(yPos, CARD_HEIGHT + 1, CARD_HEIGHT + GRID_Y_SPACER))) {} else {
            clickedCol = (mouseX - GRID_LEFT_OFFSET) / (CARD_WIDTH + GRID_X_SPACER);
            clickedRow = (mouseY - GRID_TOP_OFFSET) / (CARD_HEIGHT + GRID_Y_SPACER);
            //grid.updateSelected(clickedCol, clickedRow);
        }
    } else {
        buttonSelected = -1;
        for (int i = 0; i < NUM_BUTTONS; i++) {
            if (between(mouseX, BUTTON_LEFT_OFFSET + i * (BUTTON_WIDTH + 12), BUTTON_LEFT_OFFSET + i * (BUTTON_WIDTH + 12) + BUTTON_WIDTH) &&
                between(mouseY, BUTTON_TOP_OFFSET, BUTTON_TOP_OFFSET + BUTTON_HEIGHT)) {
                mousex = mouseX;
                mousey = mouseY;
                // 0: Add Cards, 1: Find Set, 2: New Game, 3: Pause Game, 4: Hint
                buttonSelected = i;
            }
        }
    }
}

void mouseReleased() {
    // buttonReleased determines if a button was clicked
    // Must set to -1 here as if not, do not want state change
    buttonReleased = -1;

    // If the click was on the grid, toggle the appropriate cell
    if (between(mouseX, GRID_LEFT_OFFSET, grid.rightOffset()) &&
        between(mouseY, GRID_TOP_OFFSET, GRID_BOTTOM) &&
        !(state == State.GAME_OVER) &&
        !(state == State.PAUSED)) {
        int xPos = (mouseX - GRID_LEFT_OFFSET) % (CARD_WIDTH + GRID_X_SPACER);
        int yPos = (mouseY - GRID_TOP_OFFSET) % (CARD_HEIGHT + GRID_Y_SPACER);

        if ((between(xPos, CARD_WIDTH + 1, CARD_WIDTH + GRID_X_SPACER) ||
                between(yPos, CARD_HEIGHT + 1, CARD_HEIGHT + GRID_Y_SPACER))) {} else {
            int col = (mouseX - GRID_LEFT_OFFSET) / (CARD_WIDTH + GRID_X_SPACER);
            int row = (mouseY - GRID_TOP_OFFSET) / (CARD_HEIGHT + GRID_Y_SPACER);
            if (row == clickedRow && col == clickedCol) {
                grid.updateSelected(clickedCol, clickedRow);
            }
        }
    } else { // Figure out if a button was clicked and, if so, which one
        for (int i = 0; i < NUM_BUTTONS; i++) {
            if (between(mouseX, LEFT_OFFSET + i * (BUTTON_WIDTH + 12), LEFT_OFFSET + i * (BUTTON_WIDTH + 12) + BUTTON_WIDTH) &&
                between(mouseY, BUTTON_TOP_OFFSET, BUTTON_TOP_OFFSET + BUTTON_HEIGHT)) {
                buttonReleased = i;
            }
        }
        if (buttonSelected == buttonReleased && buttonReleased >= 0) {
            if (buttonReleased == 2) {
                newGame();
            } else if (state != State.GAME_OVER) {
                switch (buttonReleased) {
                    case 0:
                        grid.addColumn();
                        break;
                    case 1:
                        state = State.FIND_SET;
                        highlightCounter = 0;
                        break;
                    case 3:
                        togglePauseResume();
                        break;
                    case 4:
                        grid.shuffleCards();
                        break;
                    default:
                        break;
                }
            }
        }
    }
}
