// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tryonSystem.TryonModel

package tryonSystem
{
    import flash.events.EventDispatcher;
    import ddt.data.player.PlayerInfo;
    import ddt.data.goods.InventoryItemInfo;
    import road7th.data.DictionaryData;
    import ddt.manager.PlayerManager;
    import ddt.data.EquipType;
    import flash.events.Event;

    public class TryonModel extends EventDispatcher 
    {

        private var _playerInfo:PlayerInfo;
        private var _selectedItem:InventoryItemInfo;
        private var _items:Array;
        private var _bagItems:DictionaryData;

        public function TryonModel(_arg_1:Array)
        {
            var _local_3:InventoryItemInfo;
            super();
            this._items = _arg_1;
            var _local_2:PlayerInfo = PlayerManager.Instance.Self;
            this._playerInfo = new PlayerInfo();
            this._playerInfo.updateStyle(_local_2.Sex, _local_2.Hide, _local_2.getPrivateStyle(), _local_2.Colors, _local_2.getSkinColor());
            this._bagItems = new DictionaryData();
            for each (_local_3 in _local_2.Bag.items)
            {
                if (_local_3.Place <= 30)
                {
                    this._bagItems.add(_local_3.Place, _local_3);
                };
            };
        }

        public function set selectedItem(_arg_1:InventoryItemInfo):void
        {
            if (_arg_1 == this._selectedItem)
            {
                return;
            };
            this._selectedItem = _arg_1;
            if (EquipType.isAvatar(_arg_1.CategoryID))
            {
                this._playerInfo.setPartStyle(_arg_1, _arg_1.NeedSex, _arg_1.TemplateID);
                if (_arg_1.CategoryID == EquipType.FACE)
                {
                    this._playerInfo.setSkinColor(_arg_1.Skin);
                };
                this._bagItems.add(EquipType.CategeryIdToCharacterload(this._selectedItem.CategoryID)[0], this._selectedItem);
            };
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function get bagItems():DictionaryData
        {
            return (this._bagItems);
        }

        public function get items():Array
        {
            return (this._items);
        }

        public function get playerInfo():PlayerInfo
        {
            return (this._playerInfo);
        }

        public function get selectedItem():InventoryItemInfo
        {
            return (this._selectedItem);
        }

        public function dispose():void
        {
            this._selectedItem = null;
            this._items = null;
            this._playerInfo = null;
            this._bagItems = null;
        }


    }
}//package tryonSystem

