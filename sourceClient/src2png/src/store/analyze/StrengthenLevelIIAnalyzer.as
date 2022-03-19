// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.analyze.StrengthenLevelIIAnalyzer

package store.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;
    import ddt.data.store.StrengthenLevelII;
    import com.pickgliss.utils.ObjectUtils;

    public class StrengthenLevelIIAnalyzer extends DataAnalyzer 
    {

        public var LevelItems1:Dictionary;
        public var LevelItems2:Dictionary;
        public var LevelItems3:Dictionary;
        public var LevelItems4:Dictionary;
        public var SucceedRate:int;
        private var _xml:XML;

        public function StrengthenLevelIIAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:int;
            var _local_4:StrengthenLevelII;
            this._xml = new XML(_arg_1);
            this.LevelItems1 = new Dictionary(true);
            this.LevelItems2 = new Dictionary(true);
            this.LevelItems3 = new Dictionary(true);
            this.LevelItems4 = new Dictionary(true);
            var _local_2:XMLList = this._xml.Item;
            if (this._xml.@value == "true")
            {
                _local_3 = 0;
                while (_local_3 < _local_2.length())
                {
                    _local_4 = new StrengthenLevelII();
                    ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                    this.SucceedRate = _local_4.DamagePlusRate;
                    this.LevelItems1[_local_4.StrengthenLevel] = _local_4.Rock;
                    this.LevelItems2[_local_4.StrengthenLevel] = _local_4.Rock1;
                    this.LevelItems3[_local_4.StrengthenLevel] = _local_4.Rock2;
                    this.LevelItems4[_local_4.StrengthenLevel] = _local_4.Rock3;
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
}//package store.analyze

