// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.analyze.ActivityInfoAnalyzer

package activity.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import activity.data.ActivityInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class ActivityInfoAnalyzer extends DataAnalyzer 
    {

        private var _list:Array;
        private var _xml:XML;

        public function ActivityInfoAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        public function get list():Array
        {
            return (this._list);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:int;
            var _local_4:ActivityInfo;
            this._xml = new XML(_arg_1);
            this._list = new Array();
            var _local_2:XMLList = this._xml..Item;
            if (this._xml.@value == "true")
            {
                _local_3 = 0;
                while (_local_3 < _local_2.length())
                {
                    _local_4 = new ActivityInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                    this._list.push(_local_4);
                    _local_3++;
                };
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
}//package activity.analyze

