package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class MultiShootAlertFrame extends BaseAlerFrame
   {
       
      
      private var _scroll:ScrollPanel;
      
      private var _sBtn:SelectedCheckButton;
      
      public function MultiShootAlertFrame()
      {
         super();
         this.initEvent();
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"));
         _loc1_.autoDispose = true;
         _loc1_.showCancel = false;
         info = _loc1_;
      }
      
      override protected function init() : void
      {
         super.init();
         this._scroll = ComponentFactory.Instance.creat("ddtDungeonRoomView.multiShootAlertFrame.scroll");
         this._scroll.setView(ComponentFactory.Instance.creat("ddtroom.dungeon.multiShootExplainMc"));
         addToContent(this._scroll);
         this._sBtn = ComponentFactory.Instance.creat("ddtDungeonRoomView.multiShootAlertFrame.selectedBtn");
         this._sBtn.text = LanguageMgr.GetTranslation("room.dungeon.multishootAlert.noTip");
         this._sBtn.selected = false;
         addToContent(this._sBtn);
      }
      
      private function initEvent() : void
      {
         this._sBtn.addEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      protected function __selectedChanged(param1:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function removeEvent() : void
      {
         if(this._sBtn)
         {
            this._sBtn.removeEventListener(Event.SELECT,this.__selectedChanged);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._sBtn)
         {
            SharedManager.Instance.isShowMultiAlert = !this._sBtn.selected;
            SharedManager.Instance.save();
         }
         ObjectUtils.disposeObject(this._scroll);
         this._scroll = null;
         ObjectUtils.disposeObject(this._sBtn);
         this._sBtn = null;
         super.dispose();
      }
   }
}
