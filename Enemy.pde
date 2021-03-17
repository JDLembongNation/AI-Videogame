final float ORIENTATION_INCREMENT = PI/16;
public final class Enemy {
  int direction;
  boolean arrive;
  int difficulty;
  boolean isChase = true;
  int health;
  float attackPower;
  float spellPower;
  float dodgeRate;
  PVector position;
  PVector velocity;
  PVector initialPosition;
  float orientation;
  float defense;
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
    max_speed = 1;
    velocity = new PVector(0, 0);
    maxHealth = 100;
    health = 100;
    expProvided = 10;
    dodgeRate=0.2;
    defense = 1;
    arrive = true;
  }

  public void setAbilities(ArrayList<Ability> abilities) {
    this.abilities = abilities;
  }

  public void integrate(PVector player) {
    if (!isPlayerInRoom(player)) {
      roam();
    } else {
      if (isChase) {
        chase(player);
        //Line Tracing Algorithm. How to avoid walls? once outside of wall territory then dont do anything. Return to normal position.
      }
    }
  }
  public Ability nextMove(Player player) {
    //Decision Tree. 
    boolean lowHealth = (health/maxHealth < 0.3);
    boolean isPlayerLowHealth = (player.health / player.maxHealth < 0.3);
    Ability ability;
    if (lowHealth) {
      ability = findBestAttackMove();
      //Low Health
    } else {
      if (isPlayerLowHealth) {
        ability = findBestAttackMove();
      } else {
        //High Health
        if (random(0, 1) < 0.4) {
          ability = findBestAttackMove();
          //Attack
        } else {
          if (random(0, 1) < 0.5) {
            ability= findBestStatChange(true);
          } else {
            ability = findBestStatChange(false);
          }
        }
      }
    }
    //
    if (ability == null) return abilities.get(0);
    return ability;
  }

  private Ability findBestStatChange(boolean self) {
    Ability current = null;
    for (int i = 0; i < abilities.size(); i++) {
      if (current == null && !abilities.get(i).isDamage && (abilities.get(i).isSelf == self)) {
        current = abilities.get(i);
      }
      if (!abilities.get(i).isDamage &&(abilities.get(i).isSelf == self) &&current!= null&&current.damage < abilities.get(i).damage) {
        current = abilities.get(i);
      }
    }
    return current;
  }

  private Ability findBestAttackMove() {
    Ability current = null;
    for (int i = 0; i < abilities.size(); i++) {
      if (current == null && abilities.get(i).isDamage) current = abilities.get(i);
      else if (abilities.get(i).isDamage && current!=null && current.damage < abilities.get(i).damage) {
        current = abilities.get(i);
      }
    }
    return current;
  }


  private boolean isPlayerInRoom(PVector player) {
    return (player.x > rangePoint.x && player.x < (rangePoint.x + rangeWidth) && player.y > rangePoint.y && player.y < (rangePoint.y + rangeHeight));
  }

  //The finite state machine conducted by the enemy
  //PLEASE CHANGE THE CODE.
  private void roam() {
    if (arrive) {
      direction = (int) random(0, 4);
      arrive = false;
    }
    switch(direction) {
    case 0:  //TOP LEFT.
    goToPosition(new PVector(rangePoint.x, rangePoint.y));
      break;
    case 1: 
    goToPosition(new PVector(rangePoint.x, rangePoint.y + rangeHeight));
      break;
    case 2: 
    goToPosition(new PVector(rangePoint.x + rangeWidth, rangePoint.y));
      break;
    case 3: 
    goToPosition(new PVector(rangePoint.x + rangeWidth, rangePoint.y + rangeHeight));
      break;
    }
  }


  private void goToPosition(PVector targetPosition) {
    targetPosition.sub(position);
    float distance = targetPosition.mag();
    if (distance < 1) {
      arrive = true;
    } else {
      velocity = targetPosition.copy();
      if (distance > max_speed) {
        velocity.normalize();
        velocity.mult(max_speed);
      }
      position.add(velocity);
    }
     float targetOrientation = atan2(velocity.y, velocity.x) ;
    if (targetOrientation < orientation) {
      if (orientation - targetOrientation < PI) orientation -= ORIENTATION_INCREMENT ;
      else orientation += ORIENTATION_INCREMENT ;
    } else {
      if (targetOrientation - orientation < PI) orientation += ORIENTATION_INCREMENT ;
      else orientation -= ORIENTATION_INCREMENT ;
    }

    // Keep in bounds
    if (orientation > PI) orientation -= 2*PI ;
    else if (orientation < -PI) orientation += 2*PI ;
  }

  private void chase(PVector player) {
    PVector direction =  new PVector();
    direction.x = player.x - position.x;
    direction.y = player.y - position.y;
    direction.normalize();
    direction.mult(speed);
    velocity.add(direction);
    if (velocity.mag() > max_speed) {
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
    } else {
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
