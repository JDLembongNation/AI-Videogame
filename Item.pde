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
  
  
}
