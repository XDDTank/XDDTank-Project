// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.DungeonAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.map.DungeonInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class DungeonAnalyzer extends DataAnalyzer 
    {

        private static const PATH:String = "LoadPVEItems.xml";

        public var list:Vector.<DungeonInfo>;

        public function DungeonAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:DungeonInfo;
            var _local_6:String;
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                this.list = new Vector.<DungeonInfo>();
                _local_3 = _local_2..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new DungeonInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    if (_local_5.Name != "")
                    {
                        _local_6 = _local_3[_local_4].@Energy;
                        _local_5.setEnergy(_local_6);
                        this.list.push(_local_5);
                    };
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

