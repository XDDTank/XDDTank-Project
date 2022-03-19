// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//feedback.FeedbackEvent

package feedback
{
    import flash.events.Event;

    public class FeedbackEvent extends Event 
    {

        public static const FEEDBACK_REPLY_ADD:String = "feedbackReplyAdd";
        public static const FEEDBACK_REPLY_REMOVE:String = "feedbackReplyRemove";
        public static const FEEDBACK_StopReply:String = "feedbackStopReply";

        public var data:Object;

        public function FeedbackEvent(_arg_1:String, _arg_2:Object)
        {
            this.data = _arg_2;
            super(_arg_1);
        }

    }
}//package feedback

