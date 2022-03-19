// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.data.ConditionRecord

package activity.data
{
    public class ConditionRecord 
    {

        private var _conditionIndex:int;
        private var _record:int;
        private var _remain1:int;

        public function ConditionRecord(_arg_1:int, _arg_2:int, _arg_3:int)
        {
            this._conditionIndex = _arg_1;
            this._record = _arg_2;
            this._remain1 = _arg_3;
        }

        public function get conditionIndex():int
        {
            return (this._conditionIndex);
        }

        public function get record():int
        {
            return (this._record);
        }

        public function get remain1():int
        {
            return (this._remain1);
        }


    }
}//package activity.data

