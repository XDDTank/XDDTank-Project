// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.analyze.ConsortionEventListAnalyzer

package consortion.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.ConsortiaEventInfo;
    import __AS3__.vec.*;

    public class ConsortionEventListAnalyzer extends DataAnalyzer 
    {

        public var eventList:Vector.<ConsortiaEventInfo>;

        public function ConsortionEventListAnalyzer(_arg_1:Function=null)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:ConsortiaEventInfo;
            this.eventList = new Vector.<ConsortiaEventInfo>();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new ConsortiaEventInfo();
                    _local_5.ID = _local_3[_local_4].@ID;
                    _local_5.ConsortiaID = _local_3[_local_4].@ConsortiaID;
                    _local_5.Date = _local_3[_local_4].@Date;
                    _local_5.Type = _local_3[_local_4].@Type;
                    _local_5.NickName = _local_3[_local_4].@NickName;
                    _local_5.EventValue = _local_3[_local_4].@EventValue;
                    _local_5.ManagerName = _local_3[_local_4].@ManagerName;
                    this.eventList.push(_local_5);
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
}//package consortion.analyze

