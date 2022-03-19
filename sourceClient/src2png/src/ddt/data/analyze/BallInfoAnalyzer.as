// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.BallInfoAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.BallInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class BallInfoAnalyzer extends DataAnalyzer 
    {

        public var list:Vector.<BallInfo>;

        public function BallInfoAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:BallInfo;
            var _local_2:XML = new XML(_arg_1);
            this.list = new Vector.<BallInfo>();
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new BallInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    _local_5.blastOutID = _local_3[_local_4].@BombPartical;
                    _local_5.craterID = _local_3[_local_4].@Crater;
                    _local_5.FlyingPartical = _local_3[_local_4].@FlyingPartical;
                    this.list.push(_local_5);
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
}//package ddt.data.analyze

