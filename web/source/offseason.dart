part of TOTC;

class Offseason extends Sprite {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Fleet _fleet;
  
  Circle _teamACircle, _teamBCircle;
  Bitmap _background;
  Sprite _offseasonDock;
  List<Boat> _boats = new List<Boat>();
  
  Offseason(ResourceManager resourceManager, Juggler juggler, Game game, Fleet fleet) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _game = game;
    _fleet = fleet;

    _background = new Bitmap(_resourceManager.getBitmapData("OffseasonBackground"));
    _background.width = _game.width;
    _background.height = _game.height;
    
    _offseasonDock = new Sprite();
    Bitmap dock = new Bitmap(_resourceManager.getBitmapData("OffseasonDock"));
    BitmapData.load('images/offseason_dock.png').then((bitmapData) {
      _offseasonDock.x = _game.width/2-bitmapData.width/2;
      _offseasonDock.y = _game.height/2-bitmapData.height/2;
    });
    
    int offset = 70;
    _teamACircle = new Circle(_resourceManager, _juggler, _game, true);
    _teamBCircle = new Circle(_resourceManager, _juggler, _game, false);
    _teamACircle.x = offset;
    _teamACircle.y = offset;
    _teamACircle.rotation = math.PI;
    _teamBCircle.x = _game.width-offset;
    _teamBCircle.y = _game.height-offset;
    
    _game.tlayer.touchables.add(_teamACircle);
    _game.tlayer.touchables.add(_teamBCircle);
    
    addChild(_background);
    addChild(_offseasonDock);
    addChild(_teamACircle);
    addChild(_teamBCircle);
    _offseasonDock.addChild(dock);
    
    _fillDocks();
  }
  
  void _fillDocks() {
    
  }
} 

class Circle extends Sprite implements Touchable {
  static const CAPACITY = 1;
  static const SPEED = 2;
  static const TUNA = 3;
  static const SARDINE = 4;
  static const SHARK = 5;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  
  Bitmap _circle;
  SimpleButton _circleButton, _capacityButton, _speedButton, _tunaButton, _sardineButton, _sharkButton, _tempButton;
  
  bool _teamA;
  bool _upgradeMode = true;
  
  Tween _rotateTween;
  num _upgradeRotation;
  
  int _touchMode = 0;
  num _circleWidth;
  
  Circle(ResourceManager resourceManager, Juggler juggler, Game game, bool teamA) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _game = game;
    _teamA = teamA;
    
    if (teamA==true) _upgradeRotation = math.PI;
    else _upgradeRotation = 0;
    
    if (_teamA==true) _circle = new Bitmap(_resourceManager.getBitmapData("TeamACircle"));
    else _circle = new Bitmap(_resourceManager.getBitmapData("TeamBCircle"));
    
    _circleButton = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("CircleButtonUp")), 
                                     new Bitmap(_resourceManager.getBitmapData("CircleButtonUp")),
                                     new Bitmap(_resourceManager.getBitmapData("CircleButtonDown")), 
                                     new Bitmap(_resourceManager.getBitmapData("CircleButtonDown")));
    _circleButton.addEventListener(MouseEvent.MOUSE_UP, _circlePressed);
    _circleButton.addEventListener(TouchEvent.TOUCH_TAP, _circlePressed);
    _circleButton.addEventListener(TouchEvent.TOUCH_BEGIN, _circlePressed);

    _capacityButton = _returnCapacityButton();
    _capacityButton.addEventListener(MouseEvent.MOUSE_DOWN, _capacityPressed);
    _capacityButton.addEventListener(TouchEvent.TOUCH_TAP, _capacityPressed);
    _capacityButton.addEventListener(TouchEvent.TOUCH_BEGIN, _capacityPressed);
    
    _speedButton = _returnSpeedButton();
    _speedButton.addEventListener(MouseEvent.MOUSE_DOWN, _speedPressed);
    _speedButton.addEventListener(TouchEvent.TOUCH_TAP, _speedPressed);
    _speedButton.addEventListener(TouchEvent.TOUCH_BEGIN, _speedPressed);
    
    _tunaButton = _returnTunaButton();
    _tunaButton.addEventListener(MouseEvent.MOUSE_DOWN, _tunaPressed);
    _tunaButton.addEventListener(TouchEvent.TOUCH_TAP, _tunaPressed);
    _tunaButton.addEventListener(TouchEvent.TOUCH_BEGIN, _tunaPressed);
    
    _sardineButton = _returnSardineButton();
    _sardineButton.addEventListener(MouseEvent.MOUSE_DOWN, _sardinePressed);
    _sardineButton.addEventListener(TouchEvent.TOUCH_TAP, _sardinePressed);
    _sardineButton.addEventListener(TouchEvent.TOUCH_BEGIN, _sardinePressed);
    
    _sharkButton = _returnSharkButton();
    _sharkButton.addEventListener(MouseEvent.MOUSE_DOWN, _sharkPressed);
    _sharkButton.addEventListener(TouchEvent.TOUCH_TAP, _sharkPressed);
    _sharkButton.addEventListener(TouchEvent.TOUCH_BEGIN, _sharkPressed);
    
    
    BitmapData.load('images/teamACircle.png').then((bitmapData) {
       _circle.pivotX = bitmapData.width/2;
       _circle.pivotY = bitmapData.height/2;
       
       num w = width/1.3;
       _capacityButton.x = math.cos(math.PI*9/8)*w;
       _capacityButton.y = math.sin(math.PI*9/8)*w;
       _speedButton.x = math.cos(math.PI*8/6)*w;
       _speedButton.y = math.sin(math.PI*8/6)*w;
       w = width/2;
       _tunaButton.x = math.cos(0)*w;
       _tunaButton.y = math.sin(0)*w;
       _sardineButton.x = math.cos(math.PI*1/6.5)*w;
       _sardineButton.y = math.sin(math.PI*1/6.5)*w;
       _sharkButton.x = math.cos(math.PI*2/6)*w;
       _sharkButton.y = math.sin(math.PI*2/6)*w;
     });
     BitmapData.load('images/circleUIButton.png').then((bitmapData) {
       _circleButton.pivotX = bitmapData.width/2;
       _circleButton.pivotY = bitmapData.height/2;
     });
    
    addChild(_circle);
    addChild(_circleButton);
    addChild(_speedButton);
    addChild(_capacityButton);
    addChild(_tunaButton);
    addChild(_sardineButton);
    addChild(_sharkButton);
  }
  
  void _circlePressed(var e) {
    if (_juggler.contains(_rotateTween)) _juggler.remove(_rotateTween);
    _rotateTween = new Tween(this, 1, TransitionFunction.easeOutBounce);
    if (_upgradeMode==true) {
      _upgradeMode = false;
      _rotateTween.animate.rotation.to(_upgradeRotation+math.PI);
    }
    else {
      _upgradeMode = true;
      _rotateTween.animate.rotation.to(_upgradeRotation);
    }
    _juggler.add(_rotateTween);
  }
  
  void _speedPressed(var e) {
    _touchMode = SPEED;
  }
  void _capacityPressed(var e) {
    _touchMode = CAPACITY;
  }
  void _tunaPressed(var e) {
    _touchMode = TUNA;
  }
  void _sardinePressed(var e) {
    _touchMode = SARDINE;
  }
  void _sharkPressed(var e) {
    _touchMode = SHARK;
  }
  SimpleButton _returnSpeedButton() {
    return new SimpleButton(new Bitmap(_resourceManager.getBitmapData("SpeedUpgradeButton")), 
                           new Bitmap(_resourceManager.getBitmapData("SpeedUpgradeButton")),
                           new Bitmap(_resourceManager.getBitmapData("SpeedUpgradeButton")), 
                           new Bitmap(_resourceManager.getBitmapData("SpeedUpgradeButton")));
  }
  SimpleButton _returnCapacityButton() {
    return new SimpleButton(new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButton")), 
                           new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButton")),
                           new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButton")), 
                           new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButton")));
  }
  SimpleButton _returnTunaButton() {
    return new SimpleButton(new Bitmap(_resourceManager.getBitmapData("TunaBoatButton")), 
                            new Bitmap(_resourceManager.getBitmapData("TunaBoatButton")),
                            new Bitmap(_resourceManager.getBitmapData("TunaBoatButton")), 
                            new Bitmap(_resourceManager.getBitmapData("TunaBoatButton")));
  }
  SimpleButton _returnSharkButton() {
    return new SimpleButton(new Bitmap(_resourceManager.getBitmapData("SharkBoatButton")), 
                           new Bitmap(_resourceManager.getBitmapData("SharkBoatButton")),
                           new Bitmap(_resourceManager.getBitmapData("SharkBoatButton")), 
                           new Bitmap(_resourceManager.getBitmapData("SharkBoatButton")));
  }
  SimpleButton _returnSardineButton() {
    return new SimpleButton(new Bitmap(_resourceManager.getBitmapData("SardineBoatButton")), 
                            new Bitmap(_resourceManager.getBitmapData("SardineBoatButton")),
                            new Bitmap(_resourceManager.getBitmapData("SardineBoatButton")), 
                            new Bitmap(_resourceManager.getBitmapData("SardineBoatButton")));
  }
  
  bool containsTouch(Contact event) {
    if (_touchMode == 0) return false;
    else return true;
  }
  
  bool touchDown(Contact event) {
    return true;
  }

  void touchDrag(Contact event) {
    if (contains(_tempButton)) removeChild(_tempButton);
    if (_touchMode == CAPACITY) _tempButton = _returnCapacityButton();
    if (_touchMode == SPEED) _tempButton = _returnSpeedButton();
    if (_touchMode == TUNA) _tempButton = _returnTunaButton();
    if (_touchMode == SARDINE) _tempButton = _returnSardineButton();
    if (_touchMode == SHARK) _tempButton = _returnSharkButton();
    addChild(_tempButton);
    
    if (_upgradeMode==true) {
      if (_teamA == true) {
        _tempButton.x = -event.touchX;
        _tempButton.y = -event.touchY;
      } else {
        _tempButton.x = -_game.width+event.touchX;
        _tempButton.y = -_game.height+event.touchY;
      }
    } else {
      num offset = width/6.5;
      if (_teamA == true) {
        _tempButton.x = event.touchX-offset;
        _tempButton.y = event.touchY-offset;
      } else {
        _tempButton.x = _game.width-event.touchX-offset;
        _tempButton.y = _game.height-event.touchY-offset;
      }
      
      
    }
  }

  void touchSlide(Contact event) {
    // TODO: implement touchSlide
  }

  void touchUp(Contact event) {
    if (contains(_tempButton)) removeChild(_tempButton);
    _touchMode = 0;
  }
}