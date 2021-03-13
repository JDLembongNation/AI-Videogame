final String PLAYER_TURN = "It's your turn!";
public final class BattleSimulator{

  public BattleSimulator(Player player, Enemy enemy){ //Can have capacity for multi-enemy.
    executeGameTurn(player, enemy);   
  }
  
  //REWRITE THIS. I DONT LIKE THE GAME TURN. PLAN FIRST.
  public void executeGameTurn(Player player,Enemy enemy){
    Ability abilityInPlay = null;
    if(player.speed > enemy.speed){
      abilityInPlay = makeChoice();
      if(abilityInPlay == null){
        if(canRun(player, enemy)){
          String res = "You fled from the battle...";
          return;
        }
      }//Choice made for run.
    }else{
      abilityInPlay = enemy.nextMove(player);
      if(didLandHit(abilityInPlay, player.dodgeRate)){
        
      }
      makeChoice();
    }
  }
  
  private Ability makeChoice(){
    boolean chosen = false;
    while(!chosen){
      //Display Options
      //Keypressd toggle
      
    }
    return new Ability();
  }
  //Can toggle if too small of a chance. 
  private boolean canRun(Player player, Enemy enemy){
    float option = random(0,player.speed);
    float enemyChance = random(0, enemy.speed);
    return (option > enemyChance);
  }
  
  
  
  private boolean didLandHit(Ability ability, float dodgeRate){
      float generated = random(0,1);
      if(ability.neverMiss) return true;
      else return generated > dodgeRate;
  }
}
