package room.view.roomView
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.data.map.DungeonInfo;
   import ddt.events.RoomEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.RoomDupSimpleTipFram;
   import room.view.RoomPlayerItem;
   import room.view.bigMapInfoPanel.DungeonBigMapInfoPanel;
   import room.view.chooseMap.DungeonChooseMapFrame;
   import room.view.smallMapInfoPanel.DungeonSmallMapInfoPanel;
   
   public class DungeonRoomView extends BaseRoomView
   {
       
      
      private var _bg:Bitmap;
      
      private var _bigMapInfoPanel:DungeonBigMapInfoPanel;
      
      private var _smallMapInfoPanel:DungeonSmallMapInfoPanel;
      
      private var _btnSwitchTeam:BaseButton;
      
      private var _ItemArr:Array;
      
      private var _singleAlsert:BaseAlerFrame;
      
      public function DungeonRoomView(param1:RoomInfo)
      {
         super(param1);
      }
      
      override protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.background.dungeonroom.rightBg");
         PositionUtils.setPos(this._bg,"asset.ddtmatchroom.bgPos");
         addChild(this._bg);
         this._bigMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddt.dungeonRoom.BigMapInfoPanel");
         this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("ddt.dungeonRoom.SmallMapInfoPanel");
         this._smallMapInfoPanel.info = _info;
         this._btnSwitchTeam = ComponentFactory.Instance.creatComponentByStylename("asset.ddtChallengeRoom.switchTeamBtn");
         addChild(this._btnSwitchTeam);
         this._btnSwitchTeam.visible = false;
         this.updateItemPos();
         super.initView();
         addChild(this._bigMapInfoPanel);
         addChild(this._smallMapInfoPanel);
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         addEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
      }
      
      override protected function __prepareClick(param1:MouseEvent) : void
      {
         super.__prepareClick(param1);
         if(PlayerManager.Instance.Self.dungeonFlag[_info.mapId] && PlayerManager.Instance.Self.dungeonFlag[_info.mapId] == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.reduceGains"));
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.room.RoomIIController.reduceGains"));
         }
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
      }
      
      private function __loadWeakGuild(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
      }
      
      private function updateItemPos() : void
      {
         this._ItemArr = [ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos1"),ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos2"),ComponentFactory.Instance.creatCustomObject("asset.ddtroomPlayerItem.Pos3")];
      }
      
      override protected function initTileList() : void
      {
         var _loc2_:RoomPlayerItem = null;
         super.initTileList();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = new RoomPlayerItem(_loc1_);
            _loc2_.x = this._ItemArr[_loc1_].x;
            _loc2_.y = this._ItemArr[_loc1_].y;
            addChild(_loc2_);
            _playerItems.push(_loc2_);
            _loc1_++;
         }
         if(isViewerRoom)
         {
            PositionUtils.setPos(_viewerItems[0],"asset.ddtchallengeroom.ViewerItemPos_0");
            PositionUtils.setPos(_viewerItems[1],"asset.ddtchallengeroom.ViewerItemPos_1");
            addChild(_viewerItems[0]);
            addChild(_viewerItems[1]);
         }
      }
      
      override protected function __startClick(param1:MouseEvent) : void
      {
         if(!_info.isAllReady())
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this.checkCanStartGame())
         {
            startGame();
         }
      }
      
      override protected function checkCanStartGame() : Boolean
      {
         var _loc2_:DungeonChooseMapFrame = null;
         var _loc1_:DungeonInfo = MapManager.getDungeonInfo(_info.mapId);
         if(super.checkCanStartGame())
         {
            if(_info.type == RoomInfo.FRESHMAN_ROOM)
            {
               return true;
            }
            if(_info.mapId == 17)
            {
               this._singleAlsert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.randomConfirm"),"",LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               this._singleAlsert.moveEnable = false;
               this._singleAlsert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               return false;
            }
            if(_info.mapId == 0 || _info.mapId == 10000)
            {
               _loc2_ = new DungeonChooseMapFrame();
               _loc2_.show();
               dispatchEvent(new RoomEvent(RoomEvent.OPEN_DUNGEON_CHOOSER));
               return false;
            }
            if(_loc1_ && _loc1_.Type == MapManager.PVE_CHANGE_MAP && RoomManager.Instance.current.players.length - RoomManager.Instance.current.currentViewerCnt < 3)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView2.clewContent.change"));
               return false;
            }
            if(_loc1_ && _loc1_.Type == MapManager.PVE_MULTISHOOT && RoomManager.Instance.current.players.length - RoomManager.Instance.current.currentViewerCnt < 3)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView2.clewContent.change"));
               return false;
            }
            if(RoomManager.Instance.current.players.length - RoomManager.Instance.current.currentViewerCnt == 1 && _loc1_.Type != MapManager.PVE_ACADEMY_MAP)
            {
               this._singleAlsert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.clewContent"),"",LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               this._singleAlsert.moveEnable = false;
               this._singleAlsert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               return false;
            }
            if(_loc1_.Type == MapManager.PVE_ACADEMY_MAP && !super.academyDungeonAllow())
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         this._singleAlsert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._singleAlsert.dispose();
         this._singleAlsert = null;
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            startGame();
         }
      }
      
      override protected function kickHandler() : void
      {
         GameInSocketOut.sendGameRoomSetUp(10000,RoomInfo.DUNGEON_ROOM,false,_info.roomPass,_info.roomName,1,0,0,false,0);
         super.kickHandler();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._singleAlsert)
         {
            this._singleAlsert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this._singleAlsert.dispose();
            this._singleAlsert = null;
         }
         this._bigMapInfoPanel.dispose();
         this._bigMapInfoPanel = null;
         this._smallMapInfoPanel.dispose();
         this._smallMapInfoPanel = null;
         this._btnSwitchTeam.dispose();
         this._btnSwitchTeam = null;
      }
      
      private function sendStartGame() : void
      {
         this.__startClick(null);
         SoundManager.instance.play("008");
      }
      
      private function _showBoGuTip() : void
      {
         var _loc1_:RoomDupSimpleTipFram = null;
         if(PlayerManager.Instance.Self._isDupSimpleTip)
         {
            PlayerManager.Instance.Self._isDupSimpleTip = false;
            _loc1_ = ComponentFactory.Instance.creatComponentByStylename("room.RoomDupSimpleTipFram");
            _loc1_.show();
         }
      }
   }
}
