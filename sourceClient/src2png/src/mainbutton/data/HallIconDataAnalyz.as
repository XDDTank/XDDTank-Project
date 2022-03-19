// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//mainbutton.data.HallIconDataAnalyz

package mainbutton.data
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;
    import mainbutton.MainButton;
    import com.pickgliss.utils.ObjectUtils;

    public class HallIconDataAnalyz extends DataAnalyzer 
    {

        public var _HallIconList:Dictionary;

        public function HallIconDataAnalyz(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:MainButton;
            this._HallIconList = new Dictionary();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new MainButton();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    this._HallIconList[_local_5.ID] = _local_5;
                    _local_4++;
                };
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
                onAnalyzeError();
            };
        }

        public function get list():Dictionary
        {
            return (this._HallIconList);
        }


    }
}//package mainbutton.data

