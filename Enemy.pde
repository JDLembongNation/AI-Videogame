public final class Enemy{
  private int difficulty;
  private boolean isChase;
  private int health;
  private int attackPower;
  private int spellPower;
  private int speed;
  private int dodgePower;
  PVector position;
  PVector initialPosition;
  float orientation;
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
