// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.FilterWordAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import com.hurlant.util.Base64;

    public class FilterWordAnalyzer extends DataAnalyzer 
    {

        public var words:Array = [];
        public var serverWords:Array = [];
        public var unableChar:String;

        public function FilterWordAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:String = Base64.decode(String(_arg_1));
            var _local_3:Array = _local_2.toLocaleLowerCase().split("\n");
            if (_local_3)
            {
                if (_local_3[0])
                {
                    this.unableChar = _local_3[0];
                };
                if (_local_3[1])
                {
                    this.words = _local_3[1].split("|");
                };
                if (_local_3[2])
                {
                    this.serverWords = _local_3[2].split("|");
                };
            };
            onAnalyzeComplete();
        }


    }
}//package ddt.data.analyze

