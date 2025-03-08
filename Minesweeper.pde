import de.bezier.guido.*;
int NUM_ROWS = 30, NUM_COLS = 30;
private MSButton[][] buttons;
private ArrayList<MSButton> mines;
private boolean gameOver = false, gameWon = false;
int gridHeight = 800;
int messageHeight = 100;
void setup() {
    size(900, 900);
    textAlign(CENTER, CENTER);
    Interactive.make(this);
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    mines = new ArrayList<MSButton>();
    for (int i = 0; i < NUM_ROWS; i++)
        for (int j = 0; j < NUM_COLS; j++)
            buttons[i][j] = new MSButton(i, j);
    setMines();
}
void draw() {
    background(0);
    if (gameOver) {
        displayMessage("OH BROTHER YOU STINK", color(255, 0, 0));
        return;
    }
    if (gameWon) {
        displayMessage("SIGMA!", color(0, 255, 0));
        return;
    }
    for (int i = 0; i < NUM_ROWS; i++)
        for (int j = 0; j < NUM_COLS; j++)
            buttons[i][j].draw();
}
public void setMines() {
    while (mines.size() < 100) {
        int row = (int) (Math.random() * NUM_ROWS);
        int col = (int) (Math.random() * NUM_COLS);
        MSButton button = buttons[row][col];
        if (!mines.contains(button)) mines.add(button);
    }
}
public void displayMessage(String message, color textColor) {
    fill(textColor);
    textSize(50);
    text(message, width / 2, height - messageHeight / 2);
}
public boolean isValid(int r, int c) {
    return r >= 0 && c >= 0 && r < NUM_ROWS && c < NUM_COLS;
}
public int countMines(int row, int col) {
    int numMines = 0;
    for (int i = row - 1; i <= row + 1; i++)
        for (int j = col - 1; j <= col + 1; j++)
            if (isValid(i, j) && mines.contains(buttons[i][j])) numMines++;
    return numMines;
}
public boolean isWon() {
    for (MSButton mine : mines) if (!mine.isFlagged()) return false;
    for (int i = 0; i < NUM_ROWS; i++)
        for (int j = 0; j < NUM_COLS; j++)
            if (buttons[i][j].isFlagged() && !mines.contains(buttons[i][j])) return false;
    return true;
}
public class MSButton {
    private int myRow, myCol;
    private float x, y, width, height;
    private boolean clicked = false, flagged = false;
    private String myLabel = "";
    public MSButton(int row, int col) {
        width = 900 / NUM_COLS;
        height = gridHeight / NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol * width;
        y = myRow * height;
        Interactive.add(this);
    }
  public void mousePressed() {
    if (gameOver || gameWon || clicked) return;
    if (mouseButton == RIGHT) {
        flagged = !flagged;
        if (isWon()) gameWon = true;
        return;
    }
    clicked = true;
    if (mines.contains(this)) {
        gameOver = true;
        return;
    }
    int mineCount = countMines(myRow, myCol);
    if (mineCount > 0) setLabel(mineCount);
    else {
        for (int i = myRow - 1; i <= myRow + 1; i++)
            for (int j = myCol - 1; j <= myCol + 1; j++)
                if (isValid(i, j) && !buttons[i][j].clicked) {
                    buttons[i][j].clicked = true;
                    int neighborMines = countMines(i, j);
                    if (neighborMines > 0) buttons[i][j].setLabel(neighborMines);
                }
            }
        }
    public void draw() {
        if (flagged) fill(0, 0, 255);
        else if (clicked) fill(mines.contains(this) ? color(255, 0, 0) : 200);
        else fill(100);
        rect(x, y, width, height);
        fill(0);
        text(myLabel, x + width / 2, y + height / 2);
    }
    public void setLabel(int newLabel) {
        myLabel = "" + newLabel;
    }
    public boolean isFlagged() {
        return flagged;
    }
}
