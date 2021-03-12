final String PLAYER_TURN = "It's your turn!";
public final class BattleSimulator{
  boolean isPlayerTurn = false;
  public BattleSimulator(Player player, Enemy enemy){ //Can have capacity for multi-enemy.
    if(player.speed > enemy.speed) isPlayerTurn = true;    
  }
  
  //REWRITE THIS. I DONT LIKE THE GAME TURN. PLAN FIRST.
  public void executeGameTurn(){
    Ability abilityInPlay = null;
    if(isPlayerTurn){
      //Display Text and Keypressed stuff.
    }else{
      abilityInPlay = enemy.nextMove(player);
      if(didLandHit(abilityInPlay, player.dodgeRate)){
        
      }
    }
  }
  
  private boolean didLandHit(Ability ability, float dodgeRate){
      float generated = random(0,1);
      if(ability.neverMiss) return true;
      else return generated > dodgeRate;
  }
}
