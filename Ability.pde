public final class Ability{
  private String name;
  private String description;
  private float damage;
  private boolean isPhysical;
  private int type; //Can be taken out if there is no time to implement this.
  public Ability(String name, String description, float damage, boolean isPhysical){
    this.name = name;
    this.description = description;
    this.damage = damage;
    this.isPhysical = isPhysical;
  }
}
