// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.data.ComposeCurrentInfo

package store.data
{
    public class ComposeCurrentInfo 
    {

        public var lastComposeTime:Date;
        public var composeNeedTime:int;
        public var templeteID:int;
        public var count:int;
        public var type:int = 40;
        private var _remainTime:int = 0;


        public function get remainTime():int
        {
            return (this._remainTime);
        }

        public function set remainTime(_arg_1:int):void
        {
            this._remainTime = _arg_1;
        }


    }
}//package store.data

