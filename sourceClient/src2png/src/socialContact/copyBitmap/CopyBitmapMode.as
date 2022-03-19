// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//socialContact.copyBitmap.CopyBitmapMode

package socialContact.copyBitmap
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    public class CopyBitmapMode extends EventDispatcher 
    {

        public static const CHANGE_MODE:String = "change_mode";

        public var ponitID:int;
        private var _startX:int;
        private var _startY:int;
        private var _endX:int;
        private var _endY:int;


        public function set startX(_arg_1:int):void
        {
            this._startX = _arg_1;
            dispatchEvent(new Event(CHANGE_MODE));
        }

        public function get startX():int
        {
            return (this._startX);
        }

        public function set startY(_arg_1:int):void
        {
            this._startY = _arg_1;
            dispatchEvent(new Event(CHANGE_MODE));
        }

        public function get startY():int
        {
            return (this._startY);
        }

        public function set endX(_arg_1:int):void
        {
            this._endX = _arg_1;
            dispatchEvent(new Event(CHANGE_MODE));
        }

        public function get endX():int
        {
            return (this._endX);
        }

        public function set endY(_arg_1:int):void
        {
            this._endY = _arg_1;
            dispatchEvent(new Event(CHANGE_MODE));
        }

        public function get endY():int
        {
            return (this._endY);
        }


    }
}//package socialContact.copyBitmap

