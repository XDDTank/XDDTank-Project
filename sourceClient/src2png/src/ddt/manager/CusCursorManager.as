// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.CusCursorManager

package ddt.manager
{
    import flash.display.MovieClip;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.MouseEvent;
    import flash.ui.MouseCursorData;
    import flash.display.BitmapData;
    import __AS3__.vec.Vector;
    import com.pickgliss.utils.ClassUtils;
    import flash.ui.Mouse;
    import __AS3__.vec.*;

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
            this.initMouse();
        }

        public static function get instance():CusCursorManager
        {
            if ((!(_instance)))
            {
                _instance = new (CusCursorManager)();
            };
            return (_instance);
        }


        public function Setup():void
        {
            this._mouseType = NORMAL;
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.__moveHandler);
        }

        private function initMouse():void
        {
            var _local_1:MouseCursorData = new MouseCursorData();
            var _local_2:Vector.<BitmapData> = new Vector.<BitmapData>();
            this._attactMouse = ClassUtils.CreatInstance("asset.core.cursorAttact");
            this._attactMouse.width = 32;
            this._attactMouse.height = 32;
            var _local_3:BitmapData = new BitmapData(this._attactMouse.width, this._attactMouse.height, true, 0);
            _local_3.draw(this._attactMouse);
            _local_2.push(_local_3);
            _local_1.data = _local_2;
            Mouse.registerCursor(ATTACT, _local_1);
        }

        private function __moveHandler(_arg_1:MouseEvent):void
        {
            if (((_arg_1) && (_arg_1.target)))
            {
            };
        }

        public function get currentX():Number
        {
            return (StageReferance.stage.mouseX);
        }

        public function get currentY():Number
        {
            return (StageReferance.stage.mouseY);
        }

        public function set mouseType(_arg_1:String):void
        {
            this._mouseType = _arg_1;
        }


    }
}//package ddt.manager

