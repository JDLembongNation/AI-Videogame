public final class Map{
  GroundNode[][] map;
  BinaryNode tree;
  int treeValue;
  final int minArea = 300000; //At least 50 squares of operating room.
  
  public Map(int chosenWidth, int chosenHeight, int nodeSize){
    int allocatedWidth = chosenWidth/nodeSize;
    int allocatedHeight = chosenHeight/nodeSize;
    this.map = new GroundNode[allocatedWidth][allocatedHeight];
    for(int i = 0; i < allocatedWidth; i++){
      for(int j = 0; j < allocatedHeight; j++){
        map[j][i] = new GroundNode((j*nodeSize),(i*nodeSize));
      }
    }
  }
  
  public GroundNode[][] getMap(){return map;}
  
  private void generateNewCave(){
    //Using the BSP Partitioning System. 
    treeValue = 0;
    tree = new BinaryNode(null, 1000, 1000,0,0);
    boolean[][] generateMap = new boolean[map.length][map[0].length]; //default is false
    resetTerrain();
    generateMap = allocateSpaces(generateMap,  tree);
    generateCharacterStartingPosition(tree);
    for(int i = 0; i < generateMap.length; i++){
      for(int j = 0; j < generateMap[0].length; j++){
        map[i][j].isWalkable = generateMap[i][j];
      }
    }
    
    //Now generate Position of player and enemy.
    //generateCharacterStartingPosition(tree);
    //generateItems();
  }
  
  private class BinaryNode{
    int x;
    int y; //not pvectors as no vector calculations are needed.
    int widthArea;
    int heightArea;
    BinaryNode parent;
    BinaryNode left;
    BinaryNode right;
    public BinaryNode(BinaryNode parent, int widthArea, int heightArea, int x, int y){
      this.parent = parent;
      this.widthArea = widthArea;
      this.heightArea = heightArea;
      this.x = x;
      this.y = y;
    }
    public int getTotalArea(){return widthArea*heightArea;}
  }
  
  private boolean[][] allocateSpaces(boolean[][] generatorMap, BinaryNode treeNode){
    //CHECK SIZE APPROPRIATE
    //Start Attaching Corridors and Drawing out Map with the GeneratorMap.
    if(treeNode.getTotalArea() < minArea){
      //Carve out area. Reassign values for x, y, widthArea, heightArea. For now, just make 5 pixels smaller. Keep same Pos.
      treeNode.widthArea -=20;
      treeNode.heightArea-=20;
      generatorMap = insertRoom(generatorMap, treeNode);
      return generatorMap;
    }else{
      int randomValue = (int) random(0,50);
      if(randomValue%2 == 0){ //Split Vertically

       int split = (int) random(treeNode.x+60, treeNode.x+treeNode.widthArea-60);
       int remainder = split%20;
       split-=remainder;
       treeNode.left = new BinaryNode(treeNode, ((split)-treeNode.x), treeNode.heightArea, treeNode.x, treeNode.y);
       allocateSpaces(generatorMap, treeNode.left);
       treeNode.right = new BinaryNode(treeNode, (treeNode.widthArea+treeNode.x-split), treeNode.heightArea, split, treeNode.y);
       allocateSpaces(generatorMap, treeNode.right);
       //50 --> 0,24 and 25,50
      }else{
        int split = (int) random(treeNode.y+60, treeNode.y+treeNode.heightArea-60);
        int remainder = split%20;
        split-=remainder;
        treeNode.left = new BinaryNode(treeNode, treeNode.widthArea, (split-treeNode.y),treeNode.x, treeNode.y); 
        allocateSpaces(generatorMap, treeNode.left);
        treeNode.right = new BinaryNode(treeNode, treeNode.widthArea, (treeNode.heightArea+treeNode.y-split), treeNode.x, split);
        allocateSpaces(generatorMap, treeNode.right);
        //Split Horizontally
      }
      if(treeNode.left!=null && treeNode.right!=null){ //Is a parent so Attach Corridors here on any length between the two children.
      return addCorridors(generatorMap, treeNode);
      }
       return generatorMap;
    }
  }
  
  private boolean[][] insertRoom(boolean[][] room, BinaryNode node){
    int factoredX = (int) node.x/20;
    int factoredY = (int) node.y/20;
    int factoredWidth = (int) node.widthArea/20;
    int factoredHeight = (int) node.heightArea/20;
    for(int i = factoredX; i < factoredWidth+factoredX; i++){
      for(int j =factoredY; j < factoredHeight+factoredY; j++){
        room[i][j] = true;
      }
    }
    return room;
  }
  //Right Node will either be always to the right or below the left node. ie. higher height, (cartesian grid)
  private boolean[][] addCorridors(boolean[][] room, BinaryNode node){
    //Reduce scale IF there are children. 
    if(node.left.right!=null && node.left.left!=null) {
      node.left.widthArea -=20;
      node.left.heightArea -=20;
    }
    if(node.right.right!=null && node.right.left!=null){
      node.right.widthArea -=20;
      node.right.heightArea -=20;
    }
    
    int factoredLeftX = (int) node.left.x/20;
    int factoredLeftY = (int) node.left.y/20;
    int factoredLeftWidth = (int) node.left.widthArea/20;
    int factoredLeftHeight = (int) node.left.heightArea/20;
    int factoredRightX = (int) node.right.x/20;
    int factoredRightY = (int) node.right.y/20;
    int factoredRightWidth = (int) node.right.widthArea/20;
    int factoredRightHeight = (int) node.right.heightArea/20;
    int factoredLeftHeightTotal = (factoredLeftY+factoredLeftHeight);
    int factoredRightHeightTotal = (factoredRightY+factoredRightHeight);
    int factoredLeftWidthTotal = (factoredLeftX + factoredLeftWidth);
    int factoredRightWidthTotal = (factoredRightX + factoredRightWidth);
    
    if(factoredLeftX < factoredRightX){ //Vertical Cut. 
      int leftEdge = factoredLeftX + factoredLeftWidth;
      //grab from any height. in range y to y+height
      int toFill = factoredRightX-leftEdge;
      //pick random left to right. 
      int lowerBoundY = (factoredLeftY < factoredRightY) ? factoredRightY : factoredLeftY;
      int upperBoundY = factoredLeftHeightTotal < factoredRightHeightTotal? factoredLeftHeightTotal : factoredRightHeightTotal;
      int chosenPath = (int) random(lowerBoundY, upperBoundY-3);
      //System.out.println("Drawing Horizontal Path from y = " + chosenPath);
      for(int j = 0; j < 3;j++){
      for(int i =leftEdge; i < leftEdge+toFill; i++){
        //System.out.println("On position x = " + chosenPath + " y = " + i);
        room[i][chosenPath+j] = true;
      }
      }
    }else{ //Horizontal Cut.
      int leftEdge = factoredLeftY + factoredLeftHeight;
      //grab from any width.in range x to x+width
      int toFill = factoredRightY - leftEdge;
      int lowerBoundX = (factoredLeftX < factoredRightX) ? factoredRightX : factoredLeftX;
      int upperBoundX = (factoredLeftWidthTotal < factoredRightWidthTotal) ? factoredLeftWidthTotal : factoredRightWidthTotal;
      int chosenPath = (int) random(lowerBoundX, upperBoundX-3);
      //System.out.println("Drawing Vertical Path from x = " + chosenPath);
      //System.out.println("Starting Point is leftY = " + factoredLeftY + "; LeftHeight = " + factoredLeftHeight  + "; rightY = " + factoredRightY); //LEFT HEIGHT IS TOO BIG BY FACTOR 1. 
      for(int j = 0; j < 3; j++){
      for(int i =leftEdge; i < leftEdge+toFill; i++){
        room[chosenPath+j][i] = true;
        //System.out.println("On position x = " + chosenPath + " y = " + i);
      }
      }
      //System.out.println("\n \n \n");
    }
    return room;
  }
  
  public ArrayList<Enemy> generateEnemies(int level){
    ArrayList<Enemy> enemies = new ArrayList<Enemy>();
    //Dependent on level. 
    BinaryNode treePtr = tree;
    while(treePtr.right!=null) treePtr = treePtr.right; //reach same room as the enemies.
    for(int i = 0; i < level; i++){
      int posX = treePtr.x + (int)random(15, treePtr.widthArea-15);
      int posY = treePtr.y + (int)random(15, treePtr.heightArea-15);
      enemies.add(new Enemy(new PVector(posX, posY)));
    }
    return enemies;
  }
  
  private ArrayList<Item> generateItems(ArrayList<Item> itemDictionary){
    ArrayList<Item> items = new ArrayList<Item>();
    BinaryNode treePtr = tree;
    placeItems(items, treePtr, itemDictionary);
    return items;
  }
  
  private void placeItems(ArrayList<Item> items, BinaryNode treePtr, ArrayList<Item> itemDictionary){
    if(treePtr.left == null && treePtr.right == null){
      //Reached a room. 
      int chosenX = treePtr.x + (int) random(15,treePtr.widthArea-15);
      int chosenY = treePtr.y + (int) random(15,treePtr.heightArea-15);
      int chosenItem = (int) random(0, itemDictionary.size());
      Item it = itemDictionary.get(chosenItem);
      it.position = new PVector(chosenX, chosenY);
      items.add(it);
      return;
    }
    if(treePtr.left!=null) placeItems(items, treePtr.left, itemDictionary);
    if(treePtr.right!=null) placeItems(items, treePtr.right, itemDictionary);
  }
  
  private void generateCharacterStartingPosition(BinaryNode tree){
    //go to bottom of tree focusing left and place spot randomly rnadomly. 
    //go to bottom of tree focusing right and place spot randomly.a
    BinaryNode treeptr = tree;
    while(treeptr.left!=null) treeptr = treeptr.left;
    BinaryNode startDimensions = treeptr;
    int chosenX = (int) random(startDimensions.x/20, (startDimensions.x+startDimensions.widthArea)/20);
    int chosenY = (int) random(startDimensions.y/20, (startDimensions.y+startDimensions.heightArea)/20);
    map[chosenX][chosenY].isStartingPosition = true;
    
    treeptr = tree;
        while(treeptr.right!=null) treeptr = treeptr.right;
    BinaryNode endDimensions = treeptr;
    chosenX = (int) random(endDimensions.x/20, (endDimensions.x+endDimensions.widthArea)/20);
    chosenY = (int) random(endDimensions.y/20, (endDimensions.y+endDimensions.heightArea)/20);
    map[chosenX][chosenY].isEndPosition = true;

  }
  
  private void resetTerrain(){
    for(int i = 0; i < map.length; i++){
      for(int j = 0; j < map[0].length; j++){
        map[i][j].isStartingPosition = false;
        map[i][j].isEndPosition = false;
      }
    }

  }
  
  
  
}
