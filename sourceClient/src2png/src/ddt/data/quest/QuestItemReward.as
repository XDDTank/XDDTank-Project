// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.quest.QuestItemReward

package ddt.data.quest
{
    public class QuestItemReward 
    {

        private var _selectGroup:int;
        private var _itemID:int;
        private var _count:Array;
        private var _isOptional:int;
        private var _time:int;
        private var _StrengthenLevel:int;
        private var _AttackCompose:int;
        private var _DefendCompose:int;
        private var _AgilityCompose:int;
        private var _LuckCompose:int;
        private var _isBind:Boolean;
        public var AttackCompose:int;
        public var DefendCompose:int;
        public var LuckCompose:int;
        public var AgilityCompose:int;
        public var StrengthenLevel:int;
        public var IsCount:Boolean;

        public function QuestItemReward(_arg_1:int, _arg_2:Array, _arg_3:String, _arg_4:String="true")
        {
            this._itemID = _arg_1;
            this._count = _arg_2;
            if (_arg_3 == "true")
            {
                this._isOptional = 1;
            }
            else
            {
                this._isOptional = 0;
            };
            if (_arg_4 == "true")
            {
                this._isBind = true;
            }
            else
            {
                this._isBind = false;
            };
        }

        public function get count():Array
        {
            return (this._count);
        }

        public function get itemID():int
        {
            return (this._itemID);
        }

        public function set time(_arg_1:int):void
        {
            this._time = _arg_1;
        }

        public function get time():int
        {
            return (this._time);
        }

        public function get ValidateTime():Number
        {
            return (this._time);
        }

        public function get isOptional():int
        {
            return (this._isOptional);
        }

        public function get isBind():Boolean
        {
            return (this._isBind);
        }


    }
}//package ddt.data.quest

