// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//update.analyzer.PopSysNoticeBaseAnalyzer

package update.analyzer
{
    import com.pickgliss.loader.DataAnalyzer;
    import update.data.PopSysNoticeBaseInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class PopSysNoticeBaseAnalyzer extends DataAnalyzer 
    {

        private var _list:Array;

        public function PopSysNoticeBaseAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        public function get list():Array
        {
            return (this._list);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_4:int;
            var _local_5:PopSysNoticeBaseInfo;
            var _local_2:XML = new XML(_arg_1);
            this._list = new Array();
            var _local_3:XMLList = _local_2..Item;
            if (_local_2.@value == "true")
            {
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new PopSysNoticeBaseInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    this._list.push(_local_5);
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
}//package update.analyzer

