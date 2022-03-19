// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.GoodCategoryAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.goods.CateCoryInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class GoodCategoryAnalyzer extends DataAnalyzer 
    {

        public var list:Vector.<CateCoryInfo>;
        private var _xml:XML;

        public function GoodCategoryAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:XMLList;
            var _local_3:int;
            var _local_4:CateCoryInfo;
            this._xml = new XML(_arg_1);
            if (this._xml.@value == "true")
            {
                this.list = new Vector.<CateCoryInfo>();
                _local_2 = this._xml..Item;
                _local_3 = 0;
                while (_local_3 < _local_2.length())
                {
                    _local_4 = new CateCoryInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                    this.list.push(_local_4);
                    _local_3++;
                };
                onAnalyzeComplete();
            }
            else
            {
                message = this._xml.@message;
                onAnalyzeError();
            };
        }


    }
}//package ddt.data.analyze

