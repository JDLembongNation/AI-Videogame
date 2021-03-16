final String PLAYER_TURN = "It's your turn!";
public final class BattleSimulator {
  Ability abilityInPlay;
  private boolean isPlayerOneTurn;
  boolean isPlayerOneGoFirst;
  int delay = -1;
  boolean[] keys;
  boolean displayTime;
  boolean chosen;
  boolean alreadyHit;
  boolean isFinished;
  boolean isFleeSuccess;
  boolean playerFaint;
  boolean isDone;
  boolean enemyFaint;
  boolean isStart;
  boolean enemyAlreadyHit;
  Player player;
  Enemy enemy;
  String choice = "Choose an Action!";
  String optionA ="";
  String optionB = "";
  String optionC ="";
  String optionD = "";
  String optionE = "";
  String BattleText1 = "";
  String BattleText2= "";
  String BattleText3="";
  //Define all text icons here.


  public BattleSimulator() { //Can have capacity for multi-enemy.
  }

  public void reset() {
    alreadyHit = false;
    enemyAlreadyHit = false;
    displayTime = false;
    isStart = false;
    chosen = false;
    isFinished = false;
    isDone = false;
    isFleeSuccess = false;
    playerFaint = false;
    enemyFaint = false;
    abilityInPlay = null;
    choice = "Choose an Action!";
    optionA ="";
    optionB = "";
    optionC ="";
    optionD = "";
    optionE = "";
    BattleText1 = "";
    BattleText2= "";
    BattleText3="";
  }

  //Should have a press M to begin battle. 
  public void run(Player player, Enemy enemy, boolean[] keys) {
    this.keys = keys;
    background(0);
    fill(255);
    if (keys[6])isStart = true;
    if (isStart) {
      if (!isDone) {
        executeGameTurn(player, enemy);
      } else {
        
          BattleText3 = "Press P to continue";
          if (keys[5] && waitSecond(1)) isFinished = true;
      }
    } else {
      optionA = "Press m to start battle.";
      isPlayerOneGoFirst = player.speed > enemy.speed;
      isPlayerOneTurn = isPlayerOneGoFirst;
    }
    textSize(30);
    text(choice, 250, 50);
    text(optionA, 250, 150);
    text(optionB, 250, 250);
    text(optionC, 250, 350);
    text(optionD, 250, 450);
    text(optionE, 250, 550);
    text(BattleText1, 250, 700);
    text(BattleText2, 250, 800);
    text(BattleText3, 250, 900);
  }

  public void executeGameTurn(Player player, Enemy enemy) {
    if (isPlayerOneTurn && !alreadyHit) {    
      resetText();
      BattleText1 = "Your Turn!";
      BattleText2 = "";
      if (!chosen) {
        playerTurn(player);
      } else {
        if (isFleeSuccess) isFinished = true;
        if (abilityInPlay!=null) {
          //Ability has been chosen. 
          if (didLandHit(abilityInPlay, enemy.dodgeRate)) {
            BattleText2 = "The Ability Hit the Enemy!";
            float dmg  = calculateDamage(player, enemy, abilityInPlay, isPlayerOneTurn);
            BattleText3 = "" + dmg +" was dealt to the enemy!" ;
          } else {
            BattleText1 = "You missed!";
          }
          alreadyHit = !alreadyHit;
          delay = millis();
        }
        didSomeoneDie(player, enemy);
        if (enemyFaint) {
          displayEnd();
        }
      }
      //UNDEFINED BEHAVIOUR HERE. TAKE A LOOK
    } else if (!isPlayerOneTurn && !enemyAlreadyHit) {
      if (!displayTime) {
        enemyTurn(player, enemy);
        didSomeoneDie(player, enemy);
        displayTime = true;
        enemyAlreadyHit = true;
        delay = millis();
        if (playerFaint){
          displayPlayerEnd();
        }
      }
    }
    if (waitSecond(3) && alreadyHit) { //Delay for a few seconds to display ENemy Move
      isPlayerOneTurn = false;
      alreadyHit = false;
      delay = millis();
      chosen = false;
    }
    if(waitSecond(3) && enemyAlreadyHit){
      isPlayerOneTurn = true;
      enemyAlreadyHit = false;
    }
  }
  void playerTurn(Player player) {
    optionA = "A) " + player.abilities.get(0).name;
    optionB = "B) " + player.abilities.get(1).name;
    optionC = "C) " + player.abilities.get(2).name;
    optionD = "D) Run!"; 
    if (keys[0]) {
      abilityInPlay = player.abilities.get(0);
      chosen = true;
    }
    if (keys[1]) {
      chosen = true;
    }
    if (keys[2]) {
      chosen = true;
    }
    if (keys[3]) {
      chosen = true;
      isFleeSuccess = true;
    }
  }
  private void enemyTurn(Player player, Enemy enemy) {
    BattleText1 = "Enemy Turn!";
    Ability abilityInPlay = enemy.nextMove(player);
    if (didLandHit(abilityInPlay, player.dodgeRate)) {
      float dmg = calculateDamage(player, enemy, abilityInPlay, isPlayerOneTurn);
      BattleText2 = dmg + " was dealt to you!";
    }
  }

  //Can toggle if too small of a chance. 
  private boolean canRun(Player player, Enemy enemy) {
    //float option = random(0,player.speed);
    //float enemyChance = random(0, enemy.speed);
    // return (option > enemyChance);
    return true;
  }

  private void didSomeoneDie(Player player, Enemy enemy) {
    if (player.health <= 0) playerFaint = true;
    if (enemy.health <= 0) enemyFaint = true;
  }

  private float calculateDamage(Player player, Enemy enemy, Ability ability, boolean isPlayerOneTurn) {
    if (isPlayerOneTurn) {
      enemy.health -= ability.damage;
    } else {
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

  private boolean waitSecond(int x) {
    return(delay+(x*1000) < millis());
  }

  private void displayEnd() {
    BattleText1 = "The Enemy Fainted! ";
    BattleText2 = "You WIN!";
    isDone = true;
    delay = millis();
  }
  
  private void displayPlayerEnd(){
    BattleText1 = "You Fainted!";
    BattleText2 = "You LOSE!";
    isDone = true;
    delay = millis();
  }

  private void resetText() {
    BattleText1 = "";
    BattleText2 = "";  
    BattleText3 = "";
  }
}
