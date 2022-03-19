// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.VoteSubmitResultAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;

    public class VoteSubmitResultAnalyzer extends DataAnalyzer 
    {

        public var result:int;

        public function VoteSubmitResultAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            this.result = _arg_1;
            onAnalyzeComplete();
        }


    }
}//package ddt.data.analyze

