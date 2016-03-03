float screen_width = 600.0;
float screen_height = 600.0;
float player_width = 100.0;
float player_height = 10.0;
float x1 = (screen_width / 2); //Center of player 1
float x2 = (screen_width / 2); //Center of player 2
float dx1 = 0.0; //Horizontal velocity player 1
float dx2 = 0.0; //Horizontal velocity player 2
float y1 = player_height; //Center of player 1
float y2 = screen_height - player_height; //Center of player 2
float ball_x = (screen_width  / 2); //Center of ball
float ball_y = (screen_height / 2); //Center of ball
float ball_w = 32.0; 
float ball_h = 32.0; 
float ball_dx =  0.0;
float ball_dy = -4.0;
boolean has_pressed_left_1  = false;
boolean has_pressed_right_1 = false;
boolean has_pressed_left_2  = false;
boolean has_pressed_right_2 = false;
boolean has_pressed_left_3  = false;
boolean has_pressed_right_3 = false;
boolean has_pressed_left_4  = false;
boolean has_pressed_right_4 = false;
color c1 = color(255, 0, 0);
color c2 = color(0, 0, 255);
int score1 = 0;
int score2 = 0;
void setup()
{
  textSize(32);
  size(600,600); //Must be equal to screen_width x screen_height 
}

void draw()
{
  move_all();
  draw_all();
  
}

void draw_all()
{
  background(0);

  //Score
  stroke(c1);
  fill(c1);
  text(score1, 1 * screen_width / 4, screen_height / 2);
  stroke(c2);
  fill(c2);
  text(score2, 3 * screen_width / 4, screen_height / 2);

  //Ball
  stroke(128); fill(255);
  ellipse(ball_x,ball_y,ball_w,ball_h);
  
  stroke(128); fill(c1);
  rect(x1 - (player_width / 2),y1 - (player_height / 2),player_width, player_height);
  
  stroke(128); fill(c2);
  rect(x2 - (player_width / 2),y2 - (player_height / 2),player_width, player_height);
}

void keyPressed() {
  if (key == 'a' || key == 'A') { has_pressed_left_1  = true; }
  if (key == 's' || key == 'S') { has_pressed_right_1 = true; }
  if (key == 'h' || key == 'H') { has_pressed_left_2  = true; }
  if (key == 'j' || key == 'J') { has_pressed_right_2 = true; }
  if (key == '\'' ) { has_pressed_left_3  = true; }
  if (key == '\\') { has_pressed_right_3 = true; }
  if (key == CODED) {
    if (keyCode == LEFT ) { has_pressed_left_4  = true; }
    if (keyCode == RIGHT) { has_pressed_right_4 = true; }
  }
}

void keyReleased() {
  if (key == 'a' || key == 'A') { has_pressed_left_1  = false; }
  if (key == 's' || key == 'S') { has_pressed_right_1 = false; }
  if (key == 'h' || key == 'H') { has_pressed_left_2  = false; }
  if (key == 'j' || key == 'J') { has_pressed_right_2 = false; }
  if (key == '\'' ) { has_pressed_left_3  = false; }
  if (key == '\\') { has_pressed_right_3 = false; }
  if (key == CODED) {
    if (keyCode == LEFT ) { has_pressed_left_4  = false; }
    if (keyCode == RIGHT) { has_pressed_right_4 = false; }
  }
}

void move_all()
{
  //The change in speed per key press per player
  float player_acceleration = 0.1;

  //The fraction of the horizontal speed that is maintained
  float player_friction = 0.99;
  
  //The horizontal speed of the player that is transmitted to the ball upon contact
  float fraction_transmitted = 0.1; 
  
 
  //Process active keys
  if (has_pressed_left_1 ) dx1 -= player_acceleration;
  if (has_pressed_right_1) dx1 += player_acceleration;
  if (has_pressed_left_2 ) dx2 -= player_acceleration;
  if (has_pressed_right_2) dx2 += player_acceleration;
  if (has_pressed_left_3 ) dx1 -= player_acceleration;
  if (has_pressed_right_3) dx1 += player_acceleration;
  if (has_pressed_left_4 ) dx2 -= player_acceleration;
  if (has_pressed_right_4) dx2 += player_acceleration;

  //When working together, exponentially increase speed
  if (has_pressed_left_1  && has_pressed_left_3 ) dx1 -= (2.0 * player_acceleration);
  if (has_pressed_right_1 && has_pressed_right_3) dx1 += (2.0 * player_acceleration);
  if (has_pressed_left_2  && has_pressed_left_4 ) dx2 -= (2.0 * player_acceleration);
  if (has_pressed_right_2 && has_pressed_right_4) dx2 += (2.0 * player_acceleration);

  //Change player velocities
  x1 += dx1;  
  x2 += dx2;  
  dx1 *= player_friction;
  dx2 *= player_friction;

  //Move players
  if (x1 - (player_width / 2) < 0) dx1 = abs(dx1); 
  if (x2 - (player_width / 2) < 0) dx2 = abs(dx2); 
  if (x1 + (player_width / 2) > screen_width) dx1 = -abs(dx1); 
  if (x2 + (player_width / 2) > screen_width) dx2 = -abs(dx2); 

  //Move ball
  ball_x += ball_dx; 
  ball_y += ball_dy; 

  //Bounce ball
  if (ball_x - (ball_w / 2) < 0) ball_dx = abs(ball_dx); 
  if (ball_x + (ball_w / 2) > screen_width) ball_dx = -abs(ball_dx); 
  if (ball_y - (ball_h / 2) < 0) 
  {
    ball_dy = abs(ball_dy);
    ++score2;
  }
  if (ball_y + (ball_h / 2) > screen_height) 
  {
    ball_dy = -abs(ball_dy); 
    ++score1;
  }
  //Check collision between players and ball
  if (ball_y - (ball_h / 2) < y1 + (player_height/2) 
    && ball_x > x1 - (player_width / 2)
    && ball_x < x1 + (player_width / 2)
  ) 
  { 
    ball_dy = abs(ball_dy); 
    ball_dx += (dx1 * fraction_transmitted); 
  } 
  if (ball_y + (ball_h / 2) > y2 - (player_height/2) 
    && ball_x > x2 - (player_width / 2)
    && ball_x < x2 + (player_width / 2)
  ) 
  { 
    ball_dy = -abs(ball_dy); 
    ball_dx += (dx2 * fraction_transmitted); 
  } 
}