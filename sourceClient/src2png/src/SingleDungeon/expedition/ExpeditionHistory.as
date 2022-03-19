// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.expedition.ExpeditionHistory

package SingleDungeon.expedition
{
    public class ExpeditionHistory 
    {

        public static const BIT_LENGTH:int = 0x0100;
        public static const FB_BASEID:int = 91000;
        private static var _instance:ExpeditionHistory;

        private var array:Array;
        private var arrLength:int;

        public function ExpeditionHistory()
        {
            this.array = new Array();
            this.arrLength = (((BIT_LENGTH - 1) >> 3) + 1);
        }

        public static function get instance():ExpeditionHistory
        {
            if ((!(_instance)))
            {
                _instance = new (ExpeditionHistory)();
            };
            return (_instance);
        }


        public function sets(_arg_1:String):void
        {
            var _local_5:String;
            var _local_2:int = ((_arg_1.length < BIT_LENGTH) ? _arg_1.length : BIT_LENGTH);
            var _local_3:int;
            while (_local_3 < this.arrLength)
            {
                this.array[_local_3] = 0;
                _local_3++;
            };
            var _local_4:int;
            while (_local_4 < _local_2)
            {
                _local_5 = _arg_1.charAt(_local_4);
                if (_local_5 == "1")
                {
                    this.set((_local_4 + 1));
                }
                else
                {
                    if (_local_5 != "0")
                    {
                    };
                };
                _local_4++;
            };
        }

        public function set(_arg_1:int):void
        {
            if (((_arg_1 < 0) || (_arg_1 >= BIT_LENGTH)))
            {
                return;
            };
            var _local_2:int = ((_arg_1 - 1) >> 3);
            var _local_3:int = (1 << ((_arg_1 - 1) % 8));
            this.array[_local_2] = (this.array[_local_2] | _local_3);
        }

        public function get(_arg_1:int):Boolean
        {
            var _local_2:int = (_arg_1 - FB_BASEID);
            if (((_local_2 < 0) || (_local_2 >= BIT_LENGTH)))
            {
                return (false);
            };
            var _local_3:int = ((_local_2 - 1) >> 3);
            var _local_4:int = (1 << ((_local_2 - 1) % 8));
            return ((!((this.array[_local_3] & _local_4) == 0)) ? true : false);
        }


    }
}//package SingleDungeon.expedition

