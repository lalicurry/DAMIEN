final static float MOVE_SPEED = 4;
final static float SPRITE_SCALE = 25.0/128;
final static float SPRITE_SIZE = 50;
final static float GRAVITY = .98;//gravity of earth
final static float JUMP_SPEED = 15;

final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 0;
final static float VERTICAL_MARGIN = 40;

final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING = 1;
final static int LEFT_FACING = 2;

public boolean playerIsDead = false;
public boolean isDone = false;

Sprite goalFlag;
PImage toilet, crate, poop_brick, plunger, c, enemy, flag;
Player player;
ArrayList<Sprite> platforms;
ArrayList<Sprite> coins;
ArrayList<Enemy> enemies;
ArrayList<Sprite> redFlag;
int score = 0;
float view_x;
float view_y;

void setup(){
  size(800, 600);
  imageMode(CENTER);
  PImage playerImage = loadImage("player.png");
  player = new Player(playerImage, 0.05);
  player.center_x = 100;
  player.center_y = 100;
  platforms = new ArrayList<Sprite>();
  coins = new ArrayList<Sprite>();
  enemies = new ArrayList<Enemy>();
  redFlag = new ArrayList<Sprite>();
  view_x = 0; 
  view_y = 0;

  poop_brick = loadImage("poop_brick.png");
  c = loadImage("gold1.png");
  plunger = loadImage("plunger.png");
  crate = loadImage("poop_crate.png");
  toilet = loadImage("toilet_brick.png");
  enemy = loadImage("water1.png");
  flag = loadImage("flag.png");
  createPlatforms("mapEnemy.csv");
}

void draw(){
  background(255);
  
  
   if(isDone){
     fill(0, 255, 0);
     textSize(50);
     text("You're Done. \n Stop playing", 470, 250);
     return;
   }
  
  if (playerIsDead) {
    fill(255, 0, 0);
    textSize(50);
    text("Game Over\nPress 'r' to revive", view_x + width/2 - 100, view_y + height/2);
    return;
  }
  
  scroll();
  
  player.display();
  player.update();
  player.updateAnimation();
  
  resolvePlatformCollisions(player, platforms);
  checkPlayerEnemyCollision();
  checkPlayerFlagCollision();
  
  for(Enemy e: enemies){
    e.display();
    e.update();
    e.updateAnimation();
  }
  
  for(Sprite s: redFlag)
    s.display();
  
  for(Sprite s: platforms)
    s.display();
    
  for(Sprite cc: coins){
    cc.display();
    ((AnimatedSprite)cc).updateAnimation();
  }

  ArrayList<Sprite> collision_list = checkCollisionList(player, coins);
  
  // if collision list not empty
  if (collision_list.size() > 0) {
    for (Sprite coin : collision_list) {
      coins.remove(coin); // remove coin
      score++;           // add 1 to score
    }
  }
  
  //score
  fill(255, 0, 0);
  textSize(32);
  text("Chickens: " + score, 50, 50);
  text("Dont touch the waterdrops!", 50, 75);
} 


void scroll(){
  
  float left_boundary = view_x + LEFT_MARGIN;
       
  if(player.getLeft() < left_boundary){
    view_x -= (left_boundary - player.getLeft());
  }
  
  float right_boundary = view_x + width - RIGHT_MARGIN;

  if(player.getRight() > right_boundary){
    view_x += (player.getRight() - right_boundary);
  }

  float top_boundary = view_y + VERTICAL_MARGIN;

  if(player.getTop() < top_boundary){
    view_y -= (top_boundary - player.getTop());
  }

  float bottom_boundary = view_y + height - VERTICAL_MARGIN;
  
  if(player.getBottom() > bottom_boundary){
    view_y += (player.getBottom() - bottom_boundary);
  }

  translate(-view_x, -view_y);
}


void keyPressed(){
  if(keyCode == RIGHT){
    player.change_x = MOVE_SPEED;
  }
  else if(keyCode == LEFT){
    player.change_x = -MOVE_SPEED;
  }
  else if(keyCode == UP && isOnPlatforms(player, platforms)){
    player.change_y = -JUMP_SPEED;
  }
  else if (playerIsDead && key == 'r') {
    setup(); // restart everything
    playerIsDead = false;
    return;
  }
}

void keyReleased(){
  if(keyCode == RIGHT || keyCode == LEFT){
    player.change_x = 0;
  }
}

public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls){
  s.center_y += 5;
  ArrayList<Sprite> collision_list = checkCollisionList(s, walls);
  s.center_y -= 5;
  return collision_list.size() > 0; 
}

public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls){
  s.change_y += GRAVITY;
  s.center_y += s.change_y;
  ArrayList<Sprite> collision_list = checkCollisionList(s, walls);
  if(collision_list.size() > 0){
     Sprite collided = collision_list.get(0);
     if(s.change_y > 0){
       s.setBottom(collided.getTop());
     }
     else if(s.change_y < 0){
       s.setTop(collided.getBottom());
     }
     s.change_y = 0;//stops vert movement
  }
  s.center_x += s.change_x;
  collision_list = checkCollisionList(s, walls);
  if(collision_list.size() > 0){
     Sprite collided = collision_list.get(0);
     if(s.change_x > 0){
       s.setRight(collided.getLeft());
     }
     else if(s.change_x < 0){
       s.setLeft(collided.getRight());
     }
  }
}

boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  return !(noXOverlap || noYOverlap);
}

public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p: list){
    if(checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}

void createPlatforms(String filename){
  String[] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++){
    String[] values = split(lines[row], ",");
    for(int col = 0; col < values.length; col++){
      if(values[col].equals("1")){
        Sprite s = new Sprite(poop_brick, SPRITE_SCALE*0.6);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("2")){
        Sprite s = new Sprite(toilet, 0.05);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("3")){
        Sprite s = new Sprite(plunger, 0.06);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("4")){
        Sprite s = new Sprite(crate, SPRITE_SCALE*0.6);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }else if(values[col].equals("5")){
        Coin coin = new Coin(c, SPRITE_SCALE/2.3);
        coin.center_x = SPRITE_SIZE/6 + col * SPRITE_SIZE;
        coin.center_y = SPRITE_SIZE/6 + row * SPRITE_SIZE;
        coins.add(coin);
      }
      else if(values[col].equals("6")){
        Enemy e = new Enemy(enemy, SPRITE_SCALE/2.3, 100, 500);
        e.center_x = SPRITE_SIZE/6 + col * SPRITE_SIZE;
        e.center_y = SPRITE_SIZE/6 + row * SPRITE_SIZE;
        enemies.add(e);
      }
      else if(values[col].equals("7")){
        goalFlag = new Sprite(flag, SPRITE_SCALE*1);
        goalFlag.center_x = SPRITE_SIZE/6 + col * SPRITE_SIZE;
        goalFlag.center_y = SPRITE_SIZE/6 + row * SPRITE_SIZE;
        redFlag.add(goalFlag);
      }
    }
  }
}

  void checkPlayerEnemyCollision(){
      for (Enemy e : enemies) {
        if (checkCollision(player, e)) {
          playerIsDead = true;
          break;
        }
      }
    }
  
  void checkPlayerFlagCollision(){
    for(Sprite f: redFlag){
      if(checkCollision(player, goalFlag)){
        isDone = true;
      }
    }
  }
  
