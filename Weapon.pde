public final class Weapon{
  String name;
  String description;
  boolean isPhysical;
  float damage;
  float abilityRef; //If spellbook
  PImage caveView;
  PImage inventoryView;
  PVector position;
  
  public Weapon(String name, String description, boolean isPhysical, float damage, float abilityRef, PImage caveView, PImage inventoryView){
    this.name = name;
    this.description = description;
    this.isPhysical = isPhysical;
    this.damage = damage;
    this.abilityRef = abilityRef;
    this.caveView = caveView;
    this.inventoryView = inventoryView;
  }
} 
