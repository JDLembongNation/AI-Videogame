final int PLAY_WIDTH = 1000;
final int PLAY_HEIGHT = 1000;
final int NODE_SIZE = 20;
final String INTRO_TEXT = "Let the Battle Commence!";

boolean inBattle = false;
PVector end;
boolean[] keys = {false, false, false, false};
GroundNode[][] currentMap;
Enemy enemy;
Map map;
Player player;
void setup() {
  size(1000, 1000);
  map = new Map(PLAY_WIDTH, PLAY_HEIGHT, NODE_SIZE);
  map.generateNewCave();
  player = new Player(100,100,0);
  enemy = new Enemy(new PVector(50,50));
}

void draw() {
  if(inBattle) battleGUI();
  else caveGUI();
}

void caveGUI(){
   background(255);
   drawMap();
   drawCharacters();
   drawItems();
   move();
   collisionCheck();
}

void battleGUI(){
  background(0);
  fill(255);
  textSize(30);
  text(INTRO_TEXT, 300, 300);
  if(keyPressed){
    if(key == 'c'){
      inBattle=false;
      player.position = player.startingPosition.copy();
      System.out.println("Starting position x and y" + player.startingPosition.x + "  " + player.startingPosition.y);
    }
  }
}

void drawMap(){
  currentMap = map.getMap();
  for(int i = 0; i < currentMap.length; i++){
    for(int j = 0; j < currentMap[i].length; j++){
      if(!currentMap[i][j].isWalkable){
        fill(20);
        rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
      }
      if(currentMap[i][j].isStartingPosition){
        fill(50,50,190);
        rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
        player.startingPosition = new PVector(i*20, j*20);
    }
      if(currentMap[i][j].isEndPosition){
         fill(180,50,190);
         rect(currentMap[i][j].x, currentMap[i][j].y, NODE_SIZE, NODE_SIZE);
         end = new PVector(i*20,j*20); 
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

  //ENEMY
  fill(20,180,20);
  ellipse(enemy.position.x, enemy.position.y, 30,30);
  int enemyX = (int)(enemy.position.x + 10 * cos(enemy.orientation));
  int enemyY = (int)(enemy.position.y + 10 * sin(enemy.orientation));
  fill(0);
  ellipse(enemyX, enemyY, 10, 10);   
}

void collisionCheck(){
  if(player.position.mag() - enemy.position.mag() < 20){
    System.out.println("Initiate Battle!");
    inBattle = true;
  }
  if(abs(player.position.mag() - end.mag()) < 20) { //EXTREMELY DODGY FIX SOON PLEASE.
    map.generateNewCave();
    drawMap();
    player.position = player.startingPosition.copy();
  }
  // == FOR EDGE OF SCREEN == 
  if(player.position.x < 15) player.position.x=15;
  if(player.position.x > width-15) player.position.x = width-15;
  if(player.position.y > height-15) player.position.y = height-15;
  if(player.position.y < 15) player.position.y = 15;
  // == FOR WALL ==
  int positionX = (int) player.position.x;
  int positionY = (int) player.position.y;
  if(positionX%20 < 10){ 
    positionX -= positionX%20;  
  }else{
    positionX += (20-positionX%20);
  }
  if(positionY%20 < 10){ 
    positionY -=positionY%20;
  }else{
   positionY +=(20-positionY%20);
  } 
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
}

void drawItems(){
  
}

void move(){
  if(keys[0] && keys[2]) player.integrate(2,0.02);
  if(keys[0] && keys[3]) player.integrate(2,-0.02);
  if(keys[1] && keys[2])player.integrate(-2,0.02);
  if(keys[1] && keys[3])player.integrate(-2,-0.02);
  if(keys[0]) player.integrate(2,0);
  if(keys[1]) player.integrate(-2,0);
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
