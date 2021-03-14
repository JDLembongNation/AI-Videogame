final float MAX_SPEED = 10f;


public final class Player {
   ArrayList<Item> inventory;
   ArrayList<Ability> abilities;
   float health; 
   float armor;
   float attackPower; //ATK in Pokemon equivalent
   float speed;
   float dodgeRate;
   float spellPower;  //Sp ATK in Pokemon equivalent.
  PVector position;
  PVector velocity;
  float orientation;
  int level;
  int exp;
  int expNeeded;
  PVector startingPosition;
  int gold;
  
  public Player(int x, int y, float orientation) {
    this.startingPosition = new PVector(x,y);
    this.position = new PVector(x,y);
    this.orientation = orientation;
    velocity = new PVector(0,0);
    this.level = 1;
    this.exp = 0;
    this.expNeeded = 10;
    this.speed = 40;
    this.dodgeRate = 0.5;
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
    if(orientation > PI) orientation -=2*PI;
    else if(orientation < -PI) orientation +=2*PI;
  }
  
  public void addExp(){
    if(exp > expNeeded){
      level++;
      expNeeded += level * 10;
      attackPower++;
      spellPower++;
      dodgeRate++;
      speed++;
    }
    
  }
  
  public void addAbilities(ArrayList<Ability> abilities ){
    this.abilities = abilities;
  }
  
}
