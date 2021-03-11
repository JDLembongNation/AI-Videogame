final int PLAY_WIDTH = 1000;
final int PLAY_HEIGHT = 1000;
final int NODE_SIZE = 20;

Map map;
void setup() {
  size(1000, 1000);
  map = new Map(PLAY_WIDTH, PLAY_HEIGHT, NODE_SIZE);
  map.generateNewCave();
}

void draw() {
   drawMap();
}

void drawMap(){
  GroundNode[][] currentMap = map.getMap();
  for(int i = 0; i < currentMap.length; i++){
    for(int j = 0; j < currentMap[i].length; j++){
      if(currentMap[i][j].isWalkable){
        fill(255);
        rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
      }else{
        fill(20);
        rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
      }
    }
  }
}
