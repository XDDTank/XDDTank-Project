// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.WeekOpenMapAnalyze

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.map.OpenMapInfo;
    import __AS3__.vec.*;

    public class WeekOpenMapAnalyze extends DataAnalyzer 
    {

        public static const PATH:String = "MapServerList.xml";

        public var list:Vector.<OpenMapInfo>;

        public function WeekOpenMapAnalyze(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_4:XMLList;
            var _local_5:int;
            var _local_6:OpenMapInfo;
            var _local_2:XML = new XML(_arg_1);
            var _local_3:String = _local_2.@value;
            if (_local_3 == "true")
            {
                this.list = new Vector.<OpenMapInfo>();
                _local_4 = _local_2..Item;
                _local_5 = 0;
                while (_local_5 < _local_4.length())
                {
                    _local_6 = new OpenMapInfo();
                    _local_6.maps = _local_4[_local_5].@OpenMap.split(",");
                    _local_6.serverID = _local_4[_local_5].@ServerID;
                    this.list.push(_local_6);
                    _local_5++;
                };
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
            };
        }


    }
}//package ddt.data.analyze

