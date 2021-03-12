final float MAX_SPEED = 10f;


public final class Player {
  private ArrayList<Item> inventory;
  private ArrayList<Ability> abilities;
  private float health; 
  private float armor;
  private float attackPower; //ATK in Pokemon equivalent
  private float speed;
  private float dodgeRate;
  private float spellPower;  //Sp ATK in Pokemon equivalent.
  PVector position;
  PVector velocity;
  float orientation;
  
  public Player(int x, int y, float orientation) {
    this.position = new PVector(x,y);
    this.orientation = orientation;
    velocity = new PVector(0,0);
  
}
  
  public void integrate(float force, float targetOrientation){
    //Adjust Orientation
    orientation += targetOrientation;
    velocity.x = cos(orientation);
    velocity.y = sin(orientation);
    //Velocity is already normalized
    velocity.mult(force);
    if(velocity.mag() > MAX_SPEED){
      velocity.normalize();
      velocity.mult(MAX_SPEED);
    }
    position.add(velocity);
  }
}
