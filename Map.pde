public final class Map {
  int totalRooms = 0; //DEBUG
  int level;
  GroundNode[][] map;
  BinaryNode tree;
  int treeValue;
  final int minArea = 100000; //At least 50 squares of operating room.
  int incisions= 0; //DEBUG 
  int stitches = 0; //DEBUG

  public Map(int chosenWidth, int chosenHeight, int nodeSize) {
    int allocatedWidth = chosenWidth/nodeSize;
    int allocatedHeight = chosenHeight/nodeSize;
    this.map = new GroundNode[allocatedWidth][allocatedHeight];
    for (int i = 0; i < allocatedWidth; i++) {
      for (int j = 0; j < allocatedHeight; j++) {
        map[j][i] = new GroundNode((j*nodeSize), (i*nodeSize));
      }
    }
  }

  public GroundNode[][] getMap() {
    return map;
  }

  private void generateNewCave() {
    level++;
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
    System.out.println("Incisions: " + incisions + " and stiches: " + stitches);
    System.out.println("Total Rooms " + totalRooms);

    //Now generate Position of player and enemy.
    //generateCharacterStartingPosition(tree);
    //generateItems();
  }
  private class Room {
    int x; //Starting Positions
    int y; 
    int widthSize;
    int heightSize;
    public Room(int x, int y, int widthSize, int heightSize) {
      this.x = x;
      this.y = y;
      this.widthSize = widthSize;
      this.heightSize = heightSize;
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
    Room room; //Will not be null if this is a leaf node. 
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

  private boolean[][] allocateSpaces(boolean[][] generatorMap, BinaryNode treeNode) {
    //CHECK SIZE APPROPRIATE
    //Start Attaching Corridors and Drawing out Map with the GeneratorMap.
    if (treeNode.getTotalArea() < minArea) {
      //Carve out area. Reassign values for x, y, widthArea, heightArea. For now, just make 5 pixels smaller. Keep same Pos.
      //reduceSize(treeNode);
      totalRooms++;
      allocateNewRoom(treeNode);
      generatorMap = insertRoom(generatorMap, treeNode);
      return generatorMap;
    } else {
      incisions++;
      int randomValue = (int) random(0, 50);
      if (randomValue%2 == 0 && (treeNode.widthArea >=120)) { //Split Vertically
        int split = (int) random(treeNode.x+60, treeNode.x+treeNode.widthArea-59);
        int remainder = split%20;
        split-=remainder;
        treeNode.left = new BinaryNode(treeNode, ((split)-treeNode.x), treeNode.heightArea, treeNode.x, treeNode.y);
        allocateSpaces(generatorMap, treeNode.left);
        treeNode.right = new BinaryNode(treeNode, ((treeNode.x+treeNode.widthArea)-split), treeNode.heightArea, split, treeNode.y);
        allocateSpaces(generatorMap, treeNode.right);
        //50 --> 0,24 and 25,50
      } else if (randomValue%2 ==1 && treeNode.heightArea >= 120) {
        //Horizontal Split
        int split = (int) random(treeNode.y+60, treeNode.y+treeNode.heightArea-59);
        int remainder = split%20;
        split-=remainder;
        treeNode.left = new BinaryNode(treeNode, treeNode.widthArea, (split-treeNode.y), treeNode.x, treeNode.y);
        allocateSpaces(generatorMap, treeNode.left);
        treeNode.right = new BinaryNode(treeNode, treeNode.widthArea, ((treeNode.y+treeNode.heightArea)-split), treeNode.x, split);
        allocateSpaces(generatorMap, treeNode.right);
        //Split Horizontally
      } else {
        //Too Narrow to split. 
        //Dont reduce size. 
        allocateNewRoom(treeNode);
        generatorMap = insertRoom(generatorMap, treeNode);
        totalRooms++;
        return generatorMap;
      }
      
      if (treeNode.left!=null && treeNode.right!=null) {
        
        addRoomsToParent(treeNode);
        //Is a parent so Attach Corridors here on any length between the two children.
        stitches++;
        return addCorridors(generatorMap, treeNode);
      }
      return generatorMap;
    }
  }
  
  private void addRoomsToParent(BinaryNode node){
    int widthArea = (node.right.room.x + node.right.room.widthSize) - (node.left.room.x);
    int heightArea = (node.right.room.y + node.right.room.heightSize) - (node.left.room.y);
    node.room = new Room(node.left.room.x, node.left.room.y, widthArea, heightArea);
  }

  private boolean[][] insertRoom(boolean[][] room, BinaryNode node) {
    int factoredX = (int) (node.room.x)/20;
    int factoredY = (int) (node.room.y)/20;
    int factoredWidth = (int) (node.room.widthSize)/20;
    int factoredHeight = (int) (node.room.heightSize)/20;
    for (int i = factoredX; i < factoredWidth+factoredX; i++) {
      for (int j =factoredY; j < factoredHeight+factoredY; j++) {
        room[i][j] = true;
        map[i][j].debug = true;
      }
    }
    return room;
  }
  //Right Node will either be always to the right or below the left node. ie. higher height, (cartesian grid)
  private boolean[][] addCorridors(boolean[][] room, BinaryNode node) {
    boolean anythingChanged = false;
    //CHECK IF THE CHILDREN ARE FINAL CHILDERN THEN DO SOMETING.
    boolean prevCutVertical; //Was the previous cut a vertical cut? 
    boolean prevPrevCutVertical; //Was the prvious previous cut a vertical cut? 
    boolean didReduction = false;
    boolean didXOR = false;
    //Reduce scale IF there are children. 
    if (node.left.right!=null && node.left.left!=null) {
      didReduction = true;
      //need to find out type of cut between node.left nad node.right 
      //also need to find oiut cut type of node.left.left and node.left.right
      if ((node.left.x/20) < (node.right.x/20)) prevCutVertical = true;
      else prevCutVertical = false;
      if (node.left.left.x/20 < node.left.right.x/20) prevPrevCutVertical = true;
      else prevPrevCutVertical = false;
      //find out difference. 
    }    //if final children 
    int leftX = (int) node.left.room.x/20;
    int leftY = (int) node.left.room.y/20;
    int leftWidth = (int) node.left.room.widthSize/20; 
    int leftHeight = (int) node.left.room.heightSize/20;   
    int rightX = (int) node.right.room.x/20;
    int rightY = (int) node.right.room.y/20;
    int rightWidth = (int) node.right.room.widthSize/20;
    int rightHeight = (int) node.right.room.heightSize/20;

    if (leftX < leftY) { //Vertical Cut. 
      int leftEdge = leftX + leftWidth;
      int toFill = (rightY-leftEdge);
      
      int lowerBoundY;
      int upperBoundY; 
      int chosenPath = (int) random(lowerBoundY, upperBoundY-3);
      //System.out.println("Drawing Horizontal Path from y = " + chosenPath);
      for (int j = factoredLeftY; j < factoredLeftY+3; j++) {
        for (int i =leftEdge; i < leftEdge+toFill; i++) {
          //System.out.println("On position x = " + chosenPath + " y = " + i);
          room[i][j] = true;
          map[i][j].bigDebug = true;
          anythingChanged = true;
        }
      }
    } else { //Horizontal Cut.
      int leftEdge = factoredLeftY + factoredLeftHeight;
      //grab from any width.in range x to x+width
      int toFill = factoredRightY - leftEdge; //Something up here. 
      if (toFill <= 0) { 
        System.out.println("Left Y: " + factoredLeftY + " HEIGHT: " + factoredLeftHeight + " RIGHT Y " + factoredRightY);
        System.out.println((toFill <= 0) + " HUH -> " + toFill);
      }
      int lowerBoundX = (factoredLeftX < factoredRightX) ? factoredRightX : factoredLeftX;
      int upperBoundX = (factoredLeftWidthTotal < factoredRightWidthTotal) ? factoredLeftWidthTotal : factoredRightWidthTotal;
      int chosenPath = (int) random(lowerBoundX, upperBoundX-3);
      //System.out.println("Drawing Vertical Path from x = " + chosenPath);
      //System.out.println("Starting Point is leftY = " + factoredLeftY + "; LeftHeight = " + factoredLeftHeight  + "; rightY = " + factoredRightY); //LEFT HEIGHT IS TOO BIG BY FACTOR 1. 
      for (int j = factoredLeftX; j < factoredLeftX+3; j++) {
        for (int i =leftEdge; i < leftEdge+toFill; i++) {
          room[j][i] = true;
          map[j][i].bigDebug = true;
          anythingChanged = true;
        }
      }
    }
    return room;
  }

  public ArrayList<Enemy> generateEnemies(int level) {
    ArrayList<Enemy> enemies = new ArrayList<Enemy>();
    //Dependent on level. 
    BinaryNode treePtr = tree;
    while (treePtr.right!=null) treePtr = treePtr.right; //reach same room as the enemies.
    for (int i = 0; i < level; i++) {
      int posX = treePtr.x + (int)random(15, treePtr.widthArea-15);
      int posY = treePtr.y + (int)random(15, treePtr.heightArea-15);
      enemies.add(new Enemy(new PVector(posX, posY), new PVector(treePtr.x, treePtr.y), treePtr.widthArea, treePtr.heightArea, level) );
    }
    return enemies;
  }

  private ArrayList<Item> generateItems(ArrayList<Item> itemDictionary) {
    ArrayList<Item> items = new ArrayList<Item>();
    BinaryNode treePtr = tree;
    placeItems(items, treePtr, itemDictionary);
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


  private void placeWeapons(ArrayList<Weapon> weapons, BinaryNode treePtr, ArrayList<Weapon> weaponDictionary) {
    if (treePtr.left == null && treePtr.right == null) {
      int chosenX = treePtr.x + (int) random(15, treePtr.widthArea-15);
      int chosenY = treePtr.y + (int) random(15, treePtr.heightArea-15);
      int chosenWeapon = (int) random(0, weaponDictionary.size());
      Weapon wp = weaponDictionary.get(chosenWeapon);
      wp.position = new PVector(chosenX, chosenY);
      weapons.add(wp);
      return;
    }
    int direction = (int) random(0, 10);
    if (direction%2==0) {
      placeWeapons(weapons, treePtr.left, weaponDictionary);
    } else {
      placeWeapons(weapons, treePtr.right, weaponDictionary);
    }
  }

  private void placeItems(ArrayList<Item> items, BinaryNode treePtr, ArrayList<Item> itemDictionary) {
    if (treePtr.left == null && treePtr.right == null) {
      //Reached a room. 
      int chosenX = treePtr.x + (int) random(30, treePtr.widthArea-30);
      int chosenY = treePtr.y + (int) random(30, treePtr.heightArea-30);
      int chosenItem = (int) random(0, itemDictionary.size());
      Item it = itemDictionary.get(chosenItem);
      it.position = new PVector(chosenX, chosenY);
      items.add(it);
      return;
    }
    if (treePtr.left!=null) placeItems(items, treePtr.left, itemDictionary);
    if (treePtr.right!=null) placeItems(items, treePtr.right, itemDictionary);
  }

  private void generateCharacterStartingPosition(BinaryNode tree) {
    //go to bottom of tree focusing left and place spot randomly rnadomly. 
    //go to bottom of tree focusing right and place spot randomly.a
    BinaryNode treeptr = tree;
    while (treeptr.left!=null) treeptr = treeptr.left;
    BinaryNode startDimensions = treeptr;
    int chosenX = (int) random(startDimensions.x/20, (startDimensions.x+startDimensions.widthArea)/20);
    int chosenY = (int) random(startDimensions.y/20, (startDimensions.y+startDimensions.heightArea)/20);
    map[chosenX][chosenY].isStartingPosition = true;

    treeptr = tree;
    while (treeptr.right!=null) treeptr = treeptr.right;
    BinaryNode endDimensions = treeptr;
    chosenX = (int) random(endDimensions.x/20, (endDimensions.x+endDimensions.widthArea)/20);
    chosenY = (int) random(endDimensions.y/20, (endDimensions.y+endDimensions.heightArea)/20);
    map[chosenX][chosenY].isEndPosition = true;
  }

  private void resetTerrain() {
    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[0].length; j++) {
        map[i][j].isStartingPosition = false;
        map[i][j].isEndPosition = false;
      }
    }
  }

  //Reduce size of room. for added variation,
  private void allocateNewRoom(BinaryNode node) {
    int posX = node.x;
    int posY = node.y; 
    int widthArea = node.widthArea;
    int heightArea = node.heightArea;
    if (widthArea <=80)widthArea-=20;
    else if (widthArea == 100) {
      int chosen = (int) random(20, 41);
      chosen -= chosen %20;
      widthArea -=chosen;
    } else {
      int chosen = (int) random(20, 61);
      chosen -= chosen %20;
     widthArea -=chosen;
    }

    if (heightArea <=80)heightArea-=20;
    else if (heightArea == 100) {
      int chosen = (int) random(20, 41);
      chosen -= chosen %20;
      heightArea -=chosen;
    } else {
      int chosen = (int) random(20, 61);
      chosen -= chosen %20;
      heightArea -=chosen;
    }
    node.room = new Room(posX, posY, widthArea, heightArea);
  }
}
