package SingleDungeon.view
{
   import SingleDungeon.SingleDungeonManager;
   import SingleDungeon.event.SingleDungeonEvent;
   import SingleDungeon.model.SingleDungeonPlayerInfo;
   import SingleDungeon.model.WalkMapObject;
   import SingleDungeon.player.WalkMapPlayer;
   import bagAndInfo.cell.BaseCell;
   import church.view.churchScene.MoonSceneMap;
   import church.vo.SceneMapVO;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.sceneCharacter.SceneCharacterEvent;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import game.view.DropGoods;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   import worldboss.WorldBossManager;
   
   public class SingleDungeonSenceMap extends Sprite implements Disposeable
   {
      
      public static const SCENE_ALLOW_FIRES:int = 6;
       
      
      private const CLICK_INTERVAL:Number = 200;
      
      protected var articleLayer:Sprite;
      
      protected var meshLayer:Sprite;
      
      protected var objLayer:Sprite;
      
      protected var bgLayer:Sprite;
      
      public var sceneScene:SceneScene;
      
      protected var _data:DictionaryData;
      
      protected var _characters:DictionaryData;
      
      public var selfPlayer:WalkMapPlayer;
      
      private var last_click:Number;
      
      private var current_display_fire:int = 0;
      
      private var _mouseMovie:MovieClip;
      
      private var _currentLoadingPlayer:WalkMapPlayer;
      
      private var _isShowName:Boolean = true;
      
      private var _isChatBall:Boolean = true;
      
      private var _clickInterval:Number = 200;
      
      private var _lastClick:Number = 0;
      
      private var _sceneMapVO:SceneMapVO;
      
      public var armyPos:Point;
      
      protected var _mapObjs:DictionaryData;
      
      private var dropGoodsList:Array;
      
      private var player:WalkMapPlayer;
      
      public var clickedBox:MapObjView;
      
      public var collectionMC:MovieClip;
      
      public var isCollecting:Boolean;
      
      private var dictionary:DictionaryData;
      
      private var endPoint:Point;
      
      protected var reference:WalkMapPlayer;
      
      private var intervalIdDic:DictionaryData;
      
      public function SingleDungeonSenceMap(param1:SceneScene, param2:DictionaryData, param3:DictionaryData, param4:Sprite, param5:Sprite)
      {
         this.dropGoodsList = new Array();
         this.dictionary = new DictionaryData();
         this.endPoint = new Point();
         this.intervalIdDic = new DictionaryData();
         super();
         this.sceneScene = param1;
         this._data = param2;
         this._mapObjs = param3;
         if(param4 == null)
         {
            this.bgLayer = new Sprite();
         }
         else
         {
            this.bgLayer = param4;
         }
         this.meshLayer = param5 == null ? new Sprite() : param5;
         this.meshLayer.alpha = 0;
         this.articleLayer = new Sprite();
         this.objLayer = new Sprite();
         this.addChild(this.bgLayer);
         this.addChild(this.meshLayer);
         this.addChild(this.objLayer);
         this.addChild(this.articleLayer);
         this.articleLayer.mouseEnabled = false;
         this.articleLayer.mouseChildren = false;
         this.init();
         this.addEvent();
         this.addObject();
      }
      
      public function get sceneMapVO() : SceneMapVO
      {
         return this._sceneMapVO;
      }
      
      public function set sceneMapVO(param1:SceneMapVO) : void
      {
         this._sceneMapVO = param1;
      }
      
      protected function init() : void
      {
         this._characters = new DictionaryData(true);
         var _loc1_:Class = ClassUtils.uiSourceDomain.getDefinition("asset.singleDungeon.walkScene.MouseClickMovie") as Class;
         this._mouseMovie = new _loc1_() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this.bgLayer.addChild(this._mouseMovie);
         this.last_click = 0;
         this.collectionMC = ClassUtils.CreatInstance("asset.singleDungeon.collectionMC");
         this.collectionMC.x = 350;
         this.collectionMC.y = 480;
      }
      
      protected function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_OBJECT_CLICK,this.__onObjClickComplete);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DROP_GOODS,this.__onDropItemComplete);
         this.addEventListener(SingleDungeonEvent.START_COLLECT,this.__startCollect);
      }
      
      private function __startCollect(param1:SingleDungeonEvent) : void
      {
         if(param1.data[0] == null)
         {
            if(this.dictionary[this.clickedBox])
            {
               ObjectUtils.disposeObject(this.dictionary[this.clickedBox]);
            }
         }
         this.clickedBox = param1.data[0] as MapObjView;
         this.isCollecting = param1.data[1] as Boolean;
      }
      
      private function __onObjClickComplete(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Boolean = _loc2_.readBoolean();
         if(NewHandContainer.Instance.hasArrow(ArrowType.TIP_CHEST))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_CHEST);
         }
      }
      
      private function __onDropItemComplete(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:ItemTemplateInfo = null;
         var _loc12_:Sprite = null;
         var _loc13_:BaseCell = null;
         var _loc14_:Point = null;
         var _loc15_:DropGoods = null;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.bytesAvailable < 1)
         {
            return;
         }
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc2_.readInt();
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = _loc2_.readInt();
               _loc10_ = _loc2_.readInt();
               _loc9_ = EquipType.filterEquiqItemId(_loc9_);
               _loc11_ = ItemManager.Instance.getTemplateById(_loc9_);
               _loc12_ = new Sprite();
               _loc13_ = new BaseCell(_loc12_,_loc11_);
               _loc13_.setContentSize(40,40);
               _loc14_ = new Point(650,540);
               _loc15_ = new DropGoods(this,_loc13_,this.armyPos,globalToLocal(_loc14_),_loc10_);
               _loc15_.start(_loc15_.CHESTS_DROP);
               this.dropGoodsList.push(_loc15_);
               _loc8_++;
            }
            _loc6_++;
         }
      }
      
      protected function addObject() : void
      {
         var _loc2_:WalkMapObject = null;
         var _loc1_:QueueLoader = new QueueLoader();
         for each(_loc2_ in this._mapObjs)
         {
            _loc1_.addLoader(LoadResourceManager.instance.createLoader(PathManager.solveWalkSceneMapobjectsPath(_loc2_.Path),BaseLoader.MODULE_LOADER));
         }
         _loc1_.addEventListener(Event.COMPLETE,this.__onLoadComplete);
         _loc1_.start();
      }
      
      private function __onLoadComplete(param1:Event) : void
      {
         var _loc3_:WalkMapObject = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MapObjView = null;
         var _loc6_:Array = null;
         var _loc7_:Sprite = null;
         var _loc2_:QueueLoader = param1.currentTarget as QueueLoader;
         if(_loc2_.completeCount == this._mapObjs.length)
         {
            _loc2_.removeEvent();
            for each(_loc3_ in this._mapObjs)
            {
               _loc4_ = ClassUtils.CreatInstance("walkscene.mapobject." + _loc3_.Path);
               _loc5_ = new MapObjView(this,this.collectionMC);
               _loc5_.mapObjInfo = _loc3_;
               _loc5_.dispChild = _loc4_;
               this.objLayer.addChild(_loc5_);
               _loc6_ = _loc3_.MapXY.split(",");
               _loc5_.x = _loc6_[0];
               _loc5_.y = _loc6_[1];
               _loc7_ = new Sprite();
               _loc7_.graphics.beginFill(16711680);
               _loc7_.graphics.drawRect(_loc5_.x,_loc5_.y,_loc5_.width + 20,_loc5_.height + 20);
               _loc7_.graphics.endFill();
               _loc7_.y -= _loc5_.height - 20;
               _loc7_.x -= _loc7_.width / 2;
               this.meshLayer.addChild(_loc7_);
               this.dictionary.add(_loc5_,_loc7_);
            }
         }
      }
      
      protected function updateMap(param1:Event) : void
      {
         var _loc2_:WalkMapPlayer = null;
         if(!this._characters || this._characters.length <= 0)
         {
            return;
         }
         for each(_loc2_ in this._characters)
         {
            _loc2_.updatePlayer();
         }
         this.BuildEntityDepth();
      }
      
      protected function __click(param1:MouseEvent) : void
      {
         if(!this.selfPlayer)
         {
            return;
         }
         if(this.isCollecting)
         {
            return;
         }
         if(Mouse.cursor == MouseCursor.BUTTON)
         {
            return;
         }
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         var _loc3_:Point = this.globalToLocal(_loc2_);
         if(this.clickedBox && this.clickedBox.hitTestPoint(param1.stageX,param1.stageY))
         {
            this.playerMove(this.selfPlayer.playerPoint,_loc3_);
            return;
         }
         this.clickedBox = null;
         if(!this.sceneScene.hit(_loc3_))
         {
            if(_loc2_.x != this.endPoint.x)
            {
               this.playerMove(this.selfPlayer.playerPoint,_loc3_);
               this.endPoint = _loc2_;
            }
         }
      }
      
      private function playerMove(param1:Point, param2:Point) : void
      {
         this.selfPlayer.singleDungeonPlayerInfo.walkPath = this.sceneScene.searchPath(param1,param2);
         this.selfPlayer.singleDungeonPlayerInfo.walkPath.shift();
         this.selfPlayer.singleDungeonPlayerInfo.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint,this.selfPlayer.singleDungeonPlayerInfo.walkPath[0]);
         this.selfPlayer.singleDungeonPlayerInfo.currentWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
         this.sendMyPosition(this.selfPlayer.singleDungeonPlayerInfo.walkPath.concat());
         this._mouseMovie.x = param2.x;
         this._mouseMovie.y = param2.y;
         this._mouseMovie.play();
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
         SocketManager.Instance.out.sendWalkScenePlayerMove(param1[param1.length - 1].x,param1[param1.length - 1].y,_loc4_);
      }
      
      public function updatePlayersStauts(param1:int, param2:int, param3:Point) : void
      {
         var _loc4_:WalkMapPlayer = null;
         if(this._characters[param1])
         {
            _loc4_ = this._characters[param1] as WalkMapPlayer;
            if(param2 == 1 && _loc4_.singleDungeonPlayerInfo.playerStauts == 3)
            {
               _loc4_.singleDungeonPlayerInfo.playerStauts = param2;
            }
            else if(param2 == 2)
            {
               _loc4_.singleDungeonPlayerInfo.playerStauts = 1;
               _loc4_.singleDungeonPlayerInfo.playerStauts = param2;
               _loc4_.singleDungeonPlayerInfo.walkPath = [param3];
            }
            else
            {
               _loc4_.singleDungeonPlayerInfo.playerStauts = param2;
            }
         }
      }
      
      public function setCenter(param1:SceneCharacterEvent = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.reference)
         {
            _loc2_ = -(this.reference.x - MoonSceneMap.GAME_WIDTH / 2);
            _loc3_ = -(this.reference.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         }
         if(_loc2_ > 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ < MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW)
         {
            _loc2_ = MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW;
         }
         if(_loc3_ > 0)
         {
            _loc3_ = 0;
         }
         if(_loc3_ < MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH)
         {
            _loc3_ = MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH;
         }
         x = _loc2_;
         y = _loc3_;
      }
      
      public function addSelfPlayer() : void
      {
         var _loc1_:SingleDungeonPlayerInfo = null;
         if(!this.selfPlayer)
         {
            _loc1_ = new SingleDungeonPlayerInfo();
            _loc1_.playerPos = SingleDungeonManager.Instance.SelfPoint;
            _loc1_.playerInfo = PlayerManager.Instance.Self;
            this._currentLoadingPlayer = new WalkMapPlayer(_loc1_,this.addPlayerCallBack);
            this.player = this._currentLoadingPlayer;
            this.articleLayer.addChild(this.player.defaultBody);
            _loc1_.playerPos = _loc1_.playerPos;
            this.ajustScreen(this.player);
            this.setCenter();
         }
      }
      
      protected function ajustScreen(param1:WalkMapPlayer) : void
      {
         if(param1 == null)
         {
            if(this.reference)
            {
               this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
               this.reference = null;
            }
            return;
         }
         if(this.reference)
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         this.reference = param1;
         this.reference.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
      }
      
      protected function __addPlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:SingleDungeonPlayerInfo = param1.data as SingleDungeonPlayerInfo;
         this._currentLoadingPlayer = new WalkMapPlayer(_loc2_,this.addPlayerCallBack);
         this.articleLayer.addChild(this._currentLoadingPlayer.defaultBody);
      }
      
      private function addPlayerCallBack(param1:WalkMapPlayer, param2:Boolean) : void
      {
         var _loc3_:uint = 0;
         if(!this.articleLayer || !param1)
         {
            return;
         }
         this._currentLoadingPlayer = null;
         param1.sceneScene = this.sceneScene;
         param1.setSceneCharacterDirectionDefault = param1.sceneCharacterDirection = param1.singleDungeonPlayerInfo.scenePlayerDirection;
         if(!this.selfPlayer && param1.singleDungeonPlayerInfo.playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            param1.singleDungeonPlayerInfo.playerPos = param1.singleDungeonPlayerInfo.playerPos;
            this.selfPlayer = param1;
            this.articleLayer.addChild(this.selfPlayer);
            this.ajustScreen(this.selfPlayer);
            this.setCenter();
            this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         else
         {
            this.articleLayer.addChild(param1);
         }
         param1.playerPoint = param1.singleDungeonPlayerInfo.playerPos;
         param1.sceneCharacterStateType = "natural";
         this._characters.add(param1.singleDungeonPlayerInfo.playerInfo.ID,param1);
         param1.isShowName = true;
         if(param1.isRobot)
         {
            param1.playerPoint = this.getRobotinitPos();
            _loc3_ = setInterval(this.moveRobot,int(Math.random() * 2000 + 3000),param1.singleDungeonPlayerInfo.playerInfo.ID);
            this.intervalIdDic.add(param1.singleDungeonPlayerInfo.playerInfo.ID,_loc3_);
         }
         if(param1.defaultBody)
         {
            ObjectUtils.disposeObject(param1.defaultBody);
            param1.defaultBody = null;
         }
      }
      
      private function getRobotinitPos() : Point
      {
         var _loc1_:Point = new Point();
         while(1)
         {
            _loc1_.x = Math.random() * this.bgLayer.width / 2 + 200;
            _loc1_.y = Math.random() * this.bgLayer.height / 2 + 200;
            if(!this.sceneScene.hit(_loc1_))
            {
               break;
            }
         }
         return _loc1_;
      }
      
      private function moveRobot(param1:int) : void
      {
         var _loc2_:int = Math.random() * 300 + 100;
         var _loc3_:Array = [[0,_loc2_],[0,-_loc2_],[-_loc2_,0],[_loc2_,0],[-_loc2_ / 2,_loc2_ / 2],[_loc2_ / 2,-_loc2_ / 2],[-_loc2_ / 2,-_loc2_ / 2],[_loc2_ / 2,_loc2_ / 2]];
         var _loc4_:int = Math.random() * 8;
         var _loc5_:Point = this._characters[param1].playerPoint;
         var _loc6_:Point = new Point(_loc3_[_loc4_][0] + _loc5_.x,_loc3_[_loc4_][1] + _loc5_.y);
         var _loc7_:Array = this.sceneScene.searchPath(_loc5_,_loc6_);
         if(!this.sceneScene.hit(_loc6_) && _loc6_.x > 0 && _loc6_.x < this.bgLayer.width && _loc6_.y > 0 && _loc6_.y < this.bgLayer.height)
         {
            this.movePlayer(param1,_loc7_);
         }
      }
      
      public function movePlayer(param1:int, param2:Array) : void
      {
         var _loc3_:WalkMapPlayer = null;
         if(this._characters[param1])
         {
            _loc3_ = this._characters[param1] as WalkMapPlayer;
            _loc3_.singleDungeonPlayerInfo.playerStauts = 1;
            _loc3_.singleDungeonPlayerInfo.walkPath = param2;
            _loc3_.playerWalk(param2);
         }
      }
      
      private function playerActionChange(param1:SceneCharacterEvent) : void
      {
         var _loc3_:Point = null;
         var _loc2_:String = param1.data.toString();
         if(_loc2_ == "naturalStandFront" || _loc2_ == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
            if(this.clickedBox && !this.isCollecting)
            {
               _loc3_ = this.localToGlobal(new Point(this.selfPlayer.playerPoint.x,this.selfPlayer.playerPoint.y + 50));
               if(this.dictionary[this.clickedBox].hitTestPoint(_loc3_.x,_loc3_.y) || this.dictionary[this.clickedBox].hitTestObject(this.selfPlayer))
               {
                  this.clickedBox.openBox();
               }
            }
         }
      }
      
      protected function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:int = (param1.data as SingleDungeonPlayerInfo).playerInfo.ID;
         var _loc3_:WalkMapPlayer = this._characters[_loc2_] as WalkMapPlayer;
         this._characters.remove(_loc2_);
         clearInterval(this.intervalIdDic[_loc2_]);
         if(_loc3_)
         {
            if(_loc3_.parent)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
            _loc3_.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            _loc3_.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            _loc3_.dispose();
         }
         _loc3_ = null;
      }
      
      protected function BuildEntityDepth() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc1_:int = this.articleLayer.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_ - 1)
         {
            _loc3_ = this.articleLayer.getChildAt(_loc2_);
            _loc4_ = this.getPointDepth(_loc3_.x,_loc3_.y);
            _loc6_ = Number.MAX_VALUE;
            _loc7_ = _loc2_ + 1;
            while(_loc7_ < _loc1_)
            {
               _loc8_ = this.articleLayer.getChildAt(_loc7_);
               _loc9_ = this.getPointDepth(_loc8_.x,_loc8_.y);
               if(_loc9_ < _loc6_)
               {
                  _loc5_ = _loc7_;
                  _loc6_ = _loc9_;
               }
               _loc7_++;
            }
            if(_loc4_ > _loc6_)
            {
               this.articleLayer.swapChildrenAt(_loc2_,_loc5_);
            }
            _loc2_++;
         }
      }
      
      protected function getPointDepth(param1:Number, param2:Number) : Number
      {
         return this.sceneMapVO.mapW * param2 + param1;
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WALKSCENE_OBJECT_CLICK,this.__onObjClickComplete);
         if(this._data)
         {
            this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
            this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         }
         if(this.reference)
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         if(this.selfPlayer)
         {
            this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DROP_GOODS,this.__onDropItemComplete);
      }
      
      public function updateSelfStatus(param1:int) : void
      {
         if(this.selfPlayer.singleDungeonPlayerInfo.playerStauts == 3)
         {
            this.selfPlayer.singleDungeonPlayerInfo.playerPos = WorldBossManager.Instance.bossInfo.playerDefaultPos;
            this.ajustScreen(this.selfPlayer);
            this.setCenter();
         }
         this.selfPlayer.singleDungeonPlayerInfo.playerStauts = param1;
      }
      
      public function getLayerByIndex(param1:uint) : Sprite
      {
         switch(param1)
         {
            case 0:
               return this.bgLayer;
            case 1:
               return this.meshLayer;
            case 2:
               return this.objLayer;
            case 3:
               return this.articleLayer;
            default:
               return new Sprite();
         }
      }
      
      private function clearAllPlayer() : void
      {
         var p:WalkMapPlayer = null;
         var i:int = 0;
         var player:WalkMapPlayer = null;
         if(this.articleLayer)
         {
            i = this.articleLayer.numChildren;
            while(i > 0)
            {
               player = this.articleLayer.getChildAt(i - 1) as WalkMapPlayer;
               if(player)
               {
                  player.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
                  player.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
                  if(player.parent)
                  {
                     player.parent.removeChild(player);
                  }
                  player.dispose();
               }
               player = null;
               try
               {
                  this.articleLayer.removeChildAt(i - 1);
               }
               catch(e:RangeError)
               {
               }
               i--;
            }
            if(this.articleLayer && this.articleLayer.parent)
            {
               this.articleLayer.parent.removeChild(this.articleLayer);
            }
         }
         this.articleLayer = null;
         for each(p in this._characters)
         {
            p.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            p.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            p.dispose();
            ObjectUtils.disposeObject(p);
            p = null;
         }
         this._characters.clear();
         this._characters = null;
      }
      
      public function dispose() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:DropGoods = null;
         this.removeEvent();
         for each(_loc1_ in this.intervalIdDic)
         {
            clearInterval(_loc1_);
         }
         this.intervalIdDic.clear();
         this.intervalIdDic = null;
         if(this._mapObjs)
         {
            this._mapObjs.clear();
            this._mapObjs = null;
         }
         if(this.collectionMC)
         {
            ObjectUtils.disposeObject(this.collectionMC);
            this.collectionMC = null;
         }
         for each(_loc2_ in this.dropGoodsList)
         {
            if(_loc2_)
            {
               _loc2_.dispose();
            }
         }
         this.dropGoodsList.length = 0;
         this.dropGoodsList = null;
         if(this.dictionary)
         {
            this.dictionary.clear();
            this.dictionary = null;
         }
         if(this._data)
         {
            this._data.clear();
            this._data = null;
         }
         this.clearAllPlayer();
         ObjectUtils.disposeObject(this.selfPlayer);
         this.selfPlayer = null;
         ObjectUtils.disposeObject(this._currentLoadingPlayer);
         this._currentLoadingPlayer = null;
         ObjectUtils.disposeObject(this.player);
         this.player = null;
         ObjectUtils.disposeObject(this._mouseMovie);
         this._mouseMovie = null;
         ObjectUtils.disposeObject(this.meshLayer);
         this.meshLayer = null;
         ObjectUtils.disposeObject(this.bgLayer);
         this.bgLayer = null;
         ObjectUtils.disposeObject(this.clickedBox);
         this.clickedBox = null;
         ObjectUtils.disposeObject(this.objLayer);
         this.objLayer = null;
         ObjectUtils.disposeObject(this.sceneScene);
         this.sceneScene = null;
         ObjectUtils.disposeAllChildren(this);
         this._sceneMapVO = null;
         this.armyPos = null;
         if(parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
