// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.analyze.SendedEmailAnalyze

package email.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import email.data.EmailInfoOfSended;
    import flash.utils.describeType;
    import com.pickgliss.utils.ObjectUtils;

    public class SendedEmailAnalyze extends DataAnalyzer 
    {

        private var _list:Array;

        public function SendedEmailAnalyze(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:XML;
            var _local_5:int;
            var _local_6:EmailInfoOfSended;
            this._list = new Array();
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2.Item;
                _local_4 = describeType(new EmailInfoOfSended());
                _local_5 = 0;
                while (_local_5 < _local_3.length())
                {
                    _local_6 = new EmailInfoOfSended();
                    ObjectUtils.copyPorpertiesByXML(_local_6, _local_3[_local_5]);
                    this.list.push(_local_6);
                    _local_5++;
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

        public function get list():Array
        {
            return (this._list);
        }


    }
}//package email.analyze

