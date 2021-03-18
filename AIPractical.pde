final int PLAY_WIDTH = 1000;
final int PLAY_HEIGHT = 1000;
final int NODE_SIZE = 20;
final String INTRO_TEXT = "Let the Battle Commence!";
final int NO_ITEMS = 2;
final int NO_WEAPONS = 5;

PImage[] images;
BattleSimulator bs;
boolean inBattle = false;
PVector end;
boolean[] keys = {false, false, false, false, false};
boolean[] battleKeys = {false, false, false, false, false, false, false};
ArrayList<Ability> abilityList;
GroundNode[][] currentMap;
ArrayList<Item> itemDictionary; //Shows every kind of item available to use.
ArrayList<Item> items; //shows the items available on the map.
ArrayList<Weapon> weaponDictionary;
ArrayList<Weapon> weapons;
ArrayList<Enemy> enemies;
int currentEnemy;
int level;
Map map;
Player player;
InventoryScreen inventory;
void setup() {
  size(1000, 1000);
  abilityList = new ArrayList<Ability>();
  map = new Map(PLAY_WIDTH, PLAY_HEIGHT, NODE_SIZE);
  level = 1;
  map.generateNewCave();
  enemies = map.generateEnemies(level);
  player = new Player(100, 100, 0);
  images = new PImage[23];
  readInContent();


  bs = new BattleSimulator();
  bs.reset();
}

void draw() {
  if (inBattle) {
    battleGUI();
  } else { 
    caveGUI();
    if (keys[4]) inventory.showInventory(player);
  }
}


void caveGUI() {
  background(255);
  drawMap();
  drawCharacters();
  drawItemsWeapons();
  move();
  enemyMove();
  collisionCheck();
}

void battleGUI() {
  bs.run(player, enemies.get(currentEnemy), battleKeys);
  if (bs.isFinished) {
    for(int i = 0; i < battleKeys.length; i++){
      battleKeys[i] = false; //ISSUE WITH THE KEYRELEASED. KEYRELEASED NOT BEING CALLED IN FUNCTION.
    }
    if (bs.enemyFaint) {
      bs.reset();
      enemies.remove(currentEnemy);
    } else {
      bs.reset();
      player.position = player.startingPosition.copy();
    }
    inBattle = false;
    bs.isFinished = false;
    for(int i = 0; i < keys.length; i++){
      keys[i] = false; //Prevent any unwanted movement.
    }
  }
}

void drawMap() {
  currentMap = map.getMap();
  for (int i = 0; i < currentMap.length; i++) {
    for (int j = 0; j < currentMap[i].length; j++) {
      if (!currentMap[i][j].isWalkable) {
        fill(20);
        rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
      }else if (currentMap[i][j].isStartingPosition) {
        fill(50, 50, 190);
        rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
        player.startingPosition = new PVector(i*20, j*20);
      }else if (currentMap[i][j].isEndPosition) {
        fill(180, 50, 190);
        image(images[22], i*20, j*20);
        //rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
        end = new PVector(i*20, j*20);
      }else{
        image(images[19], i*20, j*20);
      }
      /*
      if(currentMap[i][j].debug){
        fill(240, 24, 25);
        rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
      }if(currentMap[i][j].bigDebug){
        fill(240, 240, 25);
        rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
      }
      if(currentMap[i][j].posChild){
        fill(25, 240, 240);
        rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
      }
            if(currentMap[i][j].posParent){
        fill(240, 25, 240);
        rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
      }
      */
    }
  }
}

void drawCharacters() {
  fill(180, 20, 20);
  ellipse(player.position.x, player.position.y, 30, 30);
  int newxe = (int)(player.position.x + 10 * cos(player.orientation));
  int newye = (int)(player.position.y + 10 * sin(player.orientation));
  fill(0);
  ellipse(newxe, newye, 10, 10);

  for (Enemy e : enemies) {
    fill(20, 180, 20);

    ellipse(e.position.x, e.position.y, 30, 30);
    int enemyX = (int)(e.position.x + 10 * cos(e.orientation));
    int enemyY = (int)(e.position.y + 10 * sin(e.orientation));
    fill(0);
    ellipse(enemyX, enemyY, 10, 10);
  }
}

void collisionCheck() {
  for (int i = 0; i < enemies.size(); i++) {
    PVector currentPos = player.position.copy();
    currentPos.sub(enemies.get(i).position);
    if (currentPos.mag() < 20) {
      inBattle = true;
      currentEnemy = i;
      break;
    }
  }
  PVector currentPos = player.position.copy();
  currentPos.sub(end);
  if (currentPos.mag() < 20) { //EXTREMELY DODGY FIX SOON PLEASE.
    resetMap();
  }
  // == FOR EDGE OF SCREEN == 
  if (player.position.x < 15) player.position.x=15;
  if (player.position.x > width-15) player.position.x = width-15;
  if (player.position.y > height-15) player.position.y = height-15;
  if (player.position.y < 15) player.position.y = 15;
  // == FOR WALL ==
  int positionX = (int) player.position.x;
  int positionY = (int) player.position.y;
  if (positionX%20 < 10) { 
    positionX -= positionX%20;
  } else {
    positionX += (20-positionX%20);
  }
  if (positionY%20 < 10) { 
    positionY -=positionY%20;
  } else {
    positionY +=(20-positionY%20);
  } 
   // == FOR WALLS == 
   int i = positionX/20;
   int j = positionY/20;
   if(i-2 >= 0){ //If this condition is not satisfied, then the wall boundary will take care of it.
   if(!(currentMap[i-2][j].isWalkable)){
   if(player.position.x < ((i-2)*20) + 35) player.position.x =((i-2)*20) + 35;
   }
   }
   if(j-2 >= 0){ //If this condition is not satisfied, then the wall boundary will take care of it.
   if(!(currentMap[i][j-2].isWalkable)){
   if(player.position.y < ((j-2)*20) + 35) player.position.y = ((j-2)*20) + 35;
   }
   }
   
   if(j+1 < 49){ //If this condition is not satisfied, then the wall boundary will take care of it.
   if(!(currentMap[i][j+1].isWalkable)){
   if(player.position.y > ((j+1)*20) -15) player.position.y = ((j+1)*20) -15;
   }
   }
   if(i+1 < 49){ //If this condition is not satisfied, then the wall boundary will take care of it.
   if(!(currentMap[i+1][j].isWalkable)){ 
   if(player.position.x > ((i+1)*20) - 15) player.position.x = ((i+1)*20) - 15;
   }
   }
   
  // == FOR ITEMS ==
  int remove = -1;
  for (int w = 0; w < items.size(); w++) {
    PVector currPos = player.position.copy();
    currPos.sub(items.get(w).position);
    if (currPos.mag() < 30) {
      if (items.get(w).isTreasure) {
        player.gold += items.get(w).value;
        System.out.println("TOTAL GOLD " + player.gold);
        items.remove(w);
        break;
      } else {
        inventory.addItem(items.get(w));  
        items.remove(w);
        break;
      }
    }
  }

  // == FOR WEAPONS == 
  remove = -1;
  for (int w = 0; w < weapons.size(); w++) {
    PVector currPos = player.position.copy();
    currPos.sub(weapons.get(w).position);
    if (currPos.mag() < 15) {
      inventory.addWeapon(weapons.get(w));    
      remove = w;
      break;
    }
  }
  if (remove != -1) weapons.remove(remove);
}

void resetMap() {
  map.generateNewCave();
  level++;
  enemies = map.generateEnemies(level);
  items = map.generateItems(itemDictionary);
  weapons = map.generateWeapons(weaponDictionary);
  for (Enemy e : enemies) {
    e.setAbilities(abilityList);
  }
  drawMap();
  player.position = player.startingPosition.copy();
}


void drawItemsWeapons() {
  for (Item it : items) {
    image(it.caveView, it.position.x, it.position.y);
  }
  for (Weapon w : weapons) {
    image(w.caveView, w.position.x, w.position.y);
  }
}

void move() {
  if (keys[0] && keys[2]) player.integrate(1, 0.02);
  if (keys[0] && keys[3]) player.integrate(1, -0.02);
  if (keys[1] && keys[2])player.integrate(-1, 0.02);
  if (keys[1] && keys[3])player.integrate(-1, -0.02);
  if (keys[0]) player.integrate(2, 0);
  if (keys[1]) player.integrate(-2, 0);
  if (keys[2]) player.integrate(0, 0.08);
  if (keys[3]) player.integrate(0, -0.08);
}

void enemyMove() {
  for (Enemy e : enemies) {
    e.integrate(player.position.copy());
  }
}


void keyPressed()
{

  if (!inBattle) {
    if (key=='w') {
      keys[0]=true;
    }
    if (key=='s')
      keys[1]=true;
    if (key=='d')
      keys[2]=true;
    if (key=='a')
      keys[3]=true;
    if (key == 'i') {
      keys[4] = !keys[4];   
      delay(50);
    }
  } else {
    if (key == 'a') {
      battleKeys[0] = true;
    }
    if (key == 'b') {
      battleKeys[1] = true;
    }
    if (key == 'c') {
      battleKeys[2] = true;
    }
    if (key == 'd') {
      battleKeys[3] = true;
    }
    if (key == 'e') {
      battleKeys[4] = true;
    }
    if (key == 'p') {
      battleKeys[5] = true;
    }
    if (key == 'm') {
      battleKeys[6] = true;
    }
  }
}

void keyReleased()
{
  if (!inBattle) {
    if (key=='w')
      keys[0]=false;
    if (key=='s')
      keys[1]=false;
    if (key=='d')
      keys[2]=false;
    if (key=='a')
      keys[3]=false;
  } else {
    if (key == 'a') {
      battleKeys[0] = false;
    }
    if (key == 'b') {
      battleKeys[1] = false;
    }
    if (key == 'c') {
      battleKeys[2] = false;
    }
    if (key == 'd') {
      battleKeys[3] = false;
    }
    if (key == 'e') {
      battleKeys[4] = false;
    }
    if (key == 'p') {
      System.out.println("SET TO FALSE");
      battleKeys[5] = false;
    }
    if (key == 'm') {
      battleKeys[6] = false;
    }
  }
} 


void readInContent() {
  images[0] = loadImage("./Content/Inventory.png");
  images[1] = loadImage("./Content/inventory-icons/stat-potion.png");
  images[2] = loadImage("./Content/inventory-icons/health-potion.png");
  images[3] = loadImage("./Content/inventory-icons/spells.png");
  images[4] = loadImage("./Content/inventory-icons/armor.png");
  images[5] = loadImage("./Content/inventory-icons/dirk.png"); //increases stat point in a certain category.
  images[6] = loadImage("./Content/inventory-icons/bow.png");
  images[7] = loadImage("./Content/inventory-icons/spear.png");
  images[8] = loadImage("./Content/inventory-icons/paddle.png");
  images[9] = loadImage("./Content/cave-icons/stat-potion.png");
  images[10] = loadImage("./Content/cave-icons/health-potion.png");
  images[11] = loadImage("./Content/cave-icons/spells.png");
  images[12] = loadImage("./Content/cave-icons/armor.png");
  images[13] = loadImage("./Content/cave-icons/dirk.png");
  images[14] = loadImage("./Content/cave-icons/bow.png");
  images[15] = loadImage("./Content/cave-icons/spear.png");
  images[16] = loadImage("./Content/cave-icons/paddle.png");
  images[17] = loadImage("./Content/inventory-icons/treasure.png");
  images[18] = loadImage("./Content/cave-icons/treasure.png");
  images[19] = loadImage("./Content/cave-icons/walkable.png");
  images[20] = loadImage("./Content/cave-icons/wall-horizontal.png");
  images[21] = loadImage("./Content/cave-icons/wall-vertical.png");
    images[22] = loadImage("./Content/cave-icons/exit.png");


  HashMap<String, Integer> imageInventoryRef = new HashMap<String, Integer>();
  imageInventoryRef.put("stat-potion", 1);
  imageInventoryRef.put("health-potion", 2);
  imageInventoryRef.put("spells", 3);
  imageInventoryRef.put("armor", 4);
  imageInventoryRef.put("dirk", 5);
  imageInventoryRef.put("bow", 6);
  imageInventoryRef.put("spear", 7);
  imageInventoryRef.put("paddle", 8);
  imageInventoryRef.put("treasure", 17);

  HashMap<String, Integer> imageCaveRef = new HashMap<String, Integer>();
  imageCaveRef.put("stat-potion", 9);
  imageCaveRef.put("health-potion", 10);
  imageCaveRef.put("spells", 11);
  imageCaveRef.put("armor", 12);
  imageCaveRef.put("dirk", 13);
  imageCaveRef.put("bow", 14);
  imageCaveRef.put("spear", 15);
  imageCaveRef.put("paddle", 16);
  imageCaveRef.put("treasure", 18);
  inventory = new InventoryScreen(images[0]);
  JSONObject data = loadJSONObject("./Content/content.json");
  JSONArray abilityData = data.getJSONArray("Abilities");
  for (int i = 0; i < abilityData.size(); i++) {
    JSONObject ab = abilityData.getJSONObject(i);
    abilityList.add(new Ability(ab.getString("name"), ab.getString("description"), 
      ab.getFloat("damage"), ab.getBoolean("isPhysical"), ab.getFloat("accuracy"), ab.getBoolean("neverMiss"), 
      ab.getBoolean("isFlee"), ab.getInt("levelObtained"), ab.getBoolean("isSelf"), ab.getBoolean("isDamage"), ab.getBoolean("isDefense")));
  }
  player.addAbilities(abilityList);

  itemDictionary = new ArrayList<Item>();
  JSONArray itemData = data.getJSONArray("Items");
  for (int i = 0; i < itemData.size(); i++) {
    JSONObject it = itemData.getJSONObject(i);
    itemDictionary.add(new Item(it.getBoolean("isConsumable"), it.getBoolean("isStatChanger"),it.getBoolean("isTreasure"), it.getBoolean("isTreasure"), 
      it.getString("name"), it.getString("description"), it.getInt("value"), images[imageCaveRef.get(it.getString("iconName"))], 
      images[imageInventoryRef.get(it.getString("iconName"))]));
  }
  weaponDictionary = new ArrayList<Weapon>();
  JSONArray weaponData = data.getJSONArray("Weapons");
  //(String name, String description, boolean isPhysical, float damage, float recoil)
  for (int i = 0; i < weaponData.size(); i++) {
    JSONObject wp = weaponData.getJSONObject(i);
    weaponDictionary.add(new Weapon(wp.getString("name"), wp.getString("description"), wp.getBoolean("isPhysical"), wp.getFloat("damage"), 
      wp.getFloat("recoil"), images[imageCaveRef.get(wp.getString("iconName"))], images[imageInventoryRef.get(wp.getString("iconName"))]));
  }
  items = map.generateItems(itemDictionary);
  for (Item it : itemDictionary) {
    inventory.addItem(it);
  }
  for (Weapon wp : weaponDictionary) {
    inventory.addWeapon(wp);
  }
  weapons = map.generateWeapons(weaponDictionary);
  for (Enemy e : enemies) {
    e.setAbilities(abilityList);
  }
}
