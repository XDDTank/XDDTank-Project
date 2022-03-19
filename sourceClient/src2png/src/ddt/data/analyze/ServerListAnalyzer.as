﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.ServerListAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.ServerInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ServerListAnalyzer extends DataAnalyzer 
    {

        public var list:Vector.<ServerInfo>;
        public var agentId:int;
        public var zoneName:String;

        public function ServerListAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:ServerInfo;
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                this.agentId = _local_2.@agentId;
                this.zoneName = _local_2.@AreaName;
                message = _local_2.@message;
                _local_3 = _local_2..Item;
                this.list = new Vector.<ServerInfo>();
                if (_local_3.length() > 0)
                {
                    _local_4 = 0;
                    while (_local_4 < _local_3.length())
                    {
                        _local_5 = new ServerInfo();
                        ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                        this.list.push(_local_5);
                        _local_4++;
                    };
                    onAnalyzeComplete();
                };
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
            };
        }


    }
}//package ddt.data.analyze

