public final class Map{
  GroundNode[][] map;
  BinaryNode tree;
  int treeValue;
  final int minArea = 2500; //At least 50 squares of operating room.
  
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
    tree = null; //Restart Tree;
    boolean[][] generateMap = new boolean[map.length][map[0].length]; //default is false
    generateMap = allocateSpaces(generateMap, tree);
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
    public int getTotalArea(){return widthArea+heightArea;}
  }
  
  private boolean[][] allocateSpaces(boolean[][] generatorMap, BinaryNode treeNode){
    if(treeNode == null) treeNode = new BinaryNode(null, generatorMap[0].length, generatorMap.length,0,0); //create parent
    //CHECK SIZE APPROPRIATE
    //Start Attaching Corridors and Drawing out Map with the GeneratorMap.
    if(treeNode.left!=null && treeNode.right!=null){ //Is a parent so Attach Corridors here on any length between the two children.
      
    }
    if(treeNode.getTotalArea() < minArea){
      //Carve out area. Reassign values for x, y, widthArea, heightArea. For now, just make 5 pixels smaller. Keep same Pos.
      treeNode.widthArea -=20;
      treeNode.heightArea-=20;
      generatorMap = insertRoom(generatorMap, treeNode);
      return generatorMap;
    }else{
      int randomValue = (int) random(0,50);
      if(randomValue%2 == 0){ //Split Vertically
       int split = (int) random(treeNode.x+20, treeNode.x+treeNode.widthArea-20);
       int remainder = split%20;
       if(remainder <= 10) split-=remainder;
       if(remainder > 10) split+=remainder;
       treeNode.left = new BinaryNode(treeNode, ((split)-treeNode.x), treeNode.heightArea, treeNode.x, treeNode.y);
       allocateSpaces(generatorMap, treeNode.left);
       treeNode.right = new BinaryNode(treeNode, (treeNode.widthArea+treeNode.x-split), treeNode.heightArea, split, treeNode.y);
       allocateSpaces(generatorMap, treeNode.right);
       //50 --> 0,24 and 25,50
      }else{
        int split = (int) random(treeNode.y+20, treeNode.y+treeNode.heightArea-20);
        int remainder = split%20;
        if(remainder <= 10) split-=remainder;
        if(remainder > 10) split+=remainder;
        treeNode.left = new BinaryNode(treeNode, treeNode.widthArea, (split-treeNode.y),treeNode.x, treeNode.y);
        allocateSpaces(generatorMap, treeNode.left);
        treeNode.right = new BinaryNode(treeNode, treeNode.widthArea, (treeNode.heightArea+treeNode.y-split), treeNode.x, split);
        allocateSpaces(generatorMap, treeNode.right);
        //Split Horizontally
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
        room[j][i] = true;
      }
    }
    return room;
  }
  //Right Node will either be always to the right or below the left node. ie. higher height, (cartesian grid)
  private boolean[][] addCorridors(boolean[][] room, BinaryNode node){
    int factoredLeftX = (int) node.left.x/20;
    int factoredLeftY = (int) node.left.y/20;
    int factoredLeftWidth = (int) node.left.widthArea/20;
    int factoredLeftHeight = (int) node.left.heightArea/20;
    int factoredRightX = (int) node.left.x/20;
    int factoredRightY = (int) node.left.y/20;
    int factoredRightWidth = (int) node.left.widthArea/20;
    int factoredRightHeight = (int) node.left.heightArea/20;
    if(factoredLeftX < factoredRightX){ //Vertical Cut. 
      int leftEdge = factoredLeftX + factoredLeftWidth;
      //grab from any height. in range y to y+height
      int toFill = factoredRightX-leftEdge;
      for(int i =0; i < toFill; i++){
      
      }
    }else{ //Horizontal Cut.
      int leftEdge = factoredLeftY + factoredLeftHeight;
      //grab from any width.in range x to x+width
      int toFill = factoredRightY - leftEdge;
      for(int i =0; i < toFill; i++){
      
      }
    }
    return room;
  }
    
  
  /*
   - Split up the map in chosen difficulty. Lower difficulty means smaller spaces 
   - spit
   -recurse
   -stitch up pathways back up. When reaching a parent node. 
  */
  
}
