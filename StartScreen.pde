import ddf.minim.*;
public final class StartScreen {
  boolean isHelp;
  PImage titleImage;
  PImage buttonStart;
  PImage buttonControls;
  PImage buttonBack;
  AudioPlayer player;
  boolean optionsChosen = false;

  public StartScreen(AudioPlayer player, PImage titleImage, PImage buttonStart, PImage buttonControls, PImage buttonBack) {
    this.player = player;
    this.titleImage = titleImage;
    this.buttonControls = buttonControls;
    this.buttonStart = buttonStart;
    this.buttonBack = buttonBack;
    isHelp = false;
  }
  public void generateStartScreen() {
    player.play();
    if (player.position()>=player.length()) {
      player.rewind();
    }
    image(titleImage, 0, 0);
    if (!isHelp) {
      displayMainMenu();
    } else {
      displayControls();
    }
  }

  public boolean mouseParams(int xMin, int xMax, int yMin, int yMax) {
    return (mouseX >= xMin && mouseX <= xMax && mouseY >= yMin && mouseY <= yMax);
  }

  private String getControls() {
    StringBuilder controlString = new StringBuilder(); //Since Strings are immutable, easier to digest in this form. Instead of appending many strings together.
    controlString.append("How to play the game. \n");
    controlString.append("Use w and s to move forwards and backwards.\n");
    controlString.append("Use a and d to rotate the character.\n");
    controlString.append("Collect items around the map to help you with your adventures.\n");
    controlString.append("Fight monsters that stop you in your path!\n");
    controlString.append("Choose moves in your battle through your keyboard \n");
    controlString.append("Equip weapons to get stronger.\n");
    controlString.append("Spellbooks can be acquired, but only one spell can be learnt at anytime.\n");
    controlString.append("View your stats and inventory by pressing the i key \n");
    controlString.append("Your goal is to reach the hole in every map to descend further into the cave. \n");
    controlString.append("Descend as far as you possibly can.");
    return controlString.toString();
  }

  public boolean pressButton() {
    if (!isHelp && mouseParams(300, 450, 700, 750)) {
          player.pause();
      return true;
    }
    if (!isHelp && mouseParams(600, 750, 700, 750)) {
      isHelp = true;
      return false;
    }
    if (isHelp && mouseParams(425, 575, 700, 750)) {
      isHelp = false;
      return false;
    }
    return false;
  }
  public void displayMainMenu() {
    image(buttonStart, 300, 700);
    image(buttonControls, 600, 700);
  }
  public void displayControls() {
    textSize(20);
    fill(255);
    text(getControls(), 200, 250);
    image(buttonBack, 425, 700);
  }

  //is start buttom
  //help button
}
