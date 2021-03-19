public final class Weapon{
  String name;
  String description;
  boolean isPhysical;
  float damage;
  float abilityRef; //If spellbook
  PImage caveView;
  PImage inventoryView;
  PVector position;
  public Weapon(){
  }
  public Weapon(String name, String description, boolean isPhysical, float damage, float abilityRef, PImage caveView, PImage inventoryView){
    this.name = name;
    this.description = description;
    this.isPhysical = isPhysical;
    this.damage = damage;
    this.abilityRef = abilityRef;
    this.caveView = caveView;
    this.inventoryView = inventoryView;
  }
  public void copyWeapon(Weapon weapon){
    this.name = weapon.name;
    this.description = weapon.description;
    this.isPhysical = weapon.isPhysical;
    this.damage = weapon.damage;
    this.abilityRef = weapon.abilityRef;
    this.caveView = weapon.caveView;
    this.inventoryView = weapon.inventoryView;
    this.position = weapon.position;
  }
  
} 
