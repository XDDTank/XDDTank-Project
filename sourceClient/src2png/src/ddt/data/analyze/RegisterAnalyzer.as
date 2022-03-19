// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.RegisterAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;

    public class RegisterAnalyzer extends DataAnalyzer 
    {

        public function RegisterAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:XML = new XML(_arg_1);
            var _local_3:String = _local_2.@value;
            message = _local_2.@message;
            if (_local_3 == "true")
            {
                onAnalyzeComplete();
            }
            else
            {
                onAnalyzeError();
            };
        }


    }
}//package ddt.data.analyze

