// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.MapAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.map.MapInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class MapAnalyzer extends DataAnalyzer 
    {

        public var list:Vector.<MapInfo>;

        public function MapAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:MapInfo;
            var _local_2:XML = new XML(_arg_1);
            this.list = new Vector.<MapInfo>();
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..Item;
                _local_4 = (_local_3.length() - 1);
                while (_local_4 >= 0)
                {
                    _local_5 = new MapInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    if (_local_5.Name != "")
                    {
                        _local_5.canSelect = (_local_5.ID <= 2000);
                        this.list.push(_local_5);
                    };
                    _local_4--;
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

