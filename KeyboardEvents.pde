//DON'T CHANGE ANYTHING HERE

public void keyPressed() {
    if (key == ENTER || key == RETURN) {
        newGame();
        return;
    }

    if (state == State.GAME_OVER) return;

    if (key == ' ') {
        togglePauseResume();
        return;
    }
    
    if (key == '`') {
        grid.shuffleCards();
        return;
    }

    // No fair playing with timer paused
    if (state != State.PLAYING) return;

    String legal = "QWERTYUASDFGHJZXCVVBNMqwertyuasdfghjzxcvbnm+=-_Pp ";
    if (legal.indexOf(key) < 0) {
        message = 8;
        return;
    }

    if ("+=-_ ".indexOf(key) >= 0) {
        switch (key) {
            case ' ':
                togglePauseResume();
                break;
            case '=':
            case '+':
                grid.addColumn();
                break;
            case '_':
            case '-':
                state = State.FIND_SET;
                highlightCounter = 0;
                break;
            default:
                break;
        }
        return;
    }

    int col = "qazQAZ".indexOf(key) >= 0 ? 0 :
        "wsxWSX".indexOf(key) >= 0 ? 1 :
        "edcEDC".indexOf(key) >= 0 ? 2 :
        "rfvRFV".indexOf(key) >= 0 ? 3 :
        "tgbTGB".indexOf(key) >= 0 ? 4 :
        "yhnYHN".indexOf(key) >= 0 ? 5 :
        "ujmUJM".indexOf(key) >= 0 ? 6 : 7;
    int row = "qwertyuQWERTYU".indexOf(key) >= 0 ? 0 :
        "asdfghjASDFGHJ".indexOf(key) >= 0 ? 1 : 2;

    if (col < currentCols) {
        grid.updateSelected(col, row);
    } else {
        message = 8;
    }
}
