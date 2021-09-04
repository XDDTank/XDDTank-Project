package platformapi.tencent.view.closeFriend
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import platformapi.tencent.TencentExternalInterfaceManager;
   
   public class InviteAwardFrame extends Frame
   {
       
      
      private var _bg1:Scale9CornerImage;
      
      private var _bg2:Scale9CornerImage;
      
      private var _bg3:Scale9CornerImage;
      
      private var _inviteBtn:SimpleBitmapButton;
      
      private var _titleBitmap:Bitmap;
      
      private var _titleBGBitmap:Bitmap;
      
      private var _titleTipBitmap:Bitmap;
      
      private var _vLine:Bitmap;
      
      private var _textField1:FilterFrameText;
      
      private var _textField2:FilterFrameText;
      
      private var _getItemArray:Vector.<InviteAwardFrameGetItem>;
      
      public function InviteAwardFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.view.im.InviteAwardFrame.title");
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.BG1");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.BG2");
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.BG3");
         this._inviteBtn = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.inviteBtn");
         this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.IM.inviteFrame.title");
         this._titleBGBitmap = ComponentFactory.Instance.creatBitmap("asset.IM.inviteFrame.titleBG");
         this._titleTipBitmap = ComponentFactory.Instance.creatBitmap("asset.IM.inviteFrame.inviteTip");
         this._vLine = ComponentFactory.Instance.creatBitmap("asset.IM.inviteFrame.vLine");
         this._textField1 = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.txt1");
         this._textField2 = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.txt2");
         this._textField1.text = LanguageMgr.GetTranslation("tank.view.im.InviteAwardFrame.txt1");
         this._textField2.text = LanguageMgr.GetTranslation("tank.view.im.InviteAwardFrame.txt2");
         addToContent(this._bg1);
         addToContent(this._bg2);
         addToContent(this._bg3);
         addToContent(this._titleBGBitmap);
         addToContent(this._titleBitmap);
         addToContent(this._titleTipBitmap);
         addToContent(this._inviteBtn);
         addToContent(this._textField1);
         addToContent(this._textField2);
         addToContent(this._vLine);
         this.initCell();
      }
      
      private function initCell() : void
      {
         var _loc3_:uint = 0;
         var _loc4_:InviteAwardFrameGetItem = null;
         this._getItemArray = new Vector.<InviteAwardFrameGetItem>();
         var _loc1_:String = LanguageMgr.GetTranslation("tank.view.im.InviteAwardFrame.txt4");
         var _loc2_:Array = _loc1_.split(",");
         _loc3_ = 0;
         while(_loc3_ < 8)
         {
            _loc4_ = new InviteAwardFrameGetItem();
            _loc4_.step = _loc3_ + 1;
            _loc4_.setText(_loc3_ + 1,_loc2_[_loc3_]);
            _loc4_.x = 34 + int(_loc3_ / 4) * 327;
            _loc4_.y = 204 + _loc3_ % 4 * 37;
            addToContent(_loc4_);
            this._getItemArray.push(_loc4_);
            this.updateBtn();
            _loc3_++;
         }
      }
      
      public function updateBtn() : void
      {
         var _loc1_:InviteAwardFrameGetItem = null;
         for each(_loc1_ in this._getItemArray)
         {
            if(_loc1_.step <= PlayerManager.Instance.invitedAwardStep)
            {
               _loc1_.enable = false;
               _loc1_.taken = true;
            }
            else if(_loc1_.step > PlayerManager.Instance.invitedAwardStep + 1)
            {
               _loc1_.enable = false;
            }
            else
            {
               _loc1_.enable = true;
            }
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         PlayerManager.Instance.addEventListener(Event.CHANGE,this.__onUpdate);
         if(this._inviteBtn)
         {
            this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__inviteBtnClick);
         }
      }
      
      private function __inviteBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         TencentExternalInterfaceManager.invite();
      }
      
      private function __onUpdate(param1:Event) : void
      {
         this.updateBtn();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.playButtonSound();
            ObjectUtils.disposeObject(this);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         PlayerManager.Instance.removeEventListener(Event.CHANGE,this.__onUpdate);
      }
      
      override public function dispose() : void
      {
         var _loc1_:InviteAwardFrameGetItem = null;
         this.removeEvent();
         for each(_loc1_ in this._getItemArray)
         {
            if(_loc1_)
            {
               ObjectUtils.disposeObject(_loc1_);
            }
         }
         this._getItemArray = null;
         if(this._bg1)
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
         if(this._bg2)
         {
            ObjectUtils.disposeObject(this._bg2);
         }
         this._bg2 = null;
         if(this._bg3)
         {
            ObjectUtils.disposeObject(this._bg3);
         }
         this._bg3 = null;
         if(this._inviteBtn)
         {
            ObjectUtils.disposeObject(this._inviteBtn);
         }
         this._inviteBtn = null;
         if(this._titleBitmap)
         {
            ObjectUtils.disposeObject(this._titleBitmap);
         }
         this._titleBitmap = null;
         if(this._titleBGBitmap)
         {
            ObjectUtils.disposeObject(this._titleBGBitmap);
         }
         this._titleBGBitmap = null;
         if(this._titleTipBitmap)
         {
            ObjectUtils.disposeObject(this._titleTipBitmap);
         }
         this._titleTipBitmap = null;
         if(this._textField1)
         {
            ObjectUtils.disposeObject(this._textField1);
         }
         this._textField1 = null;
         if(this._textField2)
         {
            ObjectUtils.disposeObject(this._textField2);
         }
         this._textField2 = null;
         if(this._vLine)
         {
            ObjectUtils.disposeObject(this._vLine);
         }
         this._vLine = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
