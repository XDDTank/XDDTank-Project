package consortion.transportSence
{
   import church.view.churchScene.MoonSceneMap;
   import church.vo.SceneMapVO;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.IConsortionState;
   import consortion.consortionsence.ConsortionWalkPlayer;
   import consortion.consortionsence.ConsortionWalkPlayerInfo;
   import consortion.event.ConsortionEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
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
   import game.GameManager;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import room.RoomManager;
   import room.model.RoomInfo;
   import roomList.pvpRoomList.RoomListBGView;
   import worldboss.WorldBossManager;
   
   public class TransportSenceMap extends Sprite implements Disposeable, IConsortionState
   {
       
      
      protected var articleLayer:Sprite;
      
      protected var meshLayer:Sprite;
      
      protected var objLayer:Sprite;
      
      protected var bgLayer:Sprite;
      
      public var sceneScene:SceneScene;
      
      protected var _data:DictionaryData;
      
      protected var _characters:DictionaryData;
      
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
      
      private var _remainPanel:TransportRemainPanel;
      
      private var _infoPanel:TransportInfoPanel;
      
      private var _waitTime:TransportHijackWaitTime;
      
      private var _playerLastY:int;
      
      private var _filterBtnGroup:SelectedButtonGroup;
      
      private var _filterBtnVBox:VBox;
      
      private var endPoint:Point;
      
      protected var reference:ConsortionWalkPlayer;
      
      public function TransportSenceMap(param1:SceneScene, param2:DictionaryData, param3:DictionaryData, param4:Sprite, param5:Sprite)
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
         this.addOjbect();
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
         this._playerLastY = 0;
         this._characters = new DictionaryData(true);
         var _loc1_:Class = ClassUtils.uiSourceDomain.getDefinition("asset.walkScene.MouseClickMovie") as Class;
         this._mouseMovie = new _loc1_() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this.bgLayer.addChild(this._mouseMovie);
         this._filterBtnGroup = new SelectedButtonGroup();
         this.last_click = 0;
         this.createUI();
      }
      
      private function createUI() : void
      {
         var _loc2_:SelectedCheckButton = null;
         this._remainPanel = ComponentFactory.Instance.creat("asset.transportSence.transportRemainPanel");
         LayerManager.Instance.addToLayer(this._remainPanel,LayerManager.GAME_UI_LAYER);
         this._remainPanel.__updateMyInfo();
         this._infoPanel = ComponentFactory.Instance.creat("asset.transportSence.transportInfoPanel");
         LayerManager.Instance.addToLayer(this._infoPanel,LayerManager.GAME_UI_LAYER);
         this._filterBtnVBox = ComponentFactory.Instance.creatComponentByStylename("consortion.transportSence.filterBtnVBox");
         LayerManager.Instance.addToLayer(this._filterBtnVBox,LayerManager.GAME_UI_LAYER);
         var _loc1_:uint = 0;
         while(_loc1_ < 2)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("consortion.transportSence.filterBtn");
            if(_loc1_ == 0)
            {
               _loc2_.text = LanguageMgr.GetTranslation("ddt.transport.filterBtn.showCanHijack.txt");
            }
            else
            {
               _loc2_.text = LanguageMgr.GetTranslation("ddt.transport.filterBtn.showAll.txt");
            }
            this._filterBtnGroup.addSelectItem(_loc2_);
            this._filterBtnVBox.addChild(_loc2_);
            _loc1_++;
         }
         this._filterBtnGroup.selectIndex = SharedManager.Instance.hijackCarFilter;
      }
      
      protected function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         addEventListener(Event.ENTER_FRAME,this.__updateMap);
         TransportManager.Instance.addEventListener(ConsortionEvent.TRANSPORT_ADD_CAR,this.__addNewCar);
         TransportManager.Instance.addEventListener(ConsortionEvent.TRANSPORT_REMOVE_CAR,this.__removeCar);
         TransportManager.Instance.addEventListener(ConsortionEvent.ENABLE_SENDCAR_BTN,this.__enableSendCarBtn);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HIJACK_ANSWER,this.__hijackAnswer);
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading,false,1);
         this._filterBtnGroup.addEventListener(Event.CHANGE,this.__filterBtnGroupChange);
      }
      
      private function __filterBtnGroupChange(param1:Event) : void
      {
         var _loc2_:TransportCar = null;
         var _loc3_:TransportCar = null;
         SoundManager.instance.play("008");
         SharedManager.Instance.hijackCarFilter = this._filterBtnGroup.selectIndex;
         SharedManager.Instance.save();
         if(this._filterBtnGroup.selectIndex == 0)
         {
            for each(_loc2_ in this._mapObjs)
            {
               if(!_loc2_.canHijack && _loc2_.info.ownerId != PlayerManager.Instance.Self.ID)
               {
                  _loc2_.visible = false;
               }
            }
         }
         else
         {
            for each(_loc3_ in this._mapObjs)
            {
               _loc3_.visible = true;
            }
         }
      }
      
      private function __hijackAnswer(param1:CrazyTankSocketEvent) : void
      {
         if(this._waitTime)
         {
            this._waitTime.dispose();
            this._waitTime = null;
         }
      }
      
      private function __startLoading(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         if(this._waitTime)
         {
            this._waitTime.dispose();
            this._waitTime = null;
         }
         StateManager.getInGame_Step_6 = true;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         LayerManager.Instance.clearnGameDynamic();
         GameManager.Instance.gotoRoomLoading();
         StateManager.getInGame_Step_7 = true;
         this.dispose();
      }
      
      protected function addOjbect() : void
      {
         var _loc1_:TransportCar = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         for each(_loc1_ in this._mapObjs)
         {
            _loc1_.createCarByType();
            _loc1_.x = TransportCar.MOVE_DISTANCE * _loc1_.info.movePercent + 85;
            _loc1_.y = Math.random() * 300 + 230;
            this.objLayer.addChild(_loc1_);
            if(this._filterBtnGroup.selectIndex == 0 && !_loc1_.canHijack && _loc1_.info.ownerId != PlayerManager.Instance.Self.ID)
            {
               _loc1_.visible = false;
            }
         }
         _loc2_ = 0;
         while(_loc2_ < this._mapObjs.list.length)
         {
            _loc3_ = this._mapObjs.list.length - 1;
            while(_loc3_ > _loc2_)
            {
               if(this._mapObjs.list[_loc3_ - 1].y > this._mapObjs.list[_loc3_].y)
               {
                  this.objLayer.swapChildren(this._mapObjs.list[_loc3_ - 1],this._mapObjs.list[_loc3_]);
               }
               _loc3_--;
            }
            _loc2_++;
         }
      }
      
      private function __addNewCar(param1:ConsortionEvent) : void
      {
         var _loc2_:TransportCar = null;
         var _loc4_:uint = 0;
         if(!this._mapObjs)
         {
            return;
         }
         _loc2_ = param1.data as TransportCar;
         _loc2_.createCarByType();
         _loc2_.x = TransportCar.MOVE_DISTANCE * _loc2_.info.movePercent + 85;
         _loc2_.y = Math.random() * 300 + 230;
         this._mapObjs.add(_loc2_.info.ownerId,_loc2_);
         this.objLayer.addChild(_loc2_);
         var _loc3_:uint = 0;
         while(_loc3_ < this._mapObjs.list.length)
         {
            _loc4_ = this._mapObjs.list.length - 1;
            while(_loc4_ > _loc3_)
            {
               if(this._mapObjs.list[_loc4_ - 1].y > this._mapObjs.list[_loc4_].y)
               {
                  this.objLayer.swapChildren(this._mapObjs.list[_loc4_ - 1],this._mapObjs.list[_loc4_]);
               }
               _loc4_--;
            }
            _loc3_++;
         }
         if(_loc2_.info.guarderId == PlayerManager.Instance.Self.ID)
         {
            this._remainPanel.setBeginBtnEnable(false);
            this.selfPlayer.playerPoint = new Point(_loc2_.x,_loc2_.y + 50);
            this.selfPlayer.consortionPlayerInfo.walkPath = [new Point(_loc2_.x,_loc2_.y + 50)];
            this.setCenter();
         }
         if(this._filterBtnGroup.selectIndex == 0 && !_loc2_.canHijack && _loc2_.info.ownerId != PlayerManager.Instance.Self.ID)
         {
            _loc2_.visible = false;
         }
      }
      
      private function __removeCar(param1:ConsortionEvent) : void
      {
         if(!this._mapObjs)
         {
            return;
         }
         var _loc2_:TransportCar = param1.data as TransportCar;
         if(this._mapObjs.hasKey(_loc2_.info.ownerId))
         {
            this._mapObjs.remove(_loc2_.info.ownerId);
            this.objLayer.removeChild(_loc2_);
            _loc2_.dispose();
         }
      }
      
      protected function __updateMap(param1:Event) : void
      {
         var _loc2_:ConsortionWalkPlayer = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(!this._characters || this._characters.length <= 0)
         {
            return;
         }
         for each(_loc2_ in this._characters)
         {
            _loc2_.updatePlayer();
         }
         if(this._playerLastY != this.selfPlayer.y)
         {
            this._playerLastY = this.selfPlayer.y;
            _loc3_ = this.objLayer.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = _loc3_ - 1;
               while(_loc5_ > _loc4_)
               {
                  if(this.objLayer.getChildAt(_loc5_ - 1).y > this.objLayer.getChildAt(_loc5_).y)
                  {
                     this.objLayer.swapChildren(this.objLayer.getChildAt(_loc5_ - 1),this.objLayer.getChildAt(_loc5_));
                  }
                  _loc5_--;
               }
               _loc4_++;
            }
         }
         this.BuildEntityDepth();
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
         this._mouseMovie.x = param2.x;
         this._mouseMovie.y = param2.y;
         this._mouseMovie.play();
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
      }
      
      public function addSelfPlayer() : void
      {
         var _loc1_:Point = null;
         var _loc2_:TransportCar = null;
         var _loc3_:ConsortionWalkPlayerInfo = null;
         if(!this.selfPlayer)
         {
            _loc1_ = new Point(274,615);
            for each(_loc2_ in this._mapObjs)
            {
               if(_loc2_.info.ownerId == PlayerManager.Instance.Self.ID)
               {
                  _loc1_ = new Point(_loc2_.x,_loc2_.y + 50);
               }
            }
            _loc3_ = new ConsortionWalkPlayerInfo();
            _loc3_.playerPos = _loc1_;
            _loc3_.playerInfo = PlayerManager.Instance.Self;
            this._currentLoadingPlayer = new ConsortionWalkPlayer(_loc3_,this.addPlayerCallBack);
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
            this.objLayer.addChild(this.selfPlayer);
            this.ajustScreen(this.selfPlayer);
            this.setCenter();
            this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         param1.playerPoint = param1.consortionPlayerInfo.playerPos;
         param1.sceneCharacterStateType = "natural";
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
         var _loc3_:TransportCar = null;
         var _loc4_:Point = null;
         var _loc2_:String = param1.data.toString();
         if(_loc2_ == "naturalStandFront" || _loc2_ == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
            _loc3_ = TransportManager.Instance.currentCar;
            if(_loc3_)
            {
               _loc4_ = this.localToGlobal(new Point(this.selfPlayer.playerPoint.x,this.selfPlayer.playerPoint.y + 50));
               if(_loc3_.hitTestPoint(_loc4_.x,_loc4_.y) || _loc3_.hitTestObject(this.selfPlayer))
               {
                  this.showConfirmAlert();
               }
            }
         }
      }
      
      private function __gameStart(param1:CrazyTankSocketEvent) : void
      {
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         GameInSocketOut.sendGameRoomSetUp(0,RoomInfo.HIJACK_CAR,false,"","",3,1,0,false,RoomManager.Instance.current.ID);
      }
      
      private function __onSetupChanged(param1:CrazyTankSocketEvent) : void
      {
         this._waitTime = new TransportHijackWaitTime();
         LayerManager.Instance.addToLayer(this._waitTime,LayerManager.GAME_TOP_LAYER);
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__onSetupChanged);
         SocketManager.Instance.out.SendHijackCar(TransportManager.Instance.currentCar.info.ownerId,RoomManager.Instance.current.ID);
         TransportManager.Instance.currentCar = null;
      }
      
      private function showConfirmAlert() : void
      {
         SoundManager.instance.play("008");
         var _loc1_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("consortion.ConsortionTransport.confirmHijack.alert.txt",TransportManager.Instance.currentCar.info.ownerName,TransportManager.Instance.currentCar.info.nickName),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
         _loc1_.moveEnable = false;
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         var _loc3_:BaseAlerFrame = null;
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.checkExpedition())
            {
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc3_.moveEnable = false;
               _loc3_.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse2);
            }
            else
            {
               RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
               RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__onSetupChanged);
               GameInSocketOut.sendCreateRoom(RoomListBGView.PREWORD[int(Math.random() * RoomListBGView.PREWORD.length)],RoomInfo.HIJACK_CAR,3);
            }
         }
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CANCEL_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            TransportManager.Instance.currentCar = null;
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __confirmResponse2(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendExpeditionCancle();
            RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
            RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__onSetupChanged);
            GameInSocketOut.sendCreateRoom(RoomListBGView.PREWORD[int(Math.random() * RoomListBGView.PREWORD.length)],RoomInfo.HIJACK_CAR,3);
         }
         if(param1.responseCode == FrameEvent.CANCEL_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            TransportManager.Instance.currentCar = null;
         }
         ObjectUtils.disposeObject(_loc2_);
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
      
      private function __enableSendCarBtn(param1:ConsortionEvent) : void
      {
         if(this._remainPanel)
         {
            this._remainPanel.setBeginBtnEnable(true);
         }
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         removeEventListener(Event.ENTER_FRAME,this.__updateMap);
         TransportManager.Instance.removeEventListener(ConsortionEvent.TRANSPORT_ADD_CAR,this.__addNewCar);
         TransportManager.Instance.removeEventListener(ConsortionEvent.TRANSPORT_REMOVE_CAR,this.__removeCar);
         TransportManager.Instance.removeEventListener(ConsortionEvent.ENABLE_SENDCAR_BTN,this.__enableSendCarBtn);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HIJACK_ANSWER,this.__hijackAnswer);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         this._filterBtnGroup.removeEventListener(Event.CHANGE,this.__filterBtnGroupChange);
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
         this._characters.clear();
         this._characters = null;
      }
      
      public function dispose() : void
      {
         var _loc1_:TransportCar = null;
         this.removeEvent();
         for each(_loc1_ in this._mapObjs)
         {
            _loc1_.dispose();
         }
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
         ObjectUtils.disposeObject(this._remainPanel);
         this._remainPanel = null;
         ObjectUtils.disposeObject(this._infoPanel);
         this._infoPanel = null;
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
         ObjectUtils.disposeObject(this._filterBtnGroup);
         this._filterBtnGroup = null;
         ObjectUtils.disposeAllChildren(this);
         this._sceneMapVO = null;
         if(parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
