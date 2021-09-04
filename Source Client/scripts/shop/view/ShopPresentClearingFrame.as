package shop.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.NameInputDropListTarget;
   import ddt.view.chat.ChatFriendListPanel;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ShopPresentClearingFrame extends Frame
   {
       
      
      private var _titleTxt:FilterFrameText;
      
      private var _BG:Image;
      
      private var _BG1:ScaleBitmapImage;
      
      private var _textAreaBg:Image;
      
      private var _comboBoxLabel:FilterFrameText;
      
      private var _chooseFriendBtn:BaseButton;
      
      private var _nameInput:NameInputDropListTarget;
      
      private var _dropList:DropList;
      
      private var _friendList:ChatFriendListPanel;
      
      private var _cancelBtn:TextButton;
      
      private var _okBtn:TextButton;
      
      private var _textArea:TextArea;
      
      public function ShopPresentClearingFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get nameInput() : NameInputDropListTarget
      {
         return this._nameInput;
      }
      
      public function get presentBtn() : BaseButton
      {
         return this._okBtn;
      }
      
      public function get textArea() : TextArea
      {
         return this._textArea;
      }
      
      private function initView() : void
      {
         escEnable = true;
         this.titleText = LanguageMgr.GetTranslation("shop.view.present");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("shop.PresentFrame.titleText");
         this._titleTxt.text = LanguageMgr.GetTranslation("shop.PresentFrame.titleText");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrameBg1");
         this._comboBoxLabel = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.ComboBoxLabel");
         this._comboBoxLabel.text = LanguageMgr.GetTranslation("shop.PresentFrame.ComboBoxLabel");
         this._chooseFriendBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.ChooseFriendBtn");
         this._nameInput = ComponentFactory.Instance.creatCustomObject("ddtshop.ClearingInterface.nameInput");
         this._dropList = ComponentFactory.Instance.creatComponentByStylename("droplist.SimpleDropList");
         this._dropList.targetDisplay = this._nameInput;
         this._dropList.x = this._nameInput.x;
         this._dropList.y = this._nameInput.y + this._nameInput.height;
         this._friendList = new ChatFriendListPanel();
         this._friendList.setup(this.selectName);
         this._textArea = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PresentClearingTextArea");
         this._textArea.maxChars = 200;
         this._textAreaBg = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.TextAreaBg");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.CancelBtn");
         this._cancelBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.OkBtn");
         this._okBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         addToContent(this._titleTxt);
         addToContent(this._BG);
         addToContent(this._comboBoxLabel);
         addToContent(this._chooseFriendBtn);
         addToContent(this._nameInput);
         addToContent(this._textArea);
         this._textArea.addChild(this._textAreaBg);
         addToContent(this._cancelBtn);
         addToContent(this._okBtn);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function selectName(param1:String, param2:int = 0) : void
      {
         this.setName(param1);
         this._friendList.setVisible = false;
      }
      
      public function setName(param1:String) : void
      {
         this._nameInput.text = param1;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._nameInput.addEventListener(Event.CHANGE,this.__onReceiverChange);
         this._chooseFriendBtn.addEventListener(MouseEvent.CLICK,this.__showFramePanel);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelPresent);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideDropList);
      }
      
      private function __cancelPresent(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new FrameEvent(FrameEvent.CANCEL_CLICK));
         this.dispose();
      }
      
      private function __buyMoney(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LeavePageManager.leaveToFillPath();
      }
      
      private function __showFramePanel(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Point = this._chooseFriendBtn.localToGlobal(new Point(0,0));
         this._friendList.x = _loc2_.x - 95;
         this._friendList.y = _loc2_.y + this._chooseFriendBtn.height;
         this._friendList.setVisible = true;
         LayerManager.Instance.addToLayer(this._friendList,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(this._nameInput)
         {
            this._nameInput.removeEventListener(Event.CHANGE,this.__onReceiverChange);
         }
         if(this._chooseFriendBtn)
         {
            this._chooseFriendBtn.removeEventListener(MouseEvent.CLICK,this.__showFramePanel);
         }
         if(this._cancelBtn)
         {
            this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__buyMoney);
         }
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__hideDropList);
      }
      
      protected function __hideDropList(param1:Event) : void
      {
         if(param1.target is FilterFrameText)
         {
            return;
         }
         if(this._dropList && this._dropList.parent)
         {
            this._dropList.parent.removeChild(this._dropList);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         if(this._dropList)
         {
            this._dropList = null;
         }
         if(this._friendList)
         {
            ObjectUtils.disposeObject(this._friendList);
         }
         this._friendList = null;
         this._titleTxt = null;
         this._BG = null;
         this._comboBoxLabel = null;
         this._chooseFriendBtn = null;
         this._nameInput = null;
         this._dropList = null;
         this._cancelBtn = null;
         this._okBtn = null;
         ObjectUtils.disposeObject(this._textAreaBg);
         this._textAreaBg = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __onReceiverChange(param1:Event) : void
      {
         if(this._nameInput.text == "")
         {
            this._dropList.dataList = null;
            return;
         }
         var _loc2_:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
         this._dropList.dataList = this.filterSearch(this.filterRepeatInArray(_loc2_),this._nameInput.text);
      }
      
      private function filterRepeatInArray(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc3_ == 0)
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(_loc2_[_loc4_].NickName == param1[_loc3_].NickName)
               {
                  break;
               }
               if(_loc4_ == _loc2_.length - 1)
               {
                  _loc2_.push(param1[_loc3_]);
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function filterSearch(param1:Array, param2:String) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_].NickName.indexOf(param2) != -1)
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
   }
}
