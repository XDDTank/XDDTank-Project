// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.BoxTempInfoAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import ddt.data.box.BoxGoodsTempInfo;
    import flash.utils.getTimer;
    import ddt.manager.BossBoxManager;
    import ddt.data.EquipType;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class BoxTempInfoAnalyzer extends DataAnalyzer 
    {

        public var inventoryItemList:DictionaryData;
        private var _boxTemplateID:Dictionary;
        public var caddyBoxGoodsInfo:Vector.<BoxGoodsTempInfo>;
        public var timeBoxGoodsInfo:Vector.<BoxGoodsTempInfo>;
        public var caddyTempIDList:DictionaryData;
        public var beadTempInfoList:DictionaryData;
        public var exploitTemplateIDs:Dictionary;

        public function BoxTempInfoAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_5:BoxGoodsTempInfo;
            var _local_6:int;
            var _local_7:String;
            var _local_8:int;
            var _local_9:BoxGoodsTempInfo;
            var _local_10:BoxGoodsTempInfo;
            var _local_11:BoxGoodsTempInfo;
            var _local_12:Array;
            var _local_2:uint = getTimer();
            var _local_3:XML = new XML(_arg_1);
            var _local_4:XMLList = _local_3..Item;
            this.inventoryItemList = new DictionaryData();
            this.caddyTempIDList = new DictionaryData();
            this.beadTempInfoList = new DictionaryData();
            this.caddyBoxGoodsInfo = new Vector.<BoxGoodsTempInfo>();
            this.timeBoxGoodsInfo = new Vector.<BoxGoodsTempInfo>();
            this._boxTemplateID = BossBoxManager.instance.boxTemplateID;
            this.exploitTemplateIDs = BossBoxManager.instance.exploitTemplateIDs;
            this.initDictionaryData();
            if (_local_3.@value == "true")
            {
                _local_6 = 0;
                while (_local_6 < _local_4.length())
                {
                    _local_7 = _local_4[_local_6].@ID;
                    _local_8 = int(_local_4[_local_6].@TemplateId);
                    if (int(_local_7) == EquipType.CADDY)
                    {
                        _local_9 = new BoxGoodsTempInfo();
                        ObjectUtils.copyPorpertiesByXML(_local_9, _local_4[_local_6]);
                        this.caddyBoxGoodsInfo.push(_local_9);
                        this.caddyTempIDList.add(_local_9.TemplateId, _local_9);
                    }
                    else
                    {
                        if ((((int(_local_7) == EquipType.ONE_LEVEL_TIMEBOX) || (int(_local_7) == EquipType.TWO_LEVEL_TIMEBOX)) || (int(_local_7) == EquipType.THREE_LEVEL_TIMEBOX)))
                        {
                            _local_10 = new BoxGoodsTempInfo();
                            ObjectUtils.copyPorpertiesByXML(_local_10, _local_4[_local_6]);
                            this.timeBoxGoodsInfo.push(_local_10);
                        }
                        else
                        {
                            if ((((int(_local_7) == EquipType.BEAD_ATTACK) || (int(_local_7) == EquipType.BEAD_DEFENSE)) || (int(_local_7) == EquipType.BEAD_ATTRIBUTE)))
                            {
                                _local_11 = new BoxGoodsTempInfo();
                                ObjectUtils.copyPorpertiesByXML(_local_11, _local_4[_local_6]);
                                this.beadTempInfoList[_local_7].push(_local_11);
                            };
                        };
                    };
                    if (this._boxTemplateID[_local_7])
                    {
                        _local_5 = new BoxGoodsTempInfo();
                        _local_12 = new Array();
                        ObjectUtils.copyPorpertiesByXML(_local_5, _local_4[_local_6]);
                        this.inventoryItemList[_local_7].push(_local_5);
                    };
                    if (this.exploitTemplateIDs[_local_7])
                    {
                        _local_5 = new BoxGoodsTempInfo();
                        ObjectUtils.copyPorpertiesByXML(_local_5, _local_4[_local_6]);
                        this.exploitTemplateIDs[_local_7].push(_local_5);
                    };
                    _local_6++;
                };
                onAnalyzeComplete();
            }
            else
            {
                message = _local_3.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }

        private function initDictionaryData():void
        {
            var _local_1:String;
            var _local_2:Array;
            for each (_local_1 in this._boxTemplateID)
            {
                _local_2 = new Array();
                this.inventoryItemList.add(_local_1, _local_2);
            };
            this.beadTempInfoList.add(EquipType.BEAD_ATTACK, new Vector.<BoxGoodsTempInfo>());
            this.beadTempInfoList.add(EquipType.BEAD_DEFENSE, new Vector.<BoxGoodsTempInfo>());
            this.beadTempInfoList.add(EquipType.BEAD_ATTRIBUTE, new Vector.<BoxGoodsTempInfo>());
        }


    }
}//package ddt.data.analyze

