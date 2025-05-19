public class Player extends AnimatedSprite{
  int lives;
  boolean inPlace, onPlatform;
  PImage[] standLeft;
  PImage[] standRight; 
  public Player(PImage img, float scale){
    super(img, scale);
    direction = RIGHT_FACING;
    onPlatform = true;
    inPlace = true;
    standLeft = new PImage[1];
    standLeft[0] = loadImage("player.png");
    standRight = new PImage[1];
    standRight[0] = loadImage("player.png");
    moveLeft = new PImage[2];
    moveLeft[0] = loadImage("player.png");
    moveLeft[1] = loadImage("player_walk_left.png");
    moveRight = new PImage[2];
    moveRight[0] = loadImage("player.png");
    moveRight[1] = loadImage("player_walk_right.png"); 
    currentImages = standRight;
  }
  @Override
  public void updateAnimation(){
    onPlatform = isOnPlatforms(this, platforms);
    inPlace = change_x == 0 && change_y == 0;
    super.updateAnimation();
  }
  @Override
  public void selectDirection(){
    if(change_x > 0)
      direction = RIGHT_FACING;
    else if(change_x < 0)
      direction = LEFT_FACING;    
  }
  @Override
  public void selectCurrentImages(){
    if(direction == RIGHT_FACING){
      if(inPlace){
        currentImages = standRight;
      }
      else{
        currentImages = moveRight;
      }
    }
    else if(direction == LEFT_FACING){
      if(inPlace){
        currentImages = standLeft;
      }
      else{
        currentImages = moveLeft;
      }
      
    }

    
  }
}
