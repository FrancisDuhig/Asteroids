class Laser {

  // declare PVector varianbles for laser's x and y positions
  // & to speed along the y-axis and x-axis
  PVector location; 
  PVector velocity; 
  PVector direction;

  Laser() {
    // initialise PVector variables
    direction = new PVector (0, 0);
    location = new PVector(ship.location.x, ship.location.y);
    velocity = new PVector(ship.direction.x, ship.direction.y);
    velocity.setMag(5);
  }

  void draw() {
    pushMatrix(); //starts new environment
    // uses ships location.x and .y to fire laser from.
    translate (location.x, location.y);
    stroke(204, 102, 0); // set laser colour
    ellipse(0, 0, 5, 5); // to draw lazer into the screen 
    popMatrix(); //ends environment
    location.add(velocity); //velocity of laser
  }
}
