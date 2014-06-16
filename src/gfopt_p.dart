part of Pong;

class GFOPTP {
  CanvasElement _canvas;
  CanvasRenderingContext2D _ctx;
  bool _play;
  
  List _players;
  Ball _ball;
  
  double _last;
  
  StreamSubscription _resize_window;
  Menu _menu;
  DivElement _div_toast;
    
  GFOPTP(this._menu, this._canvas) {
    print("GFOPTP contructor");
    this._ctx = this._canvas.context2D;
    this._play = false;
    this._players = <Player>[];
    
    this._players.add(new Player(1, 10.0, this._canvas.height / 2 - 30.0, 60));
    this._players.add(new Player(2, (800 - 20).toDouble(), this._canvas.height / 2 - 30, 60));
    
    this._ball = new Ball(this._canvas.width / 2, this._canvas.height / 2, 10);
    
    this._last = this._timestamp();
    
    window.onKeyDown.listen((KeyboardEvent keyboard_event) {
      Player player1 = this._players[0];
      Player player2 = this._players[1];
      if (keyboard_event.keyCode == 87)
        player1.up_down = -1;
      else if (keyboard_event.keyCode == 83)
        player1.up_down = 1;
      if (keyboard_event.keyCode == 38)
        player2.up_down = -1;
      else if (keyboard_event.keyCode == 40)
        player2.up_down = 1;
    });
    
    window.onKeyUp.listen((KeyboardEvent keyboard_event) {
      Player player1 = this._players[0];
      Player player2 = this._players[1];
      if (keyboard_event.keyCode == 87
          || keyboard_event.keyCode == 83)
        player1.up_down = 0;
      if (keyboard_event.keyCode == 40
          || keyboard_event.keyCode == 38)
        player2.up_down = 0;
      
      if (keyboard_event.keyCode == 32) {
        this._ball.tick_increase_speed.cancel();
        this._play = !this._play;
        if (this._play) {
          this._last = this._timestamp();
          this._ball.tick_increase_speed = new Timer.periodic(new Duration(seconds: 1), (Timer timer) => this._ball.increase_ball_speed(timer));
          gameLoop();
        }
      }
    });    
    gameLoop();
  }
  
  double _timestamp() {
    return (window.performance.now());
  }
  
  void _toast(String message) {
    DivElement div_message = new DivElement()
      ..classes.add("div_message")
      ..innerHtml = message;
    
    DivElement replay = new DivElement()
      ..classes.add("button_toast")
      ..onClick.listen((MouseEvent mouse_event) {
        print("replay");
        this._div_toast.remove();
        this._ball.tick_increase_speed.cancel();
        this._ball = new Ball(this._canvas.width / 2, this._canvas.height / 2, 10);
        this._players.forEach((Player player) {
          player.score = 0;
        });
        document.querySelector("#score_player_1").innerHtml = this._players[0].score.toString(); 
        document.querySelector("#score_player_2").innerHtml = this._players[1].score.toString(); 
        this._last = this._timestamp();
        this.gameLoop();
      })
      ..innerHtml = "Re-play";
    DivElement back_menu = new DivElement()
      ..classes.add("button_toast")
      ..onClick.listen((MouseEvent mouse_event) {
        print("back to menu");
        document.querySelector("#container").innerHtml = '';
        window.localStorage[Menu.GAME_STATE] = Menu.IN_MENU;
        this._div_toast.remove();
        this._menu._startInMenu();
      })
      ..innerHtml = "Back to menu";
    DivElement button_container = new DivElement()
      ..classes.add("button_container")
      ..append(replay)
      ..append(back_menu);
    
    this._div_toast = new DivElement()
      ..classes.add("toast")
      ..style.width = window.innerWidth.toString() + "px"
      ..style.height = window.innerHeight.toString() + "px"
      ..style.background = "rgba(0, 0, 0, 0.9)"
      ..append(div_message)
      ..append(button_container);

    this._resize_window = window.onResize.listen((Event event) {
      this._div_toast
        ..style.width = window.innerWidth.toString() + "px"
        ..style.height = window.innerHeight.toString() + "px";
    });
    
    document.body
      ..append(this._div_toast);
  }
  
  void gameLoop() {
    double now = this._timestamp();
    double dt = (now - this._last) / 1000;
    this._ctx.clearRect(0, 0, this._canvas.width, this._canvas.height);
    
    this._players.forEach((Player object) {
      object.update(this._canvas, dt);
      this._ctx.fillStyle = "#fff";
      object.draw(this._ctx);
    });
    int state = this._ball.update(this._canvas, this._players, dt);
    if (state == 0) {
      this._ball.draw(this._ctx);
    }
    else if (state == 1) {
      this._players[0].score += 1;
      document.querySelector("#score_player_1").innerHtml = this._players[0].score.toString();
      this._ball.tick_increase_speed.cancel();
      this._ball = new Ball(this._canvas.width / 2, this._canvas.height / 2, 10);
      if (this._players[0].score == 10) {
        this._toast("Player 1 win !");
        this._play = false;
      }
    }
    else if (state == 2) {
      this._players[1].score += 1;
      document.querySelector("#score_player_2").innerHtml = this._players[1].score.toString();       
      this._ball.tick_increase_speed.cancel();
      this._ball = new Ball(this._canvas.width / 2, this._canvas.height / 2, 10);
      if (this._players[1].score == 10) {
        this._toast("Player 2 win !");
        this._play = false;
      }
    }
    this._last = now;
    if (this._play)
      window.requestAnimationFrame((num ellapsed) => gameLoop());
  }
}