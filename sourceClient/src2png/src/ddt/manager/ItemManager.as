// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.ItemManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import ddt.data.goods.CateCoryInfo;
    import road7th.data.DictionaryData;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.EquipType;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.analyze.ItemTempleteAnalyzer;
    import ddt.data.analyze.GoodCategoryAnalyzer;
    import ddt.data.analyze.EquipmentTemplateAnalyzer;
    import ddt.data.analyze.EquipPropertyListAnalyzer;
    import ddt.data.analyze.ComposeConfigListAnalyzer;
    import ddt.data.analyze.EquipSplitListAnalyzer;
    import ddt.data.analyze.EquipStrengthListAnalyzer;
    import ddt.data.analyze.BagCellInfoListAnalyze;
    import ddt.data.analyze.SuidTipsAnalyzer;
    import ddt.data.analyze.RuneSuitAnalyzer;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.data.goods.BagCellInfo;
    import ddt.data.goods.ComposeListInfo;
    import store.view.Compose.ComposeType;
    import ddt.data.goods.SpliteListInfo;
    import ddt.data.goods.SuidTipInfo;
    import ddt.data.goods.RuneSuitInfo;
    import ddt.data.goods.EquipStrengthInfo;

    [Event(name="templateReady", type="flash.events.Event")]
    public class ItemManager extends EventDispatcher 
    {

        private static var _instance:ItemManager;

        private var _categorys:Vector.<CateCoryInfo>;
        private var _goodsTemplates:DictionaryData;
        private var _equipTemplates:DictionaryData;
        private var _EquipPropertyList:DictionaryData;
        private var _composeList:DictionaryData;
        private var _spliteList:DictionaryData;
        private var _equipStrengthList:DictionaryData;
        private var _bagCellList:DictionaryData;
        private var _suidList:DictionaryData;
        private var _runeList:DictionaryData;
        private var _storeCateCory:Array;
        private var _equipComposeList:DictionaryData;
        private var _materialComposeList:DictionaryData;
        private var _jewelryComposeList:DictionaryData;
        private var _embedStoneComposeList:DictionaryData;
        private var _composeSuitInfoList:DictionaryData;
        private var _composeMaterialInfoList:DictionaryData;
        private var _composeEmbedInfoList:DictionaryData;
        private var _composeJewelryInfoList:DictionaryData;


        public static function fill(_arg_1:InventoryItemInfo):InventoryItemInfo
        {
            var _local_3:int;
            var _local_4:Array;
            var _local_2:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_arg_1.TemplateID);
            ObjectUtils.copyProperties(_arg_1, _local_2);
            if (_local_2)
            {
                _local_3 = 0;
                while (_local_3 < 4)
                {
                    _local_4 = EquipType.getEmbedHoleInfo(_local_2, _local_3);
                    if (((_local_4[0] == "-1") && (_local_4[1] == "0")))
                    {
                        _arg_1[("Hole" + (_local_3 + 1))] = 1;
                    }
                    else
                    {
                        _arg_1[("Hole" + (_local_3 + 1))] = _local_4[0];
                    };
                    _local_3++;
                };
            };
            return (_arg_1);
        }

        public static function get Instance():ItemManager
        {
            if (_instance == null)
            {
                _instance = new (ItemManager)();
            };
            return (_instance);
        }


        public function setupGoodsTemplates(_arg_1:ItemTempleteAnalyzer):void
        {
            this._goodsTemplates = _arg_1.list;
        }

        public function setupGoodsCategory(_arg_1:GoodCategoryAnalyzer):void
        {
            this._categorys = _arg_1.list;
        }

        public function setupEquipsTemplates(_arg_1:EquipmentTemplateAnalyzer):void
        {
            this._equipTemplates = _arg_1.list;
        }

        public function setupEquipPropertyList(_arg_1:EquipPropertyListAnalyzer):void
        {
            this._EquipPropertyList = _arg_1.list;
        }

        public function setupComposeItemConfigList(_arg_1:ComposeConfigListAnalyzer):void
        {
            this._composeList = _arg_1.list;
        }

        public function setupEquipComposeSplitList(_arg_1:EquipSplitListAnalyzer):void
        {
            this._spliteList = _arg_1.list;
        }

        public function setupEquipStrengthList(_arg_1:EquipStrengthListAnalyzer):void
        {
            this._equipStrengthList = _arg_1.list;
        }

        public function setupBagCellList(_arg_1:BagCellInfoListAnalyze):void
        {
            this._bagCellList = _arg_1.list;
        }

        public function addGoodsTemplates(_arg_1:ItemTempleteAnalyzer):void
        {
            var _local_2:ItemTemplateInfo;
            for each (_local_2 in _arg_1.list)
            {
                if ((!(this._goodsTemplates.hasKey(_local_2.TemplateID))))
                {
                    this._goodsTemplates.add(_local_2.TemplateID, _local_2);
                }
                else
                {
                    this._goodsTemplates[_local_2.TemplateID] = _local_2;
                };
            };
        }

        public function setupSuidList(_arg_1:SuidTipsAnalyzer):void
        {
            this._suidList = _arg_1.list;
        }

        public function setupRuneList(_arg_1:RuneSuitAnalyzer):void
        {
            this._runeList = _arg_1.list;
        }

        public function getTemplateById(_arg_1:int):ItemTemplateInfo
        {
            return (this._goodsTemplates[_arg_1]);
        }

        public function getEquipTemplateById(_arg_1:int):EquipmentTemplateInfo
        {
            return (this._equipTemplates[_arg_1]);
        }

        public function getEquipPropertyListById(_arg_1:int):EquipmentTemplateInfo
        {
            return (this._EquipPropertyList[_arg_1]);
        }

        public function getEquipLimitLevel(_arg_1:int):int
        {
            return (this._equipTemplates[_arg_1].StrengthLimit);
        }

        public function getBagCellByPlace(_arg_1:int):BagCellInfo
        {
            return (this._bagCellList[_arg_1]);
        }

        public function getEquipTemplateBySuitID(_arg_1:int):DictionaryData
        {
            var _local_3:EquipmentTemplateInfo;
            var _local_2:DictionaryData = new DictionaryData();
            for each (_local_3 in this._equipTemplates)
            {
                if (_local_3.SuitID == _arg_1)
                {
                    _local_2.add(_local_3.TemplateID, _local_3);
                };
            };
            return (_local_2);
        }

        public function get categorys():Vector.<CateCoryInfo>
        {
            return (this._categorys.slice(0));
        }

        public function get storeCateCory():Array
        {
            return (this._storeCateCory);
        }

        public function set storeCateCory(_arg_1:Array):void
        {
            this._storeCateCory = _arg_1;
        }

        public function get goodsTemplates():DictionaryData
        {
            return (this._goodsTemplates);
        }

        public function getFreeTemplateByCategoryId(_arg_1:int, _arg_2:int=0):ItemTemplateInfo
        {
            if (_arg_1 != EquipType.ARM)
            {
                return (this.getTemplateById(Number(((String(_arg_1) + String(_arg_2)) + "01"))));
            };
            return (this.getTemplateById(Number(((String(_arg_1) + "00") + String(_arg_2)))));
        }

        public function searchGoodsNameByStr(_arg_1:String):Array
        {
            var _local_3:ItemTemplateInfo;
            var _local_4:int;
            var _local_2:Array = new Array();
            for each (_local_3 in this._goodsTemplates)
            {
                if (_local_3.Name.indexOf(_arg_1) > -1)
                {
                    if (_local_2.length == 0)
                    {
                        _local_2.push(_local_3.Name);
                    }
                    else
                    {
                        _local_4 = 0;
                        while (_local_4 < _local_2.length)
                        {
                            if (_local_2[_local_4] == _local_3.Name) break;
                            if (_local_4 == (_local_2.length - 1))
                            {
                                _local_2.push(_local_3.Name);
                            };
                            _local_4++;
                        };
                    };
                };
            };
            return (_local_2);
        }

        public function getComposeList(_arg_1:int=0):DictionaryData
        {
            var _local_2:DictionaryData = new DictionaryData();
            if (_arg_1 == 0)
            {
                _local_2 = this._composeList;
            }
            else
            {
                if (_arg_1 == 1)
                {
                    _local_2 = this.getEquipComposeList();
                }
                else
                {
                    if (_arg_1 == 2)
                    {
                        _local_2 = this.getJewelryComposeList();
                    }
                    else
                    {
                        if (_arg_1 == 3)
                        {
                            _local_2 = this.getMaterialComposeList();
                        }
                        else
                        {
                            if (_arg_1 == 4)
                            {
                                _local_2 = this.getEmbedStoneComposeList();
                            };
                        };
                    };
                };
            };
            return (_local_2);
        }

        private function getEquipComposeList():DictionaryData
        {
            var _local_1:ComposeListInfo;
            if (this._equipComposeList == null)
            {
                this._equipComposeList = new DictionaryData();
                for each (_local_1 in this._composeList)
                {
                    if (_local_1.Type == ComposeType.EQUIP)
                    {
                        this._equipComposeList.add(_local_1.ID, _local_1);
                    };
                };
            };
            return (this._equipComposeList);
        }

        private function getMaterialComposeList():DictionaryData
        {
            var _local_1:ComposeListInfo;
            if (this._materialComposeList == null)
            {
                this._materialComposeList = new DictionaryData();
                for each (_local_1 in this._composeList)
                {
                    if (_local_1.Type == ComposeType.MATERIAL)
                    {
                        this._materialComposeList.add(_local_1.ID, _local_1);
                    };
                };
            };
            return (this._materialComposeList);
        }

        private function getJewelryComposeList():DictionaryData
        {
            var _local_1:ComposeListInfo;
            if (this._jewelryComposeList == null)
            {
                this._jewelryComposeList = new DictionaryData();
                for each (_local_1 in this._composeList)
                {
                    if (_local_1.Type == ComposeType.JEWELRY)
                    {
                        this._jewelryComposeList.add(_local_1.ID, _local_1);
                    };
                };
            };
            return (this._jewelryComposeList);
        }

        private function getEmbedStoneComposeList():DictionaryData
        {
            var _local_1:ComposeListInfo;
            if (this._embedStoneComposeList == null)
            {
                this._embedStoneComposeList = new DictionaryData();
                for each (_local_1 in this._composeList)
                {
                    if (_local_1.Type == ComposeType.EMBED_STONE)
                    {
                        this._embedStoneComposeList.add(_local_1.ID, _local_1);
                    };
                };
            };
            return (this._embedStoneComposeList);
        }

        public function getComposeInfoList(_arg_1:int, _arg_2:int=0):DictionaryData
        {
            var _local_3:DictionaryData = new DictionaryData();
            if (_arg_1 == 1)
            {
                _local_3 = this.getComposeSuitInfoList(_arg_2);
            };
            if (_arg_1 == 2)
            {
                _local_3 = this.getComposeJewelryInfoList();
            };
            if (_arg_1 == 3)
            {
                _local_3 = this.getComposeMaterialInfoList();
            };
            if (_arg_1 == 4)
            {
                _local_3 = this.getComposeEmbedInfoList();
            };
            return (_local_3);
        }

        public function judgeSuitQuality(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:Array = new Array();
            switch (_arg_2)
            {
                case 0:
                    _local_3 = this._equipComposeList[_arg_1].TemplateArray1;
                    break;
                case 1:
                    _local_3 = this._equipComposeList[_arg_1].TemplateArray2;
                    break;
                case 2:
                    _local_3 = this._equipComposeList[_arg_1].TemplateArray3;
                    break;
                case 3:
                    _local_3 = this._equipComposeList[_arg_1].TemplateArray4;
                    break;
                case 4:
                    _local_3 = this._equipComposeList[_arg_1].TemplateArray5;
                    break;
            };
            if (_local_3[0] != 0)
            {
                return (true);
            };
            return (false);
        }

        private function getComposeSuitInfoList(_arg_1:int):DictionaryData
        {
            var _local_3:ComposeListInfo;
            var _local_4:Array;
            var _local_5:int;
            var _local_6:Array;
            var _local_7:int;
            var _local_2:ItemTemplateInfo = new ItemTemplateInfo();
            this._composeSuitInfoList = new DictionaryData();
            for each (_local_3 in this._equipComposeList)
            {
                _local_4 = new Array();
                _local_5 = 0;
                _local_6 = new Array();
                switch (_arg_1)
                {
                    case 0:
                        _local_6 = _local_3.TemplateArray1;
                        break;
                    case 1:
                        _local_6 = _local_3.TemplateArray2;
                        break;
                    case 2:
                        _local_6 = _local_3.TemplateArray3;
                        break;
                    case 3:
                        _local_6 = _local_3.TemplateArray4;
                        break;
                    case 4:
                        _local_6 = _local_3.TemplateArray5;
                        break;
                };
                if (_local_6[0] != 0)
                {
                    for each (_local_7 in _local_6)
                    {
                        _local_2 = this.getTemplateById(_local_7);
                        _local_4[_local_5] = _local_2;
                        _local_5++;
                    };
                    this._composeSuitInfoList.add(_local_3.ID, _local_4);
                };
            };
            return (this._composeSuitInfoList);
        }

        private function getComposeMaterialInfoList():DictionaryData
        {
            var _local_3:ComposeListInfo;
            var _local_4:int;
            var _local_5:int;
            var _local_1:Array = new Array();
            var _local_2:ItemTemplateInfo = new ItemTemplateInfo();
            if (this._composeMaterialInfoList == null)
            {
                this._composeMaterialInfoList = new DictionaryData();
                for each (_local_3 in this._materialComposeList)
                {
                    _local_1 = new Array();
                    _local_4 = 0;
                    for each (_local_5 in _local_3.TemplateArray1)
                    {
                        _local_2 = this.getTemplateById(_local_5);
                        _local_1[_local_4] = _local_2;
                        _local_4++;
                    };
                    this._composeMaterialInfoList.add(_local_3.ID, _local_1);
                };
            };
            return (this._composeMaterialInfoList);
        }

        private function getComposeEmbedInfoList():DictionaryData
        {
            var _local_3:ComposeListInfo;
            var _local_4:int;
            var _local_5:int;
            var _local_1:Array = new Array();
            var _local_2:ItemTemplateInfo = new ItemTemplateInfo();
            if (this._composeEmbedInfoList == null)
            {
                this._composeEmbedInfoList = new DictionaryData();
                for each (_local_3 in this._embedStoneComposeList)
                {
                    _local_1 = new Array();
                    _local_4 = 0;
                    for each (_local_5 in _local_3.TemplateArray1)
                    {
                        _local_2 = this.getTemplateById(_local_5);
                        _local_1[_local_4] = _local_2;
                        _local_4++;
                    };
                    this._composeEmbedInfoList.add(_local_3.ID, _local_1);
                };
            };
            return (this._composeEmbedInfoList);
        }

        private function getComposeJewelryInfoList():DictionaryData
        {
            var _local_3:ComposeListInfo;
            var _local_4:int;
            var _local_1:Array = new Array();
            var _local_2:ItemTemplateInfo = new ItemTemplateInfo();
            if (this._composeJewelryInfoList == null)
            {
                this._composeJewelryInfoList = new DictionaryData();
                for each (_local_3 in this._jewelryComposeList)
                {
                    _local_1 = new Array();
                    for each (_local_4 in _local_3.TemplateArray1)
                    {
                        _local_2 = this.getTemplateById(_local_4);
                        _local_1[_local_4] = _local_2;
                    };
                    this._composeJewelryInfoList.add(_local_3.ID, _local_1);
                };
            };
            return (this._composeJewelryInfoList);
        }

        public function getSpliteInfoByID(_arg_1:int):SpliteListInfo
        {
            if (this._spliteList)
            {
                return (this._spliteList[_arg_1]);
            };
            return (null);
        }

        public function getSuidListByLevle(_arg_1:int):SuidTipInfo
        {
            return (this._suidList[_arg_1]);
        }

        public function getRuneListByLevel(_arg_1:int):RuneSuitInfo
        {
            return (this._runeList[_arg_1]);
        }

        public function getRuneMaxLevel():int
        {
            return (this._runeList[this._runeList.length].ID);
        }

        public function getEquipStrengthInfoByLevel(_arg_1:int, _arg_2:int):EquipStrengthInfo
        {
            var _local_3:String = (_arg_1.toString() + _arg_2.toString());
            if (this._equipStrengthList)
            {
                return (this._equipStrengthList[_local_3]);
            };
            return (null);
        }

        public function getAddMinorProperty(_arg_1:ItemTemplateInfo, _arg_2:InventoryItemInfo):int
        {
            var _local_3:int;
            var _local_4:InventoryItemInfo = _arg_2;
            var _local_5:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            var _local_6:EquipStrengthInfo = ItemManager.Instance.getEquipStrengthInfoByLevel((_local_4.StrengthenLevel + 1), _local_5.QualityID);
            if (_local_5.MainProperty1ID == 1)
            {
                _local_3 = _local_6.Attack;
            }
            else
            {
                if (_local_5.MainProperty1ID == 2)
                {
                    _local_3 = _local_6.Defence;
                }
                else
                {
                    if (_local_5.MainProperty1ID == 3)
                    {
                        _local_3 = _local_6.Agility;
                    }
                    else
                    {
                        if (_local_5.MainProperty1ID == 4)
                        {
                            _local_3 = _local_6.Lucky;
                        }
                        else
                        {
                            if (_local_5.MainProperty1ID == 5)
                            {
                                _local_3 = _local_6.Damage;
                            }
                            else
                            {
                                if (_local_5.MainProperty1ID == 6)
                                {
                                    _local_3 = _local_6.Guard;
                                }
                                else
                                {
                                    if (_local_5.MainProperty1ID == 7)
                                    {
                                        _local_3 = _local_6.Blood;
                                    }
                                    else
                                    {
                                        if (_local_5.MainProperty1ID == 8)
                                        {
                                            _local_3 = _local_6.Energy;
                                        }
                                        else
                                        {
                                            if (_local_5.MainProperty1ID == 9)
                                            {
                                                _local_3 = _local_6.ReplayBlood;
                                            }
                                            else
                                            {
                                                if (_local_5.MainProperty1ID == 10)
                                                {
                                                    _local_3 = _local_6.CritDamage;
                                                }
                                                else
                                                {
                                                    if (_local_5.MainProperty1ID == 11)
                                                    {
                                                        _local_3 = _local_6.RepelCrit;
                                                    }
                                                    else
                                                    {
                                                        if (_local_5.MainProperty1ID == 12)
                                                        {
                                                            _local_3 = _local_6.RepelCritDamage;
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (_local_3);
        }

        public function getAddTwoMinorProperty(_arg_1:ItemTemplateInfo, _arg_2:InventoryItemInfo):int
        {
            var _local_3:int;
            var _local_4:InventoryItemInfo = _arg_2;
            var _local_5:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            var _local_6:EquipStrengthInfo = ItemManager.Instance.getEquipStrengthInfoByLevel((_local_4.StrengthenLevel + 1), _local_5.QualityID);
            if (_local_5.MainProperty2ID == 1)
            {
                _local_3 = _local_6.Attack;
            }
            else
            {
                if (_local_5.MainProperty2ID == 2)
                {
                    _local_3 = _local_6.Defence;
                }
                else
                {
                    if (_local_5.MainProperty2ID == 3)
                    {
                        _local_3 = _local_6.Agility;
                    }
                    else
                    {
                        if (_local_5.MainProperty2ID == 4)
                        {
                            _local_3 = _local_6.Lucky;
                        }
                        else
                        {
                            if (_local_5.MainProperty2ID == 5)
                            {
                                _local_3 = _local_6.Damage;
                            }
                            else
                            {
                                if (_local_5.MainProperty2ID == 6)
                                {
                                    _local_3 = _local_6.Guard;
                                }
                                else
                                {
                                    if (_local_5.MainProperty2ID == 7)
                                    {
                                        _local_3 = _local_6.Blood;
                                    }
                                    else
                                    {
                                        if (_local_5.MainProperty2ID == 8)
                                        {
                                            _local_3 = _local_6.Energy;
                                        }
                                        else
                                        {
                                            if (_local_5.MainProperty2ID == 9)
                                            {
                                                _local_3 = _local_6.Crit;
                                            }
                                            else
                                            {
                                                if (_local_5.MainProperty2ID == 10)
                                                {
                                                    _local_3 = _local_6.CritDamage;
                                                }
                                                else
                                                {
                                                    if (_local_5.MainProperty2ID == 11)
                                                    {
                                                        _local_3 = _local_6.RepelCrit;
                                                    }
                                                    else
                                                    {
                                                        if (_local_5.MainProperty2ID == 12)
                                                        {
                                                            _local_3 = _local_6.RepelCritDamage;
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (_local_3);
        }

        public function getMinorProperty(_arg_1:ItemTemplateInfo, _arg_2:InventoryItemInfo):int
        {
            var _local_3:int;
            var _local_4:InventoryItemInfo = _arg_2;
            var _local_5:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            var _local_6:EquipStrengthInfo = ItemManager.Instance.getEquipStrengthInfoByLevel(_local_4.StrengthenLevel, _local_5.QualityID);
            if (_local_5.MainProperty1ID == 1)
            {
                _local_3 = _local_6.Attack;
            }
            else
            {
                if (_local_5.MainProperty1ID == 2)
                {
                    _local_3 = _local_6.Defence;
                }
                else
                {
                    if (_local_5.MainProperty1ID == 3)
                    {
                        _local_3 = _local_6.Agility;
                    }
                    else
                    {
                        if (_local_5.MainProperty1ID == 4)
                        {
                            _local_3 = _local_6.Lucky;
                        }
                        else
                        {
                            if (_local_5.MainProperty1ID == 5)
                            {
                                _local_3 = _local_6.Damage;
                            }
                            else
                            {
                                if (_local_5.MainProperty1ID == 6)
                                {
                                    _local_3 = _local_6.Guard;
                                }
                                else
                                {
                                    if (_local_5.MainProperty1ID == 7)
                                    {
                                        _local_3 = _local_6.Blood;
                                    }
                                    else
                                    {
                                        if (_local_5.MainProperty1ID == 8)
                                        {
                                            _local_3 = _local_6.Energy;
                                        }
                                        else
                                        {
                                            if (_local_5.MainProperty1ID == 9)
                                            {
                                                _local_3 = _local_6.ReplayBlood;
                                            }
                                            else
                                            {
                                                if (_local_5.MainProperty1ID == 10)
                                                {
                                                    _local_3 = _local_6.CritDamage;
                                                }
                                                else
                                                {
                                                    if (_local_5.MainProperty1ID == 11)
                                                    {
                                                        _local_3 = _local_6.RepelCrit;
                                                    }
                                                    else
                                                    {
                                                        if (_local_5.MainProperty1ID == 12)
                                                        {
                                                            _local_3 = _local_6.RepelCritDamage;
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (_local_3);
        }

        public function getTwoMinorProperty(_arg_1:ItemTemplateInfo, _arg_2:InventoryItemInfo):int
        {
            var _local_3:int;
            var _local_4:InventoryItemInfo = _arg_2;
            var _local_5:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            var _local_6:EquipStrengthInfo = ItemManager.Instance.getEquipStrengthInfoByLevel(_local_4.StrengthenLevel, _local_5.QualityID);
            if (_local_5.MainProperty2ID == 1)
            {
                _local_3 = _local_6.Attack;
            }
            else
            {
                if (_local_5.MainProperty2ID == 2)
                {
                    _local_3 = _local_6.Defence;
                }
                else
                {
                    if (_local_5.MainProperty2ID == 3)
                    {
                        _local_3 = _local_6.Agility;
                    }
                    else
                    {
                        if (_local_5.MainProperty2ID == 4)
                        {
                            _local_3 = _local_6.Lucky;
                        }
                        else
                        {
                            if (_local_5.MainProperty2ID == 5)
                            {
                                _local_3 = _local_6.Damage;
                            }
                            else
                            {
                                if (_local_5.MainProperty2ID == 6)
                                {
                                    _local_3 = _local_6.Guard;
                                }
                                else
                                {
                                    if (_local_5.MainProperty2ID == 7)
                                    {
                                        _local_3 = _local_6.Blood;
                                    }
                                    else
                                    {
                                        if (_local_5.MainProperty2ID == 8)
                                        {
                                            _local_3 = _local_6.Energy;
                                        }
                                        else
                                        {
                                            if (_local_5.MainProperty2ID == 9)
                                            {
                                                _local_3 = _local_6.Crit;
                                            }
                                            else
                                            {
                                                if (_local_5.MainProperty2ID == 10)
                                                {
                                                    _local_3 = _local_6.CritDamage;
                                                }
                                                else
                                                {
                                                    if (_local_5.MainProperty2ID == 11)
                                                    {
                                                        _local_3 = _local_6.RepelCrit;
                                                    }
                                                    else
                                                    {
                                                        if (_local_5.MainProperty2ID == 12)
                                                        {
                                                            _local_3 = _local_6.RepelCritDamage;
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (_local_3);
        }

        public function judgeJewelry(_arg_1:ItemTemplateInfo):Boolean
        {
            var _local_2:EquipmentTemplateInfo;
            if (_arg_1.CategoryID == EquipType.EQUIP)
            {
                _local_2 = this.getEquipTemplateById(_arg_1.TemplateID);
                if (((_local_2.TemplateType > 6) && (_local_2.TemplateType < 11)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function judgeOldJewelry(_arg_1:ItemTemplateInfo):Boolean
        {
            if (_arg_1.CategoryID == EquipType.EQUIP)
            {
                if (((_arg_1.TemplateID > 40499) && (_arg_1.TemplateID < 405309)))
                {
                    return (true);
                };
            };
            return (false);
        }


    }
}//package ddt.manager

