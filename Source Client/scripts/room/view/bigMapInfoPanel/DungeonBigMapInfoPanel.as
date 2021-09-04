package room.view.bigMapInfoPanel
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.events.RoomEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import room.RoomManager;
   
   public class DungeonBigMapInfoPanel extends MissionRoomBigMapInfoPanel
   {
       
      
      public function DungeonBigMapInfoPanel()
      {
         super();
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         _info.addEventListener(RoomEvent.STARTED_CHANGED,this.__onGameStarted);
         _info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__playerStateChange);
         _info.addEventListener(RoomEvent.OPEN_BOSS_CHANGED,this.__openBossChange);
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         _info.removeEventListener(RoomEvent.STARTED_CHANGED,this.__onGameStarted);
         _info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__playerStateChange);
         _info.removeEventListener(RoomEvent.OPEN_BOSS_CHANGED,this.__openBossChange);
      }
      
      override protected function initView() : void
      {
         _pos1 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dropListPos1");
         _pos2 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dropListPos2");
         _dropList = new DropList();
         _dropList.x = _pos1.x;
         _dropList.y = _pos1.y;
         addChild(_dropList);
         _dropList.visible = true;
         _info = RoomManager.Instance.current;
         if(_info)
         {
            _info.addEventListener(RoomEvent.MAP_CHANGED,this.__onMapChanged);
            _info.addEventListener(RoomEvent.HARD_LEVEL_CHANGED,this.__updateHard);
            updateMap();
            updateDropList();
         }
         MainToolBar.Instance.backFunction = this.leaveAlert;
      }
      
      private function leaveAlert() : void
      {
         if(RoomManager.Instance.current.isOpenBoss && !RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this.showAlert();
         }
         else
         {
            StateManager.setState(StateType.MAIN);
         }
      }
      
      private function showAlert() : void
      {
         var _loc1_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"),"",LanguageMgr.GetTranslation("cancel"),true,true,false,LayerManager.BLCAK_BLOCKGOUND);
         _loc1_.moveEnable = false;
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            StateManager.setState(StateType.DUNGEON_LIST);
         }
      }
      
      private function __onGameStarted(param1:RoomEvent) : void
      {
      }
      
      override protected function __onMapChanged(param1:RoomEvent) : void
      {
         this.resetReadyState();
         super.__onMapChanged(param1);
      }
      
      override protected function __updateHard(param1:RoomEvent) : void
      {
         this.resetReadyState();
         super.__updateHard(param1);
      }
      
      private function resetReadyState() : void
      {
         if(!RoomManager.Instance.current.selfRoomPlayer.isHost && StateManager.currentStateType == StateType.DUNGEON_ROOM)
         {
            GameInSocketOut.sendPlayerState(0);
         }
      }
      
      private function __playerStateChange(param1:RoomEvent) : void
      {
      }
      
      private function __openBossChange(param1:RoomEvent) : void
      {
         updateMap();
         updateDropList();
      }
      
      override protected function solvePath() : String
      {
         var _loc1_:String = PathManager.SITE_MAIN + "image/map/";
         if(_info && _info.mapId > 0)
         {
            if(_info.isOpenBoss)
            {
               if(_info.pic && _info.pic.length > 0)
               {
                  _loc1_ += _info.mapId + "/" + _info.pic;
               }
            }
            else
            {
               _loc1_ += _info.mapId + "/show1.jpg";
            }
         }
         else
         {
            _loc1_ += "10000/show1.jpg";
         }
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         MainToolBar.Instance.backFunction = null;
      }
   }
}
