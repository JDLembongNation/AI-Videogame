final String PLAYER_TURN = "It's your turn!";
public final class BattleSimulator{
  private boolean isPlayerOneTurn;
  boolean isFleeSuccess;
  
  public BattleSimulator(Player player, Enemy enemy){ //Can have capacity for multi-enemy.
    while(!isFleeSuccess){ //Add conditions for enemy dead or player dead. 
      executeGameTurn(player, enemy);   
    }  
}
  
  public void executeGameTurn(Player player,Enemy enemy){
    isPlayerOneTurn = player.speed > enemy.speed;
    if(isPlayerOneTurn){
      playerTurn(player, enemy);
      if(isFleeSuccess) return;
      enemyTurn(player,enemy);
      //Design CHoice: Player loses turn if cant run away. 
    }else{
      enemyTurn(player,enemy);
      playerTurn(player,enemy);
    }
  }
  
  private Ability makeChoice(Player player){
    boolean chosen = false;
    Ability chosenAbility = null;
    while(!chosen){
      for(int i = 0; i < player.abilities.size(); i++){
        //Display Options
      }
      if(keyPressed){
        switch(key){
         case 'a' :
           chosen = true;
           chosenAbility = new Ability();
           break;
         case 'b' : 
         chosen = true;
           break;
         case 'c' :
         chosen = true;
           break;
         case 'd':
         chosen = true;
           break;
         default: 
         break;
        }
      }
      //Display Options
      //Keypressd toggle  
    }
    if(chosenAbility == null)  return new Ability();
    else return chosenAbility;
  }
  
  
  //Can toggle if too small of a chance. 
  private boolean canRun(Player player, Enemy enemy){
    float option = random(0,player.speed);
    float enemyChance = random(0, enemy.speed);
    return (option > enemyChance);
  }
  
  private void calculateDamage(Player player, Enemy enemy, Ability ability, boolean isPlayerOneTurn){
    isPlayerOneTurn = true;
  }
  
  private boolean didLandHit(Ability ability, float dodgeRate){
      float generated = random(0,1);
      if(ability.neverMiss) return true;
      else return generated > dodgeRate;
  }
  
  private void enemyTurn(Player player, Enemy enemy){
      Ability abilityInPlay = enemy.nextMove(player);
      if(didLandHit(abilityInPlay, player.dodgeRate)){
        calculateDamage(player, enemy, abilityInPlay, isPlayerOneTurn);
      }
  }
  
  private void playerTurn(Player player, Enemy enemy){
      Ability abilityInPlay = makeChoice(player);
      if(abilityInPlay == null){
        if(canRun(player, enemy)){
          String res = "You fled from the battle...";
          isFleeSuccess=true;
          return;
        }else{
          String res = "You couldn't run away!";
          isPlayerOneTurn = !isPlayerOneTurn;
        }
      }
      if(isPlayerOneTurn){ //ask again ebcause will change if player attempts to run
        if(didLandHit(abilityInPlay, enemy.dodgeRate)){
          calculateDamage(player, enemy, abilityInPlay, isPlayerOneTurn);
        }
      } 
  }
}
