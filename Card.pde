// Really important to remember that column and row for the
// card class refers to the column and row in the sprite sheet

public class Card {
    private int col; // Column number in sheet
    private int row; // Row number in sheet

    public Card(int col, int row) {
        this.col = col;
        this.row = row;
    }

    public int getRow() {
        return row;
    }
    public int getCol() {
        return col;
    }
    public void setRow(int row) {
        this.row = row;
    }
    public void setCol(int col) {
        this.col = col;
    }

    public void display(int boardCol, int boardRow) {
        if (state == State.PAUSED) {
            fill(#FF8800);
            rect(GRID_LEFT_OFFSET + boardCol * (CARD_WIDTH + GRID_X_SPACER),
                GRID_TOP_OFFSET + boardRow * (CARD_HEIGHT + GRID_Y_SPACER),
                CARD_WIDTH,
                CARD_HEIGHT);
        } else {
            image(cimg, GRID_LEFT_OFFSET + boardCol * (CARD_WIDTH + GRID_X_SPACER),
                GRID_TOP_OFFSET + boardRow * (CARD_HEIGHT + GRID_Y_SPACER),
                CARD_WIDTH,
                CARD_HEIGHT,
                LEFT_OFFSET + col * CARD_WIDTH,
                TOP_OFFSET + row * CARD_HEIGHT,
                (col + 1) * CARD_WIDTH + CARD_X_SPACER,
                (row + 1) * CARD_HEIGHT + CARD_Y_SPACER);
        }
    }

    public boolean equals(Card other) {
        return (col == other.col && row == other.row);
    }

    public String toString() {
        return "C(" + col + "," + row + ")";
    }
}