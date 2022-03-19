// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.data.StoreModel

package store.data
{
    import flash.events.EventDispatcher;
    import ddt.data.player.SelfInfo;
    import road7th.data.DictionaryData;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.events.BagEvent;
    import ddt.data.BagInfo;
    import flash.utils.Dictionary;
    import store.events.StoreIIEvent;
    import ddt.data.EquipType;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.ItemManager;
    import store.view.Compose.ComposeController;
    import store.events.UpdateItemEvent;
    import road7th.data.DictionaryEvent;
    import store.events.StoreBagEvent;

    public class StoreModel extends EventDispatcher 
    {

        private static var _holeExpModel:HoleExpModel;

        private var _info:SelfInfo;
        private var _equipmentBag:DictionaryData;
        private var _canCpsEquipmentList:DictionaryData;
        private var _canCpsMaterialList:DictionaryData;
        private var _canCpsQewelryList:DictionaryData;
        private var _canStrthEqpmtList:DictionaryData;
        private var _canEmbedEquipmentList:DictionaryData;
        private var _strthList:DictionaryData;
        private var _canTransEquipmengtList:DictionaryData;
        private var _canSplitEquipList:DictionaryData;
        private var _canSplitPropList:DictionaryData;
        private var _canRefiningEquipList:DictionaryData;
        private var _currentPanel:int;
        private var _needAutoLink:int = 0;
        private var _weaponReady:Boolean;
        private var _transWeaponReady:Boolean;
        private var _refiningConfig:DictionaryData;
        private var _currentComposeItem:ComposeCurrentInfo;

        public function StoreModel(_arg_1:PlayerInfo)
        {
            this._info = (_arg_1 as SelfInfo);
            this._equipmentBag = this._info.Bag.items;
            this.initData();
            this.initEvent();
        }

        public static function getHoleMaxOpLv():int
        {
            if (_holeExpModel == null)
            {
                _holeExpModel = ComponentFactory.Instance.creatCustomObject("HoleExpModel");
            };
            return (_holeExpModel.getMaxOpLv());
        }

        public static function getHoleExpByLv(_arg_1:int):int
        {
            if (_holeExpModel == null)
            {
                _holeExpModel = ComponentFactory.Instance.creatCustomObject("HoleExpModel");
            };
            return (_holeExpModel.getExpByLevel(_arg_1));
        }


        private function initData():void
        {
            this._canStrthEqpmtList = new DictionaryData();
            this._canCpsEquipmentList = new DictionaryData();
            this._canEmbedEquipmentList = new DictionaryData();
            this._canCpsQewelryList = new DictionaryData();
            this._canCpsMaterialList = new DictionaryData();
            this._canTransEquipmengtList = new DictionaryData();
            this._canSplitEquipList = new DictionaryData();
            this._canRefiningEquipList = new DictionaryData();
            this._strthList = new DictionaryData();
            this.pickValidItemsOutOf(this._equipmentBag, true);
            this._canStrthEqpmtList = this.sortEquipList(this._canStrthEqpmtList);
            this._canEmbedEquipmentList = this.sortEquipList(this._canEmbedEquipmentList);
            this._canCpsEquipmentList = this.sortEquipList(this._canCpsEquipmentList);
            this._canCpsQewelryList = this.sortEquipList(this._canCpsQewelryList);
            this._canCpsMaterialList = this.sortEquipList(this._canCpsMaterialList);
            this._canTransEquipmengtList = this.sortEquipList(this._canTransEquipmengtList);
            this._canSplitEquipList = this.sortEquipList(this._canSplitEquipList);
            this._canRefiningEquipList = this.sortEquipList(this._canRefiningEquipList);
        }

        private function pickValidItemsOutOf(_arg_1:DictionaryData, _arg_2:Boolean):void
        {
            var _local_3:InventoryItemInfo;
            for each (_local_3 in _arg_1)
            {
                if (this.isProperTo_CanStrthEqpmtList(_local_3))
                {
                    this._canStrthEqpmtList.add(this._canStrthEqpmtList.length, _local_3);
                };
                if (this.isProperTo_canEmbedEquipmentList(_local_3))
                {
                    this._canEmbedEquipmentList.add(this._canEmbedEquipmentList.length, _local_3);
                };
                if (this.isProperTo_CanCpsEquipmentList(_local_3))
                {
                    this._canCpsEquipmentList.add(this._canCpsEquipmentList.length, _local_3);
                };
                if (this.isProperTo_CanCpsQewelryList(_local_3))
                {
                    this._canCpsQewelryList.add(this._canCpsQewelryList.length, _local_3);
                };
                if (this.isProperTo_CanCpsMaterialList(_local_3))
                {
                    this._canCpsMaterialList.add(this._canCpsMaterialList.length, _local_3);
                };
                if (this.isProperTo_CanTransEquipmengtList(_local_3))
                {
                    this._canTransEquipmengtList.add(this._canTransEquipmengtList.length, _local_3);
                };
                if (this.isProperTo_CanSplitEquipList(_local_3))
                {
                    this._canSplitEquipList.add(this._canSplitEquipList.length, _local_3);
                };
                if (this.isProperTo_CanRefiningEquipList(_local_3))
                {
                    this._canRefiningEquipList.add(this._canRefiningEquipList.length, _local_3);
                };
                if (this.isStrengthenStone(_local_3))
                {
                    this._strthList.add(this._strthList.length, _local_3);
                };
            };
        }

        private function initEvent():void
        {
            this._info.PropBag.addEventListener(BagEvent.UPDATE, this.updateBag);
            this._info.Bag.addEventListener(BagEvent.UPDATE, this.updateBag);
        }

        private function updateBag(_arg_1:BagEvent):void
        {
            var _local_4:InventoryItemInfo;
            var _local_5:InventoryItemInfo;
            var _local_2:BagInfo = (_arg_1.target as BagInfo);
            var _local_3:Dictionary = _arg_1.changedSlots;
            for each (_local_4 in _local_3)
            {
                _local_5 = _local_2.getItemAt(_local_4.Place);
                if (_local_5)
                {
                    this.__updateEquip(_local_5);
                }
                else
                {
                    this.removeFrom(_local_4, this._canStrthEqpmtList);
                    this.removeFrom(_local_4, this._canEmbedEquipmentList);
                    this.removeFrom(_local_4, this._canCpsEquipmentList);
                    this.removeFrom(_local_4, this._canCpsQewelryList);
                    this.removeFrom(_local_4, this._canCpsMaterialList);
                    this.removeFrom(_local_4, this._canTransEquipmengtList);
                    this.removeFrom(_local_4, this._canSplitEquipList);
                    this.removeFrom(_local_4, this._canRefiningEquipList);
                    this.removeFrom(_local_4, this._strthList);
                };
            };
        }

        private function __updateEquip(_arg_1:InventoryItemInfo):void
        {
            if (this.isProperTo_CanStrthEqpmtList(_arg_1))
            {
                this.updateDic(this._canStrthEqpmtList, _arg_1);
            }
            else
            {
                this.removeFrom(_arg_1, this._canStrthEqpmtList);
            };
            if (this.isProperTo_canEmbedEquipmentList(_arg_1))
            {
                this.updateDic(this._canEmbedEquipmentList, _arg_1);
            }
            else
            {
                this.removeFrom(_arg_1, this._canEmbedEquipmentList);
            };
            if (this.isProperTo_CanCpsEquipmentList(_arg_1))
            {
                this.updateDic(this._canCpsEquipmentList, _arg_1);
            }
            else
            {
                this.removeFrom(_arg_1, this._canCpsEquipmentList);
            };
            if (this.isProperTo_CanCpsQewelryList(_arg_1))
            {
                this.updateDic(this._canCpsQewelryList, _arg_1);
            }
            else
            {
                this.removeFrom(_arg_1, this._canCpsQewelryList);
            };
            if (this.isProperTo_CanCpsMaterialList(_arg_1))
            {
                this.updateDic(this._canCpsMaterialList, _arg_1);
            }
            else
            {
                this.removeFrom(_arg_1, this._canCpsMaterialList);
            };
            if (this.isProperTo_CanTransEquipmengtList(_arg_1))
            {
                this.updateDic(this._canTransEquipmengtList, _arg_1);
            }
            else
            {
                this.removeFrom(_arg_1, this._canTransEquipmengtList);
            };
            if (this.isProperTo_CanSplitEquipList(_arg_1))
            {
                this.updateDic(this._canSplitEquipList, _arg_1);
            }
            else
            {
                this.removeFrom(_arg_1, this._canSplitEquipList);
            };
            if (this.isProperTo_CanRefiningEquipList(_arg_1))
            {
                this.updateDic(this._canRefiningEquipList, _arg_1);
            }
            else
            {
                this.removeFrom(_arg_1, this._canRefiningEquipList);
            };
            if (this.isStrengthenStone(_arg_1))
            {
                this.updateDic(this._strthList, _arg_1);
                dispatchEvent(new StoreIIEvent(StoreIIEvent.STONE_UPDATE));
            }
            else
            {
                this.removeFrom(_arg_1, this._strthList);
            };
        }

        private function isStrengthenStone(_arg_1:InventoryItemInfo):Boolean
        {
            return (_arg_1.TemplateID == EquipType.STRENGTH_STONE_NEW);
        }

        private function isProperTo_CanCpsEquipmentList(_arg_1:InventoryItemInfo):Boolean
        {
            var _local_2:EquipmentTemplateInfo;
            if (_arg_1.CategoryID == EquipType.EQUIP)
            {
                _local_2 = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
                if (((_local_2.TemplateType <= 6) && (ComposeController.instance.model.composeItemInfoDic[_arg_1.TemplateID])))
                {
                    return (true);
                };
            };
            if (_arg_1.CategoryID == EquipType.COMPOSE_MATERIAL)
            {
                return (true);
            };
            return (false);
        }

        private function isProperTo_CanCpsQewelryList(_arg_1:InventoryItemInfo):Boolean
        {
            return (ItemManager.Instance.judgeJewelry(_arg_1));
        }

        private function isProperTo_CanCpsMaterialList(_arg_1:InventoryItemInfo):Boolean
        {
            if (_arg_1.CategoryID == EquipType.COMPOSE_MATERIAL)
            {
                return (true);
            };
            return (false);
        }

        private function isProperTo_CanStrthEqpmtList(_arg_1:InventoryItemInfo):Boolean
        {
            var _local_2:EquipmentTemplateInfo;
            if (_arg_1.CategoryID == EquipType.EQUIP)
            {
                _local_2 = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
                if (((_local_2.TemplateType <= 6) && (_local_2.StrengthLimit > 0)))
                {
                    return (true);
                };
            };
            return (false);
        }

        private function isProperTo_canEmbedEquipmentList(_arg_1:InventoryItemInfo):Boolean
        {
            var _local_2:EquipmentTemplateInfo;
            if (_arg_1)
            {
                if (_arg_1.TemplateID == EquipType.DIAMOND_DRIL)
                {
                    return (true);
                };
                _local_2 = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
                if (((_local_2) && (!(EquipType.isHolyGrail(_arg_1)))))
                {
                    return (true);
                };
            };
            return (false);
        }

        private function isProperTo_CanTransEquipmengtList(_arg_1:InventoryItemInfo):Boolean
        {
            var _local_2:EquipmentTemplateInfo;
            if (_arg_1.CategoryID == 27)
            {
                return (false);
            };
            if (_arg_1.CategoryID == EquipType.EQUIP)
            {
                _local_2 = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
                if (((_local_2.TemplateType <= 6) && (_local_2.StrengthLimit > 0)))
                {
                    return (true);
                };
            };
            return (false);
        }

        private function isProperTo_CanSplitEquipList(_arg_1:InventoryItemInfo):Boolean
        {
            if (ItemManager.Instance.getSpliteInfoByID(_arg_1.TemplateID))
            {
                return (true);
            };
            return (false);
        }

        private function isProperTo_CanRefiningEquipList(_arg_1:InventoryItemInfo):Boolean
        {
            if (ItemManager.Instance.judgeOldJewelry(_arg_1))
            {
                return (false);
            };
            return (ItemManager.Instance.judgeJewelry(_arg_1));
        }

        private function updateDic(_arg_1:DictionaryData, _arg_2:InventoryItemInfo):void
        {
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (((!(_arg_1[_local_3] == null)) && (_arg_1[_local_3].Place == _arg_2.Place)))
                {
                    _arg_1.add(_local_3, _arg_2);
                    _arg_1.dispatchEvent(new UpdateItemEvent(UpdateItemEvent.UPDATEITEMEVENT, _local_3, _arg_2));
                    return;
                };
                _local_3++;
            };
            this.addItemToTheFirstNullCell(_arg_2, _arg_1);
        }

        private function __removeEquip(_arg_1:DictionaryEvent):void
        {
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            this.removeFrom(_local_2, this._canCpsEquipmentList);
            this.removeFrom(_local_2, this._canCpsQewelryList);
            this.removeFrom(_local_2, this._canCpsMaterialList);
            this.removeFrom(_local_2, this._canStrthEqpmtList);
            this.removeFrom(_local_2, this._canEmbedEquipmentList);
            this.removeFrom(_local_2, this._canTransEquipmengtList);
        }

        private function addItemToTheFirstNullCell(_arg_1:InventoryItemInfo, _arg_2:DictionaryData):void
        {
            _arg_2.add(this.findFirstNullCellID(_arg_2), _arg_1);
        }

        private function findFirstNullCellID(_arg_1:DictionaryData):int
        {
            var _local_2:int = -1;
            var _local_3:int = _arg_1.length;
            var _local_4:int;
            while (_local_4 <= _local_3)
            {
                if (_arg_1[_local_4] == null)
                {
                    _local_2 = _local_4;
                    break;
                };
                _local_4++;
            };
            return (_local_2);
        }

        private function removeFrom(_arg_1:InventoryItemInfo, _arg_2:DictionaryData):void
        {
            var _local_3:int = _arg_2.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                if (((_arg_2[_local_4]) && (_arg_2[_local_4].Place == _arg_1.Place)))
                {
                    _arg_2[_local_4] = null;
                    _arg_2.dispatchEvent(new StoreBagEvent(StoreBagEvent.REMOVE, _local_4, _arg_1));
                    if (_arg_1.TemplateID == EquipType.STRENGTH_STONE_NEW)
                    {
                        dispatchEvent(new StoreIIEvent(StoreIIEvent.STONE_UPDATE));
                    };
                    return;
                };
                _local_4++;
            };
        }

        public function sortEquipList(_arg_1:DictionaryData):DictionaryData
        {
            var _local_2:DictionaryData = _arg_1;
            _arg_1 = new DictionaryData();
            this.fillByCategoryID(_local_2, _arg_1, EquipType.EQUIP);
            this.fillByCategoryID(_local_2, _arg_1, EquipType.COMPOSE_MATERIAL);
            this.fillByCategoryID(_local_2, _arg_1, 11);
            return (_arg_1);
        }

        private function fillByCategoryID(_arg_1:DictionaryData, _arg_2:DictionaryData, _arg_3:int):void
        {
            var _local_4:InventoryItemInfo;
            for each (_local_4 in _arg_1)
            {
                if (_local_4.CategoryID == _arg_3)
                {
                    _arg_2.add(_arg_2.length, _local_4);
                };
            };
        }

        private function fillByTemplateID(_arg_1:DictionaryData, _arg_2:DictionaryData, _arg_3:int):void
        {
            var _local_4:InventoryItemInfo;
            for each (_local_4 in _arg_1)
            {
                if (_local_4.TemplateID == _arg_3)
                {
                    _arg_2.add(_arg_2.length, _local_4);
                };
            };
        }

        private function fillByProperty1(_arg_1:DictionaryData, _arg_2:DictionaryData, _arg_3:String):void
        {
            var _local_5:InventoryItemInfo;
            var _local_4:Array = [];
            for each (_local_5 in _arg_1)
            {
                if (_local_5.Property1 == _arg_3)
                {
                    _local_4.push(_local_5);
                };
            };
            this.bubbleSort(_local_4);
            for each (_local_5 in _local_4)
            {
                _arg_2.add(_arg_2.length, _local_5);
            };
        }

        private function findByTemplateID(_arg_1:DictionaryData, _arg_2:DictionaryData, _arg_3:int):void
        {
            var _local_5:InventoryItemInfo;
            var _local_4:Array = [];
            for each (_local_5 in _arg_1)
            {
                if (_local_5.TemplateID == _arg_3)
                {
                    _local_4.push(_local_5);
                };
            };
            this.bubbleSort(_local_4);
            for each (_local_5 in _local_4)
            {
                _arg_2.add(_arg_2.length, _local_5);
            };
        }

        private function bubbleSort(_arg_1:Array):void
        {
            var _local_4:Boolean;
            var _local_5:int;
            var _local_6:InventoryItemInfo;
            var _local_2:int = _arg_1.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = true;
                _local_5 = 0;
                while (_local_5 < (_local_2 - 1))
                {
                    if (_arg_1[_local_5].Quality < _arg_1[(_local_5 + 1)].Quality)
                    {
                        _local_6 = _arg_1[_local_5];
                        _arg_1[_local_5] = _arg_1[(_local_5 + 1)];
                        _arg_1[(_local_5 + 1)] = _local_6;
                        _local_4 = false;
                    };
                    _local_5++;
                };
                if (_local_4)
                {
                    return;
                };
                _local_3++;
            };
        }

        public function get info():PlayerInfo
        {
            return (this._info);
        }

        public function set currentPanel(_arg_1:int):void
        {
            this._currentPanel = _arg_1;
        }

        public function get currentPanel():int
        {
            return (this._currentPanel);
        }

        public function get canCpsEquipmentList():DictionaryData
        {
            return (this._canCpsEquipmentList);
        }

        public function get canCpsMaterialList():DictionaryData
        {
            return (this._canCpsMaterialList);
        }

        public function get canCpsQewelryList():DictionaryData
        {
            return (this._canCpsQewelryList);
        }

        public function get canSplitEquipList():DictionaryData
        {
            return (this._canSplitEquipList);
        }

        public function get canRefiningEquipList():DictionaryData
        {
            return (this._canRefiningEquipList);
        }

        public function get canStrthEqpmtList():DictionaryData
        {
            return (this._canStrthEqpmtList);
        }

        public function get canEmbedEquipmentList():DictionaryData
        {
            return (this._canEmbedEquipmentList);
        }

        public function get canTransEquipmengtList():DictionaryData
        {
            return (this._canTransEquipmengtList);
        }

        public function set NeedAutoLink(_arg_1:int):void
        {
            this._needAutoLink = _arg_1;
        }

        public function get NeedAutoLink():int
        {
            return (this._needAutoLink);
        }

        public function loadBagData():void
        {
            this.initData();
        }

        public function get currentComposeItem():ComposeCurrentInfo
        {
            if (this._currentComposeItem == null)
            {
                this._currentComposeItem = new ComposeCurrentInfo();
            };
            return (this._currentComposeItem);
        }

        public function set currentComposeItem(_arg_1:ComposeCurrentInfo):void
        {
            var _local_2:EquipmentTemplateInfo;
            if (_arg_1.type == EquipType.EQUIP)
            {
                _local_2 = ItemManager.Instance.getEquipTemplateById(_arg_1.templeteID);
                if (_local_2.TemplateType > 6)
                {
                    _arg_1.type = EquipType.QEWELRY;
                };
            };
            this._currentComposeItem = _arg_1;
        }

        public function get weaponReady():Boolean
        {
            return (this._weaponReady);
        }

        public function set weaponReady(_arg_1:Boolean):void
        {
            this._weaponReady = _arg_1;
        }

        public function get transWeaponReady():Boolean
        {
            return (this._transWeaponReady);
        }

        public function set transWeaponReady(_arg_1:Boolean):void
        {
            this._transWeaponReady = _arg_1;
        }

        public function clear():void
        {
            this._info.PropBag.removeEventListener(BagEvent.UPDATE, this.updateBag);
            this._info.Bag.removeEventListener(BagEvent.UPDATE, this.updateBag);
            this._info = null;
            this._equipmentBag = null;
        }

        public function get refiningConfig():DictionaryData
        {
            return (this._refiningConfig);
        }

        public function set refiningConfig(_arg_1:DictionaryData):void
        {
            this._refiningConfig = _arg_1;
        }

        public function getRefiningConfigByLevel(_arg_1:int):RefiningConfigInfo
        {
            return (this._refiningConfig[_arg_1]);
        }

        public function judgeEmbedIn(_arg_1:InventoryItemInfo):Boolean
        {
            var _local_2:int = 1;
            while (_local_2 <= 4)
            {
                if (_arg_1[("Hole" + _local_2)] > 1)
                {
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }


    }
}//package store.data

