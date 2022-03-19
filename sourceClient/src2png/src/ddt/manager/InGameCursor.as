// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.InGameCursor

package ddt.manager
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.ui.Mouse;

    public class InGameCursor extends EventDispatcher 
    {

        private static const LOADING_CURSOR_CLASS:String = "cursor.LoadingCursor";
        private static var _instance:InGameCursor;
        public static var _disabled:Boolean;

        private var _setuped:Boolean;

        public function InGameCursor(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public static function set disabled(_arg_1:Boolean):void
        {
            _disabled = _arg_1;
        }

        public static function get Instance():InGameCursor
        {
            if (_instance == null)
            {
                _instance = new (InGameCursor)();
            };
            return (_instance);
        }

        public static function hide():void
        {
            Mouse.hide();
            if (_disabled)
            {
                return;
            };
        }

        public static function show():void
        {
            Mouse.show();
            if (_disabled)
            {
                return;
            };
        }


        public function set cursorType(_arg_1:String):void
        {
        }


    }
}//package ddt.manager

