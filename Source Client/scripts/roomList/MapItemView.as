package roomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.loader.MapSmallIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapItemView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _mapIcon:MapSmallIcon;
      
      private var _bgII:ScaleLeftRightImage;
      
      private var _mapID:int;
      
      private var _cellWidth:int;
      
      private var _cellheight:int;
      
      public function MapItemView(param1:int, param2:int, param3:int)
      {
         this._mapID = param1;
         this._cellWidth = param2;
         this._cellheight = param3;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.buttonMode = true;
         this._mapIcon = new MapSmallIcon(this._mapID);
         this._mapIcon.addEventListener(Event.COMPLETE,this.__mapIconLoadComplete);
         this._mapIcon.startLoad();
         this._bgII = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.RoomList.itemredbg");
         this._bgII.mouseChildren = false;
         this._bgII.mouseEnabled = false;
         this._bgII.width = this._cellWidth;
         this._bgII.height = this._cellheight;
         this._bgII.visible = false;
         addChild(this._bgII);
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
      
      private function __mapIconLoadComplete(param1:Event) : void
      {
         this._mapIcon.removeEventListener(Event.COMPLETE,this.__mapIconLoadComplete);
         this._bg = this._mapIcon.icon;
         if(this._bg)
         {
            this._bg.x = this._cellWidth / 2 - this._bg.width / 2 + 5;
            addChild(this._bg);
         }
      }
      
      public function get id() : int
      {
         return this._mapID;
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         if(this._mapIcon)
         {
            this._mapIcon.removeEventListener(Event.COMPLETE,this.__mapIconLoadComplete);
            this._mapIcon.dispose();
            this._mapIcon = null;
         }
         if(this._bg && this._bg.parent)
         {
            this._bg.parent.removeChild(this._bg);
            this._bg = null;
         }
         if(this._bgII)
         {
            ObjectUtils.disposeObject(this._bgII);
            this._bgII = null;
         }
      }
   }
}
