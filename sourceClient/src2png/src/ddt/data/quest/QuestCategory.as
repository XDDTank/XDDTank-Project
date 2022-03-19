// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.quest.QuestCategory

package ddt.data.quest
{
    public class QuestCategory 
    {

        private var _completedQuestArray:Array;
        private var _newQuestArray:Array;
        private var _questArray:Array;

        public function QuestCategory()
        {
            this._completedQuestArray = new Array();
            this._newQuestArray = new Array();
            this._questArray = new Array();
        }

        public function addNew(_arg_1:QuestInfo):void
        {
            this._newQuestArray.push(_arg_1);
        }

        public function addCompleted(_arg_1:QuestInfo):void
        {
            this._completedQuestArray.push(_arg_1);
        }

        public function addQuest(_arg_1:QuestInfo):void
        {
            this._questArray.push(_arg_1);
        }

        public function get list():Array
        {
            return (this._completedQuestArray.concat(this._newQuestArray.concat(this._questArray)));
        }

        public function get haveNew():Boolean
        {
            var _local_1:QuestInfo;
            for each (_local_1 in this._newQuestArray)
            {
                if (((_local_1.data) && (_local_1.data.isNew)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function get haveRecommend():Boolean
        {
            var _local_1:int;
            while (_local_1 < this.list.length)
            {
                if (this.list[_local_1].StarLev == 1)
                {
                    return (true);
                };
                _local_1++;
            };
            return (false);
        }

        public function get haveCompleted():Boolean
        {
            return (this._completedQuestArray.length > 0);
        }


    }
}//package ddt.data.quest

