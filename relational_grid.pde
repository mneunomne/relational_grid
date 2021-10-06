/* ----------------------------------------------------------------
  Grid squares, attempt to some drawings
  Class "Algorithmus Zeichnen, by Frieder Nake at University Bremen
  University of Bremen - 05.10.2021
  Alberto Harres
---------------------------------------------------------------- */

int w = 800; // image width
int h = 800; // image height

int squareSize = 5; // size of each square in grid

int gridW = w/squareSize;
int gridH = h/squareSize;

// number of squares in images
int [][] matrix = new int[gridW][gridH];

// multiplies values to be used in % molude to make a probability 
int pCalc = 6;

void setup () {
  size(800, 800);
  noStroke();
  // frameRate(1);
  for (int y = 0; y < gridW; y++) {
    for (int x = 0; x < gridH; x++) {
      color c = 0;
      matrix[y][x] = c;
    }
  }
  initialShape();
}

void initialShape () {
  matrix[floor(random(gridW))][floor(random(gridH))] = 255;
}

void draw(){
  for (int y = 0; y < gridW; y++) {
    for (int x = 0; x < gridH; x++) {
      color c = matrix[y][x];
      fill(c); 
      rect(x*squareSize, y*squareSize, squareSize, squareSize);
    }
  }
  render();
}

void render () {
  for (int y = 1; y < gridH-1; y++) {
    for (int x = 1; x < gridW-1; x++) {
      int prev_color = matrix[y][x];
      int new_color;

      if (prev_color == 255) { // if its black
        // add probably of x and y axis
        int prob = calculateProb(x, y);

        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            matrix[y+ky][x+kx] = int(random(100)) % prob * 255;
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

int calculateProb (int x, int y) {
  int prob_y, prob_x;
  // centrilize probability X
  if (x > (gridH) / 2 ) {
    prob_x = ceil(float(gridW-x) / (gridW) * pCalc);
  } else {
    prob_x = ceil(float(x) / (gridW) * pCalc);
  }
  // centrilize probability Y
  if (y > (gridH) / 2 ) {
    prob_y = ceil(float(gridH-y) / (gridH) * pCalc);
  } else {
    prob_y = ceil(float(y) / (gridH) * pCalc);
  }
  return prob_y + prob_x;
}

void keyPressed() {
  render();
}
