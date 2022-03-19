// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.BagInfo

package ddt.data
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import flash.utils.Dictionary;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;
    import ddt.manager.ItemManager;
    import ddt.manager.StateManager;
    import ddt.events.BagEvent;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.ShopManager;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.utils.ByteArray;
    import ddt.manager.SocketManager;

    [Event(name="update", type="ddt.events.BagEvent")]
    public class BagInfo extends EventDispatcher 
    {

        public static const EQUIPBAG:int = 0;
        public static const PROPBAG:int = 1;
        public static const TASKBAG:int = 2;
        public static const FIGHTBAG:int = 3;
        public static const TEMPBAG:int = 4;
        public static const CADDYBAG:int = 5;
        public static const CONSORTIA:int = 11;
        public static const FARM:int = 13;
        public static const VEGETABLE:int = 14;
        public static const FOOD_OLD:int = 32;
        public static const FOOD:int = 34;
        public static const PETEGG:int = 35;
        public static const UNBIND:int = 36;
        public static const BEADBAG:int = 21;
        public static const MAXPROPCOUNT:int = 48;
        public static const STOREBAG:int = 12;
        public static const PERSONAL_EQUIP_COUNT:int = 30;

        public const NUMBER:Number = 1;

        private var _type:int;
        private var _capability:int;
        private var _items:DictionaryData;
        private var _texpList:DictionaryData;
        private var _changedCount:int = 0;
        private var _changedSlots:Dictionary = new Dictionary();
        private var _overtimeItems:Array = new Array();

        public function BagInfo(_arg_1:int, _arg_2:int)
        {
            this._type = _arg_1;
            this._items = new DictionaryData();
            this._capability = _arg_2;
        }

        public function get BagType():int
        {
            return (this._type);
        }

        public function getItemAt(_arg_1:int):InventoryItemInfo
        {
            return (this._items[_arg_1]);
        }

        public function get items():DictionaryData
        {
            return (this._items);
        }

        public function get itemNumber():int
        {
            var _local_1:int;
            var _local_2:int;
            while (_local_2 < 56)
            {
                if (this._items[_local_2] != null)
                {
                    _local_1++;
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function get itemBagNumber():int
        {
            var _local_1:int;
            var _local_2:int = 31;
            while (_local_2 < 175)
            {
                if (this._items[_local_2] != null)
                {
                    _local_1++;
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function itemBagFull():Boolean
        {
            var _local_4:int;
            var _local_1:int = PlayerManager.Instance.Self.Grade;
            var _local_2:int;
            var _local_3:int = 31;
            if (_local_1 < 20)
            {
                _local_4 = 79;
            }
            else
            {
                if (_local_1 < 30)
                {
                    _local_4 = 127;
                }
                else
                {
                    _local_4 = 175;
                };
            };
            var _local_5:int = _local_3;
            while (_local_5 < _local_4)
            {
                if (this._items[_local_5] != null)
                {
                    _local_2++;
                };
                _local_5++;
            };
            if (_local_2 >= (_local_4 - _local_3))
            {
                return (true);
            };
            return (false);
        }

        public function set items(_arg_1:DictionaryData):void
        {
            this._items = _arg_1;
        }

        public function get TexpItems():DictionaryData
        {
            var _local_1:InventoryItemInfo;
            this._texpList = new DictionaryData();
            for each (_local_1 in this.items)
            {
                if (this.isTexpLvGoods(_local_1))
                {
                    this._texpList.add(this._texpList.length, _local_1);
                };
            };
            return (this._texpList);
        }

        private function isTexpLvGoods(_arg_1:InventoryItemInfo):Boolean
        {
            if (((_arg_1.TemplateID == EquipType.TEXP_LV_II) || (_arg_1.TemplateID == EquipType.TEXP_LV_I)))
            {
                return (true);
            };
            return (false);
        }

        public function addItem(_arg_1:InventoryItemInfo):void
        {
            _arg_1.BagType = this._type;
            this._items.add(_arg_1.Place, _arg_1);
            this.onItemChanged(_arg_1.Place, _arg_1);
        }

        public function addItemIntoFightBag(_arg_1:int, _arg_2:int=1):void
        {
            var _local_3:InventoryItemInfo = new InventoryItemInfo();
            _local_3.BagType = FIGHTBAG;
            _local_3.Place = this.findFirstPlace();
            _local_3.Count = _arg_2;
            _local_3.TemplateID = _arg_1;
            ItemManager.fill(_local_3);
            this.addItem(_local_3);
        }

        private function findFirstPlace():int
        {
            var _local_1:int;
            while (_local_1 < 3)
            {
                if (this.getItemAt(_local_1) == null)
                {
                    return (_local_1);
                };
                _local_1++;
            };
            return (-1);
        }

        public function removeItemAt(_arg_1:int):void
        {
            var _local_2:InventoryItemInfo = this._items[_arg_1];
            if (_local_2)
            {
                this._items.remove(_arg_1);
                if (((this._type == TEMPBAG) && (StateManager.isInFight)))
                {
                    return;
                };
                this.onItemChanged(_arg_1, _local_2);
            };
        }

        public function updateItem(_arg_1:InventoryItemInfo):void
        {
            if (_arg_1.BagType == this._type)
            {
                this.onItemChanged(_arg_1.Place, _arg_1);
            };
        }

        public function beginChanges():void
        {
            this._changedCount++;
        }

        public function commiteChanges():void
        {
            this._changedCount--;
            if (this._changedCount <= 0)
            {
                this._changedCount = 0;
                this.updateChanged();
            };
        }

        protected function onItemChanged(_arg_1:int, _arg_2:InventoryItemInfo):void
        {
            this._changedSlots[_arg_1] = _arg_2;
            if (this._changedCount <= 0)
            {
                this._changedCount = 0;
                this.updateChanged();
            };
        }

        protected function updateChanged():void
        {
            dispatchEvent(new BagEvent(BagEvent.UPDATE, this._changedSlots));
            this._changedSlots = new Dictionary();
        }

        public function findItems(_arg_1:int, _arg_2:Boolean=true):Array
        {
            var _local_4:InventoryItemInfo;
            var _local_3:Array = new Array();
            for each (_local_4 in this._items)
            {
                if (_local_4.CategoryID == _arg_1)
                {
                    if (((!(_arg_2)) || (_local_4.getRemainDate() > 0)))
                    {
                        _local_3.push(_local_4);
                    };
                };
            };
            return (_local_3);
        }

        public function findFirstItem(_arg_1:int, _arg_2:Boolean=true):InventoryItemInfo
        {
            var _local_3:InventoryItemInfo;
            for each (_local_3 in this._items)
            {
                if (_local_3.CategoryID == _arg_1)
                {
                    if (((!(_arg_2)) || (_local_3.getRemainDate() > 0)))
                    {
                        return (_local_3);
                    };
                };
            };
            return (null);
        }

        public function findEquipedItemByTemplateId(_arg_1:int, _arg_2:Boolean=true):InventoryItemInfo
        {
            var _local_3:InventoryItemInfo;
            for each (_local_3 in this._items)
            {
                if (_local_3.TemplateID == _arg_1)
                {
                    if (_local_3.Place <= 30)
                    {
                        if (((!(_arg_2)) || (_local_3.getRemainDate() > 0)))
                        {
                            return (_local_3);
                        };
                    };
                };
            };
            return (null);
        }

        public function findItemsByTemplateType(_arg_1:int):DictionaryData
        {
            var _local_3:InventoryItemInfo;
            var _local_4:EquipmentTemplateInfo;
            var _local_2:DictionaryData = new DictionaryData();
            for each (_local_3 in this._items)
            {
                _local_4 = ItemManager.Instance.getEquipTemplateById(_local_3.TemplateID);
                if (((_local_4) && (_local_4.TemplateType == _arg_1)))
                {
                    _local_2[_local_3.ItemID] = _local_3;
                };
            };
            return (_local_2);
        }

        public function findOvertimeItems(_arg_1:Number=0):Array
        {
            var _local_3:InventoryItemInfo;
            var _local_4:Number;
            var _local_2:Array = new Array();
            for each (_local_3 in this._items)
            {
                _local_4 = _local_3.getRemainDate();
                if (((_local_4 > _arg_1) && (_local_4 < this.NUMBER)))
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public function set overTimeItems(_arg_1:Array):void
        {
            this._overtimeItems = _arg_1;
        }

        public function get overTimeItems():Array
        {
            return (this._overtimeItems);
        }

        public function findOvertimeItemsByBody():Array
        {
            var _local_3:Number;
            var _local_1:Array = [];
            var _local_2:uint;
            while (_local_2 < 30)
            {
                if ((this._items[_local_2] as InventoryItemInfo))
                {
                    _local_3 = (this._items[_local_2] as InventoryItemInfo).getRemainDate();
                    if (((_local_3 <= 0) && (ShopManager.Instance.canAddPrice((this._items[_local_2] as InventoryItemInfo).TemplateID))))
                    {
                        _local_1.push(this._items[_local_2]);
                    };
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function findOvertimeItemsByBodyII():Array
        {
            var _local_3:Number;
            var _local_1:Array = [];
            var _local_2:uint;
            while (_local_2 < 80)
            {
                if ((this._items[_local_2] as InventoryItemInfo))
                {
                    if (_local_2 < 30)
                    {
                        _local_3 = (this._items[_local_2] as InventoryItemInfo).getRemainDate();
                    };
                    if ((this._items[_local_2] as InventoryItemInfo).isGold)
                    {
                        _local_3 = (this._items[_local_2] as InventoryItemInfo).getGoldRemainDate();
                    };
                    if (_local_3 <= 0)
                    {
                        _local_1.push(this._items[_local_2]);
                    };
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function findItemsForEach(_arg_1:int, _arg_2:Boolean=true):Array
        {
            var _local_4:InventoryItemInfo;
            var _local_5:EquipmentTemplateInfo;
            var _local_3:Array = new Array();
            for each (_local_4 in this._items)
            {
                if (_local_4.CategoryID == EquipType.EQUIP)
                {
                    _local_5 = ItemManager.Instance.getEquipTemplateById(_local_4.TemplateID);
                    if (_local_5.TemplateType == _arg_1)
                    {
                        if (((!(_arg_2)) || (_local_4.getRemainDate() > 0)))
                        {
                            _local_3.push(_local_4);
                        };
                    };
                };
            };
            return (_local_3);
        }

        public function findSuitsForEach(_arg_1:int):Array
        {
            var _local_3:InventoryItemInfo;
            var _local_4:ItemTemplateInfo;
            var _local_5:EquipmentTemplateInfo;
            var _local_2:Array = new Array();
            for each (_local_3 in this._items)
            {
                if (_local_3.CategoryID == EquipType.EQUIP)
                {
                    _local_4 = ItemManager.Instance.getTemplateById(_local_3.TemplateID);
                    if (int(_local_4.Property1) == _arg_1)
                    {
                        _local_5 = ItemManager.Instance.getEquipTemplateById(_local_3.TemplateID);
                        _local_2.push(_local_5);
                    };
                };
            };
            return (_local_2);
        }

        public function findFistItemByTemplateId(_arg_1:int, _arg_2:Boolean=true, _arg_3:Boolean=false):InventoryItemInfo
        {
            var _local_6:InventoryItemInfo;
            var _local_4:InventoryItemInfo;
            var _local_5:InventoryItemInfo;
            for each (_local_6 in this._items)
            {
                if (((_local_6.TemplateID == _arg_1) && ((!(_arg_2)) || (_local_6.getRemainDate() > 0))))
                {
                    if (_arg_3)
                    {
                        if (_local_6.IsUsed)
                        {
                            if (_local_4 == null)
                            {
                                _local_4 = _local_6;
                            };
                        }
                        else
                        {
                            if (_local_5 == null)
                            {
                                _local_5 = _local_6;
                            };
                        };
                    }
                    else
                    {
                        return (_local_6);
                    };
                };
            };
            return ((_local_4) ? _local_4 : _local_5);
        }

        public function findBodyThingByCategory(_arg_1:int):Array
        {
            var _local_4:InventoryItemInfo;
            var _local_2:Array = new Array();
            var _local_3:int;
            while (_local_3 < 30)
            {
                _local_4 = (this._items[_local_3] as InventoryItemInfo);
                if (_local_4 != null)
                {
                    if (_local_4.CategoryID == _arg_1)
                    {
                        _local_2.push(_local_4);
                    };
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function getItemCountByTemplateId(_arg_1:int, _arg_2:Boolean=true):int
        {
            var _local_4:InventoryItemInfo;
            var _local_3:int;
            for each (_local_4 in this._items)
            {
                if (((_local_4.TemplateID == _arg_1) && ((!(_arg_2)) || (_local_4.getRemainDate() > 0))))
                {
                    _local_3 = (_local_3 + _local_4.Count);
                };
            };
            return (_local_3);
        }

        public function getItemsByTempleteID(_arg_1:int, _arg_2:Boolean=true):Array
        {
            var _local_4:InventoryItemInfo;
            var _local_3:Array = [];
            for each (_local_4 in this._items)
            {
                if (((_local_4.TemplateID == _arg_1) && ((!(_arg_2)) || (_local_4.getRemainDate() > 0))))
                {
                    _local_3.push(_local_4);
                };
            };
            return (_local_3);
        }

        public function getItemBindsByTemplateID(_arg_1:int):Boolean
        {
            var _local_2:InventoryItemInfo;
            for each (_local_2 in this._items)
            {
                if (((_local_2.TemplateID == _arg_1) && (_local_2.IsBinds == false)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function findItemsByTempleteID(_arg_1:int, _arg_2:Boolean=true):Array
        {
            var _local_4:InventoryItemInfo;
            var _local_3:DictionaryData = new DictionaryData();
            for each (_local_4 in this._items)
            {
                if (_local_4.TemplateID == _arg_1)
                {
                    if (((!(_arg_2)) || (_local_4.getRemainDate() > 0)))
                    {
                        _local_3.add(_local_4.ItemID, _local_4);
                    };
                };
            };
            return (_local_3.list);
        }

        public function findCellsByTempleteID(_arg_1:int, _arg_2:Boolean=true):Array
        {
            var _local_4:InventoryItemInfo;
            var _local_3:Array = new Array();
            for each (_local_4 in this._items)
            {
                if (((_local_4.TemplateID == _arg_1) && ((!(_arg_2)) || (_local_4.getRemainDate() > 0))))
                {
                    _local_3.push(_local_4);
                };
            };
            return (_local_3);
        }

        public function clearnAll():void
        {
            var _local_1:int;
            while (_local_1 < 49)
            {
                this.removeItemAt(_local_1);
                _local_1++;
            };
        }

        public function unlockItem(_arg_1:InventoryItemInfo):void
        {
            _arg_1.lock = false;
            this.onItemChanged(_arg_1.Place, _arg_1);
        }

        public function unLockAll():void
        {
            var _local_1:InventoryItemInfo;
            this.beginChanges();
            for each (_local_1 in this._items)
            {
                if (_local_1.lock)
                {
                    this.onItemChanged(_local_1.Place, _local_1);
                };
                _local_1.lock = false;
            };
            this.commiteChanges();
        }

        public function sortBag(_arg_1:int, _arg_2:BagInfo, _arg_3:int, _arg_4:int, _arg_5:Boolean=false):void
        {
            var _local_6:DictionaryData;
            var _local_7:Array;
            var _local_8:Array;
            var _local_9:DictionaryData;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:ByteArray;
            if (_arg_1 != 21)
            {
                _local_6 = _arg_2.items;
                _local_7 = [];
                _local_8 = [];
                _local_9 = new DictionaryData();
                _local_10 = 0;
                _local_11 = _local_6.list.length;
                _local_12 = 0;
                if (_arg_2 == PlayerManager.Instance.Self.Bag)
                {
                    _local_12 = 31;
                };
                while (_local_13 < _local_11)
                {
                    if (int(_local_6.list[_local_13].Place) >= _local_12)
                    {
                        _local_7.push({
                            "TemplateID":_local_6.list[_local_13].TemplateID,
                            "ItemID":_local_6.list[_local_13].ItemID,
                            "CategoryIDSort":this.getBagGoodsCategoryIDSort(uint(_local_6.list[_local_13].CategoryID)),
                            "Place":_local_6.list[_local_13].Place,
                            "RemainDate":(_local_6.list[_local_13].getRemainDate() > 0),
                            "CanStrengthen":_local_6.list[_local_13].CanStrengthen,
                            "StrengthenLevel":_local_6.list[_local_13].StrengthenLevel,
                            "IsBinds":_local_6.list[_local_13].IsBinds
                        });
                    };
                    _local_13++;
                };
                _local_14 = new ByteArray();
                _local_14.writeObject(_local_7);
                _local_14.position = 0;
                _local_8 = (_local_14.readObject() as Array);
                _local_7.sortOn(["RemainDate", "CategoryIDSort", "TemplateID", "CanStrengthen", "IsBinds", "StrengthenLevel", "Place"], [Array.DESCENDING, Array.NUMERIC, (Array.NUMERIC | Array.DESCENDING), Array.DESCENDING, Array.DESCENDING, (Array.NUMERIC | Array.DESCENDING), Array.NUMERIC]);
                if (((this.bagComparison(_local_7, _local_8, _local_12)) && (!(_arg_5))))
                {
                    return;
                };
                SocketManager.Instance.out.sendMoveGoodsAll(_arg_2.BagType, _local_7, _local_12, _arg_5);
            }
            else
            {
                if (_arg_1 == 21)
                {
                    this.sortBead(_arg_2, _arg_3, _arg_4, _arg_5);
                };
            };
        }

        private function sortBead(_arg_1:BagInfo, _arg_2:int, _arg_3:int, _arg_4:Boolean):void
        {
            var _local_5:DictionaryData = _arg_1.items;
            var _local_6:Array = [];
            var _local_7:Array = [];
            var _local_8:int;
            var _local_9:int = _local_5.list.length;
            var _local_10:int;
            while (_local_10 < _local_9)
            {
                if (((int(_local_5.list[_local_10].Place) >= _arg_2) && (int(_local_5.list[_local_10].Place) <= _arg_3)))
                {
                    _local_6.push({
                        "Type":_local_5.list[_local_10].Property2,
                        "TemplateID":_local_5.list[_local_10].TemplateID,
                        "Level":_local_5.list[_local_10].Hole1,
                        "Exp":_local_5.list[_local_10].Hole2,
                        "Place":_local_5.list[_local_10].Place
                    });
                };
                _local_10++;
            };
            var _local_11:ByteArray = new ByteArray();
            _local_11.writeObject(_local_6);
            _local_11.position = 0;
            _local_7 = (_local_11.readObject() as Array);
            _local_6.sortOn(["Type", "TemplateID", "Level", "Exp", "Place"], [Array.NUMERIC, Array.DESCENDING, Array.DESCENDING, Array.DESCENDING, Array.NUMERIC]);
            if (((this.bagComparison(_local_6, _local_7, _arg_2)) && (!(_arg_4))))
            {
                return;
            };
            SocketManager.Instance.out.sendMoveGoodsAll(_arg_1.BagType, _local_6, _arg_2, _arg_4);
        }

        public function getBagGoodsCategoryIDSort(_arg_1:uint):int
        {
            var _local_2:Array = [EquipType.ARM, EquipType.HOLYGRAIL, EquipType.HEAD, EquipType.CLOTH, EquipType.ARMLET, EquipType.RING, EquipType.GLASS, EquipType.NECKLACE, EquipType.SUITS, EquipType.WING, EquipType.HAIR, EquipType.FACE, EquipType.EFF, EquipType.CHATBALL, EquipType.ATACCKT, EquipType.DEFENT, EquipType.ATTRIBUTE];
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_arg_1 == _local_2[_local_3])
                {
                    return (_local_3);
                };
                _local_3++;
            };
            return (9999);
        }

        private function bagComparison(_arg_1:Array, _arg_2:Array, _arg_3:int):Boolean
        {
            if (_arg_1.length < _arg_2.length)
            {
                return (false);
            };
            var _local_4:int = _arg_1.length;
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                if ((((!((_local_5 + _arg_3) == _arg_2[_local_5].Place)) || (!(_arg_1[_local_5].ItemID == _arg_2[_local_5].ItemID))) || (!(_arg_1[_local_5].TemplateID == _arg_2[_local_5].TemplateID))))
                {
                    return (false);
                };
                _local_5++;
            };
            return (true);
        }

        public function itemBgNumber(_arg_1:int, _arg_2:int):int
        {
            var _local_3:int;
            var _local_4:int = _arg_1;
            while (_local_4 <= _arg_2)
            {
                if (this._items[_local_4] != null)
                {
                    _local_3++;
                };
                _local_4++;
            };
            return (_local_3);
        }


    }
}//package ddt.data

