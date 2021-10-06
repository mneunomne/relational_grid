/*
Grid squares, attempt to some drawings
Class "Algorithmus Zeichnen, by Frieder Nake at University Bremen
05.10.2021
*/

int w = 800; // image width
int h = 800; // image height

int squareSize = 5; // size of each square in grid

// number of squares in images
int [][] matrix = new int[w/squareSize][h/squareSize];


int pCalc = 8;

void setup () {
  size(800, 800);
  noStroke();
  // frameRate(1);
  for (int y = 0; y < w/squareSize; y++) {
    for (int x = 0; x < h/squareSize; x++) {
      color c = 0;
      matrix[y][x] = c;
    }
  }
}

void draw(){
  for (int y = 0; y < w/squareSize; y++) {
    for (int x = 0; x < h/squareSize; x++) {
      color c = matrix[y][x];
      fill(c); 
      rect(x*squareSize, y*squareSize, squareSize, squareSize);
    }
  }
  //go();
}

void go() {
  for (int y = 1; y < h/squareSize-1; y++) {
    for (int x = 1; x < w/squareSize-1; x++) {
      int prev_color = matrix[y][x]; // previous color
      int new_color;
      if (prev_color == 0) { // if its black
        // int prob = ceil(y * 4 / h/squareSize) + ceil(x * 4 / w/squareSize);
        int prob_y, prob_x;
        if (x > (h/squareSize) / 2 ) {
          prob_x = ceil(float(w/squareSize-x) / (w/squareSize) * pCalc);
        } else {
          prob_x = ceil(float(x) / (w/squareSize) * pCalc);
        }
        if (y > (h/squareSize) / 2 ) {
          prob_y = ceil(float(h/squareSize-y) / (h/squareSize) * pCalc);
        } else {
          prob_y = ceil(float(y) / (h/squareSize) * pCalc);
        }
        
        int prob = prob_y + prob_x;
        int sum = 0;
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            sum += matrix[y+ky][x+kx];
            matrix[y+ky][x+kx] = int(random(100)) % prob * 255;
          }
        }
        
        new_color = int(random(100)) % 2 * 255;
      } else { // if its not white
        new_color = prev_color/2;
      }
      
      matrix[y][x] = new_color;
    }
  }
}

void keyPressed() {
  go();
}
