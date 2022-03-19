// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.analyze.StoreEquipExpericenceAnalyze

package store.analyze
{
    import com.pickgliss.loader.DataAnalyzer;

    public class StoreEquipExpericenceAnalyze extends DataAnalyzer 
    {

        public var expericence:Array;

        public function StoreEquipExpericenceAnalyze(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_2:XML = new XML(_arg_1);
            this.expericence = [];
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    this.expericence[_local_4] = int(_local_3[_local_4].@Exp);
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
}//package store.analyze

