/* ----------------------------------------------------------------
  Grid squares, attempt to some drawings
  Class "Algorithmus Zeichnen, by Frieder Nake at University Bremen
  University of Bremen - 05.10.2021
  Alberto Harres
---------------------------------------------------------------- */

int w = 600; // image width
int h = 600; // image height

int squareSize = 2; // size of each square in grid

int cols = w/squareSize;
int rows = h/squareSize;

// number of squares in images
int [][] matrix = new int[cols][rows];

// multiplies values to be used in % molude to make a probability 
int pCalc = 4;

void setup () {
  size(600, 600);
  noStroke();
  // frameRate(1);
  for (int y = 0; y < cols; y++) {
    for (int x = 0; x < rows; x++) {
      color c = 0;
      matrix[y][x] = c;
    }
  }
  initialShape();
}

void initialShape () {
  matrix[floor(random(cols))][floor(random(rows))] = 255;

}

void draw(){
  for (int y = 0; y < cols; y++) {
    for (int x = 0; x < rows; x++) {
      color c = matrix[y][x];
      fill(c); 
      // if (c == 255){
      boolean hasN = hasWhiteNeigbors(x, y);
      if (hasN) {
        if (c == 0) {
          fill(0, 0, 255);
        }
      }
      // }
      rect(x*squareSize, y*squareSize, squareSize, squareSize);
    }
  }
  calculate();
  if (frameCount % 2 == 0) {
    // saveFrame("frame-####.tiff");
  }
  pCalc = ceil(float(1+mouseX)/(w/60));
  println("pCalc", pCalc);
}

void calculate () {
  for (int y = 1; y < rows-1; y++) {
    for (int x = 1; x < cols-1; x++) {
      int prev_color = matrix[y][x];
      int new_color;
      
      // add probably of x and y axis
      int prob = calculateProb(x, y);

      if (prev_color > 100) { // if its black
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            matrix[y+ky][x+kx] = int(random(100)) % prob * (matrix[y+ky][x+kx] + 100);
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
  calculate();
  initialShape();
}
