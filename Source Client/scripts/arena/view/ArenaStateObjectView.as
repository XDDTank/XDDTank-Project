package arena.view
{
   import arena.ArenaManager;
   import arena.model.ArenaEvent;
   import arena.model.ArenaPlayerStates;
   import arena.model.ArenaScenePlayerInfo;
   import arena.object.ArenaScenePlayer;
   import church.view.churchScene.MoonSceneMap;
   import church.vo.SceneMapVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.sceneCharacter.SceneCharacterEvent;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class ArenaStateObjectView extends Sprite implements Disposeable
   {
      
      public static const MAP_SIZE:Array = [3208,2000];
       
      
      private var _sceneScene:SceneScene;
      
      private var _mapLayer:Sprite;
      
      private var _playerLayer:Sprite;
      
      private var _maskLayer:Sprite;
      
      private var _mouseMovie:MovieClip;
      
      private var _currentLoadingPlayer:ArenaScenePlayer;
      
      private var _selfPlayer:ArenaScenePlayer;
      
      private var _playerDic:DictionaryData;
      
      private var _loadingPlayerInfo:ArenaScenePlayerInfo;
      
      private var _lastPoint:Point;
      
      private var _initPlayer:ArenaScenePlayer;
      
      protected var _reference:ArenaScenePlayer;
      
      public function ArenaStateObjectView()
      {
         this._lastPoint = new Point();
         super();
         this._playerDic = new DictionaryData();
         this._sceneScene = new SceneScene();
         this._mapLayer = new Sprite();
         addChild(this._mapLayer);
         this._playerLayer = new Sprite();
         this._playerLayer.mouseChildren = true;
         this._playerLayer.mouseEnabled = true;
         addChild(this._playerLayer);
         this._maskLayer = new Sprite();
         this._maskLayer.mouseEnabled = false;
         this._maskLayer.mouseChildren = false;
         addChild(this._maskLayer);
         this.initView();
         this.initEvent();
         this.addSelfPlayer();
      }
      
      public function update() : void
      {
         var _loc1_:ArenaScenePlayer = null;
         if(!this._loadingPlayerInfo)
         {
            this._loadingPlayerInfo = this.getLoadPlayerInfo();
         }
         this.initPlayer();
         for each(_loc1_ in this._playerDic)
         {
            if(ArenaManager.instance.model.playerDic.hasKey(_loc1_.playerInfo.ID))
            {
               _loc1_.updatePlayer();
            }
            else
            {
               if(_loc1_.defaultBody && this._playerLayer.contains(_loc1_.defaultBody))
               {
                  this._playerLayer.removeChild(_loc1_.defaultBody);
               }
               if(this._playerLayer.contains(_loc1_))
               {
                  this._playerLayer.removeChild(_loc1_);
               }
               this._playerDic.remove(_loc1_.playerInfo.ID);
               _loc1_ = null;
            }
         }
         this.checkHit();
         this.updatePlayerLevel();
      }
      
      private function getLoadPlayerInfo() : ArenaScenePlayerInfo
      {
         var _loc1_:ArenaScenePlayerInfo = null;
         var _loc3_:ArenaScenePlayerInfo = null;
         var _loc2_:DictionaryData = ArenaManager.instance.model.playerDic;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.playerInfo.ID != PlayerManager.Instance.Self.ID)
            {
               if(!this._playerDic.hasKey(_loc3_.playerInfo.ID))
               {
                  _loc1_ = _loc2_[_loc3_.playerInfo.ID];
               }
               continue;
            }
         }
         return _loc1_;
      }
      
      private function checkHit() : void
      {
         var _loc1_:ArenaScenePlayer = ArenaManager.instance.model.targetPlayer;
         if(_loc1_ != null)
         {
            if(this.selfPlayer && this.selfPlayer.hitTestObject(_loc1_))
            {
               this.selfPlayer.fight(_loc1_);
               ArenaManager.instance.model.targetPlayer = null;
            }
         }
      }
      
      public function set selfPlayer(param1:ArenaScenePlayer) : void
      {
         this._selfPlayer = param1;
      }
      
      public function get selfPlayer() : ArenaScenePlayer
      {
         return this._selfPlayer;
      }
      
      public function moveTo(param1:Point) : void
      {
         if(!this._sceneScene.hit(param1) && this.selfPlayer)
         {
            if(param1.x != this._lastPoint.x)
            {
               this.playerMove(this.selfPlayer.playerPoint,param1);
               this._lastPoint = param1;
            }
         }
      }
      
      private function playerMove(param1:Point, param2:Point) : void
      {
         if(this.selfPlayer.arenaPlayerInfo.playerStauts == ArenaPlayerStates.NORMAL || this.selfPlayer.arenaPlayerInfo.playerStauts == ArenaPlayerStates.INVINSIBLE)
         {
            this.selfPlayer.scenePlayerInfo.walkPath = this._sceneScene.searchPath(param1,param2);
            this.selfPlayer.scenePlayerInfo.walkPath.shift();
            this.selfPlayer.scenePlayerInfo.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint,this.selfPlayer.scenePlayerInfo.walkPath[0]);
            this.selfPlayer.scenePlayerInfo.currenWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
            this.sendMyPosition(this.selfPlayer.scenePlayerInfo.walkPath.concat());
            this._mouseMovie.x = param2.x;
            this._mouseMovie.y = param2.y;
            this._mouseMovie.play();
         }
      }
      
      public function sendMyPosition(param1:Array) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:Array = [];
         while(_loc3_ < param1.length)
         {
            _loc2_.push(int(param1[_loc3_].x),int(param1[_loc3_].y));
            _loc3_++;
         }
         var _loc4_:String = _loc2_.toString();
         ArenaManager.instance.sendMove(param1[param1.length - 1].x,param1[param1.length - 1].y,_loc4_);
      }
      
      private function initView() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc1_:MovieClip = ComponentFactory.Instance.creat("arena.scene.mapMc") as MovieClip;
         _loc2_ = _loc1_.getChildByName("mesh") as Sprite;
         _loc3_ = _loc1_.getChildByName("bg") as Sprite;
         _loc4_ = _loc1_.getChildByName("plantArea") as MovieClip;
         _loc5_ = _loc1_.getChildByName("plantArea") as MovieClip;
         _loc5_.alpha = 0.5;
         this._mouseMovie = ComponentFactory.Instance.creat("asset.walkScene.MouseClickMovie") as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this._mapLayer.addChild(_loc3_);
         this._mapLayer.addChild(_loc2_);
         this._mapLayer.addChild(this._mouseMovie);
         this._mapLayer.addChild(_loc4_);
         _loc2_.alpha = 0;
         this._maskLayer.addChild(_loc5_);
         this._sceneScene.setHitTester(new PathMapHitTester(_loc2_));
      }
      
      private function initEvent() : void
      {
         ArenaManager.instance.model.playerDic.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         ArenaManager.instance.model.playerDic.addEventListener(DictionaryEvent.UPDATE,this.__updatePlayer);
         ArenaManager.instance.model.addEventListener(ArenaEvent.UPDATE_SELF,this.__updateSelf);
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
      }
      
      protected function __mouseClick(param1:MouseEvent) : void
      {
         if(Mouse.cursor == MouseCursor.BUTTON)
         {
            return;
         }
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         var _loc3_:Point = globalToLocal(_loc2_);
         this.moveTo(_loc3_);
         if(!(param1.target as ArenaScenePlayer))
         {
            ArenaManager.instance.model.targetPlayer = null;
         }
      }
      
      private function updatePlayerLevel() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc1_:int = this._playerLayer.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_ - 1)
         {
            _loc3_ = this._playerLayer.getChildAt(_loc2_);
            _loc4_ = _loc2_ + 1;
            while(_loc4_ < _loc1_)
            {
               _loc5_ = this._playerLayer.getChildAt(_loc4_);
               if(_loc3_.hitTestObject(_loc5_))
               {
                  if(_loc3_.y > _loc5_.y)
                  {
                     if(this._playerLayer.getChildIndex(_loc3_) < this._playerLayer.getChildIndex(_loc5_))
                     {
                        this._playerLayer.swapChildren(_loc3_,_loc5_);
                     }
                  }
               }
               _loc4_++;
            }
            _loc2_++;
         }
      }
      
      private function initPlayer() : void
      {
         if(this._loadingPlayerInfo)
         {
            if(this._initPlayer == null || this._initPlayer.playerInfo.ID != this._loadingPlayerInfo.playerInfo.ID)
            {
               if(this._playerDic.hasKey(this._loadingPlayerInfo.playerInfo.ID))
               {
                  this._initPlayer = this._playerDic[this._loadingPlayerInfo.playerInfo.ID];
                  this._playerDic.remove(this._initPlayer);
                  ObjectUtils.disposeObject(this._initPlayer);
                  this._initPlayer = null;
               }
               if(ArenaManager.instance.model.playerDic.hasKey(this._loadingPlayerInfo.playerInfo.ID))
               {
                  this._initPlayer = new ArenaScenePlayer(this._loadingPlayerInfo,this.addPlayerCallBack);
                  this._playerLayer.addChild(this._initPlayer.defaultBody);
               }
            }
         }
      }
      
      private function addSelfPlayer() : void
      {
         var _loc1_:ArenaScenePlayerInfo = null;
         var _loc2_:ArenaScenePlayer = null;
         if(!this.selfPlayer)
         {
            _loc1_ = ArenaManager.instance.model.selfInfo;
            _loc2_ = new ArenaScenePlayer(_loc1_,this.addPlayerCallBack);
            this.ajustScreen(_loc2_);
            this.setCenter();
         }
      }
      
      private function __addPlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:ArenaScenePlayerInfo = param1.data as ArenaScenePlayerInfo;
         if(_loc2_.playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         var _loc3_:ArenaScenePlayer = new ArenaScenePlayer(_loc2_,this.addPlayerCallBack);
         this._playerLayer.addChild(_loc3_.defaultBody);
      }
      
      private function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:ArenaScenePlayerInfo = param1.data as ArenaScenePlayerInfo;
         var _loc3_:ArenaScenePlayer = this._playerDic[_loc2_.playerInfo.ID];
         this._playerDic.remove(_loc2_.playerInfo.ID);
         ObjectUtils.disposeObject(_loc3_);
         _loc3_ = null;
      }
      
      private function __updatePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:ArenaScenePlayerInfo = param1.data as ArenaScenePlayerInfo;
         if(this._playerDic.hasKey(_loc2_.playerInfo.ID))
         {
            this._playerDic[_loc2_.playerInfo.ID].arenaPlayerInfo = _loc2_;
            if(_loc2_.playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               this.selfPlayer.arenaPlayerInfo = _loc2_;
               this.selfPlayer.playerPoint = _loc2_.playerPos;
               this.setCenter();
            }
         }
      }
      
      private function __updateSelf(param1:ArenaEvent) : void
      {
         this.selfPlayer.arenaPlayerInfo = ArenaManager.instance.model.selfInfo;
         this.selfPlayer.playerPoint = ArenaManager.instance.model.selfInfo.playerPos;
         this.setCenter();
      }
      
      private function addPlayerCallBack(param1:ArenaScenePlayer, param2:Boolean) : void
      {
         if(!this._playerLayer || !param1)
         {
            return;
         }
         this._currentLoadingPlayer = null;
         param1.sceneScene = this._sceneScene;
         param1.setSceneCharacterDirectionDefault = param1.sceneCharacterDirection = param1.scenePlayerInfo.scenePlayerDirection;
         if(!this.selfPlayer && param1.scenePlayerInfo.playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            param1.scenePlayerInfo.playerPos = param1.scenePlayerInfo.playerPos;
            this.selfPlayer = param1;
            this.selfPlayer.scenePlayerInfo = ArenaManager.instance.model.selfInfo;
            this._playerLayer.addChild(this.selfPlayer);
            this.ajustScreen(this.selfPlayer);
            this.setCenter();
            this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.__playerActionChange);
            ArenaManager.instance.sendUpdate();
            ArenaManager.instance.model.addPlayerInfoRightNow(this.selfPlayer.playerInfo.ID,this.selfPlayer.arenaPlayerInfo);
            ArenaManager.instance.model.dispatchEvent(new ArenaEvent(ArenaEvent.ENTER_SCENE));
         }
         else
         {
            if(param1.defaultBody && this._playerLayer.contains(param1.defaultBody))
            {
               this._playerLayer.removeChild(param1.defaultBody);
            }
            if(this._playerLayer.contains(param1))
            {
               this._playerLayer.removeChild(param1);
            }
            if(ArenaManager.instance.model.playerDic.hasKey(param1.playerInfo.ID))
            {
               this._playerLayer.addChild(param1);
            }
         }
         param1.playerPoint = param1.scenePlayerInfo.playerPos;
         param1.sceneCharacterStateType = "natural";
         this._loadingPlayerInfo = null;
         this._initPlayer = null;
         if(ArenaManager.instance.model.playerDic.hasKey(param1.playerInfo.ID))
         {
            this._playerDic.add(param1.scenePlayerInfo.playerInfo.ID,param1);
         }
      }
      
      private function __playerActionChange(param1:SceneCharacterEvent) : void
      {
         var _loc2_:String = param1.data.toString();
         if(_loc2_ == "naturalStandFront" || _loc2_ == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
         }
      }
      
      protected function ajustScreen(param1:ArenaScenePlayer) : void
      {
         if(param1 == null)
         {
            if(this._reference)
            {
               this._reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
               this._reference = null;
            }
            return;
         }
         if(this._reference)
         {
            this._reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         this._reference = param1;
         this._reference.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
      }
      
      public function setCenter(param1:SceneCharacterEvent = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._reference)
         {
            _loc2_ = -(this._reference.x - MoonSceneMap.GAME_WIDTH / 2);
            _loc3_ = -(this._reference.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         }
         if(_loc2_ > 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ < MoonSceneMap.GAME_WIDTH - this.sceneMapVO.mapW)
         {
            _loc2_ = MoonSceneMap.GAME_WIDTH - this.sceneMapVO.mapW;
         }
         if(_loc3_ > 0)
         {
            _loc3_ = 0;
         }
         if(_loc3_ < MoonSceneMap.GAME_HEIGHT - this.sceneMapVO.mapH)
         {
            _loc3_ = MoonSceneMap.GAME_HEIGHT - this.sceneMapVO.mapH;
         }
         x = _loc2_;
         y = _loc3_;
      }
      
      public function get sceneMapVO() : SceneMapVO
      {
         var _loc1_:SceneMapVO = new SceneMapVO();
         _loc1_.mapW = MAP_SIZE[0];
         _loc1_.mapH = MAP_SIZE[1];
         _loc1_.defaultPos = new Point(100,100);
         return _loc1_;
      }
      
      private function removePlayer() : void
      {
         var _loc1_:ArenaScenePlayer = null;
         var _loc2_:int = this._playerDic.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this._playerDic.list[0];
            this._playerDic.remove(_loc1_.playerInfo.ID);
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
            _loc3_++;
         }
         this._initPlayer = null;
         this._playerDic = null;
      }
      
      private function removeEvent() : void
      {
         ArenaManager.instance.model.playerDic.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         ArenaManager.instance.model.playerDic.removeEventListener(DictionaryEvent.UPDATE,this.__updatePlayer);
         ArenaManager.instance.model.removeEventListener(ArenaEvent.UPDATE_SELF,this.__updateSelf);
         removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         if(this.selfPlayer)
         {
            this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.__playerActionChange);
         }
      }
      
      private function removeView() : void
      {
         this._sceneScene = null;
         ObjectUtils.disposeAllChildren(this._mapLayer);
         ObjectUtils.disposeObject(this._mapLayer);
         this._mapLayer = null;
         ObjectUtils.disposeAllChildren(this._playerLayer);
         ObjectUtils.disposeObject(this._playerLayer);
         this._playerLayer = null;
         ObjectUtils.disposeAllChildren(this._maskLayer);
         ObjectUtils.disposeObject(this._maskLayer);
         this._maskLayer = null;
         ObjectUtils.disposeObject(this._mouseMovie);
         this._mouseMovie = null;
      }
      
      public function dispose() : void
      {
         this._loadingPlayerInfo = null;
         this.removeEvent();
         this.removePlayer();
         this.removeView();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
