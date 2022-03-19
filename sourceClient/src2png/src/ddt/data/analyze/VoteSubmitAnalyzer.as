// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.VoteSubmitAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;

    public class VoteSubmitAnalyzer extends DataAnalyzer 
    {

        public static const FILENAME:String = "vote.xml";

        public var result:String = "";

        public function VoteSubmitAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            if (_arg_1 != -1)
            {
                this.result = _arg_1;
                onAnalyzeComplete();
            }
            else
            {
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }


    }
}//package ddt.data.analyze

