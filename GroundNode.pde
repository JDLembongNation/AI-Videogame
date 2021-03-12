public final class GroundNode{
  boolean isWalkable;
  int x; 
  boolean isStartingPosition;
  boolean isEndPosition;
  int y;  //Class will be in charge of item placements, Entrace and Exit, and A Star Alogrithmic Findings.
  public GroundNode(int x, int y){
    this.x = x;
    this.y = y;
  }
}
