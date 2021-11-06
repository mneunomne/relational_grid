/* ----------------------------------------------------------------
  Grid squares, attempt to some drawings
  Class "Algorithmus Zeichnen, by Frieder Nake at University Bremen
  University of Bremen - 05.10.2021
  Alberto Harres
---------------------------------------------------------------- */

int w = 800; // image width
int h = 800; // image height

int squareSize = 8; // size of each square in grid

int opacity = 255;

int cols = w/squareSize;
int rows = h/squareSize;

boolean run = true;


float hue_start;
float hue;
float sat; 

// number of squares in images
int [][] matrix = new int[cols][rows];
float [][] matrix_hue = new float[cols][rows];

// multiplies values to be used in % molude to make a probability 
int pCalc = 4;

void setup () {
  size(800,800);
  noStroke();
  // set initial values of the color matrix
  for (int y = 0; y < cols; y++) {
    for (int x = 0; x < rows; x++) {
      color c = 0; // in this case, always zero
      matrix[y][x] = c;
    }
  }
  // set color mode as HSB
  colorMode(HSB, 360, 100, 255);
  reset();
}

// Pick initial ooint for the drawing to start  
void initialShape () {
  int x = floor(random(cols));
  int y = floor(random(rows));
  matrix[x][y] = 255;
  matrix_hue[x][y] = random(360);
}

void reset () {
  // set initial matrix value for both hue and brightness grid
  for (int y = 0; y < cols; y++) {
    for (int x = 0; x < rows; x++) {
      matrix[y][x] = 0;
      matrix_hue[y][x] = hue;
    }
  }
  // set general hue and saturation value as random for each iteration
  hue = random(360);
  sat = random(100);
  // initial hue
  hue_start = random(hue/2);
  initialShape();
}

void draw(){

  for (int y = 0; y < cols; y++) {
    for (int x = 0; x < rows; x++) {
      color c = matrix[y][x];
      
      fill(matrix_hue[y][x] % 360, sat, c, opacity); 
      
      boolean hasN = hasWhiteNeigbors(x, y);
      // if pixel has "white" neigbors
      if (hasN) {
        // if the pixel itself is black
        if (c == 0) {
          // then color itself with its inveted brighness
          fill(360-matrix_hue[y][x], 100 - sat, 100-c);
          matrix_hue[y][x] = (matrix_hue[y][x] + random(0, 1)) % 360;
        } else {
          //if its not black, have a probability of 
          matrix_hue[y][x] = (matrix_hue[y][x] - random(1, calculateProb(x, y))) % 360 ; 
        }
      }
      // draw "pixel"
      rect(x*squareSize, y*squareSize, squareSize, squareSize);
    }
  }
  if (run) calculate();
}

void calculate () {
  for (int y = 1; y < rows-1; y++) {
    for (int x = 1; x < cols-1; x++) {
      int prev_color = matrix[y][x];
      float prev_hue = matrix_hue[y][x];
      int new_color;
      
      // add probably of x and y axis
      int prob = calculateProb(x, y);
      
      // if the pixel is white, change its brighness to a new random level, and change hue tiny bit backwards 
      if (prev_color == 255) { 
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            matrix[y+ky][x+kx] = int(random(100)) % prob * 255;
            matrix_hue[y+ky][x+kx] = prev_hue + random(-1, 2);
          }
        }
        new_color = prev_color / 2;
        // end if black
        matrix[y][x] = new_color;
      }
      // if pixel is not white or black, devide the brightness of all its neigbors by 2
      // and change the hue a tiny bit foward
      if (prev_color > 0 && prev_color < 255) {
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            matrix[y+ky][x+kx] = matrix[y+ky][x+kx] / 2;
            matrix_hue[y+ky][x+kx] = matrix_hue[y+ky][x+kx] + random(-2, 1);
          }
        }
      }
      
    }
  }
}

void recursive_calc() {
  for (int y = 1; y < rows-1; y++) {
    for (int x = 1; x < cols-1; x++) {
      int prev_color = matrix[y][x];
      if (prev_color == 255) {
         
      }
    }
  }
}

// Check the sum brightness of its neigbors
boolean hasWhiteNeigbors (int x, int y) {
  int sum=0;
  for(int ky = max(0, y-1); ky <= min(y+1, cols-1); ky++){
    for(int kx = max(0, x-1); kx <= min(x+1, rows-1); kx++){
      if(x != kx || y != ky){
        sum += matrix[ky][kx];
      }
    }
  }
  return sum == 0;
}

// calculate the probability level based on the position of the pixel
int calculateProb (int x, int y) {
  int prob_y, prob_x;
  // centrilize probability X
  if (x > (rows) / 2 ) {
    prob_x = ceil(float(cols-x) / (cols) * pCalc);
  } else {
    prob_x = ceil(float(x) / (cols) * pCalc);
  }
  // centrilize probability Y
  if (y > (rows) / 2 ) {
    prob_y = ceil(float(rows-y) / (rows) * pCalc);
  } else {
    prob_y = ceil(float(y) / (rows) * pCalc);
  }
  return prob_y + prob_x;
}

// debug controlls
void keyPressed() {
  if (key == 'c') calculate();
  if (key == 'r') initialShape();
  if (key == 'w') pCalc++;
  if (key == 's' && pCalc > 2) pCalc--;
  if (key == 'p') run = !run;
  if (key == 'q') reset();
  if (key == 'd' && opacity < 254) opacity+=5;
  if (key == 'a' && opacity > 1) opacity-=5;
}
