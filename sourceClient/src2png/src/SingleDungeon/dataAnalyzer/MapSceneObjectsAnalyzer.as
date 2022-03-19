// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.dataAnalyzer.MapSceneObjectsAnalyzer

package SingleDungeon.dataAnalyzer
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import SingleDungeon.model.WalkMapObject;
    import com.pickgliss.utils.ObjectUtils;

    public class MapSceneObjectsAnalyzer extends DataAnalyzer 
    {

        public var walkMapObjectsDic:DictionaryData = new DictionaryData();

        public function MapSceneObjectsAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:WalkMapObject;
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new WalkMapObject();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    this.walkMapObjectsDic.add(_local_5.ID, _local_5);
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

