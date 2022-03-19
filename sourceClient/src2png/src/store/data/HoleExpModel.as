// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.data.HoleExpModel

package store.data
{
    public class HoleExpModel 
    {

        private var _expList:Array;
        private var _maxLv:int;
        private var _maxOpLv:int;


        public function set explist(_arg_1:String):void
        {
            this._expList = _arg_1.split("|");
        }

        public function set maxLv(_arg_1:String):void
        {
            this._maxLv = int(_arg_1);
        }

        public function set oprationLv(_arg_1:String):void
        {
            this._maxOpLv = int(_arg_1);
        }

        public function getMaxLv():int
        {
            return (this._maxLv);
        }

        public function getMaxOpLv():int
        {
            return (this._maxOpLv);
        }

        public function getExpByLevel(_arg_1:int):int
        {
            var _local_2:int = this._expList[_arg_1];
            if (_local_2 >= 0)
            {
                return (_local_2);
            };
            return (-1);
        }


    }
}//package store.data

