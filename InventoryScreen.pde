public final class InventoryScreen{
  //ORigin https://www.deviantart.com/bizmasterstudios
  PImage backgroundImage;
  public InventoryScreen(PImage backgroundImage){
  this.backgroundImage = backgroundImage;
  }
  public void showInventory(){
    image(backgroundImage,0,0);
  }
}
