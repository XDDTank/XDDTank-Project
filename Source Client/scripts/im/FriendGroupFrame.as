package im
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import im.info.CustomInfo;
   
   public class FriendGroupFrame extends Frame
   {
       
      
      private var _confirm:TextButton;
      
      private var _close:TextButton;
      
      private var _combox:ComboBox;
      
      public var nickName:String;
      
      private var _customList:Vector.<CustomInfo>;
      
      public function FriendGroupFrame()
      {
         var _loc1_:Bitmap = null;
         super();
         _loc1_ = ComponentFactory.Instance.creatBitmap("asset.core.newFrame.titleBg");
         PositionUtils.setPos(_loc1_,"friendGroupFrame.title.pos");
         var _loc2_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.titleLabel");
         _loc2_.text = LanguageMgr.GetTranslation("ddt.friendGroup.LabelTxt");
         var _loc3_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.titleLabelI");
         _loc3_.text = LanguageMgr.GetTranslation("ddt.friendGroup.LabelTxtI");
         titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
         this._confirm = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.confirm");
         this._confirm.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         this._close = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.close");
         this._close.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
         this._combox = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.choose");
         addToContent(_loc1_);
         addToContent(_loc2_);
         addToContent(_loc3_);
         addToContent(this._confirm);
         addToContent(this._close);
         addToContent(this._combox);
         this._combox.beginChanges();
         this._combox.selctedPropName = "text";
         var _loc4_:VectorListModel = this._combox.listPanel.vectorListModel;
         _loc4_.clear();
         this._customList = PlayerManager.Instance.customList;
         var _loc5_:Array = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < this._customList.length - 1)
         {
            _loc5_.push(this._customList[_loc6_].Name);
            _loc6_++;
         }
         _loc4_.appendAll(_loc5_);
         this._combox.listPanel.list.updateListView();
         this._combox.commitChanges();
         this._combox.textField.text = this._customList[0].Name;
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._close.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._confirm.addEventListener(MouseEvent.CLICK,this.__confirmHandler);
         this._combox.button.addEventListener(MouseEvent.CLICK,this.__buttonClick);
         this._combox.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
      }
      
      protected function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      protected function __confirmHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = 0;
         while(_loc2_ < this._customList.length)
         {
            if(this._customList[_loc2_].Name == this._combox.textField.text)
            {
               SocketManager.Instance.out.sendAddFriend(this.nickName,this._customList[_loc2_].ID);
               break;
            }
            _loc2_++;
         }
         this.dispose();
      }
      
      protected function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      protected function __buttonClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._close.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._confirm.removeEventListener(MouseEvent.CLICK,this.__confirmHandler);
         this._combox.button.removeEventListener(MouseEvent.CLICK,this.__buttonClick);
         this._combox.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._customList = null;
         if(this._confirm)
         {
            ObjectUtils.disposeObject(this._confirm);
         }
         this._confirm = null;
         if(this._close)
         {
            ObjectUtils.disposeObject(this._close);
         }
         this._close = null;
         if(this._combox)
         {
            ObjectUtils.disposeObject(this._combox);
         }
         this._combox = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         IMController.Instance.clearGroupFrame();
      }
   }
}
