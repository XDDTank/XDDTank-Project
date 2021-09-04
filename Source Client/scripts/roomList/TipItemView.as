package roomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TipItemView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _bgII:ScaleLeftRightImage;
      
      private var _value:int;
      
      private var _cellWidth:int;
      
      private var _cellheight:int;
      
      public function TipItemView(param1:Bitmap, param2:int, param3:int, param4:int)
      {
         this._value = param2;
         this._bg = param1;
         this._cellWidth = param3;
         this._cellheight = param4;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.buttonMode = true;
         this._bg.x = this._cellWidth / 2 - this._bg.width / 2;
         this._bgII = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.RoomList.itemredbg");
         this._bgII.width = this._cellWidth;
         this._bgII.height = this._cellheight;
         this._bgII.mouseChildren = false;
         this._bgII.mouseEnabled = false;
         this._bgII.visible = false;
         addChild(this._bgII);
         addChild(this._bg);
         addEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
      }
      
      protected function __itemOut(param1:MouseEvent) : void
      {
         this._bgII.visible = false;
      }
      
      protected function __itemOver(param1:MouseEvent) : void
      {
         this._bgII.visible = true;
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function dispose() : void
      {
         if(this._bgII)
         {
            ObjectUtils.disposeObject(this._bgII);
            this._bgII = null;
         }
         if(this._bg && this._bg.bitmapData)
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
