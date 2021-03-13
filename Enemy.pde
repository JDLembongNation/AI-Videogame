public final class Enemy{
   int difficulty;
   boolean isChase;
   int health;
   int attackPower;
   int spellPower;
   int speed;
   int dodgeRate;
  PVector position;
  PVector initialPosition;
  float orientation;
   int rangeWidth;
   int rangeHeight;
  PVector rangePoint;
  public Enemy(PVector initialPosition){
    this.initialPosition = initialPosition;
    this.position = initialPosition;
    orientation = 0;
  }
  
  public void integrate(PVector player){
    if(isChase){
      //Line Tracing Algorithm. How to avoid walls? once outside of wall territory then dont do anything. Return to normal position.
    }else{
      //Dont bother
    }
  }
  public Ability nextMove(Player player){
    return new Ability();
  }
  




}
