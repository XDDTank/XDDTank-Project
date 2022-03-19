// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.fightLib.FightLibAwardInfo

package ddt.data.fightLib
{
    public class FightLibAwardInfo 
    {

        private var _id:int;
        private var _easyAward:Array;
        private var _normalAward:Array;
        private var _difficultAward:Array;

        public function FightLibAwardInfo()
        {
            this._easyAward = [];
            this._normalAward = [];
            this._difficultAward = [];
        }

        public function get easyAward():Array
        {
            return (this._easyAward);
        }

        public function set easyAward(_arg_1:Array):void
        {
            this._easyAward = _arg_1;
        }

        public function get normalAward():Array
        {
            return (this._normalAward);
        }

        public function set normalAward(_arg_1:Array):void
        {
            this._normalAward = _arg_1;
        }

        public function get difficultAward():Array
        {
            return (this._difficultAward);
        }

        public function set difficultAward(_arg_1:Array):void
        {
            this._difficultAward = _arg_1;
        }

        public function get id():int
        {
            return (this._id);
        }

        public function set id(_arg_1:int):void
        {
            this._id = _arg_1;
        }


    }
}//package ddt.data.fightLib

