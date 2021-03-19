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
  String optionADesc = "";
  String optionB = "";
  String optionBDesc = "";

  String optionC ="";
  String optionCDesc = "";

  String optionD = "";
  String optionDDesc = "";

  String optionE = "";
  String optionEDesc = "";

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
    optionADesc ="";
    optionBDesc = "";
    optionCDesc ="";
    optionDDesc = "";
    optionEDesc = "";
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
    textSize(15);

    text(optionADesc, 250, 180);

    text(optionBDesc, 250, 280);

    text(optionCDesc, 250, 380);

    text(optionDDesc, 250, 480);

    text(optionEDesc, 250, 580);
  }

  public void executeGameTurn(Player player, Enemy enemy) {
    if (isPlayerOneTurn && !alreadyHit) {    
      resetText();
      BattleText1 = "Your Turn!";
      BattleText2 = "";
      if (!chosen) {
        playerTurn(player);
      } else {
        if (abilityInPlay!=null) {
          //Ability has been chosen. 
          if (didLandHit(abilityInPlay, enemy.dodgeRate)) {
            float dmg  = calculateDamage(player, enemy, abilityInPlay, isPlayerOneTurn);
            if (dmg!=-1) {
              BattleText1 = "The Ability Hit the Enemy!";
              BattleText2 = "" + dmg +" was dealt to the enemy!" ;
            } else {
              if(abilityInPlay.isFlee){
                isFinished = true;
              }
              if (abilityInPlay.isSelf) {
                if (abilityInPlay.isDefense) {
                  BattleText1 = "Your defense has increased by " + abilityInPlay.damage;
                  BattleText2 = "New defense level: " + player.defense ;
                } else {
                  BattleText1 = "Your attack power has increased by " + abilityInPlay.damage;
                  BattleText2 = "New attack level: " + player.attackPower ;
                }
              } else {
                if (abilityInPlay.isDefense) {
                  BattleText1 = "Enemy defense has decreased by " + abilityInPlay.damage;
                  BattleText2 = "Enemy new defense level: " + enemy.defense ;
                } else {
                  BattleText1 = "Enemy attack power has decreased by " + abilityInPlay.damage;
                  BattleText2 = "Enemy new attack level: " + enemy.attackPower ;
                }
              }
            }
          } else {
            BattleText1 = "You missed!";
          }
          alreadyHit = !alreadyHit;
          delay = millis();
        } else {
          //Attempted to run. 
          if (canRun(player, enemy)) {
            isFinished = true; //Directly finish.
          } else {
            BattleText1 = "Cant Escape!";
            alreadyHit = !alreadyHit;
            delay = millis();
          }
        }
        didSomeoneDie(player, enemy);
        if (enemyFaint) {
          displayEnd(player, enemy);
        }
      }
      //UNDEFINED BEHAVIOUR HERE. TAKE A LOOK
    } else if (!isPlayerOneTurn && !enemyAlreadyHit) {
      enemyTurn(player, enemy);
      didSomeoneDie(player, enemy);
      displayTime = true;
      enemyAlreadyHit = true;
      delay = millis();
      if (playerFaint) {
        displayPlayerEnd();
      }
    }
    if (waitSecond(3) && alreadyHit) { //Delay for a few seconds to display ENemy Move
      abilityInPlay = null;
      isPlayerOneTurn = false;
      alreadyHit = false;
      delay = millis();
      chosen = false;
    }
    if (waitSecond(3) && enemyAlreadyHit) {
      isPlayerOneTurn = true;
      enemyAlreadyHit = false;
    }
  }

  void playerTurn(Player player) {
    if (player.availableAbilities.get(0) != null) {
      optionA = "A) " + player.availableAbilities.get(0).name;
      optionADesc = player.availableAbilities.get(0).description;
    }
    if (player.availableAbilities.get(1) != null) {
      optionB = "B) " + player.availableAbilities.get(1).name;
      optionBDesc = player.availableAbilities.get(1).description;
    }
    if (player.availableAbilities.get(2) != null ) {
      optionC = "C) " + player.availableAbilities.get(2).name;
      optionCDesc =  player.availableAbilities.get(2).description;
    }
    if (player.availableAbilities.get(3) != null) {
      optionD = "D) " + player.availableAbilities.get(3).name;
      optionDDesc = player.availableAbilities.get(3).description;
    }
    optionE = "E) Run!"; 
    optionEDesc = "Run like hell..."; 

    if (keys[0] && player.availableAbilities.get(0) != null) {
      abilityInPlay = player.availableAbilities.get(0);
      chosen = true;
    }
    if (keys[1] && (player.availableAbilities.get(1) != null)) {
      abilityInPlay = player.availableAbilities.get(1);
      chosen = true;
    }
    if (keys[2] && player.availableAbilities.get(2) != null) {
      abilityInPlay = player.availableAbilities.get(2);

      chosen = true;
    }
    if (keys[3] && player.availableAbilities.get(3) != null) {
      abilityInPlay = player.availableAbilities.get(3);
      chosen = true;
    }
    if (keys[4]) {
      //RUN.
      chosen = true;
    }
  }
  private void enemyTurn(Player player, Enemy enemy) {
    BattleText1 = "Enemy Turn!";
    Ability abilityInPlay = enemy.nextMove(player);
    if (didLandHit(abilityInPlay, player.dodgeRate)) {
      float dmg = calculateDamage(player, enemy, abilityInPlay, isPlayerOneTurn);
      if (dmg!=-1) {
        BattleText1 = "Enemy Ability Hit you!";
        BattleText2 = "" + dmg +" was dealt you!" ;
      } else {
        if (abilityInPlay.isSelf) {
          if (abilityInPlay.isDefense) {
            BattleText1 = "Enemy defense has increased by " + abilityInPlay.damage;
            BattleText2 = "Enemy new defense level: " + player.defense ;
          } else {
            BattleText1 = "Enemy attack power has increased by " + abilityInPlay.damage;
            BattleText2 = "Enemy new attack level: " + player.attackPower ;
          }
        } else {
          if (abilityInPlay.isDefense) {
            BattleText1 = "Your defense has decreased by " + abilityInPlay.damage;
            BattleText2 = "Your new defense level: " + enemy.defense ;
          } else {
            BattleText1 = "Your attack power has decreased by " + abilityInPlay.damage;
            BattleText2 = "Your new attack level: " + enemy.attackPower ;
          }
        }
      }
    } else {
      BattleText2 = "The enemy missed their attack!";
    }
  }

  //Can toggle if too small of a chance. 
  private boolean canRun(Player player, Enemy enemy) {
    float option = random(0, player.speed);
    float enemyChance = random(0, enemy.speed);
    return (option < enemyChance);
  }

  private void didSomeoneDie(Player player, Enemy enemy) {
    if (player.health <= 0) playerFaint = true;
    if (enemy.health <= 0) enemyFaint = true;
  }

  private float calculateDamage(Player player, Enemy enemy, Ability ability, boolean isPlayerOneTurn) {
    float damageDealt = 0;
    if (isPlayerOneTurn) {
      if (ability.isDamage) {
        if (!ability.isPhysical) { //Spell Move
          damageDealt = (ability.damage * (1+(player.specialAttack*0.1))) / enemy.specialDefense;
        } else if (player.weapon!=null) {
          damageDealt = (ability.damage * (1+(player.specialAttack*0.1)+(player.weapon.damage/100)))/enemy.defense;
        } else {
          damageDealt = (ability.damage * (1+(player.attackPower*0.1))) / enemy.defense;
        }
        doDamage(player, enemy, damageDealt, isPlayerOneTurn);
      } else {
        //Is Stat Changer
        if (ability.isSelf) {
          if (ability.isDefense) {
            //Increase Defense
            player.defense += ability.damage;
          } else {
            //Increase Damage. Use Spells? Special Attack and Defense?
            player.attackPower += ability.damage;
          }
        } else {
          if (ability.isDefense) {
            //Decrease Enemy Defense
            enemy.defense -= ability.damage;
            if (enemy.defense < 0.25) enemy.defense = 0.25;
          } else {
            //Decrease Enemy Offense
            enemy.attackPower -= ability.damage;
            if (enemy.attackPower < 0.25) enemy.attackPower = 0.25;
          }
        }
        damageDealt = -1; //Identifier for not Attack Move.
      }
    } else {
      if (ability.isDamage) {
        if (!ability.isPhysical) {
          damageDealt = (ability.damage*(1+(enemy.specialAttack*0.1)))/player.specialDefense;
        } else {
          damageDealt = (ability.damage*(1+(enemy.attackPower*0.1)))/player.defense;
        }
        doDamage(player, enemy, damageDealt, isPlayerOneTurn);
      } else {
        //Stat Change
        if (ability.isSelf) {
          if (ability.isDefense) {
            enemy.defense += ability.damage;
          } else {
            enemy.attackPower += ability.damage;
          }
        } else {
          if (ability.isDefense) {
            player.defense -= ability.damage;
            if (player.defense < 0.25) player.defense = 0.25;
          } else {
            player.attackPower -= ability.damage;
            if (player.attackPower < 0.25) player.attackPower = 0.25;
          }
        }
        damageDealt = -1;
      }
    }
    return damageDealt;
  }

  private void doDamage(Player player, Enemy enemy, float damage, boolean isPlayerOneTurn) {
    if (isPlayerOneTurn) {
      //reduce enemy health.
      damage -= enemy.armor;
      enemy.armor = enemy.armor <= 0 ? 0 : enemy.armor;
      enemy.health -= damage;
    } else {
      damage -= player.armor; 
      player.armor = player.armor <= 0 ? 0 : player.armor;
      player.health -= damage;
    }
  }

  private boolean didLandHit(Ability ability, float dodgeRate) {
    float generated = random(0, 1);
    if (ability.neverMiss) return true;
    else return generated > dodgeRate;
  }

  private boolean waitSecond(int x) {
    return(delay+(x*1000) < millis());
  }

  private void displayEnd(Player player, Enemy enemy) {
    BattleText1 = "The Enemy Fainted! ";
    BattleText2 = "You Gained " + enemy.expProvided + " exp points!";
    boolean isLevelUp = player.addExp(enemy.expProvided);
    if (isLevelUp) BattleText2 = "You leveled up to: " + player.level;
    isDone = true;
    delay = millis();
  }

  private void displayPlayerEnd() {
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
