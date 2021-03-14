final String PLAYER_TURN = "It's your turn!";
public final class BattleSimulator {
  Ability abilityInPlay;
  boolean[] keys = {false, false, false, false};
  private boolean isPlayerOneTurn;
  boolean chosen;
  boolean isFinished;
  boolean isFleeSuccess;
  boolean playerFaint;
  boolean isDone;
  boolean enemyFaint;
  Player player;
  Enemy enemy;
  String choice = "Choose an Action!";
  String optionA ="";
  String optionB = "";
  String optionC ="";
  String optionD = "";
  String BattleText1 = "";
  String BattleText2= "";
  String BattleText3="";
  //Define all text icons here.


  public BattleSimulator() { //Can have capacity for multi-enemy.
  }
  
  public void reset(){
    chosen = false;
    isFinished = false;
    isDone = false;
    isFleeSuccess = false;
    playerFaint = false;
    enemyFaint = false;
    abilityInPlay = null;
  }
  
  public void run(Player player, Enemy enemy) {
    background(0);
    fill(255);
    if(!isDone){
    executeGameTurn(player, enemy);
    }else{
      BattleText3 = "Press P to continue";
      if(keyPressed && key=='p')isFinished = true;
    }
    textSize(30);
    text(choice, 250, 50);
    text(optionA, 250, 150);
    text(optionB, 250, 250);
    text(optionC, 250, 350);
    text(optionD, 250, 450);
    text(BattleText1, 250, 600);
    text(BattleText2, 250, 700);
    text(BattleText3, 250, 800);

  }

  public void executeGameTurn(Player player, Enemy enemy) {
    isPlayerOneTurn = player.speed > enemy.speed;
    if (isPlayerOneTurn) {
      if (!chosen){
        playerTurn(player);
      }else{
      if (isFleeSuccess) isFinished = true;
      if (abilityInPlay!=null) {
        //Ability has been chosen. 
      if (didLandHit(abilityInPlay, enemy.dodgeRate)) {
          BattleText1 = "The Ability Hit the Enemy!";
          float dmg  = calculateDamage(player,enemy, abilityInPlay, isPlayerOneTurn);
          BattleText2 = "" + dmg +" was dealt to the enemy!" ;
        }else{
          BattleText1 = "You missed!";
        }
      }
      didSomeoneDie(player,enemy);
      if(enemyFaint){
        BattleText1 = "The Enemy Fainted! ";
        BattleText2 = "You WIN!";
        isDone = true;
        return;
      }
      isPlayerOneTurn = !isPlayerOneTurn;
      enemyTurn(player,enemy);
      isPlayerOneTurn = !isPlayerOneTurn;
      didSomeoneDie(player,enemy);
      if(playerFaint) return;
      //Design CHoice: Player loses turn if cant run away.
      }
    } else {
      enemyTurn(player, enemy);
      //playerTurn(player, enemy);
    }
  }
  void playerTurn(Player player) {
    optionA = "A) " + player.abilities.get(0).name;
    optionB = "B) " + player.abilities.get(1).name;
    optionC = "C) " + player.abilities.get(2).name;
    optionD = "D) Run!"; 
    if (keyPressed) {
      chosen = true;
      switch(key) {
      case 'a': 
        {
          abilityInPlay = player.abilities.get(0);
          break;
        }
      case 'b':
        {
          break;
        }
      case 'c':
        {
          break;
        }
      case 'd':
        {
          isFleeSuccess = true;
          break;
        }
      }
    }
  }
  
  private void enemyTurn(Player player, Enemy enemy) {
    BattleText1 = "Enemy Turn!";
    Ability abilityInPlay = enemy.nextMove(player);
    if (didLandHit(abilityInPlay, player.dodgeRate)) {
      calculateDamage(player, enemy, abilityInPlay, isPlayerOneTurn);
    }
  }

  //Can toggle if too small of a chance. 
  private boolean canRun(Player player, Enemy enemy) {
    //float option = random(0,player.speed);
    //float enemyChance = random(0, enemy.speed);
    // return (option > enemyChance);
    return true;
  }
  
  private void didSomeoneDie(Player player, Enemy enemy){
    if(player.health <= 0) playerFaint = true;
    if(enemy.health <= 0) enemyFaint = true;
  }

  private float calculateDamage(Player player, Enemy enemy, Ability ability, boolean isPlayerOneTurn) {
    if(isPlayerOneTurn){
      enemy.health -= ability.damage;
    }else{
      player.health -= ability.damage;
    }
    return ability.damage;
    
  }

  private boolean didLandHit(Ability ability, float dodgeRate) {
    return true;
    //float generated = random(0, 1);
//if (ability.neverMiss) return true;
    //else return generated > dodgeRate;
  }

}
