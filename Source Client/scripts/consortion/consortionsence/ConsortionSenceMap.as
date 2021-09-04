package consortion.consortionsence
{
   import church.view.churchScene.MoonSceneMap;
   import church.vo.SceneMapVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.IConsortionState;
   import consortion.data.MonsterInfo;
   import consortion.managers.ConsortionMonsterManager;
   import consortion.objects.ConsortionMonster;
   import consortion.view.selfConsortia.ConsortionSkillFrame;
   import consortion.view.selfConsortia.SelfConsortiaViewFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
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
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import worldboss.WorldBossManager;
   
   public class ConsortionSenceMap extends Sprite implements Disposeable, IConsortionState
   {
       
      
      protected var articleLayer:Sprite;
      
      protected var meshLayer:Sprite;
      
      protected var topLayer:Sprite;
      
      protected var objLayer:Sprite;
      
      protected var bgLayer:Sprite;
      
      protected var hallLayer:MovieClip;
      
      protected var shopLayer:MovieClip;
      
      protected var skillLayer:MovieClip;
      
      public var sceneScene:SceneScene;
      
      protected var _data:DictionaryData;
      
      protected var _characters:DictionaryData;
      
      protected var _monsters:DictionaryData;
      
      public var selfPlayer:ConsortionWalkPlayer;
      
      private var last_click:Number;
      
      private var _mouseMovie:MovieClip;
      
      private var _currentLoadingPlayer:ConsortionWalkPlayer;
      
      private var _clickInterval:Number = 200;
      
      private var _lastClick:Number = 0;
      
      private var _sceneMapVO:SceneMapVO;
      
      public var armyPos:Point;
      
      protected var _mapObjs:DictionaryData;
      
      private var player:ConsortionWalkPlayer;
      
      private var _shopBuild:MovieClip;
      
      private var _skillBuild:MovieClip;
      
      private var _hallBuild:MovieClip;
      
      private var _hallBtn:BaseButton;
      
      private var _shopBtn:BaseButton;
      
      private var _skillBtn:BaseButton;
      
      private var endPoint:Point;
      
      protected var reference:ConsortionWalkPlayer;
      
      public function ConsortionSenceMap(param1:SceneScene, param2:DictionaryData, param3:DictionaryData, param4:Sprite, param5:Sprite, param6:MovieClip = null, param7:MovieClip = null, param8:MovieClip = null, param9:Sprite = null)
      {
         this.endPoint = new Point();
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
         this.hallLayer = param6 == null ? new MovieClip() : param6;
         this.shopLayer = param7 == null ? new MovieClip() : param7;
         this.skillLayer = param8 == null ? new MovieClip() : param8;
         this.articleLayer = new Sprite();
         this.objLayer = new Sprite();
         this.topLayer = param9;
         this.addChild(this.bgLayer);
         this.addChild(this.meshLayer);
         this.addChild(this.objLayer);
         this.addChild(this.hallLayer);
         this.addChild(this.shopLayer);
         this.addChild(this.skillLayer);
         this.addChild(this.articleLayer);
         this.addChild(param9);
         this._hallBtn = ComponentFactory.Instance.creatComponentByStylename("consortionWalkMap.hallBtn");
         this._shopBtn = ComponentFactory.Instance.creatComponentByStylename("consortionWalkMap.shopBtn");
         this._skillBtn = ComponentFactory.Instance.creatComponentByStylename("consortionWalkMap.skillBtn");
         this.addChild(this._hallBtn);
         this.addChild(this._shopBtn);
         this.addChild(this._skillBtn);
         var _loc10_:Object = new Object();
         _loc10_["title"] = LanguageMgr.GetTranslation("ddt.consortionWalkMap.hallbuild.title");
         _loc10_["content"] = LanguageMgr.GetTranslation("ddt.consortionWalkMap.hallbuild.content");
         this._hallBtn.tipData = _loc10_;
         var _loc11_:Object = new Object();
         _loc11_["title"] = LanguageMgr.GetTranslation("ddt.consortionWalkMap.shopbuild.title");
         _loc11_["content"] = LanguageMgr.GetTranslation("ddt.consortionWalkMap.shopbuild.content");
         this._shopBtn.tipData = _loc11_;
         var _loc12_:Object = new Object();
         _loc12_["title"] = LanguageMgr.GetTranslation("ddt.consortionWalkMap.skillbuild.title");
         _loc12_["content"] = LanguageMgr.GetTranslation("ddt.consortionWalkMap.skillbuild.content");
         this._skillBtn.tipData = _loc12_;
         this.topLayer.mouseEnabled = false;
         this.topLayer.mouseChildren = false;
         this.articleLayer.mouseEnabled = true;
         this.articleLayer.mouseChildren = true;
         this.init();
         this.initPlayers();
         this.initBuild();
         this.addOjbect();
         this.addEvent();
      }
      
      private function initPlayers() : void
      {
         var _loc1_:ConsortionWalkPlayerInfo = null;
         for each(_loc1_ in this._data)
         {
            if(!this._characters.hasKey(_loc1_.playerInfo.ID))
            {
               this._currentLoadingPlayer = new ConsortionWalkPlayer(_loc1_,this.addPlayerCallBack);
               this.articleLayer.addChild(this._currentLoadingPlayer.defaultBody);
            }
         }
      }
      
      private function initBuild() : void
      {
         if(this.bgLayer != null && this.articleLayer != null)
         {
            this._hallBuild = this.hallLayer;
            this._hallBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__hallOver);
            this._hallBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__hallOut);
            this._hallBtn.addEventListener(MouseEvent.CLICK,this.__openHall);
            this._hallBuild.gotoAndStop(1);
            this._shopBuild = this.shopLayer;
            this._shopBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__shopOver);
            this._shopBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__shopOut);
            this._shopBtn.addEventListener(MouseEvent.CLICK,this.__openShop);
            this._shopBuild.gotoAndStop(1);
            this._skillBuild = this.skillLayer;
            this._skillBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__skillOver);
            this._skillBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__skillOut);
            this._skillBtn.addEventListener(MouseEvent.CLICK,this.__openSkill);
            this._skillBuild.gotoAndStop(1);
         }
      }
      
      private function __hallOver(param1:MouseEvent) : void
      {
         this._hallBuild.gotoAndStop(2);
      }
      
      private function __hallOut(param1:MouseEvent) : void
      {
         this._hallBuild.gotoAndStop(1);
      }
      
      private function __shopOver(param1:MouseEvent) : void
      {
         this._shopBuild.gotoAndStop(2);
      }
      
      private function __shopOut(param1:MouseEvent) : void
      {
         this._shopBuild.gotoAndStop(1);
      }
      
      private function __skillOver(param1:MouseEvent) : void
      {
         this._skillBuild.gotoAndStop(2);
      }
      
      private function __skillOut(param1:MouseEvent) : void
      {
         this._skillBuild.gotoAndStop(1);
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
         this._monsters = new DictionaryData(true);
         var _loc1_:Class = ClassUtils.uiSourceDomain.getDefinition("asset.walkScene.MouseClickMovie") as Class;
         this._mouseMovie = new _loc1_() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this.bgLayer.addChild(this._mouseMovie);
         this.last_click = 0;
      }
      
      protected function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         addEventListener(Event.ENTER_FRAME,this.__updateMap);
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._mapObjs.addEventListener(DictionaryEvent.ADD,this.__addMonster);
         this._mapObjs.addEventListener(DictionaryEvent.UPDATE,this.__onMonsterUpdate);
         this._mapObjs.addEventListener(DictionaryEvent.REMOVE,this.__removeMonster);
      }
      
      protected function addOjbect() : void
      {
         if(ConsortionMonsterManager.Instance.ActiveState)
         {
            SocketManager.Instance.out.sendAddMonsterRequest();
         }
      }
      
      protected function __updateMap(param1:Event) : void
      {
         var _loc2_:ConsortionWalkPlayer = null;
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
      
      private function __openHall(param1:MouseEvent) : void
      {
         var _loc2_:SelfConsortiaViewFrame = null;
         SoundManager.instance.play("008");
         _loc2_ = ComponentFactory.Instance.creatComponentByStylename("SelfConsortiaViewFrame");
         _loc2_.show();
      }
      
      private function __openShop(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.consortionStatus)
         {
            SocketManager.Instance.out.sendShopRefreshGood();
            ConsortionModelControl.Instance.alertShopFrame();
            return;
         }
         return MessageTipManager.getInstance().show("你的公会财富维持费不够,不能使用该建筑");
      }
      
      private function __openSkill(param1:MouseEvent) : void
      {
         var _loc2_:ConsortionSkillFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.consortionStatus)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("consortionSkillFrame");
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            return;
         }
         return MessageTipManager.getInstance().show("你的公会财富维持费不够,不能使用该建筑");
      }
      
      protected function __mouseClick(param1:MouseEvent) : void
      {
         if(!this.selfPlayer)
         {
            return;
         }
         if(Mouse.cursor == MouseCursor.BUTTON)
         {
            return;
         }
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         var _loc3_:Point = this.globalToLocal(_loc2_);
         var _loc4_:ConsortionMonster = ConsortionMonsterManager.Instance.curMonster;
         if(_loc4_ && _loc4_.hitTestPoint(param1.stageX,param1.stageY) && _loc4_.visible)
         {
            this.playerMove(this.selfPlayer.playerPoint,_loc3_);
            return;
         }
         ConsortionMonsterManager.Instance.curMonster = null;
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
         this.selfPlayer.consortionPlayerInfo.walkPath = this.sceneScene.searchPath(param1,param2);
         this.selfPlayer.consortionPlayerInfo.walkPath.shift();
         this.selfPlayer.consortionPlayerInfo.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint,this.selfPlayer.consortionPlayerInfo.walkPath[0]);
         this.selfPlayer.consortionPlayerInfo.currenWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
         this.sendMyPosition(this.selfPlayer.consortionPlayerInfo.walkPath.concat());
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
         SocketManager.Instance.out.SendConsortionWalkScenePlayeMove(param1[param1.length - 1].x,param1[param1.length - 1].y,_loc4_);
      }
      
      public function updatePlayerStauts(param1:int, param2:int, param3:Point) : void
      {
         var _loc4_:ConsortionWalkPlayer = null;
         if(this._characters[param1])
         {
            _loc4_ = this._characters[param1] as ConsortionWalkPlayer;
            if(param2 == 1 && _loc4_.consortionPlayerInfo.playerStauts == 3)
            {
               _loc4_.consortionPlayerInfo.playerStauts = param2;
            }
            else if(param2 == 2)
            {
               _loc4_.consortionPlayerInfo.playerStauts = 1;
               _loc4_.consortionPlayerInfo.playerStauts = param2;
               _loc4_.consortionPlayerInfo.walkPath = [param3];
            }
            else
            {
               _loc4_.consortionPlayerInfo.playerStauts = param2;
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
      
      protected function __addPlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:ConsortionWalkPlayerInfo = param1.data as ConsortionWalkPlayerInfo;
         this._currentLoadingPlayer = new ConsortionWalkPlayer(_loc2_,this.addPlayerCallBack);
         this.articleLayer.addChild(this._currentLoadingPlayer.defaultBody);
      }
      
      private function __addMonster(param1:DictionaryEvent) : void
      {
         var _loc2_:MonsterInfo = param1.data as MonsterInfo;
         var _loc3_:ConsortionMonster = new ConsortionMonster(_loc2_,_loc2_.MonsterPos);
         this._monsters.add(_loc2_.ID,_loc3_);
         this.articleLayer.addChild(_loc3_);
      }
      
      private function __onMonsterUpdate(param1:DictionaryEvent) : void
      {
         var _loc2_:MonsterInfo = param1.data as MonsterInfo;
         var _loc3_:ConsortionMonster = this._monsters[_loc2_.ID] as ConsortionMonster;
         if(_loc3_)
         {
            this._monsters.remove(_loc2_.ID);
            _loc3_.dispose();
         }
         var _loc4_:ConsortionMonster = new ConsortionMonster(_loc2_,_loc2_.MonsterPos);
         this._monsters.add(_loc2_.ID,_loc4_);
         this.articleLayer.addChild(_loc4_);
      }
      
      private function __removeMonster(param1:DictionaryEvent) : void
      {
         var _loc2_:MonsterInfo = param1.data as MonsterInfo;
         var _loc3_:ConsortionMonster = this._monsters[_loc2_.ID] as ConsortionMonster;
         this._monsters.remove(_loc2_.ID);
         _loc3_.dispose();
      }
      
      public function addSelfPlayer() : void
      {
         var _loc1_:ConsortionWalkPlayerInfo = null;
         if(!this.selfPlayer)
         {
            _loc1_ = new ConsortionWalkPlayerInfo();
            _loc1_.playerPos = ConsortionManager.Instance.SelfPoint;
            _loc1_.playerInfo = PlayerManager.Instance.Self;
            this._currentLoadingPlayer = new ConsortionWalkPlayer(_loc1_,this.addPlayerCallBack);
            this.player = this._currentLoadingPlayer;
            this.ajustScreen(this.player);
            this.setCenter();
         }
      }
      
      protected function ajustScreen(param1:ConsortionWalkPlayer) : void
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
      
      private function addPlayerCallBack(param1:ConsortionWalkPlayer, param2:Boolean) : void
      {
         if(!this.articleLayer || !param1)
         {
            return;
         }
         this._currentLoadingPlayer = null;
         param1.sceneScene = this.sceneScene;
         param1.setSceneCharacterDirectionDefault = param1.sceneCharacterDirection = param1.consortionPlayerInfo.scenePlayerDirection;
         if(!this.selfPlayer && param1.consortionPlayerInfo.playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            param1.consortionPlayerInfo.playerPos = param1.consortionPlayerInfo.playerPos;
            this.selfPlayer = param1;
            this.articleLayer.addChild(this.selfPlayer);
            this.ajustScreen(this.selfPlayer);
            this.setCenter();
            this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         else
         {
            this.articleLayer.removeChild(param1.defaultBody);
            this.articleLayer.addChild(param1);
         }
         param1.playerPoint = param1.consortionPlayerInfo.playerPos;
         param1.sceneCharacterStateType = "natural";
         param1.sceneCharacterActionType = "naturalStandFront";
         this._characters.add(param1.consortionPlayerInfo.playerInfo.ID,param1);
      }
      
      public function movePlayer(param1:int, param2:Array) : void
      {
         var _loc3_:ConsortionWalkPlayer = null;
         if(this._characters[param1])
         {
            _loc3_ = this._characters[param1] as ConsortionWalkPlayer;
            _loc3_.consortionPlayerInfo.playerStauts = 1;
            _loc3_.consortionPlayerInfo.walkPath = param2;
            _loc3_.playerWalk(param2);
         }
      }
      
      private function playerActionChange(param1:SceneCharacterEvent) : void
      {
         var _loc3_:ConsortionMonster = null;
         var _loc4_:Point = null;
         var _loc2_:String = param1.data.toString();
         if(_loc2_ == "naturalStandFront" || _loc2_ == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
            _loc3_ = ConsortionMonsterManager.Instance.curMonster;
            if(_loc3_ && _loc3_.MonsterState == MonsterInfo.LIVIN)
            {
               _loc4_ = this.localToGlobal(new Point(this.selfPlayer.playerPoint.x,this.selfPlayer.playerPoint.y + 50));
               if(_loc3_.hitTestPoint(_loc4_.x,_loc4_.y) || _loc3_.hitTestObject(this.selfPlayer))
               {
                  _loc3_.StartFight();
               }
            }
         }
      }
      
      protected function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:int = (param1.data as ConsortionWalkPlayerInfo).playerInfo.ID;
         var _loc3_:ConsortionWalkPlayer = this._characters[_loc2_] as ConsortionWalkPlayer;
         this._characters.remove(_loc2_);
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
         removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         removeEventListener(Event.ENTER_FRAME,this.__updateMap);
         if(this._data)
         {
            this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
            this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         }
         if(this._mapObjs)
         {
            this._mapObjs.removeEventListener(DictionaryEvent.ADD,this.__addMonster);
            this._mapObjs.removeEventListener(DictionaryEvent.UPDATE,this.__onMonsterUpdate);
            this._mapObjs.removeEventListener(DictionaryEvent.REMOVE,this.__removeMonster);
         }
         if(this.reference)
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         if(this.selfPlayer)
         {
            this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
      }
      
      public function updateSelfStatus(param1:int) : void
      {
         if(this.selfPlayer.consortionPlayerInfo.playerStauts == 3)
         {
            this.selfPlayer.consortionPlayerInfo.playerPos = WorldBossManager.Instance.bossInfo.playerDefaultPos;
            this.ajustScreen(this.selfPlayer);
            this.setCenter();
         }
         this.selfPlayer.consortionPlayerInfo.playerStauts = param1;
      }
      
      private function clearAllPlayer() : void
      {
         var p:ConsortionWalkPlayer = null;
         var o:ConsortionMonster = null;
         var i:int = 0;
         var player:ConsortionWalkPlayer = null;
         if(this.articleLayer)
         {
            i = this.articleLayer.numChildren;
            while(i > 0)
            {
               player = this.articleLayer.getChildAt(i - 1) as ConsortionWalkPlayer;
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
            ObjectUtils.disposeObject(p);
            p = null;
         }
         for each(o in this._monsters)
         {
            o.dispose();
            o = null;
         }
         this._monsters.clear();
         this._characters.clear();
         this._characters = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._mapObjs)
         {
            this._mapObjs.clear();
            this._mapObjs = null;
         }
         if(this._data)
         {
            this._data.clear();
            this._data = null;
         }
         this.clearAllPlayer();
         ObjectUtils.disposeObject(this.topLayer);
         this.topLayer = null;
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
         ObjectUtils.disposeObject(this.objLayer);
         this.objLayer = null;
         ObjectUtils.disposeObject(this.sceneScene);
         this.sceneScene = null;
         ObjectUtils.disposeAllChildren(this);
         this._sceneMapVO = null;
         if(parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
