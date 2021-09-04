package room.view.smallMapInfoPanel
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.MouseEvent;
   import room.RoomManager;
   import room.events.RoomPlayerEvent;
   import room.model.RoomInfo;
   import room.view.chooseMap.DungeonChooseMapFrame;
   
   public class DungeonSmallMapInfoPanel extends MissionRoomSmallMapInfoPanel
   {
       
      
      private var _btn:SimpleBitmapButton;
      
      public function DungeonSmallMapInfoPanel()
      {
         super();
      }
      
      private function removeEvents() : void
      {
         _info.selfRoomPlayer.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__update);
         removeEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._btn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMapInfo.btn");
         this._btn.tipData = LanguageMgr.GetTranslation("tank.room.RoomIIMapSet.room2");
         addChild(this._btn);
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(RoomManager.Instance.current.isOpenBoss && !RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this.showAlert();
            return;
         }
         var _loc2_:DungeonChooseMapFrame = new DungeonChooseMapFrame();
         _loc2_.show();
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
      
      override public function set info(param1:RoomInfo) : void
      {
         super.info = param1;
         if(_info)
         {
            _info.selfRoomPlayer.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__update);
         }
         if(_info && _info.selfRoomPlayer.isHost)
         {
            this._btn.visible = buttonMode = true;
            addEventListener(MouseEvent.CLICK,this.__onClick);
         }
         else
         {
            this._btn.visible = buttonMode = false;
            removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      private function __update(param1:RoomPlayerEvent) : void
      {
         if(_info.selfRoomPlayer.isHost)
         {
            this._btn.visible = buttonMode = true;
            addEventListener(MouseEvent.CLICK,this.__onClick);
         }
         else
         {
            this._btn.visible = buttonMode = false;
            removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         this._btn.dispose();
         this._btn = null;
         super.dispose();
      }
   }
}
