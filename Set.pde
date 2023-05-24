//DON'T CHANGE ANYTHING HERE

PImage cimg;
// For extracting pieces of the image at http://clojure.paris/resources/public/imgs/all-cards.png
public final int SHEET_LENGTH = 9; // Number of cards in a row (or column) on the sheet
public final int NUM_CARDS = 81; // Number of cards in the sheet
public final int CARD_WIDTH = 138; // Width in pixels of a card
public final int CARD_HEIGHT = 97; // Height in pixels of a card
public final int CARD_X_SPACER = 1; // Space between cards in the x-direction on the sheet
public final int CARD_Y_SPACER = 1; // Space between cards in the y-direction on the sheet
// Offsets into the sheet of cards
final int LEFT_OFFSET = 6;
final int TOP_OFFSET = 9;

// For locating cards on the play grid
public final int GRID_LEFT_OFFSET = 16; // Distance from left to start drawing grid
public final int GRID_TOP_OFFSET = 72; // Distance from top to start drawing grid
public final int GRID_X_SPACER = 8; // Separation between cards horizontally
public final int GRID_Y_SPACER = 8; // Separation between cards vertically
public final int BEGIN_COLS = 4; // Beginning number of columns in the grid
public final int ROWS = 3; // Number of rows in the grid
public final int MAX_COLS = 7; // Maximum number of columns in the grid
public int currentCols = BEGIN_COLS; // Important to program in general, but also good
// for testing special cases (cardsInPlay == 3, e.g.)

// From left of window to right edge of grid
//public int grid_right = GRID_LEFT_OFFSET + currentCols * (CARD_WIDTH + GRID_X_SPACER);
// From top of window to bottom of grid
public final int GRID_BOTTOM = GRID_TOP_OFFSET + ROWS * (CARD_HEIGHT + GRID_Y_SPACER);

// From top of window to top of buttons
final int BUTTON_LEFT_OFFSET = GRID_LEFT_OFFSET;
final int BUTTON_TOP_OFFSET = GRID_BOTTOM + 16;
final int BUTTON_WIDTH = 180;
final int BUTTON_HEIGHT = 52;

// Four buttons: Add Cards, Find Set, New Game, Pause
public final int NUM_BUTTONS = 5;

Grid grid;
Deck deck;

// Score information
public PFont scoreFont;
public final color SCORE_FILL = #000000;    // Black RGB values; feel free to change
public int score;
public int SCORE_LEFT_OFFSET = GRID_LEFT_OFFSET;
public int SCORE_TOP_OFFSET = 25;

// Timer information
public PFont timerFont;
public final color TIMER_FILL = #000000;
public int runningTimer;
public int runningTimerEnd;
public final int TIMER_LEFT_OFFSET = SCORE_LEFT_OFFSET + 256;
public final int TIMER_TOP_OFFSET = SCORE_TOP_OFFSET;

// Message information
public PFont messageFont;
public final color MESSAGE_FILL = #000000;    // Black RGB values; feel free to change
public int message;
public final int MESSAGE_LEFT_OFFSET = TIMER_LEFT_OFFSET + 256;
public final int MESSAGE_TOP_OFFSET = TIMER_TOP_OFFSET;

// Directions information
public PFont keyOptionsFont;
public final color KEY_OPTIONS_FILL = #000000;
public final int KEY_OPTIONS_LEFT_OFFSET = GRID_LEFT_OFFSET;
public final int KEY_OPTIONS_TOP_OFFSET = BUTTON_TOP_OFFSET + BUTTON_HEIGHT + 48;
public final String keyOptions = "q, w, e, r, [t, y, u]: top row;\na, s, d, f, [g, h, j]: second row;\n" +
    "z, x, c, v, [b, n, m]: third row\n" +
    "+ to add cards, - to find a set, SPACE to pause, ENTER/RETURN for a new game, ` to shuffle";

public final color BACKGROUND_COLOR = color(189, 195, 199);
public final color SELECTED_HIGHLIGHT = #FFDD00;
public final color CORRECT_HIGHLIGHT = #00FF00;
public final color INCORRECT_HIGHLIGHT = #FF0000;
public final color FOUND_HIGHLIGHT = #11CCCC;
public final int HIGHLIGHT_TICKS = 35;
public final int FIND_SET_TICKS = 60;
public int highlightCounter = 0;

// TIMER
public int gameTimer = 0;
public int setTimer = 0;
public int runningTimerStart;
public int timeElapsed = 0;


// state:
//   0 -> Normal play
//   1 -> Three cards selected (for freezing highlights)
//   2 -> Find Set selected
//   3 -> Game Over
//   4 -> Game Paused
public enum State {
    PLAYING,
    EVAL_SET,
    FIND_SET,
    GAME_OVER,
    PAUSED
};
State state = State.PLAYING;

void setup() {
    size(1056, 568);
    background(BACKGROUND_COLOR);

    fill(#000000);
  text("Loading...", 50, 150);
  
  newGame();

  initFonts();  
  
  initSpriteSheet();
}

void draw() {
  background(BACKGROUND_COLOR);
  
  showScore();
  showTimer();
  showMessage();
  drawButtons();
  drawDirections();
  
  grid.display();
  grid.highlightSelectedCards();
  
  if (grid.tripleSelected() && state == State.PLAYING) {
        state = State.EVAL_SET;
        highlightCounter = 0;
    }

    // Three cards selected; process them
    if (state == State.EVAL_SET) {
        if (highlightCounter == HIGHLIGHT_TICKS) { // 35 ticks showing special highlight
            grid.processTriple();
        } else {
            highlightCounter = highlightCounter + 1;
        }
        // Find Set selected
    } else if (state == State.FIND_SET) {
        if (highlightCounter == FIND_SET_TICKS) { // 35 ticks showing special highlight
            state = State.PLAYING;
            grid.clearSelected();
            score -= 5;
        } else {
            highlightCounter = highlightCounter + 1;
        }
    }
}

// For details on the 8-argument version of image(), see:
// https://forum.processing.org/one/topic/image-ing-a-part-of-a-pimage.html
void drawCard(int cardCol, int cardRow, int xpos, int ypos) {
    image(cimg, xpos, ypos, CARD_WIDTH + CARD_X_SPACER, CARD_HEIGHT + CARD_Y_SPACER,
        LEFT_OFFSET + cardCol * CARD_WIDTH, TOP_OFFSET + cardRow * CARD_HEIGHT,
        (cardCol + 1) * CARD_WIDTH + CARD_X_SPACER, (cardRow + 1) * CARD_HEIGHT + CARD_Y_SPACER);
}

void drawRow(int row) {
    for (int col = 0; col < SHEET_LENGTH; col++) {
        drawCard(col, row, col * (CARD_WIDTH + CARD_X_SPACER), row * (CARD_HEIGHT + CARD_Y_SPACER));
    }
}

void drawDeck() {
    for (int row = 0; row < ROWS; row++) {
        drawRow(row);
    }
}

void drawCards() {
    for (int row = 0; row < SHEET_LENGTH; row++) {
        drawRow(row);
    }
}

void drawButtons() {
    // Start, Stop, Clear rectangles in gray
    fill(#DDDDDD);
    for (int i = 0; i < NUM_BUTTONS; i++) {
        rect(BUTTON_LEFT_OFFSET + i * (BUTTON_WIDTH + 12), BUTTON_TOP_OFFSET, BUTTON_WIDTH, BUTTON_HEIGHT);
    }

    // Set text color on the buttons to blue
    fill(#0000FF);

    text("Add Cards", BUTTON_LEFT_OFFSET+18, BUTTON_TOP_OFFSET+22); 
    text(" Find Set", BUTTON_LEFT_OFFSET+18+BUTTON_WIDTH+12, BUTTON_TOP_OFFSET+22); 
    text("New Game", BUTTON_LEFT_OFFSET+18+2*(BUTTON_WIDTH+12), BUTTON_TOP_OFFSET+22); 
    if (state == State.PAUSED) {
        text("Resume", BUTTON_LEFT_OFFSET + 45 + 3 * (BUTTON_WIDTH + 12), BUTTON_TOP_OFFSET + 22);
    } else {
        text("Pause", BUTTON_LEFT_OFFSET + 54 + 3 * (BUTTON_WIDTH + 12), BUTTON_TOP_OFFSET + 22);
    }
    text("Shuffle", BUTTON_LEFT_OFFSET+28+4*(BUTTON_WIDTH+12), BUTTON_TOP_OFFSET+22); 
}

public void newGame() {
    deck = new Deck();
    grid = new Grid();
    score = 0;
    currentCols = 4;
    state = State.PLAYING;
    message = 0;

    for (int i = 0; i < currentCols * ROWS; i++) {
        grid.addCardToBoard(deck.deal());
    }

    //gameTimer = 0;
    //setTimer = 0;
    timeElapsed = 0;
    runningTimerStart = millis();
}

public void initFonts() {
    scoreFont = createFont("ComicSansMS-Bold", 26);
    messageFont = scoreFont;
    timerFont = scoreFont;
    keyOptionsFont = createFont("Times New Roman", 14);
    textAlign(LEFT, CENTER);
}

public void drawDirections() {
    fill(KEY_OPTIONS_FILL);
    textFont(keyOptionsFont);
    text(keyOptions, KEY_OPTIONS_LEFT_OFFSET, KEY_OPTIONS_TOP_OFFSET);
}

public void initSpriteSheet() {
    // NOTE: These cards are being used for educational purposes only and are not to be used
    // for profit without written consent by copyright holder(s).
    //String url = "https://amiealbrecht.files.wordpress.com/2016/08/set-cards.jpg?w=1250";
    // Need string that says "Loading..." here
    String url = "set-cards.jpg";
    cimg = loadImage(url, "png");
}

void showScore() {
    textFont(scoreFont);
    fill(SCORE_FILL);
    text("Score: " + score, SCORE_LEFT_OFFSET, SCORE_TOP_OFFSET);
}

public void showMessage() {
    textFont(messageFont);
    String str = "";
    switch (message) {
        case 0:
            str = "Welcome to SET!";
            break;
        case 1:
            str = "Set found!";
            break;
        case 2:
            str = "Sorry, not a set!";
            break;
        case 3:
            str = "Cards added to board...";
            break;
        case 4:
            str = "There is a set on the board!";
            break;
        case 5:
            str = "No cards left in the deck!";
            break;
        case 6:
            str = "No set on board to find!";
            break;
        case 7:
            str = "GAME OVER! PRESS NEW GAME!";
            break;
        case 8:
            str = "\"" + key + "\"" + " not an active key!";
            break;
        case 9:
            str = "Game paused";
            break;
        case 10:
            str = "Game resumed";
            break;
        default:
            str = "Something is wrong. :-(";
    }
    text(str, MESSAGE_LEFT_OFFSET, MESSAGE_TOP_OFFSET);
}
