// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.VoteInfoAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;
    import ddt.data.vote.VoteQuestionInfo;

    public class VoteInfoAnalyzer extends DataAnalyzer 
    {

        public var firstQuestionID:String;
        public var completeMessage:String;
        public var questionLength:int;
        public var list:Dictionary;
        public var voteId:String;
        private var award:String;

        public function VoteInfoAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        public function get awardArr():Array
        {
            return (this.award.split(","));
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_5:VoteQuestionInfo;
            var _local_6:XMLList;
            var _local_7:int;
            var _local_8:int;
            var _local_9:String;
            this.list = new Dictionary();
            var _local_2:XML = new XML(_arg_1);
            this.voteId = _local_2.@voteId;
            this.firstQuestionID = _local_2.@firstQuestionID;
            this.completeMessage = _local_2.@completeMessage;
            this.award = _local_2.@award;
            var _local_3:XMLList = _local_2..item;
            this.questionLength = _local_3.length();
            var _local_4:int;
            while (_local_4 < _local_3.length())
            {
                _local_5 = new VoteQuestionInfo();
                _local_5.questionID = _local_3[_local_4].@id;
                _local_5.multiple = ((_local_3[_local_4].@multiple == "true") ? true : false);
                _local_5.question = _local_3[_local_4].@question;
                _local_5.nextQuestionID = _local_3[_local_4].@nextQuestionID;
                _local_6 = _local_3[_local_4]..answer;
                _local_5.answerLength = _local_6.length();
                _local_7 = 0;
                while (_local_7 < _local_6.length())
                {
                    _local_8 = int(_local_6[_local_7].@id);
                    _local_9 = _local_6[_local_7].@value;
                    _local_5.answer[_local_8] = _local_9;
                    _local_7++;
                };
                this.list[_local_5.questionID] = _local_5;
                _local_4++;
            };
            onAnalyzeComplete();
        }


    }
}//package ddt.data.analyze

