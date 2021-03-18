import ddf.minim.*;
public final class StartScreen{
  boolean isHelp;
  PImage titleImage;
  PImage buttonStart;
  PImage buttonControls;
  PImage buttonBack;
  AudioPlayer player;
  boolean optionsChosen = false;
  final int FADE = 2500;
  boolean isVolumeOn = true;

  public StartScreen(AudioPlayer player, PImage titleImage, PImage buttonStart, PImage buttonControls, PImage buttonBack){
    this.player = player;
    this.titleImage = titleImage;
    this.buttonControls = buttonControls;
    this.buttonStart = buttonStart;
    this.buttonBack = buttonBack;
    isHelp = false;
  }
  public void generateStartScreen(){
            image(titleImage, 0,0);
    if(!isHelp){
    displayMainMenu();
    }else{
      displayControls();
    }
  }
  
    public boolean mouseParams(int xMin, int xMax, int yMin, int yMax){
    return (mouseX >= xMin && mouseX <= xMax && mouseY >= yMin && mouseY <= yMax);
  }
  
    private String getControls(){
    StringBuilder controlString = new StringBuilder(); //Since Strings are immutable, easier to digest in this form. Instead of appending many strings together.
    controlString.append("How to play the game. \n");
    controlString.append("Use q and e to control the trajectory of the missile. \n");
    controlString.append("Use w and s to control the strength of the missile. \n");
    controlString.append("Use a and d to control the movements of the tank. \n");
    controlString.append("Press f to launch the missle to your enemies once you are ready! \n");
    controlString.append("First to 5 wins. The game is easy, just dont miss.");
    return controlString.toString();
  }
  
  public boolean pressButton(){
    if(!isHelp && mouseParams(300,450,700,750)){
      return true;
    }
    if(!isHelp && mouseParams(600,750,700,750)){
      isHelp = true;
      return false;
    }
    if(isHelp && mouseParams(425, 575, 700, 750)){
      isHelp = false;
      return false;
    }
    return false;
  }
  public void displayMainMenu(){
      image(buttonStart, 300, 700);
      image(buttonControls,600,700);
  }
  public void displayControls(){
    textSize(16);
    fill(255);
    text(getControls(), 300, 250);
    image(buttonBack, 425, 700);
  }
  
  //is start buttom
  //help button
  
}
