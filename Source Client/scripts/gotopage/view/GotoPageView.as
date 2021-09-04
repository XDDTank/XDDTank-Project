package gotopage.view
{
   import cityWide.CityWideManager;
   import civil.CivilController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SavePointManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import militaryrank.MilitaryRankManager;
   import room.RoomManager;
   import setting.controll.SettingController;
   import tofflist.TofflistController;
   import tofflist.TofflistManager;
   import update.UpdateDescFrame;
   
   public class GotoPageView extends BaseAlerFrame
   {
       
      
      private var _btnList:Vector.<SimpleBitmapButton>;
      
      private var _btnListContainer:SimpleTileList;
      
      private var _bg:Scale9CornerImage;
      
      private var _setBtn:SimpleBitmapButton;
      
      private var _friendBtn:SimpleBitmapButton;
      
      private var _tofflistBtn:SimpleBitmapButton;
      
      private var _updateBtn:SimpleBitmapButton;
      
      private var _PVPBtn:SimpleBitmapButton;
      
      private var _light:Bitmap;
      
      private var _vline:MutipleImage;
      
      private var _hline:MutipleImage;
      
      private var _event:MouseEvent;
      
      public function GotoPageView()
      {
         super();
         this.initView();
      }
      
      override public function dispose() : void
      {
         GotoPageController.Instance.isShow = false;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._setBtn)
         {
            ObjectUtils.disposeObject(this._setBtn);
         }
         this._setBtn = null;
         if(this._friendBtn)
         {
            ObjectUtils.disposeObject(this._friendBtn);
         }
         this._friendBtn = null;
         if(this._tofflistBtn)
         {
            ObjectUtils.disposeObject(this._tofflistBtn);
         }
         this._tofflistBtn = null;
         if(this._updateBtn)
         {
            ObjectUtils.disposeObject(this._updateBtn);
         }
         this._updateBtn = null;
         if(this._PVPBtn)
         {
            ObjectUtils.disposeObject(this._PVPBtn);
         }
         this._PVPBtn = null;
         if(this._vline)
         {
            ObjectUtils.disposeObject(this._vline);
         }
         this._vline = null;
         if(this._hline)
         {
            ObjectUtils.disposeObject(this._hline);
         }
         this._hline = null;
         if(this._btnList)
         {
            this.clearBtn();
         }
         ObjectUtils.disposeObject(this._btnListContainer);
         this._btnList = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
      
      private function initView() : void
      {
         info = new AlertInfo(LanguageMgr.GetTranslation("tank.view.ChannelList.FastMenu.titleText"));
         _info.showSubmit = false;
         _info.showCancel = false;
         _info.moveEnable = false;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("gotopage.GotoPageView.bg");
         addToContent(this._bg);
         this._setBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.setBtn");
         addToContent(this._setBtn);
         this._friendBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.friendBtn");
         addToContent(this._friendBtn);
         this._friendBtn.mouseEnabled = false;
         this._friendBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         if(SavePointManager.Instance.savePoints[13])
         {
            this._friendBtn.mouseEnabled = true;
            this._friendBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
         this._tofflistBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.famehallBtn");
         addToContent(this._tofflistBtn);
         this._tofflistBtn.mouseEnabled = false;
         this._tofflistBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         if(SavePointManager.Instance.savePoints[27])
         {
            this._tofflistBtn.mouseEnabled = true;
            this._tofflistBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
         this._updateBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.updateBtn");
         addToContent(this._updateBtn);
         this._PVPBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.PVPBtn");
         addToContent(this._PVPBtn);
         this._PVPBtn.mouseEnabled = false;
         this._PVPBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         if(SavePointManager.Instance.savePoints[27])
         {
            this._PVPBtn.mouseEnabled = true;
            this._PVPBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
         this._vline = ComponentFactory.Instance.creatComponentByStylename("gotopage.vline");
         addToContent(this._vline);
         this._hline = ComponentFactory.Instance.creatComponentByStylename("gotopage.hline");
         addToContent(this._hline);
         this._btnList = new Vector.<SimpleBitmapButton>();
         this._btnList.push(this._PVPBtn);
         this._btnList.push(this._tofflistBtn);
         this._btnList.push(this._friendBtn);
         this._btnList.push(this._setBtn);
         this._btnList.push(this._updateBtn);
         this.creatBtn();
      }
      
      private function creatBtn() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._btnList.length)
         {
            this._btnList[_loc1_].addEventListener(MouseEvent.MOUSE_OVER,this.__overHandle);
            this._btnList[_loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.__outHandle);
            this._btnList[_loc1_].addEventListener(MouseEvent.CLICK,this.__clickHandle);
            _loc1_++;
         }
      }
      
      private function clearBtn() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._btnList.length)
         {
            if(this._btnList[_loc1_])
            {
               this._btnList[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandle);
               this._btnList[_loc1_].removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandle);
               this._btnList[_loc1_].removeEventListener(MouseEvent.CLICK,this.__clickHandle);
               ObjectUtils.disposeObject(this._btnList[_loc1_]);
            }
            this._btnList[_loc1_] = null;
            _loc1_++;
         }
      }
      
      private function __overHandle(param1:MouseEvent) : void
      {
      }
      
      private function __outHandle(param1:MouseEvent) : void
      {
      }
      
      private function __clickHandle(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         var _loc2_:int = this._btnList.indexOf(param1.currentTarget as SimpleBitmapButton);
         this._event = param1;
         SoundManager.instance.play("047");
         if(param1.currentTarget != this._setBtn && RoomManager.Instance.current != null && RoomManager.Instance.current.selfRoomPlayer != null)
         {
            if((StateManager.currentStateType == StateType.MISSION_ROOM || RoomManager.Instance.current.isOpenBoss) && !RoomManager.Instance.current.selfRoomPlayer.isViewer && (_loc2_ != 0 && _loc2_ != 1 && _loc2_ != 4))
            {
               this.showAlert();
               return;
            }
         }
         this.skipView(param1);
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
            this.skipView(this._event);
         }
         else
         {
            this.dispose();
            dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
         }
      }
      
      private function skipView(param1:MouseEvent) : void
      {
         var _loc3_:UpdateDescFrame = null;
         var _loc2_:int = this._btnList.indexOf(param1.currentTarget as SimpleBitmapButton);
         switch(_loc2_)
         {
            case 1:
               TofflistManager.Instance.showToffilist(TofflistController.Instance.setup,UIModuleTypes.TOFFLIST);
               ComponentSetting.SEND_USELOG_ID(8);
               break;
            case 3:
               SettingController.Instance.switchVisible();
               break;
            case 2:
               CityWideManager.Instance.showCityWide(CivilController.Instance.setup,UIModuleTypes.DDTCIVIL);
               ComponentSetting.SEND_USELOG_ID(10);
               break;
            case 0:
               MilitaryRankManager.Instance.show();
               break;
            case 4:
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("ddt.update.descFrame");
               _loc3_.show();
         }
         dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
      }
      
      private function toDungeon() : void
      {
         StateManager.setState(StateType.SINGLEDUNGEON);
      }
   }
}
