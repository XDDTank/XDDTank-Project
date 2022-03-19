// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.dataAnalyzer.BigMapDataAnalyzer

package SingleDungeon.dataAnalyzer
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import SingleDungeon.model.BigMapModel;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class BigMapDataAnalyzer extends DataAnalyzer 
    {

        public var bigMapList:Vector.<BigMapModel>;

        public function BigMapDataAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:BigMapModel;
            this.bigMapList = new Vector.<BigMapModel>();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new BigMapModel();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    this.bigMapList.push(_local_5);
                    _local_4++;
                };
                onAnalyzeComplete();
            }
            else
            {
                onAnalyzeError();
            };
        }


    }
}//package SingleDungeon.dataAnalyzer

