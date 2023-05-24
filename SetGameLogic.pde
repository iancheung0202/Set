//COMPLETE ALL METHODS HERE

import java.util.Arrays;

boolean allEqual(int a, int b, int c) {
    return a == b && b == c;
}

boolean allDifferent(int a, int b, int c) {
    return a != b && b != c && a != c;
}

boolean sameColor(Card c1, Card c2, Card c3) {
    int a = c1.getCol();
    int b = c2.getCol();
    int c = c3.getCol();
    boolean range1 = (a >= 0 && a <= 2) && (b >= 0 && b <= 2) && (c >= 0 && c <= 2);
    boolean range2 = (a >= 3 && a <= 5) && (b >= 3 && b <= 5) && (c >= 3 && c <= 5);
    boolean range3 = (a >= 6 && a <= 8) && (b >= 6 && b <= 8) && (c >= 6 && c <= 8);
    return range1 || range2 || range3;
}

boolean sameShape(Card a, Card b, Card c) {

    return allEqual(a.getCol() % 3, b.getCol() % 3, c.getCol() % 3);
}

boolean sameFill(Card c1, Card c2, Card c3) {
    int a = c1.getRow();
    int b = c2.getRow();
    int c = c3.getRow();
    boolean range1 = (a >= 0 && a <= 2) && (b >= 0 && b <= 2) && (c >= 0 && c <= 2);
    boolean range2 = (a >= 3 && a <= 5) && (b >= 3 && b <= 5) && (c >= 3 && c <= 5);
    boolean range3 = (a >= 6 && a <= 8) && (b >= 6 && b <= 8) && (c >= 6 && c <= 8);
    return range1 || range2 || range3;
}

boolean sameCount(Card a, Card b, Card c) {
    return allEqual(a.getRow() % 3, b.getRow() % 3, c.getRow() % 3);
}

boolean diffColor(Card c1, Card c2, Card c3) {
    int a = c1.getCol();
    int b = c2.getCol();
    int c = c3.getCol();
    boolean range1 = (a >= 0 && a <= 2) || (b >= 0 && b <= 2) || (c >= 0 && c <= 2);
    boolean range2 = (a >= 3 && a <= 5) || (b >= 3 && b <= 5) || (c >= 3 && c <= 5);
    boolean range3 = (a >= 6 && a <= 8) || (b >= 6 && b <= 8) || (c >= 6 && c <= 8);
    return (range1 && range2 && range3);
}

boolean diffShape(Card a, Card b, Card c) {
    return allDifferent(a.getCol() % 3, b.getCol() % 3, c.getCol() % 3);
}

boolean diffFill(Card c1, Card c2, Card c3) {
    int a = c1.getRow();
    int b = c2.getRow();
    int c = c3.getRow();
    boolean range1 = (a >= 0 && a <= 2) || (b >= 0 && b <= 2) || (c >= 0 && c <= 2);
    boolean range2 = (a >= 3 && a <= 5) || (b >= 3 && b <= 5) || (c >= 3 && c <= 5);
    boolean range3 = (a >= 6 && a <= 8) || (b >= 6 && b <= 8) || (c >= 6 && c <= 8);
    return (range1 && range2 && range3);
}

boolean diffCount(Card a, Card b, Card c) {
    return allDifferent(a.getRow() % 3, b.getRow() % 3, c.getRow() % 3);
}

boolean isSet(Card a, Card b, Card c) {
    return (sameCount(a, b, c) || diffCount(a, b, c)) &&
        (sameShape(a, b, c) || diffShape(a, b, c)) &&
        (sameColor(a, b, c) || diffColor(a, b, c)) &&
        (sameFill(a, b, c) || diffFill(a, b, c));
}