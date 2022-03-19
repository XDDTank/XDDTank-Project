// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.toplevel.StageReferance

package com.pickgliss.toplevel
{
    import flash.display.Stage;
    import flash.events.Event;

    public final class StageReferance 
    {

        public static var stageHeight:int;
        public static var stageWidth:int;
        private static var _stage:Stage;


        public static function setup(_arg_1:Stage):void
        {
            if (_stage != null)
            {
                return;
            };
            _stage = _arg_1;
            _stage.addEventListener(Event.EXIT_FRAME, __onNextFrame);
            _stage.addEventListener(Event.RESIZE, __onResize);
            _stage.stageFocusRect = false;
        }

        private static function __onNextFrame(_arg_1:Event):void
        {
            if (_stage.stageWidth > 0)
            {
                _stage.removeEventListener(Event.EXIT_FRAME, __onNextFrame);
                stageWidth = _stage.stageWidth;
                stageHeight = _stage.stageHeight;
            };
        }

        private static function __onResize(_arg_1:Event):void
        {
            stageWidth = _stage.stageWidth;
            stageHeight = _stage.stageHeight;
        }

        public static function get stage():Stage
        {
            return (_stage);
        }


    }
}//package com.pickgliss.toplevel

