class Spaceship {

  PImage spaceship;

  // declare PVector variables for ships locations
  // & to speed along the y-axis and x-axis
  PVector location;
  PVector velocity;
  PVector direction;
  float velocityControl = 0.97;
  int laserLoad, laserFire;
  int spaceWrap = 25;
  int spaceWrap2 = 75;

  // constructor with ships initial locations called x and y
  Spaceship(float x, float y) {

    // initialise PVector variables
    location = new PVector(x, y); // center of the screen
    velocity = new PVector(0, 0); // starting velocity set to 0.
    direction = new PVector(0, -0.1); // used in rotate

    spaceship = loadImage("Spaceship1new.png"); 
    spaceship.resize(50, 50); // resize a shps image

    laserLoad = 0; // int value laser reloading time.
    laserFire = 30; // when int value reached, laser can fire.
  }

  void draw() {

    pushMatrix(); // starts a new environment
    // Moves the origin of the spaceship image to location.x location.y
    translate(location.x, location.y); 
    rotate(direction.heading()); // rotates ship and returns heading angle.
    image(spaceship, 0, 0); //spaceship rendering at 0,0 due to translate
    popMatrix(); // finishes new environment

    laserLoad ++;
    location.add(velocity); // adding velocity to locations
    velocity.limit(5); // used your velocity limiter from concept.

    // Forward direction spaceship is facing
    if (upArrow) velocity.add(direction); 

    // backwards direction
    if (downArrow) velocity.sub(direction);

    // amount of angle change with key press
    if (leftArrow) direction.rotate(-radians(5)); 
    if (rightArrow) direction.rotate(radians(5));

    // If spacebar and laserload time exceeds laserfire, 
    // the laser will be shot.
    if (spaceBar && laserLoad > laserFire) { 
      lzrList.add(new Laser()); // adds new laser to laser array.
      laserShots.play(); // plays laser sound effect.
      laserShots.rewind(); // rewinds laser sound, so can be called again.
      laserLoad = 0; // resets laser load to zero to reset reload time.
    }
    if (keyPressed == false) {
      velocity.mult(velocityControl);
    }
  }

  /** spacewarp()
   It allows the ship to traverse from one side of the screen to the other
   on both the X and Y axis. Once either the X or Y parameter is satisfied, 
   the X or Y location is changed. 
   It utilizes the height and width in-built variables to detect edges 
   as well as adding or subtracting an amount of pixels 
   to make the transition look seamless.
   **/

  void spacewarp() {
    // spacewarp X-axis
    if (location.x-spaceship.width < -spaceWrap2) location.x = width+spaceWrap ;
    if (location.x-spaceship.width > width) location.x = 0;

    // spacewarp Y-axis
    if (location.y-spaceship.height < -spaceWrap2) location.y = height +spaceWrap ;
    if (location.y-spaceship.height > height) location.y = 0;
  }

  // method called into the main to re center spaceship on hit with asteroid.
  void reCenter() {
    shipX = width/2; // to restore the original position of the ship
    shipY = height/2; 
    ship = new Spaceship(shipX, shipY); // calls a new ship.
  }
}
