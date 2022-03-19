// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.ChargeMoneyAnalyzer

package ddt.manager
{
    import com.pickgliss.loader.DataAnalyzer;

    public class ChargeMoneyAnalyzer extends DataAnalyzer 
    {

        public var result:Boolean;

        public function ChargeMoneyAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                this.result = true;
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }


    }
}//package ddt.manager

