package platformapi.tencent.view.closeFriend
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class InviteAwardFrameGetItem extends Sprite implements Disposeable
   {
       
      
      private var _textField:FilterFrameText;
      
      private var _hLine:Bitmap;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _takenTip:Bitmap;
      
      private var _step:uint;
      
      public function InviteAwardFrameGetItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._textField = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.txt3");
         this._hLine = ComponentFactory.Instance.creatBitmap("asset.IM.inviteFrame.hLine");
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.getBtn");
         this._takenTip = ComponentFactory.Instance.creatBitmap("asset.IM.levelUpFrame.levelGift.GOT");
         this._takenTip.visible = false;
         addChild(this._textField);
         addChild(this._hLine);
         addChild(this._getBtn);
         addChild(this._takenTip);
         this.taken = false;
      }
      
      public function setText(param1:int, param2:int) : void
      {
         var _loc3_:String = LanguageMgr.GetTranslation("tank.view.im.InviteAwardFrame.txt3");
         var _loc4_:String = "<font color=\'#f5a10e\'><b>" + param2.toString() + "</b></font>";
         _loc3_ = _loc3_.replace("{0}",param1.toString());
         _loc3_ = _loc3_.replace("{1}",_loc4_);
         this._textField.htmlText = _loc3_;
      }
      
      public function set step(param1:uint) : void
      {
         this._step = param1;
      }
      
      public function get step() : uint
      {
         return this._step;
      }
      
      public function set taken(param1:Boolean) : void
      {
         this._takenTip.visible = param1;
      }
      
      public function set enable(param1:Boolean) : void
      {
         this._getBtn.enable = param1;
      }
      
      private function initEvent() : void
      {
         this._getBtn.addEventListener(MouseEvent.CLICK,this.__onGetBtnClicked);
      }
      
      private function removeEvent() : void
      {
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.__onGetBtnClicked);
      }
      
      private function __onGetBtnClicked(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         SocketManager.Instance.out.sendInvitedFriendAward(0,this._step,0);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._textField)
         {
            ObjectUtils.disposeObject(this._textField);
         }
         this._textField = null;
         if(this._hLine)
         {
            ObjectUtils.disposeObject(this._hLine);
         }
         this._hLine = null;
         if(this._getBtn)
         {
            ObjectUtils.disposeObject(this._getBtn);
         }
         this._getBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
