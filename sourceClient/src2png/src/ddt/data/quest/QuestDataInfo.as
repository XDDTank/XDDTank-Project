// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.quest.QuestDataInfo

package ddt.data.quest
{
    public class QuestDataInfo 
    {

        public var repeatLeft:int;
        public var hadChecked:Boolean;
        public var quality:int;
        private var _questID:int;
        private var _progress:Array;
        public var CompleteDate:Date;
        private var _isAchieved:Boolean;
        private var _isNew:Boolean;
        private var _informed:Boolean;
        private var _isExist:Boolean;

        public function QuestDataInfo(_arg_1:int):void
        {
            this._questID = _arg_1;
            this.hadChecked = false;
            this._isNew = false;
            this._informed = false;
        }

        public function set isExist(_arg_1:Boolean):void
        {
            this._isExist = _arg_1;
        }

        public function get isExist():Boolean
        {
            return (this._isExist);
        }

        public function get id():int
        {
            return (this._questID);
        }

        public function set isNew(_arg_1:Boolean):void
        {
            this._isNew = _arg_1;
        }

        public function get isNew():Boolean
        {
            return (this._isNew);
        }

        public function set informed(_arg_1:Boolean):void
        {
            this._informed = _arg_1;
        }

        public function get needInformed():Boolean
        {
            if (((!(this._informed)) && (this._isNew)))
            {
                return (true);
            };
            return (false);
        }

        public function get isAchieved():Boolean
        {
            return (this._isAchieved);
        }

        public function set isAchieved(_arg_1:Boolean):void
        {
            this._isAchieved = _arg_1;
        }

        public function setProgress(_arg_1:int, _arg_2:int=0, _arg_3:int=0, _arg_4:int=0):void
        {
            if ((!(this._progress)))
            {
                this._progress = new Array();
            };
            this._progress[0] = _arg_1;
            this._progress[1] = _arg_2;
            this._progress[2] = _arg_3;
            this._progress[3] = _arg_4;
        }

        public function get progress():Array
        {
            return (this._progress);
        }

        public function get isCompleted():Boolean
        {
            if ((!(this._progress)))
            {
                return (false);
            };
            if (((((this._progress[0] <= 0) && (this._progress[1] <= 0)) && (this._progress[2] <= 0)) && (this._progress[3] <= 0)))
            {
                return (true);
            };
            return (false);
        }

        public function get ConditionCount():int
        {
            if (this._progress[0])
            {
                return (this._progress[0]);
            };
            return (0);
        }

        public function set ConditionCount(_arg_1:int):void
        {
        }


    }
}//package ddt.data.quest

