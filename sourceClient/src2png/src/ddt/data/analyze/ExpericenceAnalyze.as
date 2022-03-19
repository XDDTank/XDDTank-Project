// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.ExpericenceAnalyze

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;

    public class ExpericenceAnalyze extends DataAnalyzer 
    {

        public var expericence:Array;
        public var HP:Array;

        public function ExpericenceAnalyze(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_2:XML = new XML(_arg_1);
            this.expericence = [];
            this.HP = [];
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    this.expericence.push(int(_local_3[_local_4].@GP));
                    this.HP.push(int(_local_3[_local_4].@Blood));
                    _local_4++;
                };
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
}//package ddt.data.analyze

