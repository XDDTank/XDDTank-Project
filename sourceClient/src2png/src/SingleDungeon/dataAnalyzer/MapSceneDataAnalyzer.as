// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.dataAnalyzer.MapSceneDataAnalyzer

package SingleDungeon.dataAnalyzer
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import SingleDungeon.model.MapSceneModel;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class MapSceneDataAnalyzer extends DataAnalyzer 
    {

        public var mapSceneList:Vector.<MapSceneModel>;

        public function MapSceneDataAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:MapSceneModel;
            this.mapSceneList = new Vector.<MapSceneModel>();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new MapSceneModel();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    this.mapSceneList.push(_local_5);
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

