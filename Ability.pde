public final class Ability{
  private String name;
  private String description;
  private float damage; //if isFlee, then flee chance is calcualted 
  private float accuracy;
  private boolean isPhysical;
  private boolean neverMiss;
  private boolean isFlee;
  private int levelObtained;
  int ref;
  boolean isSelf;
  boolean isDamage;
  boolean isDefense;
  public Ability(){
    name = "peysar";
    description = "Some pey";
    damage = 0;
    isPhysical = true;

  }
  public Ability(String name, String description, float damage, boolean isPhysical, float accuracy, 
  boolean neverMiss, boolean isFlee, int levelObtained, boolean isSelf, boolean isDamage, boolean isDefense, int ref){
    this.name = name;
    this.description = description;
    this.damage = damage;
    this.isPhysical = isPhysical;
    this.accuracy = accuracy;
    this.neverMiss = neverMiss;
    this.isFlee  = isFlee;
    this.levelObtained = levelObtained;
    this.isSelf= isSelf;
    this.isDamage = isDamage;
    this.isDefense = isDefense;
    this.ref = ref; //Will be 0 if physical, any number above 0 if a spell move. 
  }
}
