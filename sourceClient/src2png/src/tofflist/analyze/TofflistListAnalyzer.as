// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.analyze.TofflistListAnalyzer

package tofflist.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import tofflist.data.TofflistListData;
    import tofflist.data.TofflistPlayerInfo;
    import tofflist.data.TofflistConsortiaData;
    import tofflist.data.TofflistConsortiaInfo;
    import flash.utils.describeType;
    import com.pickgliss.utils.ObjectUtils;

    public class TofflistListAnalyzer extends DataAnalyzer 
    {

        public var data:TofflistListData;
        private var _xml:XML;
        public var listName:String;

        public function TofflistListAnalyzer(_arg_1:Function, _arg_2:String)
        {
            super(_arg_1);
            this.listName = _arg_2;
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:TofflistPlayerInfo;
            var _local_5:XML;
            var _local_6:int;
            var _local_7:TofflistConsortiaData;
            var _local_8:TofflistConsortiaInfo;
            var _local_9:TofflistPlayerInfo;
            this._xml = new XML(_arg_1);
            var _local_2:Array = new Array();
            this.data = new TofflistListData();
            this.data.lastUpdateTime = this._xml.@date;
            if (this._xml.@value == "true")
            {
                _local_3 = XML(this._xml)..Item;
                _local_4 = new TofflistPlayerInfo();
                _local_5 = describeType(_local_4);
                _local_6 = 0;
                while (_local_6 < _local_3.length())
                {
                    _local_7 = new TofflistConsortiaData();
                    _local_8 = new TofflistConsortiaInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_8, _local_3[_local_6]);
                    _local_7.consortiaInfo = _local_8;
                    if (_local_3[_local_6].children().length() > 0)
                    {
                        _local_9 = new TofflistPlayerInfo();
                        _local_9.beginChanges();
                        ObjectUtils.copyPorpertiesByXML(_local_9, _local_3[_local_6].Item[0]);
                        _local_9.commitChanges();
                        _local_7.playerInfo = _local_9;
                        _local_2.push(_local_7);
                    };
                    _local_6++;
                };
                this.data.list = _local_2;
                onAnalyzeComplete();
            }
            else
            {
                message = this._xml.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }


    }
}//package tofflist.analyze

