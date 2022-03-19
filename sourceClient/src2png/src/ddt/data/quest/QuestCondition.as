// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.quest.QuestCondition

package ddt.data.quest
{
    public class QuestCondition 
    {

        private var _description:String;
        private var _type:int;
        private var _param1:int;
        private var _param2:int;
        private var _questId:int;
        private var _conId:int;
        public var isOpitional:Boolean;

        public function QuestCondition(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String="", _arg_5:int=0, _arg_6:int=0)
        {
            this._questId = _arg_1;
            this._conId = _arg_2;
            this._description = _arg_4;
            this._type = _arg_3;
            this._param1 = _arg_5;
            this._param2 = _arg_6;
        }

        public function get target():int
        {
            if (((this._type == 20) && (!(this._param1 == 3))))
            {
                if ((!(this._param2)))
                {
                    return (0);
                };
            };
            return (this._param2);
        }

        public function get param():int
        {
            if ((!(this._param1)))
            {
                return (0);
            };
            return (this._param1);
        }

        public function get param2():int
        {
            if ((!(this._param2)))
            {
                return (0);
            };
            return (this._param2);
        }

        public function get description():String
        {
            if (this._description == "")
            {
                return ("no description");
            };
            return (this._description);
        }

        public function get type():int
        {
            return (this._type);
        }

        public function tos():String
        {
            return (this._description);
        }

        public function get questID():int
        {
            return (this._questId);
        }

        public function get ConID():int
        {
            return (this._conId);
        }


    }
}//package ddt.data.quest

