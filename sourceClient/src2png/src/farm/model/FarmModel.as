// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//farm.model.FarmModel

package farm.model
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import __AS3__.vec.Vector;
    import flash.events.IEventDispatcher;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;
    import ddt.data.BagInfo;
    import ddt.data.EquipType;

    public class FarmModel extends EventDispatcher 
    {

        private var _currentFarmerId:int;
        public var currentFarmerName:String;
        public var fieldsInfo:DictionaryData = new DictionaryData();
        public var seedingFieldInfo:FieldVO;
        public var selfFieldsInfo:Vector.<FieldVO>;
        public var gainFieldId:int;

        public function FarmModel(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public function get currentFarmerId():int
        {
            return (this._currentFarmerId);
        }

        public function set currentFarmerId(_arg_1:int):void
        {
            this._currentFarmerId = _arg_1;
        }

        public function getfieldInfoById(_arg_1:int):FieldVO
        {
            var _local_2:FieldVO;
            for each (_local_2 in this.fieldsInfo)
            {
                if (_local_2.fieldID == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function findItemInfo(_arg_1:int, _arg_2:int):InventoryItemInfo
        {
            var _local_5:InventoryItemInfo;
            var _local_3:InventoryItemInfo;
            var _local_4:Array = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(_arg_1);
            for each (_local_5 in _local_4)
            {
                if (_local_5.TemplateID == _arg_2)
                {
                    _local_3 = _local_5;
                    break;
                };
            };
            return (_local_3);
        }

        public function getSeedCountByID(_arg_1:int):int
        {
            var _local_4:InventoryItemInfo;
            var _local_2:int;
            var _local_3:Array = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(EquipType.SEED);
            for each (_local_4 in _local_3)
            {
                if (_local_4.TemplateID == _arg_1)
                {
                    _local_2 = (_local_2 + _local_4.Count);
                };
            };
            return (_local_2);
        }


    }
}//package farm.model

