package room.view.roomView
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.RoomEvent;
   import ddt.events.TaskEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import hall.FightPowerAndFatigue;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.RoomPlayerItem;
   import room.view.bigMapInfoPanel.MatchRoomBigMapInfoPanel;
   import room.view.smallMapInfoPanel.MatchRoomSmallMapInfoPanel;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class MatchRoomView extends BaseRoomView
   {
      
      private static const MATCH_NPC:int = 40;
      
      private static const BOTH_MODE_ALERT_TIME:int = 60;
      
      private static const DISABLE_RETURN:int = 20;
      
      private static const MATCH_NPC_ENABLE:Boolean = false;
       
      
      private var _bg:Bitmap;
      
      private var _itemListBg:MovieClip;
      
      private var _bigMapInfoPanel:MatchRoomBigMapInfoPanel;
      
      private var _smallMapInfoPanel:MatchRoomSmallMapInfoPanel;
      
      private var _playerItemContainer:SimpleTileList;
      
      private var _crossZoneBtn:SelectedButton;
      
      private var _timerII:Timer;
      
      private var _alert1:BaseAlerFrame;
      
      private var _alert2:BaseAlerFrame;
      
      private var _ItemArr:Array;
      
      public function MatchRoomView(param1:RoomInfo)
      {
         this._timerII = new Timer(1000);
         super(param1);
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_NPC,this.__onFightNpc);
         _info.addEventListener(RoomEvent.ALLOW_CROSS_CHANGE,this.__crossZoneChangeHandler);
         this._bigMapInfoPanel.addEventListener(RoomEvent.TWEENTY_SEC,this.__onTweentySec);
         this._crossZoneBtn.addEventListener(MouseEvent.CLICK,this.__crossZoneClick);
         this._timerII.addEventListener(TimerEvent.TIMER,this.__onTimer);
         addEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_NPC,this.__onFightNpc);
         _info.removeEventListener(RoomEvent.ALLOW_CROSS_CHANGE,this.__crossZoneChangeHandler);
         this._bigMapInfoPanel.removeEventListener(RoomEvent.TWEENTY_SEC,this.__onTweentySec);
         this._crossZoneBtn.removeEventListener(MouseEvent.CLICK,this.__crossZoneClick);
         this._timerII.removeEventListener(TimerEvent.TIMER,this.__onTimer);
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         if(this._alert1)
         {
            this._alert1.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         if(this._alert2)
         {
            this._alert2.removeEventListener(FrameEvent.RESPONSE,this.__onResponseII);
         }
      }
      
      private function __loadWeakGuild(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         TaskManager.instance.addEventListener(TaskEvent.ROOMLIST_REFLASH,this.showStart);
         this.showStart();
      }
      
      private function showStart(param1:TaskEvent = null) : void
      {
         if(SavePointManager.Instance.isInSavePoint(14) && !TaskManager.instance.isNewHandTaskCompleted(10) || SavePointManager.Instance.isInSavePoint(17) && !TaskManager.instance.isNewHandTaskCompleted(13) || SavePointManager.Instance.isInSavePoint(18) && !TaskManager.instance.isNewHandTaskCompleted(14) || SavePointManager.Instance.isInSavePoint(55) && !TaskManager.instance.isNewHandTaskCompleted(27))
         {
            NewHandContainer.Instance.clearArrowByID(-1);
            NewHandContainer.Instance.showArrow(ArrowType.START_GAME,-45,"trainer.startGameArrowPos","asset.trainer.startGameTipAsset","trainer.startGameTipPos",this);
         }
         if(SavePointManager.Instance.isInSavePoint(15) || SavePointManager.Instance.isInSavePoint(19) || SavePointManager.Instance.isInSavePoint(26))
         {
            NewHandContainer.Instance.showArrow(ArrowType.EXIT_MATCHROOM,-45,"trainer.exitMatchRoomArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
         }
      }
      
      private function showWait() : void
      {
         if(SavePointManager.Instance.isInSavePoint(14))
         {
            NewHandContainer.Instance.clearArrowByID(-1);
            NewHandContainer.Instance.showArrow(ArrowType.WAIT_GAME,-45,"trainer.startGameArrowPos","asset.trainer.txtWait","trainer.startGameTipPos",this);
         }
      }
      
      private function userGuideAlert(param1:int, param2:String) : void
      {
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation(param2),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__responseTip);
         SocketManager.Instance.out.syncWeakStep(param1);
      }
      
      private function __responseTip(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__responseTip);
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __crossZoneChangeHandler(param1:RoomEvent) : void
      {
         this._crossZoneBtn.selected = _info.isCrossZone;
         if(_info.isCrossZone)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView.cross.kuaqu"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView.cross.benqu"));
         }
      }
      
      private function __onTweentySec(param1:RoomEvent) : void
      {
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            return;
         }
         _cancelBtn.enable = true;
      }
      
      private function __onTimer(param1:TimerEvent) : void
      {
         if(MATCH_NPC_ENABLE && this._timerII.currentCount == MATCH_NPC && _info.selfRoomPlayer.isHost)
         {
            this.showMatchNpc();
         }
         if(_info.gameMode == RoomInfo.GUILD_MODE && this._timerII.currentCount == BOTH_MODE_ALERT_TIME && _info.selfRoomPlayer.isHost)
         {
            this.showBothMode();
         }
      }
      
      private function showMatchNpc() : void
      {
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc1_.data = LanguageMgr.GetTranslation("tank.room.PickupPanel.ChangeStyle");
         this._alert1 = AlertManager.Instance.alert("SimpleAlert",_loc1_,LayerManager.ALPHA_BLOCKGOUND);
         this._alert1.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         var _loc2_:ChatData = null;
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            GameInSocketOut.sendGameStyle(2);
            _loc2_ = new ChatData();
            _loc2_.channel = ChatInputView.SYS_TIP;
            _loc2_.msg = LanguageMgr.GetTranslation("tank.room.UpdateGameStyle");
            ChatManager.Instance.chat(_loc2_);
         }
         this._alert1.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._alert1.dispose();
      }
      
      override protected function __startHandler(param1:RoomEvent) : void
      {
         super.__startHandler(param1);
         NewHandContainer.Instance.clearArrowByID(ArrowType.START_GAME);
         NewHandContainer.Instance.clearArrowByID(ArrowType.EXIT_MATCHROOM);
         if(_info.started)
         {
            FightPowerAndFatigue.Instance.fightPowerBtnEnable = false;
            this._timerII.start();
            this.showWait();
         }
         else
         {
            FightPowerAndFatigue.Instance.fightPowerBtnEnable = true;
            this._timerII.stop();
            this._timerII.reset();
            this.showStart();
         }
      }
      
      private function showBothMode() : void
      {
         this._alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.PickupPanel.ChangeStyle"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         this._alert2.addEventListener(FrameEvent.RESPONSE,this.__onResponseII);
      }
      
      private function __onResponseII(param1:FrameEvent) : void
      {
         var _loc2_:ChatData = null;
         SoundManager.instance.play("008");
         this._alert2.removeEventListener(FrameEvent.RESPONSE,this.__onResponseII);
         this._alert2.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            GameInSocketOut.sendGameStyle(2);
            _loc2_ = new ChatData();
            _loc2_.channel = ChatInputView.SYS_TIP;
            _loc2_.msg = LanguageMgr.GetTranslation("tank.room.UpdateGameStyle");
            ChatManager.Instance.chat(_loc2_);
         }
      }
      
      private function __crossZoneClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendGameRoomSetUp(_info.mapId,_info.type,false,_info.roomPass,_info.roomName,3,0,0,!_info.isCrossZone,0);
         this._crossZoneBtn.selected = _info.isCrossZone;
      }
      
      private function __onFightNpc(param1:CrazyTankSocketEvent) : void
      {
         this.showMatchNpc();
      }
      
      override protected function updateButtons() : void
      {
         super.updateButtons();
         this._crossZoneBtn.enable = _info.selfRoomPlayer.isHost && !_info.started;
         this._smallMapInfoPanel._actionStatus = _info.selfRoomPlayer.isHost && !_info.started;
      }
      
      override protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.background.room.rightBg");
         PositionUtils.setPos(this._bg,"asset.ddtmatchroom.bgPos");
         addChild(this._bg);
         this._itemListBg = ClassUtils.CreatInstance("asset.ddtroom.playerItemlist.bg") as MovieClip;
         PositionUtils.setPos(this._itemListBg,"asset.ddtroom.playerItemlist.bgPos");
         this._bigMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddtroom.matchRoomBigMapInfoPanel");
         this._bigMapInfoPanel.info = _info;
         addChild(this._bigMapInfoPanel);
         this._crossZoneBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.crossZoneButton");
         this._crossZoneBtn.selected = _info.isCrossZone;
         this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddtroom.matchRoomSmallMapInfoPanel");
         this._smallMapInfoPanel.info = _info;
         this.updateItemPos();
         super.initView();
         addChild(this._smallMapInfoPanel);
      }
      
      private function updateItemPos() : void
      {
         this._ItemArr = [ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos1"),ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos2"),ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos3")];
      }
      
      override protected function initTileList() : void
      {
         var _loc3_:int = 0;
         var _loc4_:RoomPlayerItem = null;
         super.initTileList();
         this._playerItemContainer = new SimpleTileList(2);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.matchRoom.listSpace");
         this._playerItemContainer.hSpace = _loc1_.x;
         this._playerItemContainer.vSpace = _loc1_.y;
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerListPos");
         this._playerItemContainer.x = this._bg.x + _loc2_.x;
         this._playerItemContainer.y = this._bg.y + _loc2_.y;
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            _loc4_ = new RoomPlayerItem(_loc3_);
            _loc4_.x = this._ItemArr[_loc3_].x;
            _loc4_.y = this._ItemArr[_loc3_].y;
            addChild(_loc4_);
            _playerItems.push(_loc4_);
            _loc3_++;
         }
         if(isViewerRoom)
         {
            PositionUtils.setPos(_viewerItems[0],"asset.ddtmatchroom.ViewerItemPos");
            addChild(_viewerItems[0]);
         }
      }
      
      override protected function __addPlayer(param1:RoomEvent) : void
      {
         var _loc2_:RoomPlayer = param1.params[0] as RoomPlayer;
         if(_loc2_.isFirstIn)
         {
            SoundManager.instance.play("158");
         }
         if(_loc2_.isViewer)
         {
            _viewerItems[_loc2_.place - 6].info = _loc2_;
         }
         else
         {
            _playerItems[_loc2_.place].info = _loc2_;
            PlayerManager.Instance.dispatchEvent(new Event(PlayerManager.UPDATE_ROOMPLAYER));
         }
         this.updateButtons();
      }
      
      override protected function __removePlayer(param1:RoomEvent) : void
      {
         var _loc2_:RoomPlayer = param1.params[0] as RoomPlayer;
         if(_loc2_.place >= 6)
         {
            _viewerItems[_loc2_.place - 6].info = null;
         }
         else
         {
            _playerItems[_loc2_.place].info = null;
         }
         _loc2_.dispose();
         this.updateButtons();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         NewHandContainer.Instance.clearArrowByID(ArrowType.EXIT_MATCHROOM);
         TaskManager.instance.removeEventListener(TaskEvent.ROOMLIST_REFLASH,this.showStart);
         if(this._bg)
         {
            removeChild(this._bg);
         }
         this._bg = null;
         this._bigMapInfoPanel.dispose();
         this._bigMapInfoPanel = null;
         this._smallMapInfoPanel.dispose();
         this._smallMapInfoPanel = null;
         this._playerItemContainer.dispose();
         this._playerItemContainer = null;
         this._crossZoneBtn.dispose();
         this._crossZoneBtn = null;
         if(this._alert1)
         {
            this._alert1.dispose();
         }
         this._alert1 = null;
         if(this._alert2)
         {
            this._alert2.dispose();
         }
         this._alert2 = null;
      }
   }
}
