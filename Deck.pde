//DON'T CHANGE ANYTHING HERE

public class Deck {
    private ArrayList < Card > cards = new ArrayList < Card > ();

    public Deck() {
        initDeck();
    }

    public void initDeck() {
        for (int col = 0; col < SHEET_LENGTH; col++) {
            for (int row = 0; row < SHEET_LENGTH; row++) {
                cards.add(new Card(col, row));
            }
        }
    }

    public Card getCard(int n) {
        return cards.get(n);
    }

    public Card deal() {
        if (cards.size() == 0) {
            return null;
        }
        return cards.remove((int)(Math.random() * cards.size()));
    }

    public int size() {
        return cards.size();
    }
}