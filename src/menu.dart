part of Pong;

class Menu {
  static String GAME_STATE = "GAME_STATE";
  static String IN_MENU = "IN_MENU";
  static String IN_GAME_ONE = "IN_GAME_ONE";
  static String IN_GAME_TWO = "IN_GAME_TWO";

  Map _initialisation_function;

  Menu() {
    this._initialisation_function = <String, Function> {};
    this._initialisation_function[Menu.IN_MENU] = this._startInMenu;
    this._initialisation_function[Menu.IN_GAME_ONE] = this._startInGameOne;
    this._initialisation_function[Menu.IN_GAME_TWO] = this._startInGameTwo;
    if (window.localStorage.containsKey(Menu.GAME_STATE)) {
      if (this._initialisation_function.containsKey(window.localStorage[Menu.GAME_STATE])) {
        Function function = this._initialisation_function[window.localStorage[Menu.GAME_STATE]];
        function();
      }
      else
        this._initialisation_function[Menu.IN_MENU]();
    }
    else
      this._initialisation_function[Menu.IN_MENU]();
    window.onBeforeUnload.listen((Event event) {
      return ("");
    });
  }

  void _startInMenu() {
    print("start in menu");
    DivElement flex = new DivElement()
      ..classes.add("flex");
    DivElement one = new DivElement()
      ..attributes["id"] = "one"
      ..classes.add("playbutton")
      ..innerHtml = "One Player One Pc"
      ..onClick.listen((MouseEvent mouse_event) {
        print("Not supported yet");
      });
    DivElement two = new DivElement()
      ..attributes["id"] = "two"
      ..classes.add("playbutton")
      ..innerHtml = "Two Player One Pc"
      ..onClick.listen((MouseEvent mouse_event) {
        document.querySelector("#container").innerHtml = '';
        this._startInGameTwo();
        window.localStorage[Menu.GAME_STATE] = Menu.IN_GAME_TWO;
      });
    flex
      ..append(one)
      ..append(two);
    
    document.querySelector("#container")
      ..append(flex);
  }
  
  void _startInGameOne() {
    print("start in game one");
    DivElement all_scores = new DivElement()
      ..classes.add("all_scores")
      ..innerHtml = 'Scores :';
    
    DivElement player1 = new DivElement()
      ..classes.add("player1")
      ..innerHtml = 'Player 1 :';
    DivElement player2 = new DivElement()
      ..classes.add("player2")
      ..innerHtml = 'Player 2 :';
    DivElement text_scores = new DivElement()
      ..classes.add("text_scores")
      ..append(player1)
      ..append(player2);
    
    DivElement score_player1 = new DivElement()
      ..classes.add("scoreplayer1")
      ..attributes["id"] = "score_player_1"
      ..innerHtml = '0';
    DivElement score_player2 = new DivElement()
      ..classes.add("scoreplayer2")
      ..attributes["id"] = "score_player_2"
      ..innerHtml = '0';
    DivElement scores = new DivElement()
      ..classes.add("scores")
      ..append(score_player1)
      ..append(score_player2);
    
    CanvasElement canvas = new CanvasElement(width: 800, height: 600)
      ..classes.add("canvas");
    
    document.querySelector("#container")
      ..append(all_scores)
      ..append(text_scores)
      ..append(scores)
      ..append(canvas);
  }
  
  void _startInGameTwo() {
    print("start in game two");
    DivElement all_scores = new DivElement()
      ..classes.add("all_scores")
      ..innerHtml = 'Scores :';
    
    DivElement player1 = new DivElement()
      ..classes.add("player1")
      ..innerHtml = 'Player 1 :';
    DivElement player2 = new DivElement()
      ..classes.add("player2")
      ..innerHtml = 'Player 2 :';
    DivElement text_scores = new DivElement()
      ..classes.add("text_scores")
      ..append(player1)
      ..append(player2);
    
    DivElement score_player1 = new DivElement()
      ..classes.add("scoreplayer1")
      ..attributes["id"] = "score_player_1"
      ..innerHtml = '0';
    DivElement score_player2 = new DivElement()
      ..classes.add("scoreplayer2")
      ..attributes["id"] = "score_player_2"
      ..innerHtml = '0';
    DivElement scores = new DivElement()
      ..classes.add("scores")
      ..append(score_player1)
      ..append(score_player2);
    
    CanvasElement canvas = new CanvasElement(width: 800, height: 600)
      ..classes.add("canvas");
    
    document.querySelector("#container")
      ..append(all_scores)
      ..append(text_scores)
      ..append(scores)
      ..append(canvas);
    
    GFOPTP game = new GFOPTP(this, canvas);
  }
}
