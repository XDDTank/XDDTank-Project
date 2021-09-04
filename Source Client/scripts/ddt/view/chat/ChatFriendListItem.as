package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.BasePlayer;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ChatFriendListItem extends Sprite implements IListCell, Disposeable
   {
      
      public static const SELECT:String = "select";
       
      
      private var _bg:ScaleLeftRightImage;
      
      private var _contentTxt:TextField;
      
      private var _fun:Function;
      
      private var _info:BasePlayer;
      
      private var _spaceLine:Bitmap;
      
      public function ChatFriendListItem()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._spaceLine);
         this._spaceLine = null;
         if(this._contentTxt && this._contentTxt.parent)
         {
            this._contentTxt.parent.removeChild(this._contentTxt);
            this._contentTxt = null;
         }
         this._info = null;
         this._fun = null;
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      public function get info() : BasePlayer
      {
         return this._info;
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         if(this._fun != null)
         {
            SoundManager.instance.play("008");
            this._fun(this._info.NickName,this._info.ID);
         }
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         this._bg.alpha = 0;
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         this._bg.alpha = 1;
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.newScaleLeftRightImage.ScaleLeftRightImage1");
         this._bg.width = 140;
         this._spaceLine = ComponentFactory.Instance.creat("asset.chat.FriendListItemSpaceLine");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("chat.FriendList.ItemTxt");
         this._contentTxt.mouseEnabled = false;
         addChild(this._bg);
         addChild(this._contentTxt);
         this._bg.alpha = 0;
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function updateItem() : void
      {
         this._contentTxt.text = this._info.NickName;
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._info = param1;
         this.updateItem();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
