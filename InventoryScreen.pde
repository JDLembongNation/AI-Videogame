public final class InventoryScreen{
  //ORigin https://www.deviantart.com/bizmasterstudios
  boolean [][] imageSlots;
  ArrayList<Item> items;
  ArrayList<Weapon> weapons;
  PImage backgroundImage;
  public InventoryScreen(PImage backgroundImage){
    imageSlots = new boolean[5][3]; //x, y Usually otherway round, but program this way to visualise easier.
    this.backgroundImage = backgroundImage;
  }
  public void showInventory(){
    image(backgroundImage,0,0);
  }
  
  public void addItem(Item item){
    for(int i=0; i < imageSlots.length; i++){
      for(int j = 0; j < imageSlots[0].length; j++){
        if(!imageSlots[i][j]) {
           imageSlots[i][j] = true;
        }
      }
    }
  }
  public void addWeapon(Weapon weapon){
  
  }
  
}
