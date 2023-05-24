//DON'T CHANGE ANYTHING HERE

public boolean between(double a, double low, double high) {
    return (a >= low) && (a <= high);
}

public boolean member(char ch, char[] chars) {
    for (int i = 0; i < chars.length; i++) {
        if (ch == chars[i]) return true;
    }
    return false;
}