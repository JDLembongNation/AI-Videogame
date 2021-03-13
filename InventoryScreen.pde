final int WIDTH_SIZE_SLOT = 113;
final int HEIGHT_SIZE_SLOT = 113;
public final class InventoryScreen{
  //ORigin https://www.deviantart.com/bizmasterstudios
  Slot[][] imageSlots;
  ArrayList<Item> items;
  ArrayList<Weapon> weapons;
  PImage backgroundImage;
  public InventoryScreen(PImage backgroundImage){
    imageSlots = new Slot[5][3]; //x, y Usually otherway round, but program this way to visualise easier.
    this.backgroundImage = backgroundImage;
    for(int i=0; i < imageSlots.length; i++){
      for(int j = 0; j < imageSlots[0].length; j++){
       imageSlots[i][j] = new Slot();
       imageSlots[i][j].x = (91+(i * 176));
       imageSlots[i][j].y = 505 + (j * 149);
      }
    }
  }
  
  private class Slot{
    boolean isTaken;
    Item item;
    Weapon weapon;
    int x;
    int y;
  }
  
  
  
  public void showInventory(){
    image(backgroundImage,0,0);
    for(int i=0; i < imageSlots.length; i++){
      for(int j = 0; j < imageSlots[0].length; j++){
        if(imageSlots[i][j].isTaken){
          if(imageSlots[i][j].item!=null)image(imageSlots[i][j].item.inventoryView, imageSlots[i][j].x, imageSlots[i][j].y);
          else image(imageSlots[i][j].weapon.inventoryView, imageSlots[i][j].x, imageSlots[i][j].y);
        }
      }
    }
  }
  
  public void addItem(Item item){
    for(int i=0; i < imageSlots.length; i++){
      for(int j = 0; j < imageSlots[0].length; j++){
         if(!imageSlots[i][j].isTaken){
           imageSlots[i][j].isTaken = true;
           imageSlots[i][j].item = item;
           return;
         }
      }
    }
  }
  public void addWeapon(Weapon weapon){
     for(int i=0; i < imageSlots.length; i++){
      for(int j = 0; j < imageSlots[0].length; j++){
         if(!imageSlots[i][j].isTaken){
           imageSlots[i][j].weapon = weapon;
         }
      }
    }
  }
  
}
