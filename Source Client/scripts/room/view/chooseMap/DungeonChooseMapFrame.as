package room.view.chooseMap
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MapManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class DungeonChooseMapFrame extends Sprite implements Disposeable
   {
       
      
      private var _frame:BaseAlerFrame;
      
      private var _view:DungeonChooseMapView;
      
      private var _alert:BaseAlerFrame;
      
      private var _voucherAlert:BaseAlerFrame;
      
      public function DungeonChooseMapFrame()
      {
         super();
         this._frame = ComponentFactory.Instance.creatComponentByStylename("asset.ddtdungeonRoom.ChooseMap.Frame");
         addChild(this._frame);
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("tank.room.RoomIIMapSetPanel.room");
         _loc1_.submitLabel = LanguageMgr.GetTranslation("ok");
         _loc1_.showCancel = false;
         _loc1_.moveEnable = false;
         this._frame.info = _loc1_;
         this._view = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dungeonChooseMapView");
         this._frame.addToContent(this._view);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__responeHandler);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __responeHandler(param1:FrameEvent) : void
      {
         var _loc2_:DungeonInfo = null;
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
         else if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SoundManager.instance.play("008");
            if(this._view.checkState())
            {
               _loc2_ = MapManager.getDungeonInfo(this._view.selectedMapID);
               if(this._view.select)
               {
                  this.showAlert();
               }
               else
               {
                  if(_loc2_.Type == MapManager.PVE_CHANGE_MAP)
                  {
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.CHANGE_DUNGEON,false,this._view.roomPass,this._view.roomName,1,this._view.selectedLevel,0,false,this._view.selectedMapID);
                  }
                  else if(_loc2_.Type == MapManager.PVE_MULTISHOOT)
                  {
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.MULTI_DUNGEON,false,this._view.roomPass,this._view.roomName,4,this._view.selectedLevel,0,false,this._view.selectedMapID);
                  }
                  else
                  {
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.DUNGEON_ROOM,false,this._view.roomPass,this._view.roomName,1,this._view.selectedLevel,0,false,this._view.selectedMapID);
                  }
                  RoomManager.Instance.current.roomName = this._view.roomName;
                  RoomManager.Instance.current.roomPass = this._view.roomPass;
                  RoomManager.Instance.current.dungeonType = this._view.selectedDungeonType;
                  this.dispose();
               }
            }
         }
      }
      
      private function getPrice() : String
      {
         var _loc1_:Array = [];
         var _loc2_:String = "";
         var _loc3_:String = MapManager.getDungeonInfo(this._view.selectedMapID).BossFightNeedMoney;
         if(_loc3_)
         {
            _loc1_ = _loc3_.split("|");
         }
         if(_loc1_ && _loc1_.length > 0)
         {
            switch(this._view.selectedLevel)
            {
               case RoomInfo.EASY:
                  _loc2_ = _loc1_[0];
                  break;
               case RoomInfo.NORMAL:
                  _loc2_ = _loc1_[1];
                  break;
               case RoomInfo.HARD:
                  _loc2_ = _loc1_[2];
                  break;
               case RoomInfo.HERO:
                  _loc2_ = _loc1_[3];
            }
         }
         return _loc2_;
      }
      
      private function showAlert() : void
      {
         if(this._alert == null)
         {
            this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.openBossTip.text",this.getPrice()),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            this._alert.moveEnable = false;
            this._alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         }
      }
      
      private function disposeAlert() : void
      {
         if(this._alert)
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            ObjectUtils.disposeObject(this._alert);
            this._alert.dispose();
         }
         this._alert = null;
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               if(PlayerManager.Instance.Self.totalMoney < Number(this.getPrice()))
               {
                  this.showVoucherAlert();
               }
               else
               {
                  GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.DUNGEON_ROOM,true,this._view.roomPass,this._view.roomName,1,this._view.selectedLevel,0,false,this._view.selectedMapID);
                  RoomManager.Instance.current.roomName = this._view.roomName;
                  RoomManager.Instance.current.roomPass = this._view.roomPass;
                  RoomManager.Instance.current.dungeonType = this._view.selectedDungeonType;
                  this.dispose();
               }
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.disposeAlert();
         }
      }
      
      private function showVoucherAlert() : void
      {
         if(this._voucherAlert == null)
         {
            this._voucherAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
            this._voucherAlert.addEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         }
      }
      
      private function disposeVoucherAlert() : void
      {
         this.disposeAlert();
         if(this._voucherAlert)
         {
            this._voucherAlert.removeEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
            this._voucherAlert.disposeChildren = true;
            this._voucherAlert.dispose();
            this._voucherAlert = null;
         }
      }
      
      private function __onNoMoneyResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.disposeVoucherAlert();
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      public function dispose() : void
      {
         this.disposeAlert();
         this.disposeVoucherAlert();
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__responeHandler);
         if(this._frame)
         {
            this._frame.dispose();
            this._frame = null;
         }
         if(this._view)
         {
            this._view.dispose();
            this._view = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
