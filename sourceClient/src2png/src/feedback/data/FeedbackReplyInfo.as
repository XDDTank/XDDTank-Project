// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//feedback.data.FeedbackReplyInfo

package feedback.data
{
    public class FeedbackReplyInfo 
    {

        private var _questionId:String;
        private var _questionTitle:String;
        private var _occurrenceDate:String;
        private var _questionContent:String;
        private var _replyId:int;
        private var _nickName:String;
        private var _replyDate:Date;
        private var _replyContent:String;
        private var _stopReply:String;


        public function get questionId():String
        {
            return (this._questionId);
        }

        public function set questionId(_arg_1:String):void
        {
            this._questionId = _arg_1;
        }

        public function get replyId():int
        {
            return (this._replyId);
        }

        public function set replyId(_arg_1:int):void
        {
            this._replyId = _arg_1;
        }

        public function get nickName():String
        {
            return (this._nickName);
        }

        public function set nickName(_arg_1:String):void
        {
            this._nickName = _arg_1;
        }

        public function get replyDate():Date
        {
            return (this._replyDate);
        }

        public function set replyDate(_arg_1:Date):void
        {
            this._replyDate = _arg_1;
        }

        public function get replyContent():String
        {
            return (this._replyContent);
        }

        public function set replyContent(_arg_1:String):void
        {
            this._replyContent = _arg_1;
        }

        public function get stopReply():String
        {
            return (this._stopReply);
        }

        public function set stopReply(_arg_1:String):void
        {
            this._stopReply = _arg_1;
        }

        public function get questionTitle():String
        {
            return (this._questionTitle);
        }

        public function set questionTitle(_arg_1:String):void
        {
            this._questionTitle = _arg_1;
        }

        public function get occurrenceDate():String
        {
            return (this._occurrenceDate);
        }

        public function set occurrenceDate(_arg_1:String):void
        {
            this._occurrenceDate = _arg_1;
        }

        public function get questionContent():String
        {
            return (this._questionContent);
        }

        public function set questionContent(_arg_1:String):void
        {
            this._questionContent = _arg_1;
        }


    }
}//package feedback.data

