// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.LoginSelectListAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.Role;
    import road7th.utils.DateUtils;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class LoginSelectListAnalyzer extends DataAnalyzer 
    {

        public var list:Vector.<Role>;
        public var totalCount:int;

        public function LoginSelectListAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:Role;
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                this.list = new Vector.<Role>();
                this.totalCount = int(_local_2.@total);
                _local_3 = XML(_local_2)..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new Role();
                    _local_5.LastDate = DateUtils.dealWithStringDate(String(_local_3[_local_4].@LastDate).replace("T", " "));
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    this.list.push(_local_5);
                    _local_4++;
                };
                this.list.sort(this.sortLastDate);
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
            };
        }

        private function sortLastDate(_arg_1:Role, _arg_2:Role):int
        {
            var _local_3:int;
            if (_arg_1.LastDate.time < _arg_2.LastDate.time)
            {
                _local_3 = 1;
            }
            else
            {
                _local_3 = -1;
            };
            return (_local_3);
        }


    }
}//package ddt.data.analyze

