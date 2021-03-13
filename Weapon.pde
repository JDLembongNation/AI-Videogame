public final class Weapon{
  String name;
  String description;
  boolean isPhysical;
  float damage;
  float recoil; //If wielding weapon inflicts damage on user.
  PImage caveView;
  PImage inventoryView;
  
  public Weapon(String name, String description, boolean isPhysical, float damage, float recoil, PImage caveView, PImage inventoryView){
    this.name = name;
    this.description = description;
    this.isPhysical = isPhysical;
    this.damage = damage;
    this.recoil = recoil;
    this.caveView = caveView;
    this.inventoryView = inventoryView;
  }
} 
