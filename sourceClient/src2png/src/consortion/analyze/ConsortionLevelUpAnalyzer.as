// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.analyze.ConsortionLevelUpAnalyzer

package consortion.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import consortion.data.ConsortiaLevelInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ConsortionLevelUpAnalyzer extends DataAnalyzer 
    {

        public var levelUpData:Vector.<ConsortiaLevelInfo>;

        public function ConsortionLevelUpAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:ConsortiaLevelInfo;
            var _local_2:XML = new XML(_arg_1);
            this.levelUpData = new Vector.<ConsortiaLevelInfo>();
            if (_local_2.@value == "true")
            {
                _local_3 = XML(_local_2)..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new ConsortiaLevelInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    this.levelUpData.push(_local_5);
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

