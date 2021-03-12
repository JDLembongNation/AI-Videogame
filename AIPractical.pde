final int PLAY_WIDTH = 1000;
final int PLAY_HEIGHT = 1000;
final int NODE_SIZE = 20;

boolean[] keys = {false, false, false, false};
Map map;
Player player;
void setup() {
  size(1000, 1000);
  map = new Map(PLAY_WIDTH, PLAY_HEIGHT, NODE_SIZE);
  map.generateNewCave();
  player = new Player(100,100,0);
}

void draw() {
   background(255);
   drawMap();
   drawCharacters();
   drawItems();
   move();
}

void drawMap(){
  GroundNode[][] currentMap = map.getMap();
  for(int i = 0; i < currentMap.length; i++){
    for(int j = 0; j < currentMap[i].length; j++){
      if(!currentMap[i][j].isWalkable){
        fill(20);
        rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
      }
    }
  }
}

void drawCharacters(){
   fill(180,20,20);
   ellipse(player.position.x, player.position.y, 30,30);
  int newxe = (int)(player.position.x + 10 * cos(player.orientation));
  int newye = (int)(player.position.y + 10 * sin(player.orientation));
  fill(0);
  ellipse(newxe, newye, 10, 10);  
   
}

void drawItems(){
}

void move(){
  if(keys[0] && keys[2]) player.integrate(0.8,0.02);
  if(keys[0] && keys[3]) player.integrate(0.8,-0.02);
  if(keys[1] && keys[2])player.integrate(-0.8,0.02);
  if(keys[1] && keys[3])player.integrate(-0.8,-0.02);
  if(keys[0]) player.integrate(1,0);
  if(keys[1]) player.integrate(-1,0);
  if(keys[2]) player.integrate(0,0.08);
  if(keys[3]) player.integrate(0,-0.08);

}
void keyPressed()
{
  if(key=='w')
    keys[0]=true;
  if(key=='s')
    keys[1]=true;
   if(key=='d')
    keys[2]=true;
   if(key=='a')
    keys[3]=true;
}

void keyReleased()
{
  if(key=='w')
    keys[0]=false;
  if(key=='s')
    keys[1]=false;
  if(key=='d')
    keys[2]=false;
  if(key=='a')
    keys[3]=false;
} 
