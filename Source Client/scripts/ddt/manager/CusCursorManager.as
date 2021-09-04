package ddt.manager
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.utils.ClassUtils;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import flash.ui.MouseCursorData;
   
   public class CusCursorManager
   {
      
      public static const NORMAL:String = "normal";
      
      public static const ATTACT:String = "attact";
      
      private static var _instance:CusCursorManager;
       
      
      private var _attactMouse:MovieClip;
      
      public var CustomSign:Boolean = false;
      
      private var _mouseType:String;
      
      public function CusCursorManager()
      {
         super();
         this.initMouse();
      }
      
      public static function get instance() : CusCursorManager
      {
         if(!_instance)
         {
            _instance = new CusCursorManager();
         }
         return _instance;
      }
      
      public function Setup() : void
      {
         this._mouseType = NORMAL;
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.__moveHandler);
      }
      
      private function initMouse() : void
      {
         var _loc1_:MouseCursorData = new MouseCursorData();
         var _loc2_:Vector.<BitmapData> = new Vector.<BitmapData>();
         this._attactMouse = ClassUtils.CreatInstance("asset.core.cursorAttact");
         this._attactMouse.width = 32;
         this._attactMouse.height = 32;
         var _loc3_:BitmapData = new BitmapData(this._attactMouse.width,this._attactMouse.height,true,0);
         _loc3_.draw(this._attactMouse);
         _loc2_.push(_loc3_);
         _loc1_.data = _loc2_;
         Mouse.registerCursor(ATTACT,_loc1_);
      }
      
      private function __moveHandler(param1:MouseEvent) : void
      {
         if(param1 && param1.target)
         {
         }
      }
      
      public function get currentX() : Number
      {
         return StageReferance.stage.mouseX;
      }
      
      public function get currentY() : Number
      {
         return StageReferance.stage.mouseY;
      }
      
      public function set mouseType(param1:String) : void
      {
         this._mouseType = param1;
      }
   }
}
