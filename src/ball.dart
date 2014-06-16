part of Pong;

class Ball {
  double _x;
  double _y;
  
  double _last_x;
  
  int _width_height;
  
  double _decallage_x;
  double _decallage_y;
  
  Timer tick_increase_speed;
  
  Ball(this._x, this._y, this._width_height) {
    Random rand = new Random();
    this._decallage_x = rand.nextInt(120) - 60.0;
    if (this._decallage_x.isNegative)
      this._decallage_x -= 120;
    else
      this._decallage_x += 120;
    this._decallage_y = rand.nextInt(40) - 20.0;
    if (this._decallage_y.isNegative)
      this._decallage_y -= 40;
    else
      this._decallage_y += 40;
    this._last_x = this._x;
    this.tick_increase_speed = new Timer.periodic(new Duration(seconds: 1), (Timer timer) => this.increase_ball_speed(timer));
  }
  
  void increase_ball_speed(Timer timer) {
    if (this._decallage_x.isNegative)
      this._decallage_x -= 2;
    else 
      this._decallage_x += 2;
    if (this._decallage_y.isNegative)
      this._decallage_y -= 2;
    else
      this._decallage_y += 2;
  }

  void draw(CanvasRenderingContext2D ctx) {
    ctx
      ..beginPath()
      ..rect(this._x, this._y, this._width_height, this._width_height)
      ..fillStyle = '#fff'
      ..fill();
  }

  int update(CanvasElement canvas, List players, num ellapsed) {
    if (this._y + (this._decallage_y * ellapsed) < 0
        || this._y + (this._decallage_y * ellapsed) > canvas.height - this._width_height)
      this._decallage_y *= -1;
    else if (this._x + (this._decallage_x * ellapsed) < 0)
      return (2);
    else if (this._x + this._width_height + (this._decallage_x * ellapsed) > canvas.width)
      return (1);
    
    players.forEach((Player player) {
      if (player.y < (this._y + this._width_height) && (player.y + player.height) > this._y) {
        if (this._decallage_x.isNegative) {
          if (player.x + player.width >= this._x && player.x + player.width <= this._last_x)
            this._decallage_x *= -1;
        }
        else {
          if (player.x <= this._x + this._width_height && player.x >= this._last_x + this._width_height)
            this._decallage_x *= -1;
        }
      }
    });
    
    this._last_x = this._x;
    this._x += (this._decallage_x * ellapsed);
    this._y += (this._decallage_y * ellapsed);
    return (0);
  }
}