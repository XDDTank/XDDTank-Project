// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.BadgeInfoAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;
    import consortion.data.BadgeInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class BadgeInfoAnalyzer extends DataAnalyzer 
    {

        public var list:Dictionary = new Dictionary();

        public function BadgeInfoAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_6:BadgeInfo;
            var _local_2:XML = new XML(_arg_1);
            var _local_3:XMLList = _local_2..item;
            var _local_4:int = _local_3.length();
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_6 = new BadgeInfo();
                ObjectUtils.copyPorpertiesByXML(_local_6, _local_3[_local_5]);
                this.list[_local_6.BadgeID] = _local_6;
                _local_5++;
            };
            onAnalyzeComplete();
        }


    }
}//package ddt.data.analyze

