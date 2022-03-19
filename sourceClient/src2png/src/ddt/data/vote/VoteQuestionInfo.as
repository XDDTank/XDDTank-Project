// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.vote.VoteQuestionInfo

package ddt.data.vote
{
    import flash.utils.Dictionary;

    public class VoteQuestionInfo 
    {

        public var questionID:String;
        public var question:String;
        public var nextQuestionID:String;
        public var multiple:Boolean;
        public var answer:Dictionary;
        public var answerLength:int;

        public function VoteQuestionInfo()
        {
            this.answer = new Dictionary();
        }

    }
}//package ddt.data.vote

