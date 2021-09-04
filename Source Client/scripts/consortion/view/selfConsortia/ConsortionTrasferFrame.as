package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.view.club.CreateConsortionFrame;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class ConsortionTrasferFrame extends Frame
   {
      
      private static const ITEM_POS:String = "asset.viceChairmanItem.pos";
       
      
      private var _titleBg:Bitmap;
      
      private var _itemBg:Scale9CornerImage;
      
      private var _itemBgI:Bitmap;
      
      private var _Line:MutipleImage;
      
      private var _ok:TextButton;
      
      private var _cancel:TextButton;
      
      private var _titleTxt:FilterFrameText;
      
      private var _listitleTxt:FilterFrameText;
      
      private var _listitleTxtI:FilterFrameText;
      
      private var _listilteTxtII:FilterFrameText;
      
      private var items:Vector.<ViceChairmanItem>;
      
      private var _vbox:VBox;
      
      private var _currentItem:ViceChairmanItem;
      
      public function ConsortionTrasferFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.AlienationConsortiaFrame.titleText");
         this._ok = ComponentFactory.Instance.creatComponentByStylename("consortion.transferFrame.ok");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("consortion.transferFrame.cancel");
         addToContent(this._ok);
         addToContent(this._cancel);
         this._ok.text = LanguageMgr.GetTranslation("ok");
         this._cancel.text = LanguageMgr.GetTranslation("cancel");
         this._titleBg = ComponentFactory.Instance.creatBitmap("asset.taskTitle.bg");
         PositionUtils.setPos(this._titleBg,"asset.TrasferTitle.pos");
         addToContent(this._titleBg);
         this._itemBg = ComponentFactory.Instance.creatComponentByStylename("TrasferFrame.AllitemBg");
         addToContent(this._itemBg);
         this._itemBgI = ComponentFactory.Instance.creatBitmap("TrasferFrame.AllitemBgI");
         addToContent(this._itemBgI);
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("consortionTrasfer.TitleText");
         this._titleTxt.text = LanguageMgr.GetTranslation("ddt.consortion.consortionTrasfer.TitleText");
         addToContent(this._titleTxt);
         this._listitleTxt = ComponentFactory.Instance.creatComponentByStylename("consortionTrasfer.ListTitleText");
         this._listitleTxtI = ComponentFactory.Instance.creatComponentByStylename("consortionTrasfer.ListTitleText1");
         this._listilteTxtII = ComponentFactory.Instance.creatComponentByStylename("consortionTrasfer.ListTitleText2");
         this._listitleTxt.text = LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.level.txt");
         this._listitleTxtI.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.name");
         this._listilteTxtII.text = LanguageMgr.GetTranslation("ddt.roomlist.right.sex");
         addToContent(this._listitleTxt);
         addToContent(this._listitleTxtI);
         addToContent(this._listilteTxtII);
         this._Line = ComponentFactory.Instance.creatComponentByStylename("consortionTrasfer.Vline");
         addToContent(this._Line);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("consrotionTrasfer.ItemVbox");
         this.items = new Vector.<ViceChairmanItem>(3);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.items[_loc1_] = new ViceChairmanItem();
            this.items[_loc1_].buttonMode = true;
            addToContent(this.items[_loc1_]);
            PositionUtils.setPos(this.items[_loc1_],ITEM_POS + _loc1_.toString());
            this.items[_loc1_].addEventListener(MouseEvent.CLICK,this.__clickHandler);
            this.items[_loc1_].addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            this.items[_loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            _loc1_++;
         }
         this._ok.enable = false;
         this.setItem();
      }
      
      private function setItem() : void
      {
         var _loc3_:int = 0;
         this._vbox.disposeAllChildren();
         var _loc1_:Vector.<ConsortiaPlayerInfo> = ConsortionModelControl.Instance.model.ViceChairmanConsortiaMemberList;
         var _loc2_:int = _loc1_.length;
         if(_loc2_ == 0)
         {
            return MessageTipManager.getInstance().show("暂无副会长");
         }
         while(_loc3_ < 3)
         {
            if(_loc3_ < _loc2_)
            {
               this.items[_loc3_].info = _loc1_[_loc3_];
               this.items[_loc3_].buttonMode = true;
               this.items[_loc3_].mouseChildren = true;
               this.items[_loc3_].mouseEnabled = true;
            }
            else
            {
               this.items[_loc3_].buttonMode = false;
               this.items[_loc3_].mouseChildren = false;
               this.items[_loc3_].mouseEnabled = false;
            }
            _loc3_++;
         }
      }
      
      public function get currentItem() : ViceChairmanItem
      {
         return this._currentItem;
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            if(this.items[_loc2_] == param1.currentTarget as ViceChairmanItem)
            {
               this.items[_loc2_].isSelelct = true;
               this._currentItem = this.items[_loc2_];
            }
            else
            {
               this.items[_loc2_].isSelelct = false;
            }
            _loc2_++;
         }
         this._ok.enable = true;
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         (param1.currentTarget as ViceChairmanItem).light = true;
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
         (param1.currentTarget as ViceChairmanItem).light = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._ok.addEventListener(MouseEvent.CLICK,this.__okHandler);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._ok.removeEventListener(MouseEvent.CLICK,this.__okHandler);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
         if(param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.__okHandler(null);
         }
      }
      
      private function __okHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._ok.enable = false;
         var _loc2_:ConsortiaPlayerInfo = this._currentItem.info;
         if(_loc2_.Grade < CreateConsortionFrame.MIN_CREAT_CONSROTIA_LEVEL)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.AlienationConsortiaFrame.Grade"));
            return;
         }
         SocketManager.Instance.out.sendConsortiaChangeChairman(_loc2_.NickName);
         this.dispose();
      }
      
      private function __cancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            if(this._ok.enable)
            {
               this.__okHandler(null);
            }
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.items[_loc1_].dispose();
            this.items[_loc1_].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
            this.items[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            this.items[_loc1_].removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            this.items[_loc1_] = null;
            _loc1_++;
         }
         super.dispose();
         if(this._vbox)
         {
            this._vbox.disposeAllChildren();
            ObjectUtils.disposeObject(this._vbox);
         }
         this._titleBg = null;
         this._itemBg = null;
         this._itemBgI = null;
         this._Line = null;
         this._ok = null;
         this._cancel = null;
         this._currentItem = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
