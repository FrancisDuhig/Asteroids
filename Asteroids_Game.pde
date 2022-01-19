/*
 Assessment 3 - Asteroids! for 2020 TRIMESTER 1 COSC101
 
 Group 12:
 Jamie Hyo-Joo Mills / Student ID: 220209717
 Francis Duhig / Student ID: 220211079
 
 Overview video can be found at:
 https://www.youtube.com/watch?v=srqhi0wj-Xg&feature=youtu.be
 
 **Asteroids**
 Asteroids is an arcade classic that was originally developed in 1979.
 This program has taken its basic functions and ideas from the original,
 and combined it with updated graphics and sound effects. This updated
 version of Asteroids features 2 levels, with level 1 being complete on
 scoring 20 points. Level 2 is completed upon scoring 30 points and ends
 the game.
 
 The controls are:
 Up arrow: move ship forward
 Down arrow: decrease ship velocity
 Left arrow: rotate ship left
 Right arrow: rotate ship right
 Space bar: Shoot laser
 
 *How to compile and run the solution:
 The program is developed in Processing 3.5.4 version. 
 In order to successfully compile and run the program, we recommend the version. 
 To download the latest version, please go to https://processing.org/download/.
 
 In order to play the sound system, please import Minim from Library.
 
 *Reference: 
 The separate word file called as 'reference' has listed all the links.
 They all are free sourced. */

// import sound libraries and create sound objects
import ddf.minim.*;
Minim minim;
AudioPlayer laserShots, crashing, bgm;

// declare objects 
Spaceship ship; // declare the object 'Spaceship' and call it 'ship'
Asteroid ast; // declare the object 'Asteroid' and call it 'ast'
Laser lzr; // declare the object 'Laser' and call it 'lzr'

// delcare images/shpes and fonts
PImage background1, background2, background3, spaceship;
PShape asteroid;
PFont font, fontBold;

// boolean to control the ship's movement and lazer shots
boolean upArrow, downArrow, leftArrow, rightArrow, spaceBar;

boolean enter = false; // boolean to enter in the game
boolean startGame = false;  // boolean to start the play mode
boolean secondStage = false; // boolean to start the second stage
boolean endGame = false; // if wins/loses a game, it will become 'true' 
boolean detection = false; // asteroid collision detection

// to prevent multiple images and score systems in ships detection method
int shipDetect1 = 0; 
boolean shipDetect2 = false;
// to prevent multiple images and score systems in asteroids detection method
int astDetect1 = 0; 
int astDetect2 = 0; 

// global variables
float shipSize = 80; // the size for the ship
float diameter = 80; // diameter of the bigger asteroid
float diameterS = 50; // diameter for the smaller asteroid
int scores = 0; // increment scores when an asteroid is shot 
int images = 0; // to call a background image from the 'background' array
int lives = 3; // decrement lives during the game 
int shipX = 600; // ships x and y position
int shipY = 400;
float astX, astY; // asteroids x and y position

// declar and initialise an array
PImage[] background = new PImage[3]; // to store background images

// declare and initialise arrylists for the Asteroid and Laser objects 
ArrayList<Asteroid> astList = new ArrayList<Asteroid>(); 
ArrayList<Laser> lzrList = new ArrayList<Laser>();

void setup() {
  size(1200, 800);

  // load images/shapes
  background1 = loadImage("background1.jpg");
  background2 = loadImage("background2.jpg");
  background3 = loadImage("background3.png");
  spaceship = loadImage("Spaceship1new.png");
  asteroid = loadShape("asteroid.svg");

  // resize background images
  background1.resize(width, height);
  background2.resize(width, height);
  background3.resize(width, height);

  // assign background images to the background array
  background[0] = background1;
  background[1] = background2;
  background[2] = background3;

  // x and y location for the asteroid
  astX = random(diameter, width); 
  astY = random(diameter, height);

  // initialise objects
  ship = new Spaceship(shipX, shipY);
  lzr = new Laser();
  ast = new Asteroid (asteroid, astX, astY, diameter);

  // load font files and assign the fonts 
  fontBold = createFont("zx_spectrum-7_bold.ttf", 180);
  font = createFont("zx_spectrum-7.ttf", 90);

  // load background music and sound effect files 
  minim = new Minim(this);
  laserShots = minim.loadFile("laser_beam_zapsplat.mp3");
  crashing = minim.loadFile("burning.mp3");
  bgm = minim.loadFile("bgm_zapsplat.mp3");
  bgm.play();
  bgm.loop();

  imageMode(CENTER);
  shapeMode(CENTER);
  rectMode(CENTER);

  // to reset the game 
  restart();
}

void draw() {

  background(background[images]);

  if (endGame) {

    // 4. game ending
    // if you win the game, you will get a 'Well Done' message
    // Otherwise, you will get a 'Game Over' message

    if (lives <= 0) {
      startEndTexts("return", "BACKSPACE", "GAME OVER");
    } else if (lives > 0) { 
      startEndTexts("return", "BACKSPACE", "WELL DONE");
    }

    // press BACKSPACE to return the beginning
    if (keyPressed) {
      if (key == BACKSPACE) {
        restart(); // to reset the game
      }
    }
  } else if (secondStage) {

    // 3. stage 2

    images = 2; // to change a background image
    gameTexts(); // to display texts in the background

    if (scores >= 30) {
      secondStage = false;
      endGame = true;
    }

    // if you lose, boolean 'secondStage' will be false and move to the ending
    if (lives <= 0) {
      secondStage = false;
      endGame = true;
    }

    // call from Spaceship object
    ship.draw();
    ship.spacewarp();

    // call from Asteroid object
    for (Asteroid ast : astList) {
      ast.draw();
      ast.x();
      ast.y();
    }

    // call from Lazer object
    for (Laser lzr : lzrList) {
      lzr.draw();
    }

    // collision detections for the ship and asteroids
    asteroidShot();
    shipDetection();
  } else if (startGame) {

    // 2. start a game - stage 1

    images = 1; // to change the background image
    gameTexts(); // to display texts in the background

    // if you lose, boolean 'startGame' will be false and go to the stage 2
    if (scores >= 20) {
      scores = 0;
      startGame = false;
      secondStage = true;
    }

    // if you lose, go to the ending
    if (lives <= 0) {
      startGame= false;
      endGame = true;
    }

    // call from Spaceship object
    ship.draw();
    ship.spacewarp();

    // call from Asteroid object
    for (Asteroid ast : astList) {
      ast.draw();
      ast.x();
      ast.y();
      ast.collision(lzr);
    }

    // call from Lazer object
    for (Laser lzr : lzrList) {
      lzr.draw();
    }

    // collision detections for the ship and asteroids
    asteroidShot(); 
    shipDetection();
  } else {

    // 1. beginning of the game
    startEndTexts("start", "ENTER", "ASTEROIDS"); // to display start texts
    enter = true; // to start the game 

    // press enter to start the game
    if (keyPressed) {
      if (key == ENTER && enter) {
        startGame = true;
        enter = false;
      }
    }
  }
}

// to reset the game 
void  restart() {

  shipX = width/2; // to restore the original position of the ship
  shipY = height/2;
  scores = 0; // to restore the scores
  lives = 3;  // to restore the lives
  secondStage = false; 
  startGame = false;   
  enter = false;
  images = 0;
  astList.clear(); // clear up the arrayList
  lzrList.clear();
  endGame = false;

  ship = new Spaceship(shipX, shipY); // to call a ship

  // to call asteroids 
  for (int i = 0; i < 3; i++) {
    astList.add(new Asteroid (asteroid, astX, astY, diameter));
  }
}

// to display start and end texts
// In arguments, type in 'Start', 'Enter' or 'Backspace' as a key and write
// 'ASTEROIDS', 'Game Over' or 'Well Done' depending on the stage of the game

void startEndTexts(String start, String enter, String ASTEROIDS) {

  int textSize = 60;

  fill(250);
  textFont(fontBold);
  text(ASTEROIDS, width/2, height/2);
  textSize(textSize);
  textAlign(CENTER);
  text("Press " + enter + " to " + start, width/2, height/2 + textSize);
}


// to display information (a ship, lives and scores) in the window
void gameTexts() {

  int textLocation = 50;

  fill(250);
  textFont(fontBold);
  textSize(100);
  textAlign(LEFT);
  text("SCORE: " + scores, textLocation, textLocation*2);
  textSize(60);
  text("LEXX" + " x " + lives, textLocation, height - textLocation);
}

// to play sound effects and background music 
void playSound(AudioPlayer sound, boolean yes) {
  if (yes) {
    sound.play(0);
  }
}

// Used booleans for key inputs
void keyPressed() { 
  if (keyCode == UP) upArrow = true;
  if (keyCode == DOWN) downArrow = true;
  if (keyCode == LEFT) leftArrow = true;
  if (keyCode == RIGHT) rightArrow = true;
  if (keyCode == ' ') spaceBar = true;
}

void keyReleased() {
  if (keyCode == UP) upArrow = false;
  if (keyCode == DOWN) downArrow = false;
  if (keyCode == LEFT) leftArrow = false;
  if (keyCode == RIGHT) rightArrow = false;
  if (key == ' ') spaceBar = false;
}

// when asteroids get laser shot, 
// call the collision detection boolean method from the Asteroid class.
// The bigger asteroids will be borken into 2 pieces 
// and smaller asteroids are removed on shot

void asteroidShot() {

  for (int j = 0; j <lzrList.size(); j++) {
    Laser lzr = lzrList.get(j);
    for (int i = 0; i < astList.size(); i++) {
      Asteroid ast = astList.get(i);

      if (ast.collision(lzr) && ast.diameter() != true) {
        astDetect1 = 1; // to prevent multiple images and score systems 
        if (astDetect1 != 0) {
          float x_post = ast.x(); // asteroids location from Asteroid's class
          float y_post = ast.y();
          // swap the bigger asteroid with a smaller asteroid
          astList.set(i, new Asteroid (asteroid, x_post, y_post, diameterS));
          // add a smaller asteroid in the array
          astList.add(new Asteroid (asteroid, x_post+10, y_post+10, diameterS));
          // add a bigger asteroid in the array
          astList.add(new Asteroid (asteroid, astX, astY, diameter));
          lzrList.remove(lzr); // remove laser when it hits a bigger asteroid
          crashing.play();
          crashing.rewind();
          scores++;
          astDetect1 = 0;
        }
      } else if (ast.collision(lzr) && ast.diameter()) {
        astDetect2 = 2; // to prevent multiple images and score system
        if (astDetect2 != 0) {
          astList.remove(ast); // to remove a smaller asteroid when shot
          crashing.play();
          crashing.rewind();
          scores++;
          astDetect2 = 0;
        }
      }
    }
  }
}



// ship's collision detection. When it is hit by an asteroid, 
// it decrements ship's live

void shipDetection() {

  for (int i = 0; i < astList.size(); i++) {
    Asteroid ast = astList.get(i);
    shipDetect1 = 1;
    if (shipDetect1 != 0) {
      float xShip = ship.location.x; // ships location from Spaceship's class
      float yShip = ship.location.y;
      float astX = ast.x(); // asteroids location from Asteroid's class
      float astY = ast.y();
      float d = dist(xShip, yShip, astX, astY); //distance between their points
      shipDetect2 = true;
      if (d < diameterS && shipDetect2) { 
        crashing.play();
        crashing.rewind();
        lives--; // decrement ship's live
        ship.reCenter();
        shipDetect2 = false;
      }
    }
  }
}
