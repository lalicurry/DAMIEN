
public class Enemy extends AnimatedSprite{
  float boundaryLeft, boundaryRight;
  public Enemy(PImage img, float scale, float bLeft, float bRight){
    super(img, scale);
    moveLeft = new PImage[3];
    moveLeft[0] = loadImage("water1.png");
    moveLeft[1] = loadImage("water2.png");
    moveLeft[2] = loadImage("water3.png");
    moveRight = new PImage[3];
    moveRight[0] = loadImage("water1.png");
    moveRight[1] = loadImage("water2.png"); 
    moveRight[2] = loadImage("water3.png"); 
    currentImages = moveRight;
    direction = RIGHT_FACING;
    boundaryLeft = bLeft;
    boundaryRight = bRight;
    change_x = 2;
  }
  void update(){
    super.update();
    if(getLeft() <= boundaryLeft){
      setLeft(boundaryLeft);
      change_x *= -1;
    }
    else if(getRight() >= boundaryRight){
      setRight(boundaryRight);
      change_x *= -1;
    }
  }
}
