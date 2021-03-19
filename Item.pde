public final class Item{
   boolean isConsumable;
  private boolean isTreasure;
  private boolean isStatChanger;
  private String name;
   String description;
  private int value;
  PImage caveView; 
  PImage inventoryView;
  PVector position;
  public Item(){
  
  }
  
  public Item(boolean isConsumable, boolean isStatChanger, boolean isTreasure, boolean isPhyiscal, String name, String description, int value, PImage caveView, PImage inventoryView){
    this.isConsumable = isConsumable;
    this.isStatChanger = isStatChanger;
    this.isTreasure = isTreasure;
    this.name = name;
    this.description = description;
    this.value = value;
    this.caveView = caveView;
    this.inventoryView = inventoryView;
  } 
  public void copyItem(Item item){
    this.isConsumable = item.isConsumable;
    this.isTreasure = item.isTreasure;
  this.isStatChanger = item.isStatChanger;
  this.name = item.name;
   this.description = item.description;
  this.value = item.value;
  this.caveView = item.caveView; 
  this.inventoryView = item.inventoryView;
  this.position = item.position;
  }
  
  
}
