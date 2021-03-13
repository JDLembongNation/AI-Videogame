public final class Ability{
  private String name;
  private String description;
  private float damage; //if isFlee, then flee chance is calcualted 
  private boolean isPhysical;
  private boolean neverMiss;
  private boolean isFlee;
  public Ability(){
    name = "peysar";
    description = "Some pey";
    damage = 0;
    isPhysical = true;

  }
  public Ability(String name, String description, float damage, boolean isPhysical){
    this.name = name;
    this.description = description;
    this.damage = damage;
    this.isPhysical = isPhysical;
  }
}
