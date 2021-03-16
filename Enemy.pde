final float ORIENTATION_INCREMENT = PI/16;
public final class Enemy {
  int difficulty;
  boolean isChase = true;
  int health;
  int attackPower;
  int spellPower;
  int dodgeRate;
  PVector position;
  PVector velocity;
  PVector initialPosition;
  float orientation;
  float rotation;
  int rangeWidth;
  int maxHealth;
  int rangeHeight;
  int speed;
  int expProvided;
  int max_speed;
  PVector rangePoint;
  ArrayList<Ability> abilities;
  public Enemy(PVector initialPosition, PVector rangePoint, int rangeWidth, int rangeHeight) {
    this.initialPosition = initialPosition;
    this.position = initialPosition.copy();
    this.dodgeRate = 0;
    this.rangePoint = rangePoint;
    this.rangeWidth = rangeWidth;
    this.rangeHeight = rangeHeight;
    orientation = 0;
    speed = 1;
    max_speed = 3;
    velocity = new PVector(0,0);
    maxHealth = 100;
    health = 100;
    expProvided = 5;
  }
  
  public void setAbilities(ArrayList<Ability> abilities){
    this.abilities = abilities;
  }

  public void integrate(PVector player) {
    if (!isPlayerInRoom(player)) {
      roam();
    }else{
    if (isChase) {
        chase(player);
      //Line Tracing Algorithm. How to avoid walls? once outside of wall territory then dont do anything. Return to normal position.
    }
  }
  }
  public Ability nextMove(Player player) {
    ArrayList<Ability> playerAbilities = player.abilities;
    //Decision Tree. 
    boolean lowHealth = (health/maxHealth < 0.3);
    boolean isPlayerLowHealth = (player.health / player.)
    if(lowHealth) {
      return findBestAttackMove();
      //Low Health
    }else{
      //High Health
      if(random(0,1) < 0.4){
        return findBestAttackMove();
        //Attack
      }else{
         if(random(0,1) < 0.5){
           return findBestStatChange(true);
         }else{
           return findBestStatChange(false);
         }
      }
    }
      //
  }
  
  private Ability findBestStatChange(boolean isSelf){
    return abilities.get(0);
  }
  
  private Ability findBestAttackMove(){
    return abilities.get(0);
  }
  

  private boolean isPlayerInRoom(PVector player) {
    return (player.x > rangePoint.x && player.x < (rangePoint.x + rangeWidth) && player.y > rangePoint.y && player.y < (rangePoint.y + rangeHeight));
  }

  //The finite state machine conducted by the enemy
  //PLEASE CHANGE THE CODE.
  private void roam() {
    int direction = (int) random(0, 4);
    switch(direction) {
    case 0: 
      for (int i = 0; i < random(0, 10); i++) {
        if (position.y > rangePoint.y+35 && position.y < rangePoint.y + rangeHeight-20) position.y -=1;
      }
      break;
    case 1: 
      for (int i = 0; i < random(0, 10); i++) {
        if (position.x > rangePoint.x + 35 && position.x < rangePoint.x + rangeWidth-20) position.x +=1;
      }
      break;
    case 2: 
      for (int i = 0; i < random(0, 10); i++) {
        if (position.y > rangePoint.y+35 && position.y < rangePoint.y + rangeHeight-20) position.y +=1;
      }
      break;
    case 3: 
      for (int i = 0; i < random(0, 10); i++) {
        if (position.x > rangePoint.x + 35 && position.x < rangePoint.x + rangeWidth-20) position.x -=1;
      }
      break;
    }
  }

  private void chase(PVector player) {
    PVector direction =  new PVector();
    direction.x = player.x - position.x;
    direction.y = player.y - position.y;
    direction.normalize();
    direction.mult(speed);
    velocity.add(direction);
    if(velocity.mag() > max_speed){
      velocity.normalize();
      velocity.mult(max_speed);
    }
    position.add(velocity);
    //Add barriers here if necessary for edges. BUt should not be needed.
    float targetOrientation = atan2(velocity.y, velocity.x);
        // if it's less than me, then how much if up to PI less, decrease otherwise increase
    if (targetOrientation < orientation) {
      if (orientation - targetOrientation < PI) orientation -= ORIENTATION_INCREMENT ;
      else orientation += ORIENTATION_INCREMENT ;
    }
    else {
     if (targetOrientation - orientation < PI) orientation += ORIENTATION_INCREMENT ;
     else orientation -= ORIENTATION_INCREMENT ; 
    }
    
    // Keep in bounds
    if (orientation > PI) orientation -= 2*PI ;
    else if (orientation < -PI) orientation += 2*PI ; 
      
    }

  private void returnToRoom() {
  }  
}
