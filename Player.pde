final float MAX_SPEED = 10f;
final int MAX_MOVES  = 4;
final int MAX_PHYSICAL_MOVES = 3;

public final class Player {
   ArrayList<Item> inventory;
   ArrayList<Ability> abilities;
   ArrayList<Ability> availableAbilities;
   Weapon weapon;
   float health; 
   float armor;
   float maxHealth;
   float attackPower; //ATK in Pokemon equivalent
   float specialAttack;
   float specialDefense; 
   float defense;
   float speed;
   float dodgeRate;
  PVector position;
  PVector velocity;
  float orientation;
  int level;
  int exp;
  int expNeeded;
  PVector startingPosition;
  int gold;
  
  public Player(int x, int y, float orientation) {
    availableAbilities= new ArrayList<Ability>();
    this.startingPosition = new PVector(x,y);
    this.position = new PVector(x,y);
    this.orientation = orientation;
    velocity = new PVector(0,0);
    this.level = 1;
    this.exp = 0;
    this.expNeeded = 10;
    this.speed = 3;
    this.dodgeRate = 0.5;
    this.maxHealth = 500;
    this.health = maxHealth;
    this.defense = 1;
    this.specialAttack = 1;
    this.specialDefense =1;
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
  
  public boolean addExp(int newExp){
    exp +=newExp;
    if(exp >= expNeeded){
      level++;
      expNeeded += level * 10;
      attackPower++;
      specialAttack++;
      dodgeRate+=0.01;
      speed++;
      //MOVE FROM OLD TO NEW MOVES. 
      for(int i = 0; i < abilities.size(); i++){
        if(abilities.get(i).levelObtained == level){ //Add to new arsena
          if(availableAbilities.size() == MAX_MOVES){
            availableAbilities.remove(0);
            availableAbilities.add(abilities.get(i));
          }else{
            availableAbilities.add(abilities.get(i));
          }
        }
      }
      return true;
    }
    return false;
    
  }
  
  public void addAbilities(ArrayList<Ability> abilities ){
    this.abilities = abilities;
    for(Ability a : abilities){
      if(a.levelObtained == level){
        availableAbilities.add(a);
      }
    }
  }
  
  
  
  public void assignWeapon(Weapon weapon){
    this.weapon = weapon;
  }
  
}
