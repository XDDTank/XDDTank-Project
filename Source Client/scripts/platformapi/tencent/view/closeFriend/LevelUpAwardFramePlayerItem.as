package platformapi.tencent.view.closeFriend
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.InvitedFirendListPlayer;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   
   public class LevelUpAwardFramePlayerItem extends Sprite implements Disposeable, IListCell
   {
       
      
      private var _BG:Bitmap;
      
      private var _textField:FilterFrameText;
      
      private var _info:InvitedFirendListPlayer;
      
      public function LevelUpAwardFramePlayerItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("asset.IM.levelUpFrame.playerItemBG");
         this._BG.alpha = 0;
         this._textField = ComponentFactory.Instance.creatComponentByStylename("IMFrame.levelUpAward.playerItem.txt");
         addChild(this._BG);
         addChild(this._textField);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
      }
      
      private function __onMouseOver(param1:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.BUTTON;
      }
      
      private function __onMouseOut(param1:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.AUTO;
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
         if(this._BG)
         {
            this._BG.alpha = !!param2 ? Number(1) : Number(0);
         }
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function get info() : InvitedFirendListPlayer
      {
         return this._info;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._info = param1;
         this._textField.text = this._info.NickName;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(this._textField)
         {
            ObjectUtils.disposeObject(this._textField);
         }
         this._textField = null;
         this._info = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
