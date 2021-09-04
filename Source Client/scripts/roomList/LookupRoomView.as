package roomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   
   public class LookupRoomView extends Component implements Disposeable
   {
       
      
      private var _idInputText:TextInput;
      
      private var _findBtn:TextButton;
      
      private var _roomType:int;
      
      public function LookupRoomView(param1:int)
      {
         this._roomType = param1;
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:Rectangle = null;
         this._idInputText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomlistFrame.idinput");
         this._idInputText.text = LanguageMgr.GetTranslation("ddt.roomLIst.roomIdTxt");
         this._idInputText.textField.restrict = "0-9";
         this._idInputText.textField.wordWrap = false;
         this._idInputText.textField.autoSize = "none";
         this._idInputText.textField.width = 135;
         if(this._roomType != 0)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("asset.ddtroomlistFrame.idinputRectangle");
            this._idInputText.width = _loc1_.width;
            this._idInputText.height = _loc1_.height;
            this._idInputText.x = _loc1_.x;
            this._idInputText.y = _loc1_.y;
         }
         this._findBtn = ComponentFactory.Instance.creatComponentByStylename("ddtroomlist.roombaidu_btn");
         this._findBtn.text = LanguageMgr.GetTranslation("ddt.roomList.baiduTxt");
         addChild(this._idInputText);
         addChild(this._findBtn);
      }
      
      private function initEvent() : void
      {
         this._idInputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         this._idInputText.addEventListener(MouseEvent.MOUSE_DOWN,this.__clearName);
         this._findBtn.addEventListener(MouseEvent.CLICK,this.__mouseClick);
      }
      
      private function removeEvent() : void
      {
         this._idInputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         this._idInputText.removeEventListener(MouseEvent.MOUSE_DOWN,this.__clearName);
         this._findBtn.removeEventListener(MouseEvent.CLICK,this.__mouseClick);
      }
      
      private function __onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            SoundManager.instance.play("008");
            this.submit();
         }
      }
      
      private function __clearName(param1:MouseEvent) : void
      {
         if(this._idInputText.text == "请输入房间ID")
         {
            this._idInputText.text = "";
         }
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         this.submit();
      }
      
      private function submit() : void
      {
         SoundManager.instance.play("008");
         if(this._idInputText.text == "" || this._idInputText.text == "请输入房间ID")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIFindRoomPanel.id"));
            return;
         }
         if(this._roomType == 1)
         {
            SocketManager.Instance.out.sendGameLogin(2,-1,int(this._idInputText.text));
         }
         else
         {
            SocketManager.Instance.out.sendGameLogin(1,-1,int(this._idInputText.text));
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._idInputText)
         {
            this._idInputText.dispose();
            this._idInputText = null;
         }
         if(this._findBtn)
         {
            ObjectUtils.disposeObject(this._findBtn);
            this._findBtn = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
