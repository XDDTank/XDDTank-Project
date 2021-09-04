package room.view.smallMapInfoPanel
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import room.events.RoomPlayerEvent;
   import room.model.RoomInfo;
   import room.view.chooseMap.MatchRoomSetView;
   
   public class MatchRoomSmallMapInfoPanel extends BaseSmallMapInfoPanel
   {
       
      
      private var _teamPic:Bitmap;
      
      private var _btn:SimpleBitmapButton;
      
      protected var _timeType:ScaleFrameImage;
      
      private var _canSelected:Boolean = true;
      
      public function MatchRoomSmallMapInfoPanel()
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
         this._teamPic = ComponentFactory.Instance.creatBitmap("asset.ddtroom.smallMapInfoPanel.iconAsset");
         this._timeType = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMapInfo.seconds");
         addChild(this._timeType);
         this._timeType.setFrame(1);
         this._btn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMapInfo.btn");
         this._btn.tipData = LanguageMgr.GetTranslation("tank.room.RoomIIMapSet.room2");
         addChild(this._btn);
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
            this._actionStatus = this._canSelected;
         }
         else
         {
            this._actionStatus = false;
         }
      }
      
      private function __update(param1:RoomPlayerEvent) : void
      {
         if(_info.selfRoomPlayer.isHost)
         {
            this._actionStatus = this._canSelected;
         }
         else
         {
            this._actionStatus = false;
         }
      }
      
      public function set _actionStatus(param1:Boolean) : void
      {
         if(param1)
         {
            this._btn.visible = buttonMode = this._canSelected;
            addEventListener(MouseEvent.CLICK,this.__onClick);
         }
         else
         {
            this._btn.visible = buttonMode = false;
            removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      protected function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:MatchRoomSetView = new MatchRoomSetView();
         _loc2_.showMatchRoomSetView();
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         this._timeType.dispose();
         this._timeType = null;
         this._teamPic.bitmapData.dispose();
         this._teamPic = null;
         this._btn.dispose();
         this._btn = null;
         super.dispose();
      }
      
      override protected function updateView() : void
      {
         super.updateView();
         this._timeType.setFrame(Boolean(_info) ? int(_info.timeType) : int(1));
      }
      
      public function get canSelected() : Boolean
      {
         return this._canSelected;
      }
      
      public function set canSelected(param1:Boolean) : void
      {
         this._canSelected = param1;
         if(_info && _info.selfRoomPlayer.isHost)
         {
            this._actionStatus = this._canSelected;
         }
         else
         {
            this._actionStatus = false;
         }
      }
   }
}
