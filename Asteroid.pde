class Asteroid {

  float x; // X-coordinate of the asteroid
  float y; // Y-coordinate of the asteroid
  float diameter; // diameter of the asteroid
  float speedX = random(1, 4); // speed along the x-axis
  float speedY = random(2, 5); // speed along the y-axis
  int smallAsteroid = 50;
  PShape asteroid;

  // constructor w/ an image, x and y location of the asteroid and its diameter
  Asteroid(PShape asteroid, float x, float y, float diameter) {
    this.asteroid = asteroid;
    this.x = x; 
    this.y = y; 
    this.diameter = diameter;
  }

  void draw() {
    // to speed up the asteroid
    x = x + speedX;
    y = y + speedY;

    // to draw an asteroid to the screen
    shape(asteroid, x, y, diameter, diameter);

    // to bounce off the edges of the screen
    if (x > width-(diameter/2) || x < diameter/2) {
      speedX  = speedX * -1;
    }
    if (y > height-(diameter/2) || y < diameter/2) {
      speedY = speedY * -1;
    }
  }

  // to return x-coordinate of the asteroid
  float x() {
    return x;
  }

  // to return y-coordinate of the asteroid
  float y() {
    return y;
  }

  /*This is the collision detection on an astroid. 
   If the distance (d) is shorter than its diameter, it returns true.
   This will be a boolean value for asteroidShot() method in the main.
   The Laser class is passing through argument to call its x and y location.*/

  boolean collision(Laser lzr) {
    float d = dist(x, y, lzr.location.x, lzr.location.y);
    if (d < diameter) {
      return true;
    } else { 
      return false;
    }
  }

  // if it returns true, 
  // it means the smaller asteroid will disappear from the screen on shot.
  // This will be a boolean for asteroidShot() method in the main

  boolean diameter() {
    if (diameter == smallAsteroid) {
      return true;
    } else {
      return false;
    }
  }
}
