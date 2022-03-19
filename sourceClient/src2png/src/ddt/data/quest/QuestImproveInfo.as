// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.quest.QuestImproveInfo

package ddt.data.quest
{
    public class QuestImproveInfo 
    {

        private var _bindMoneyRate:Array;
        private var _expRate:Array;
        private var _goldRate:Array;
        private var _exploitRate:Array;
        private var _canOneKeyFinishTime:int;


        public function get canOneKeyFinishTime():int
        {
            return (this._canOneKeyFinishTime);
        }

        public function set canOneKeyFinishTime(_arg_1:int):void
        {
            this._canOneKeyFinishTime = _arg_1;
        }

        public function get exploitRate():Array
        {
            return (this._exploitRate);
        }

        public function set exploitRate(_arg_1:Array):void
        {
            this._exploitRate = _arg_1;
        }

        public function get goldRate():Array
        {
            return (this._goldRate);
        }

        public function set goldRate(_arg_1:Array):void
        {
            this._goldRate = _arg_1;
        }

        public function get expRate():Array
        {
            return (this._expRate);
        }

        public function set expRate(_arg_1:Array):void
        {
            this._expRate = _arg_1;
        }

        public function get bindMoneyRate():Array
        {
            return (this._bindMoneyRate);
        }

        public function set bindMoneyRate(_arg_1:Array):void
        {
            this._bindMoneyRate = _arg_1;
        }


    }
}//package ddt.data.quest

