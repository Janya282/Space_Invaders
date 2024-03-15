/*
Janya Walia
ICS3U1
Assignment 4 - Space Invaders
*/

/***** Variables and declarations *****/
PImage enemy;
PImage tank;
int tankX = 10;    
int tankY = 725;
int cannonX = 10;
int cannonY = 725;
int cannonWidth = 0;
int cannonHeight = 0;
int boundaryLine = 700;
int score = 0;
int moveRight = 0;
int moveLeft = 0;
int gameScreen = 0;
int Timer = 0;
int enemyState = 0;
int bulletY = 725;
int enemyXSpeed = 15;
int enemyYSpeed = 50;
int[] enemyXPosition = new int [45];  
int[] enemyYPosition = new int [45]; // 45 enemies on the game screen
boolean bulletShot = false;
boolean enemyMoveDown = false;
boolean[] enemyAlive = new boolean[45];

void setup() {
  size(800, 800); 
  enemyPosition(); //initalizes the position
}

/***** Screen Contents *****/
void draw() {
  if (gameScreen == 1) { // running the game screen and its commands
    background(#000000); 
    enemyDraw();
    enemyMove();
    enemyMoveDown();
    playerTank();
    moveTankandCannon();
    bullet();
    collision();
    winGame();
  } 
  if (gameScreen == 0) { 
    startScreen();
  }
  if (gameScreen == 2) { 
    loseScreen();
  }
}

void loseScreen() {
  background(#000000);  
  textSize(32);
  textAlign(CENTER);
  text("You Lost!", 400, 400);
  text("To Play Again, Press R", 400, 500);
}

void winscreen() {
  background(#000000);
  textAlign(CENTER);
  text("Congrats! You Won!", 400, 400);
}

void startScreen() { // the start screen
  background(#091763);  
  textSize(40);
  textAlign(CENTER);
  text("Space Invaders", 400, 300);
  text("Click Anywhere to Start", 400, 400);
}

void loseGame() {
  gameScreen = 2;
}

void winGame() {
  if (score >= 450) {
    winscreen();
  }
}

/***** Enemy *****/
void enemyDraw() {
  if (enemyState == 0 && gameScreen == 1) { 
    enemy = loadImage("aliens.png");
  }
  if (enemyState == 50 && gameScreen == 1) {
    enemy = loadImage("aliens2.png");
  } else {
    enemyState++;
  }
  enemyState = (enemyState+1)%99;  // animation
  for (int i = 0; i < 45; i++) { // drawing enemy
    image(enemy, enemyXPosition[i], enemyYPosition[i], 40, 40); //holds the place of enemy
  }
}

void enemyPosition() {
  int yPosition = 0;
  int i = -1;
  for (int y = 0; y < 3; y++) {
    for (int x = 0; x < 15; x++) {
      i++;
      enemyXPosition[i] = x*45;
      enemyYPosition[i] = yPosition + 25;
    }
    yPosition += 40;
  }
  for (int n = 0; n < 45; n++) {
    enemyAlive[n] = true;
    println(enemyAlive);
  }
}

void enemyMove() { //making the enemies move
  int speed = 250;
  if (millis()/speed - Timer > 0) { 
    Timer = millis()/speed;
    for (int i = 0; i < 45; i++) {
      enemyXPosition[i] = enemyXPosition[i] + enemyXSpeed; 
    }
    for (int i = 0; i < 45; i++) {
      if (enemyXPosition[i] >= 750 && enemyAlive[i] == true) { 
        enemyXSpeed = -abs(enemyXSpeed);
        enemyMoveDown = true;
      }
      if (enemyXPosition[i] <= 10 && enemyAlive[i] == true) {
        enemyXSpeed = abs(enemyXSpeed);
        enemyMoveDown = true;
      }
      if (enemyYPosition[i] >= boundaryLine - 40) {
        loseGame();
      }
    }
  }
}

void enemyMoveDown() {
  if (enemyMoveDown) {
    for (int i = 0; i < 45; i++) {
      enemyYPosition[i] = enemyYPosition[i] + enemyYSpeed;
      enemyMoveDown = false;
      if (i >= 45) {
        break;
      }
    }
  }
}

/***** Player Tank *****/
void playerTank() {
  tank = loadImage("tankk.png");
  image(tank, tankX, tankY, 80, 80); // using variables to control the x and y's of the playerTank
  rect(0, boundaryLine, 800, 5); //boundaryLine for enemys to destroy the tank
}

/**** OTHERS *****/
void reset() { //resets all the variables
  tankX = 10;     
  tankY = 725; 
  cannonX = 10;
  cannonY = 725;
  cannonWidth = 0;
  cannonHeight = 0;
  score = 0;
  moveRight = 0;
  moveLeft = 0;
  gameScreen = 0;
  Timer = 0;
  enemyState = 0;
  bulletY = 725;
  enemyXSpeed = 15;
  enemyYSpeed = 50;
  bulletShot = false;
  enemyPosition();
}

void bullet() { //bullets on screen
  if (bulletShot == false) {
    bulletY = 725;
    cannonX = tankX;
  } else {
    moveLeftC = 0;
    moveRightC = 0;
    rect(cannonX + 35, bulletY, 5, 15);    
    bulletY = bulletY - 20;
  }
  if (bulletY < -5) {
    bulletShot = false;
  }
}

void collision() { // collision for bullets and enemies 
  int bulletT = bulletY;
  int bulletL = cannonX-1;
  int bulletR = cannonX+3; 
  int bulletB = bulletY + 3;
  for (int i = 0; i < 45; i++) {
    if (enemyAlive[i] == false) {
      enemyYPosition[i] = enemyYPosition[i] - 10000;
    }
    int enemyB = enemyYPosition[i] + 45;
    int enemyL = enemyXPosition[i] - 3;
    int enemyR = enemyXPosition[i] + 45;
    int enemyT = enemyYPosition[i];
    if (bulletR > enemyL && bulletL < enemyR && bulletT < enemyB && bulletB > enemyT) {
      //if (cannonX > enemyL && cannonX < enemyR && bulletT < enemyB) {
      enemyAlive[i] = false; 
      bulletShot = false;
      score += 10;
    }
  }
}
int moveRightC = 0;
int moveLeftC = 0;
void moveTankandCannon() {  //moveTank with if statements and booolean switches
  if (moveRight == 1 && tankX < 770) {
    tankX += 7;
  }
  if (moveLeft == 1 && tankX > 0) {
    tankX -= 7;
  }
  if (moveRightC == 1 && cannonX < 770 && bulletShot == false) {
    cannonX += 7;
  }
  if (moveLeftC == 1 && cannonX > 0 && bulletShot == false) {
    cannonX -= 7;
  }
}

/***** Keyboard controls *****/
void mousePressed() { //starts the game.
  if (gameScreen == 0);
  gameScreen = 1;
}

void keyPressed() {
  if (key == ' ' && gameScreen == 1) { //used to shoot the bullet, only in gameScreen 1
    bulletShot = true;
  }
  if (key == ' ' && gameScreen == 0) { //used to start the screen if no mouse is available
    gameScreen = 1;
  }
  if (key == 'a') { //tank left 
    moveLeft = 1;
    moveLeftC = 1;
  }
  if (key == 'd') { //tank right
    moveRight = 1;
    moveRightC = 1;
  }
  if (key == 'r') { //resets the game to starts screen
    reset();
    gameScreen = 0;
  }
}

void keyReleased() { //to make sure the movement buttons are not ON/OFF switches
  if (key == 'a') {
    moveLeft = 0;
  }
  if (key == 'd') {
    moveRight = 0;
  }
}
