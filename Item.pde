public final class Item{
  private boolean isConsumable;
  private boolean isTreasure;
  private boolean isPhysical; //If the item is a weapon, is it a phyiscal or a magical item?
  private String name;
  private String description;
  private int value;
  
  public Item(){
  
  }
  
  public Item(boolean isConsumable, boolean isTreasure, boolean isPhyiscal, String name, String description, int value){
    this.isConsumable = isConsumable;
    this.isTreasure = isTreasure;
    this.isPhysical = isPhyiscal;
    this.name = name;
    this.description = description;
    this.value = value;
  } 
}
