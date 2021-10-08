/* ----------------------------------------------------------------
  Grid squares, attempt to some drawings
  Class "Algorithmus Zeichnen, by Frieder Nake at University Bremen
  University of Bremen - 05.10.2021
  Alberto Harres
---------------------------------------------------------------- */

int w = 800; // image width
int h = 800; // image height

int squareSize = 2; // size of each square in grid

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
  // frameRate(1);
  for (int y = 0; y < cols; y++) {
    for (int x = 0; x < rows; x++) {
      color c = 0;
      matrix[y][x] = c;
    }
  }
  //initialShape();
  colorMode(HSB, 360, 100, 255);
  reset();
}

void initialShape () {
  int x = floor(random(cols));
  int y = floor(random(rows));
  matrix[x][y] = 255;
  matrix_hue[x][y] = random(360);
  

}

void reset () {
   for (int y = 0; y < cols; y++) {
    for (int x = 0; x < rows; x++) {
      matrix[y][x] = 0;
      matrix_hue[y][x] = hue;
    }
  }
  hue = random(360);
  sat = random(100);
  
  
  hue_start = random(hue/2);
  initialShape();
}

void draw(){

  for (int y = 0; y < cols; y++) {
    for (int x = 0; x < rows; x++) {
      color c = matrix[y][x];
      
      fill(matrix_hue[y][x] % 360, sat, c, opacity); 
      
      boolean hasN = hasWhiteNeigbors(x, y);
      if (hasN) {
        if (c == 0) {
          fill(360-matrix_hue[y][x], 100 - sat, 100-c);
          matrix_hue[y][x] = (matrix_hue[y][x] + random(0, 1)) % 360;
        } else {
          matrix_hue[y][x] = (matrix_hue[y][x] - random(1, calculateProb(x, y))) % 360 ; 
        }
      }

      // matrix_hue[y][x] = hue;
      
      // }
      rect(x*squareSize, y*squareSize, squareSize, squareSize);
    }
  }
  if (run) calculate();
  if (frameCount % 2 == 0) {
    // saveFrame("frame-####.tiff");
  }
  // pCalc = ceil(float(1+mouseX)/(w/60));
  println("pCalc", pCalc);
}

void calculate () {
  for (int y = 1; y < rows-1; y++) {
    for (int x = 1; x < cols-1; x++) {
      int prev_color = matrix[y][x];
      float prev_hue = matrix_hue[y][x];
      int new_color;
      
      // add probably of x and y axis
      int prob = calculateProb(x, y);

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

      if (prev_color > 0 && prev_color < 255) {
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            matrix[y+ky][x+kx] = matrix[y+ky][x+kx] / 2;
            matrix_hue[y+ky][x+kx] = matrix_hue[y+ky][x+kx] + random(-2, 1);
          }
        }
      }
      
      // matrix[y][x] = new_color;
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

void keyPressed() {
  if (key == 'c') calculate();
  if (key == 'r') initialShape();
  if (key == 'w') pCalc++;
  if (key == 's' && pCalc > 2) pCalc--;
  if (key == 'p') run = !run;
  if (key == 'q') reset();
  if (key == 'd' && opacity < 254) opacity+=5;
  if (key == 'a' && opacity > 1) opacity-=5;
  // initialShape();
}
