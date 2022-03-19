// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.fightPower.FightPowerDescAnalyzer

package bagAndInfo.fightPower
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class FightPowerDescAnalyzer extends DataAnalyzer 
    {

        private var _list:Vector.<FightPowerDescInfo>;

        public function FightPowerDescAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        public function get list():Vector.<FightPowerDescInfo>
        {
            return (this._list);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_4:int;
            var _local_5:FightPowerDescInfo;
            var _local_2:XML = new XML(_arg_1);
            this._list = new Vector.<FightPowerDescInfo>();
            var _local_3:XMLList = _local_2..Item;
            if (_local_2.@value == "true")
            {
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new FightPowerDescInfo();
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
}//package bagAndInfo.fightPower

