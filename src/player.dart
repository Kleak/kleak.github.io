part of Pong;

class Player {
  int _id;
  
  double x;
  double y;
  int width;
  int height;
  
  int score;
  
  int up_down;
  
  Player(this._id, this.x, this.y, this.height) {
    this.width = 10;
    this.score = 0;
  }

  void draw(CanvasRenderingContext2D ctx) {
    ctx
      ..beginPath()
      ..rect(this.x, this.y, this.width, this.height)
      ..fillStyle = '#fff'
      ..fill();
  }

  void update(CanvasElement canvas, num ellapsed) {
    if (this.up_down == 1) {
      if (this.y + this.height + (100 * ellapsed) < canvas.height)
        this.y += (100 * ellapsed);
      else
        this.y = (canvas.height - this.height).toDouble();
    }
    else if (this.up_down == -1) {
      if (this.y - (100 * ellapsed) > 0)
        this.y -= (100 * ellapsed);
      else
        this.y = 0.0;
    }
    else
      this.up_down = 0;
  }
}
