// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.utils.Helpers

package ddt.utils
{
    import flash.display.Stage;
    import flash.display.Sprite;
    import flash.text.TextFormat;
    import flash.text.TextField;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.MouseEvent;
    import flash.display.InteractiveObject;
    import flash.events.Event;

    public class Helpers 
    {

        private static var _stage:Stage;
        public static const STAGE_UP_EVENT:String = "STAGE_UP_EVENT";
        public static const MOUSE_DOWN_AND_DRAGING_EVENT:String = "MOUSE_DOWN_AND_DRAGING_EVENT";
        private static var enterFrameDispatcher:Sprite = new Sprite();
        private static const encode_arr:Array = [["%", "%01"], ["]", "%02"], ["\\[", "%03"]];
        private static const decode_arr:Array = [["%", "%01"], ["]", "%02"], ["[", "%03"]];


        public static function setTextfieldFormat(_arg_1:TextField, _arg_2:Object, _arg_3:Boolean=false):void
        {
            var _local_5:String;
            var _local_4:TextFormat = _arg_1.getTextFormat();
            for (_local_5 in _arg_2)
            {
                _local_4[_local_5] = ((_arg_2[_local_5]) || (_local_4[_local_5]));
            };
            if (_arg_3)
            {
                _arg_1.setTextFormat(_local_4);
            };
            _arg_1.defaultTextFormat = _local_4;
        }

        public static function hidePosMc(_arg_1:DisplayObjectContainer):void
        {
            var _local_3:DisplayObject;
            var _local_2:RegExp = /_pos$/;
            var _local_4:int;
            while (_local_4 < _arg_1.numChildren)
            {
                _local_3 = _arg_1.getChildAt(_local_4);
                if (_local_2.test(_local_3.name))
                {
                    _local_3.visible = false;
                };
                _local_4++;
            };
        }

        public static function registExtendMouseEvent(_arg_1:InteractiveObject):void
        {
            _arg_1.addEventListener(MouseEvent.MOUSE_DOWN, __dobjDown);
        }

        private static function __dobjDown(e:MouseEvent):void
        {
            var dobj:InteractiveObject;
            var fun_up:Function;
            var fun_move:Function;
            dobj = (e.currentTarget as InteractiveObject);
            fun_up = function (_arg_1:MouseEvent):void
            {
                dobj.dispatchEvent(new Event(STAGE_UP_EVENT));
                dobj.stage.removeEventListener(MouseEvent.MOUSE_UP, fun_up);
                dobj.stage.removeEventListener(MouseEvent.MOUSE_MOVE, fun_move);
            };
            fun_move = function (_arg_1:MouseEvent):void
            {
                dobj.dispatchEvent(new Event(MOUSE_DOWN_AND_DRAGING_EVENT));
            };
            dobj.stage.addEventListener(MouseEvent.MOUSE_UP, fun_up);
            dobj.stage.addEventListener(MouseEvent.MOUSE_MOVE, fun_move);
        }

        public static function delayCall(fun:Function, delay_frame:int=1):void
        {
            var fun_new:Function;
            fun_new = function (_arg_1:Event):void
            {
                if (--delay_frame <= 0)
                {
                    fun();
                    enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME, fun_new);
                };
            };
            enterFrameDispatcher.addEventListener(Event.ENTER_FRAME, fun_new);
        }

        public static function copyProperty(_arg_1:Object, _arg_2:Object, _arg_3:Array=null):void
        {
            var _local_4:String;
            for each (_local_4 in _arg_3)
            {
                _arg_2[_local_4] = _arg_1[_local_4];
            };
        }

        public static function enCodeString(_arg_1:String):String
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < encode_arr.length)
            {
                _arg_1 = _arg_1.replace(new RegExp(encode_arr[_local_2][0], "g"), encode_arr[_local_2][1]);
                _local_2++;
            };
            return (_arg_1);
        }

        public static function deCodeString(_arg_1:String):String
        {
            var _local_2:int;
            _local_2 = (decode_arr.length - 1);
            while (_local_2 >= 0)
            {
                _arg_1 = _arg_1.replace(new RegExp(decode_arr[_local_2][1], "g"), decode_arr[_local_2][0]);
                _local_2--;
            };
            return (_arg_1);
        }

        public static function setup(_arg_1:Stage):void
        {
            _stage = _arg_1;
        }

        public static function randomPick(_arg_1:Array):*
        {
            var _local_2:int = _arg_1.length;
            var _local_3:int = Math.floor((_local_2 * Math.random()));
            return (_arg_1[_local_3]);
        }


    }
}//package ddt.utils

