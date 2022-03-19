// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//feedback.analyze.LoadFeedbackReplyAnalyzer

package feedback.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import feedback.data.FeedbackReplyInfo;

    public class LoadFeedbackReplyAnalyzer extends DataAnalyzer 
    {

        public var listData:DictionaryData;

        public function LoadFeedbackReplyAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:XMLList;
            var _local_3:int;
            var _local_4:FeedbackReplyInfo;
            if (((!(String(_arg_1) == "0")) || (!(_arg_1))))
            {
                this.listData = new DictionaryData();
                _local_2 = XML(_arg_1)..Question;
                if (_local_2)
                {
                    _local_3 = 0;
                    while (_local_3 < _local_2.length())
                    {
                        _local_4 = new FeedbackReplyInfo();
                        _local_4.questionId = _local_2[_local_3].@QuestionID;
                        _local_4.replyId = _local_2[_local_3].@ReplyID;
                        _local_4.occurrenceDate = _local_2[_local_3].@OccurrenceDate;
                        _local_4.questionTitle = _local_2[_local_3].@Title;
                        _local_4.questionContent = _local_2[_local_3].@QuestionContent;
                        _local_4.replyContent = _local_2[_local_3].@ReplyContent;
                        _local_4.stopReply = _local_2[_local_3].@StopReply;
                        this.listData.add(((_local_4.questionId + "_") + _local_4.replyId), _local_4);
                        _local_3++;
                    };
                };
            };
            onAnalyzeComplete();
        }


    }
}//package feedback.analyze

