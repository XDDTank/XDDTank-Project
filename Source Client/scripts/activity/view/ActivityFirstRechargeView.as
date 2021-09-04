package activity.view
{
   import activity.ActivityController;
   import activity.data.ActivityGiftbagInfo;
   import activity.data.ActivityInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   
   public class ActivityFirstRechargeView extends Frame
   {
      
      public static const CELL_NUM:int = 6;
       
      
      private var _bitmap:Bitmap;
      
      private var _getButton:BaseButton;
      
      private var _chargeBtn:BaseButton;
      
      private var _cellList:SimpleTileList;
      
      private var _panel:ScrollPanel;
      
      private var _info:ActivityInfo;
      
      public function ActivityFirstRechargeView()
      {
         this._info = ActivityController.instance.checkHasFirstCharge();
         super();
         this.initView();
         this.initEvent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         ActivityController.instance.sendAskForActiviLog(this._info);
      }
      
      public function hide() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function initView() : void
      {
         this._bitmap = ComponentFactory.Instance.creatBitmap("ddtactivity.ActivityFirstRechargeView.bitmap");
         addToContent(this._bitmap);
         this._chargeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityFirstRechargeView.btn");
         addToContent(this._chargeBtn);
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("activity.ActivityFirstRechargeView.GetButton");
         this._getButton.visible = false;
         addToContent(this._getButton);
         this._cellList = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityFirstRechargeView.cellList",[3]);
         addToContent(this._cellList);
         this._panel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityFirstRechargeView.cellPanel");
         addToContent(this._panel);
         this._panel.setView(this._cellList);
         this.initCells();
      }
      
      private function checkBtn() : void
      {
         this._getButton.visible = PlayerManager.Instance.Self.moneyOfCharge > 0;
         this._chargeBtn.visible = !PlayerManager.Instance.Self.moneyOfCharge > 0;
      }
      
      private function initCells() : void
      {
         var _loc1_:DictionaryData = null;
         var _loc2_:ActivityCell = null;
         var _loc3_:ActivityGiftbagInfo = null;
         var _loc4_:int = 0;
         this.removeCells();
         for each(_loc3_ in ActivityController.instance.getAcitivityGiftBagByActID(this._info.ActivityId))
         {
            _loc1_ = ActivityController.instance.getRewardsByGiftbagID(_loc3_.GiftbagId);
            _loc4_ = 0;
            while(_loc4_ < _loc1_.list.length)
            {
               _loc2_ = new ActivityCell(_loc1_.list[_loc4_]);
               _loc2_.count = _loc1_.list[_loc4_].Count;
               this._cellList.addChild(_loc2_);
               _loc4_++;
            }
         }
         this._panel.vScrollProxy = this._cellList.numChildren > CELL_NUM ? int(0) : int(2);
      }
      
      private function removeCells() : void
      {
         this._cellList.disposeAllChildren();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         this._getButton.addEventListener(MouseEvent.CLICK,this.__getAward);
         this._chargeBtn.addEventListener(MouseEvent.CLICK,this.__sendCharge);
         PlayerManager.Instance.Self.addEventListener(PlayerEvent.MONEY_CHARGE,this.__moneyChargeHandle);
      }
      
      private function __getAward(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ActivityController.instance.model.getLog(this._info.ActivityId) > 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.activity.activityFirstRechargeView.hasGet"));
         }
         else
         {
            ActivityController.instance.getActivityAward(this._info);
            this.hide();
         }
      }
      
      private function __sendCharge(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ActivityController.instance.model.getLog(this._info.ActivityId) > 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.activity.activityFirstRechargeView.hasGet"));
         }
         else
         {
            LeavePageManager.leaveToFillPath();
            this.hide();
         }
      }
      
      private function __moneyChargeHandle(param1:PlayerEvent) : void
      {
         this.checkBtn();
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.hide();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         this._chargeBtn.removeEventListener(MouseEvent.CLICK,this.__sendCharge);
         PlayerManager.Instance.Self.removeEventListener(PlayerEvent.MONEY_CHARGE,this.__moneyChargeHandle);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeCells();
         ObjectUtils.disposeObject(this._cellList);
         this._cellList = null;
         ObjectUtils.disposeObject(this._bitmap);
         this._bitmap = null;
         ObjectUtils.disposeObject(this._chargeBtn);
         this._chargeBtn = null;
         super.dispose();
      }
   }
}
