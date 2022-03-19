// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.vo.FatherBallConfigVO

package church.vo
{
    public class FatherBallConfigVO 
    {

        private var _isMask:String;
        private var _rowNumber:int;
        private var _rowWitdh:Number;
        private var _rowHeight:Number;
        private var _frameStep:Number;
        private var _sleepSecond:int;


        public function get isMask():String
        {
            return (this._isMask);
        }

        public function set isMask(_arg_1:String):void
        {
            this._isMask = _arg_1;
        }

        public function get sleepSecond():int
        {
            return (this._sleepSecond);
        }

        public function set sleepSecond(_arg_1:int):void
        {
            this._sleepSecond = _arg_1;
        }

        public function get frameStep():Number
        {
            return (this._frameStep);
        }

        public function set frameStep(_arg_1:Number):void
        {
            this._frameStep = _arg_1;
        }

        public function get rowHeight():Number
        {
            return (this._rowHeight);
        }

        public function set rowHeight(_arg_1:Number):void
        {
            this._rowHeight = _arg_1;
        }

        public function get rowWitdh():Number
        {
            return (this._rowWitdh);
        }

        public function set rowWitdh(_arg_1:Number):void
        {
            this._rowWitdh = _arg_1;
        }

        public function get rowNumber():int
        {
            return (this._rowNumber);
        }

        public function set rowNumber(_arg_1:int):void
        {
            this._rowNumber = _arg_1;
        }


    }
}//package church.vo

