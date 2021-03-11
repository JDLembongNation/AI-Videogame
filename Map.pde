public final class Map{
  GroundNode[][] map;
  BinaryNode tree;
  int treeValue;
  final int minArea = 50; //At least 50 squares of operating room.
  
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
    if(treeNode.getTotalArea() < minArea){
      return generatorMap;
    }else{
      float randomValue = random(0,50);
      if(randomValue%2 == 0){ //Split Vertically
        int split = (int) random(treeNode.x, treeNode.x+treeNode.widthArea);
       treeNode.left = new BinaryNode(treeNode, ((split-1)-treeNode.x), treeNode.heightArea, treeNode.x, treeNode.y);
       allocateSpaces(generatorMap, treeNode.left);
       treeNode.right = new BinaryNode(treeNode, (treeNode.widthArea+treeNode.x-split), treeNode.heightArea, split, treeNode.y);
       allocateSpaces(generatorMap, treeNode.right);
       return generatorMap;
       //50 --> 0,24 and 25,50
      }else{
        int split = (int) random(treeNode.y, treeNode.y+treeNode.heightArea);
        treeNode.left = new BinaryNode(treeNode, treeNode.widthArea, (split-1-treeNode.y),treeNode.x, treeNode.y);
        allocateSpaces(generatorMap, treeNode.left);
        treeNode.right = new BinaryNode(treeNode, treeNode.widthArea, (treeNode.heightArea+treeNode.y-split), treeNode.x, split);
        allocateSpaces(generatorMap, treeNode.right);
        //Split Horizontally
      
      }
    }
    return generatorMap;
  }
  /*
   - Split up the map in chosen difficulty. Lower difficulty means smaller spaces 
   - spit
   -recurse
   -stitch up pathways back up. When reaching a parent node. 
  */
  
}
