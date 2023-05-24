//DON'T CHANGE ANYTHING HERE

public void togglePauseResume() {
    if (state == State.PAUSED) {
        resumeGame();
    } else {
        pauseGame();
    }
}

public void pauseGame() {
    state = State.PAUSED;
    timeElapsed += millis() - runningTimerStart;
    message = 9;
}

public void resumeGame() {
    state = State.PLAYING;
    runningTimerStart = millis();
    message = 10;
}

void showTimer() {
    textFont(timerFont);
    fill(TIMER_FILL);
    // If the game is paused, show time elapsed
    // If the game is over, show time to complete
    // Otherwise, show time elapsed so far in current game
    if (state == State.PAUSED) {
        text("Time: " + timeElapsed / 1000, TIMER_LEFT_OFFSET, TIMER_TOP_OFFSET);
    } else if (state == State.GAME_OVER) {
        text("Time: " + (timeElapsed) / 1000, TIMER_LEFT_OFFSET, TIMER_TOP_OFFSET);
    } else {
        text("Time: " + (millis() - runningTimerStart + timeElapsed) / 1000, TIMER_LEFT_OFFSET, TIMER_TOP_OFFSET);
    }
}

public int timerScore() {
    // Returns the number of points scored based on the timer, which is
    // the GREATER of:
    //    300 minus the number of seconds taken when the game ends
    //      0
    //
    // If it took 277 seconds to finish the game, this should return 23 (300-277=23)
    // If it took 435 seconds to finish the game, this should return 0 (435 > 300)
    int timeInSeconds = (millis() - runningTimerStart) / 1000; // total time in seconds
    int timeUnderFiveMinutes = max(0, 300 - timeInSeconds); // time under 5 minutes (or 0 if over)

    if (timeUnderFiveMinutes == 0) {
        return 0; // player took more than 5 minutes, no points earned
    } else {
        int points = timeUnderFiveMinutes; // earn 1 point for every second completed under 5 minutes\
        return points;
    }
}