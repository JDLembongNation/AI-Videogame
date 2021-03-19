public final class Map {
  int totalRooms = 0; //DEBUG

  GroundNode[][] map;
  BinaryNode tree;
  int treeValue;
  final int maxMinArea = 500000;
  int minArea = 500000;

  public Map(int chosenWidth, int chosenHeight, int nodeSize) {
    int allocatedWidth = chosenWidth/nodeSize;
    int allocatedHeight = chosenHeight/nodeSize;
    this.map = new GroundNode[allocatedWidth][allocatedHeight];
    for (int i = 0; i < allocatedWidth; i++) {
      for (int j = 0; j < allocatedHeight; j++) {
        map[j][i] = new GroundNode((j*nodeSize), (i*nodeSize)); //Insert this way, so [x][y].
      }
    }
  }

  public GroundNode[][] getMap() {
    return map;
  }

 // == METHOD to generate a new cave.
  private void generateNewCave(int level) {
    minArea = maxMinArea-(level*30000);
    if(minArea < 100000) minArea = 100000;
    //Using the BSP Partitioning System. 
    treeValue = 0;
    tree = new BinaryNode(null, 1000, 1000, 0, 0);
    boolean[][] generateMap = new boolean[map.length][map[0].length]; //default is false
    resetTerrain();
    generateMap = allocateSpaces(generateMap, tree);
    generateCharacterStartingPosition(tree);
    for (int i = 0; i < generateMap.length; i++) {
      for (int j = 0; j < generateMap[0].length; j++) {
        map[i][j].isWalkable = generateMap[i][j];
      }
    }
  }
  private class BinaryNode {
    int x;
    int y; //not pvectors as no vector calculations are needed.
    int widthArea;
    int heightArea;
    BinaryNode parent;
    BinaryNode left;
    BinaryNode right;
    public BinaryNode(BinaryNode parent, int widthArea, int heightArea, int x, int y) {
      this.parent = parent;
      this.widthArea = widthArea;
      this.heightArea = heightArea;
      this.x = x;
      this.y = y;
    }
    public int getTotalArea() {
      return widthArea*heightArea;
    }
  }
  
  // == METHOD to implement recursive Binary Split Partitioning Algorithm of the map.
  private boolean[][] allocateSpaces(boolean[][] generatorMap, BinaryNode treeNode) {
    if (treeNode.getTotalArea() < minArea) {
      treeNode.widthArea -=40;
      treeNode.heightArea-=40;
      generatorMap = insertRoom(generatorMap, treeNode);
      return generatorMap;
    } else {
      int randomValue = (int) random(0, 10);
      if (randomValue%2 == 0 && treeNode.widthArea >= 200) { //Split Vertically

        int split = (int) random(treeNode.x+80, treeNode.x+treeNode.widthArea-80);
        int remainder = split%40;
        split-=remainder;
        treeNode.left = new BinaryNode(treeNode, ((split)-treeNode.x), treeNode.heightArea, treeNode.x, treeNode.y);
        allocateSpaces(generatorMap, treeNode.left);
        treeNode.right = new BinaryNode(treeNode, (treeNode.widthArea+treeNode.x-split), treeNode.heightArea, split, treeNode.y);
        allocateSpaces(generatorMap, treeNode.right);
      } else if (treeNode.heightArea>=200) {
        int split = (int) random(treeNode.y+80, treeNode.y+treeNode.heightArea-80);
        int remainder = split%40;
        split-=remainder;
        treeNode.left = new BinaryNode(treeNode, treeNode.widthArea, (split-treeNode.y), treeNode.x, treeNode.y); 
        allocateSpaces(generatorMap, treeNode.left);
        treeNode.right = new BinaryNode(treeNode, treeNode.widthArea, (treeNode.heightArea+treeNode.y-split), treeNode.x, split);
        allocateSpaces(generatorMap, treeNode.right);
        //Split Horizontally
      } else {
        treeNode.widthArea -=40;
        treeNode.heightArea-=40;
        generatorMap = insertRoom(generatorMap, treeNode);
        return generatorMap;
      }

      if (treeNode.left!=null && treeNode.right!=null) { //Is a parent so Attach Corridors here on any length between the two children.
        return addCorridors(generatorMap, treeNode);
      }
      return generatorMap;
    }
  }
  
  // == METHOD to toggle the walkable boolean parameter.
  private boolean[][] insertRoom(boolean[][] room, BinaryNode node) {
    int factoredX = (int) node.x/40;
    int factoredY = (int) node.y/40;
    int factoredWidth = (int) node.widthArea/40;
    int factoredHeight = (int) node.heightArea/40;
    for (int i = factoredX; i < factoredWidth+factoredX; i++) {
      for (int j =factoredY; j < factoredHeight+factoredY; j++) {
        room[i][j] = true;
      }
    }
    return room;
  }
  
  //Right Node will either be always to the right or below the left node. ie. higher height, (cartesian grid)
  //Right Node will either be always to the right or below the left node. ie. higher height, (cartesian grid)
  // == METHOD to line up the rooms together. 
  private boolean[][] addCorridors(boolean[][] room, BinaryNode node) {
    //Reduce scale IF there are children. 
    if (node.left.right!=null && node.left.left!=null) {
      node.left.widthArea -=40;
      node.left.heightArea -=40;
    }
    if (node.right.right!=null && node.right.left!=null) {
      node.right.widthArea -=40;
      node.right.heightArea -=40;
    }

    int factoredLeftX = (int) node.left.x/40;
    int factoredLeftY = (int) node.left.y/40;
    int factoredLeftWidth = (int) node.left.widthArea/40;
    int factoredLeftHeight = (int) node.left.heightArea/40;
    int factoredRightX = (int) node.right.x/40;
    int factoredRightY = (int) node.right.y/40;
    int factoredRightWidth = (int) node.right.widthArea/40;
    int factoredRightHeight = (int) node.right.heightArea/40;
    int factoredLeftHeightTotal = (factoredLeftY+factoredLeftHeight);
    int factoredRightHeightTotal = (factoredRightY+factoredRightHeight);
    int factoredLeftWidthTotal = (factoredLeftX + factoredLeftWidth);
    int factoredRightWidthTotal = (factoredRightX + factoredRightWidth);

    if (factoredLeftX < factoredRightX) { 
      int leftEdge = factoredLeftX + factoredLeftWidth;
      //grab from any height. in range y to y+height
      int toFill = factoredRightX-leftEdge;
      //pick random left to right. 
      int lowerBoundY = (factoredLeftY < factoredRightY) ? factoredRightY : factoredLeftY;
      int upperBoundY = factoredLeftHeightTotal < factoredRightHeightTotal? factoredLeftHeightTotal : factoredRightHeightTotal;
      int chosenPath = (int) random(lowerBoundY, upperBoundY-3);
      for (int j = 0; j < 3; j++) {
        for (int i =leftEdge; i < leftEdge+toFill; i++) {
          room[i][chosenPath+j] = true;
        }
      }
    } else { //Horizontal Cut.
      int leftEdge = factoredLeftY + factoredLeftHeight;
      //grab from any width.in range x to x+width
      int toFill = factoredRightY - leftEdge;
      int lowerBoundX = (factoredLeftX < factoredRightX) ? factoredRightX : factoredLeftX;
      int upperBoundX = (factoredLeftWidthTotal < factoredRightWidthTotal) ? factoredLeftWidthTotal : factoredRightWidthTotal;
      int chosenPath = (int) random(lowerBoundX, upperBoundX-3);
      for (int j = 0; j < 3; j++) {
        for (int i =leftEdge; i < leftEdge+toFill; i++) {
          room[chosenPath+j][i] = true;
        }
      }
    }
    return room;
  }
  
  // == METHOD to place enemies where the exit of the map is.
  public ArrayList<Enemy> generateEnemies(int level) {
    ArrayList<Enemy> enemies = new ArrayList<Enemy>();
    //Dependent on level. 
    BinaryNode treePtr = tree;
    while (treePtr.right!=null) treePtr = treePtr.right; //reach same room as the enemies.
    for (int i = 0; i < level; i+=2) {
      int posX = treePtr.x + (int)random(15, treePtr.widthArea-15);
      int posY = treePtr.y + (int)random(15, treePtr.heightArea-15);
      enemies.add(new Enemy(new PVector(posX, posY), new PVector(treePtr.x, treePtr.y), treePtr.widthArea, treePtr.heightArea, level) );
      
    }
    treePtr = tree;
    placeAdditionalEnemies(enemies, treePtr);
    return enemies;
  }
    // == METHOD to recursively descend down the binary tree and place enemies accordingly
  public void placeAdditionalEnemies(ArrayList<Enemy> enemies, BinaryNode treePtr){
     if(treePtr.left == null && treePtr.right == null){
      for (int i = 0; i < level; i++) {
        int posX = treePtr.x + (int)random(15, treePtr.widthArea-15);
        int posY = treePtr.y + (int)random(15, treePtr.heightArea-15);
        float rate = random(0,10);
      if(rate < 0.5){
        enemies.add(new Enemy(new PVector(posX, posY), new PVector(treePtr.x, treePtr.y), treePtr.widthArea, treePtr.heightArea, level) );
        }
      }
      return;
     }else{
       placeAdditionalEnemies(enemies, treePtr.left);
       placeAdditionalEnemies(enemies, treePtr.right);
     }
     
  }

  private ArrayList<Item> generateItems(ArrayList<Item> itemDictionary, ArrayList<Enemy> enemies) {
    ArrayList<Item> items = new ArrayList<Item>();
    BinaryNode treePtr = tree;
    placeItems(items, treePtr, itemDictionary, enemies);
    return items;
  }

  private ArrayList<Weapon> generateWeapons(ArrayList<Weapon> weaponDictionary) {
    //Some random algo. 
    ArrayList<Weapon> weapons = new ArrayList<Weapon>();
    BinaryNode treePtr = tree;
    if (level%5==0) {
      placeWeapons(weapons, treePtr, weaponDictionary);
    }
    return weapons;
  }

  // == METHOD to recursively descend down the binary tree and place weapons accordingly

  private void placeWeapons(ArrayList<Weapon> weapons, BinaryNode treePtr, ArrayList<Weapon> weaponDictionary) {
    if (treePtr.left == null && treePtr.right == null) {
      int chosenX = treePtr.x + (int) random(15, treePtr.widthArea-15);
      int chosenY = treePtr.y + (int) random(15, treePtr.heightArea-15);
      int chosenWeapon = (int) random(0, weaponDictionary.size());
      int dropRate = (int) random(0,10);
      if(dropRate < 8){ //Simple drop rate percentage. 
      Weapon wp = new Weapon();
      
      wp.copyWeapon(weaponDictionary.get(chosenWeapon));
      wp.position = new PVector(chosenX, chosenY);
      weapons.add(wp);
      return;
      }else{
        return;
      }
    }
    int direction = (int) random(0, 10);
    if (direction%2==0) {
      placeWeapons(weapons, treePtr.left, weaponDictionary);
    } else {
      placeWeapons(weapons, treePtr.right, weaponDictionary);
    }
  }
  // == METHOD to recursively descend down the binary tree and place items accordingly
  private void placeItems(ArrayList<Item> items, BinaryNode treePtr, ArrayList<Item> itemDictionary, ArrayList<Enemy> enemies) {
    if (treePtr.left == null && treePtr.right == null) {
      //Reached a room. 
      int chosenX;
      int chosenY;
      chosenX = treePtr.x + (int) random(0, treePtr.widthArea-40);

      chosenY = treePtr.y + (int) random(0, treePtr.heightArea-40);
      int dropRate = (int) random(0,10);
      if(dropRate < 3){ //Simple drop rate percentage. 
      int chosenItem = (int) random(0, itemDictionary.size());
      Item it = new Item();
      it.copyItem(itemDictionary.get(chosenItem));
      it.position = new PVector(chosenX, chosenY);      
      items.add(it);
      if(it.name.equals("Treasure")){
        enemies.add(new Enemy(new PVector(chosenX, chosenY), new PVector(treePtr.x, treePtr.y), treePtr.widthArea, treePtr.heightArea, level));
      }
      return;
      }else{
        return;
      }
    }
    if (treePtr.left!=null) placeItems(items, treePtr.left, itemDictionary, enemies);
    if (treePtr.right!=null) placeItems(items, treePtr.right, itemDictionary, enemies);
  }
  
// == METHOD assigns the start and end position of the map. 
  private void generateCharacterStartingPosition(BinaryNode tree) {
    BinaryNode treeptr = tree;
    while (treeptr.left!=null) treeptr = treeptr.left;
    BinaryNode startDimensions = treeptr;
    int chosenX = (int) random(startDimensions.x/40, (startDimensions.x+startDimensions.widthArea)/40);
    int chosenY = (int) random(startDimensions.y/40, (startDimensions.y+startDimensions.heightArea)/40);
    map[chosenX][chosenY].isStartingPosition = true;

    treeptr = tree;
    while (treeptr.right!=null) treeptr = treeptr.right;
    BinaryNode endDimensions = treeptr;
    chosenX = (int) random(endDimensions.x/40, (endDimensions.x+endDimensions.widthArea)/40);
    chosenY = (int) random(endDimensions.y/40, (endDimensions.y+endDimensions.heightArea)/40);
    map[chosenX][chosenY].isEndPosition = true;
  }

  // == METHOD to reset start/end positions
  private void resetTerrain() {
    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[0].length; j++) {
        map[i][j].isStartingPosition = false;
        map[i][j].isEndPosition = false;
      }
    }
  }
}
