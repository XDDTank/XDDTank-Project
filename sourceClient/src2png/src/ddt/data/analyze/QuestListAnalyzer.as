// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.QuestListAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;
    import ddt.data.quest.QuestInfo;

    public class QuestListAnalyzer extends DataAnalyzer 
    {

        private var _xml:XML;
        private var _list:Dictionary;

        public function QuestListAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        public function get list():Dictionary
        {
            return (this._list);
        }

        public function get improveXml():XML
        {
            var _local_1:XMLList = this._xml..Rate;
            return (_local_1[0]);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_4:XML;
            var _local_5:QuestInfo;
            this._xml = new XML(_arg_1);
            var _local_2:XMLList = this._xml..Item;
            this._list = new Dictionary();
            var _local_3:int;
            while (_local_3 < _local_2.length())
            {
                _local_4 = _local_2[_local_3];
                _local_5 = QuestInfo.createFromXML(_local_4);
                this._list[_local_5.Id] = _local_5;
                _local_3++;
            };
            onAnalyzeComplete();
        }


    }
}//package ddt.data.analyze

