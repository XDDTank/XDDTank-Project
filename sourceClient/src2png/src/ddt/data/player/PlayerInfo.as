// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.player.PlayerInfo

package ddt.data.player
{
    import road7th.data.DictionaryData;
    import ddt.data.BagInfo;
    import pet.date.PetInfo;
    import ddt.view.character.RoomCharacter;
    import ddt.data.EquipType;
    import totem.TotemManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.PlayerManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.events.WebSpeedEvent;
    import ddt.data.BuffInfo;
    import flash.events.Event;
    import ddt.manager.TimeManager;
    import weekend.WeekendEvent;

    public class PlayerInfo extends BasePlayer 
    {

        public static const FIGHTPOWER:String = "FightPower";
        public static const SEX:String = "Sex";
        public static const STYLE:String = "Style";
        public static const HIDE:String = "Hide";
        public static const SKIN:String = "Skin";
        public static const COLORS:String = "Colors";
        public static const NIMBUS:String = "Nimbus";
        public static const GRADE:String = "Grade";
        public static const GOLD:String = "Gold";
        public static const MONEY:String = "Money";
        public static const DDT_MONEY:String = "Money";
        public static const MEDAL:String = "medal";
        public static const ARM:String = "WeaponID";
        public static const UPDATE_SHOP_FINALLY_TIME:String = "shopFinallyGottenTime";
        public static const BEAD_SCORE:String = "bead_score";
        public static const CHARM_LEVEL_NEED_EXP:Array = [0, 10, 50, 120, 210, 320, 450, 600, 770, 960, 1170, 1410, 1680, 1980, 2310, 2670, 3060, 3480, 3930, 4410, 4920, 5470, 6060, 6690, 7360, 8070, 8820, 9610, 10440, 11310, 12220, 13190, 14220, 15310, 16460, 17670, 18940, 20270, 21660, 23110, 25110, 27660, 30760, 34410, 38610, 43360, 48660, 54510, 60910, 67860, 75360, 83460, 92160, 101460, 111360, 121860, 132960, 144660, 156960, 169860, 183360, 197460, 212160, 227460, 243360, 259860, 276960, 294660, 312960, 331860, 351360, 371460, 392160, 413460, 435360, 457860, 480960, 504660, 528960, 553860, 579360, 605460, 632160, 659460, 687360, 715860, 744960, 774660, 804960, 835860, 867360, 899460, 932160, 965460, 999360, 1033860, 1068960, 1104660, 1140960, 1177860];
        public static const CHARM_LEVEL_ALL_EXP:Array = [0, 10, 60, 180, 390, 710, 1160, 1760, 2530, 3490, 4660, 6070, 7750, 9730, 12040, 14710, 17770, 21250, 25180, 29590, 34510, 39980, 46040, 52730, 60090, 68160, 76980, 86590, 97030, 108340, 120560, 133750, 147970, 163280, 179740, 197410, 216350, 236620, 258280, 281390, 306500, 334160, 364920, 399330, 437940, 481300, 529960, 584470, 645380, 713240, 788600, 872060, 964220, 1065680, 1177040, 1298900, 1431860, 1576520, 1733480, 1903340, 2086700, 2284160, 2496320, 2723780, 2967140, 3227000, 3503960, 3798620, 4111580, 4443440, 4794800, 5166260, 5558420, 5971880, 6407240, 6865100, 7346060, 7850720, 8379680, 8933540, 9512900, 10118360, 10750520, 11409980, 12097340, 12813200, 13558160, 14332820, 15137780, 15973640, 16841000, 17740460, 18672620, 19638080, 20637440, 21671300, 22740260, 23844920, 24985880, 26163740];
        public static const MAX_CHARM_LEVEL:int = 100;

        private var _lastLuckNum:int;
        private var _luckyNum:int;
        private var _lastLuckyNumDate:Date;
        private var _attachtype:int = -1;
        private var _attachvalue:int;
        private var _hide:int;
        private var _hidehat:Boolean;
        private var _hideGlass:Boolean = false;
        private var _suitesHide:Boolean = false;
        private var _showSuits:Boolean = true;
        private var _wingHide:Boolean = false;
        private var _nimbus:int;
        private var _sinple:int;
        private var _modifyStyle:String;
        private var _style:String;
        private var _tutorialProgress:int;
        private var _colors:String = "|,|,,,,||,,,,";
        private var _intuitionalColor:String;
        private var _skin:String;
        private var _paopaoType:int = 0;
        public var SuperAttack:int;
        public var Delay:int;
        private var _attack:int;
        private var _crit:int;
        private var _Stormdamage:int;
        private var _Uprisinginjury:int;
        private var _Uprisingstrike:int;
        private var _answerSite:int;
        private var _defence:int;
        private var _luck:int;
        private var _hp:int;
        public var increaHP:int;
        private var _agility:int;
        private var _Damage:int;
        private var _Guard:int;
        private var _Energy:int;
        private var _dungeonFlag:Object;
        private var _propertyAddition:DictionaryData;
        private var _bag:BagInfo;
        public var _beadBag:BagInfo;
        private var _deputyWeaponID:int = 0;
        private var _webSpeed:int;
        private var _weaponID:int;
        protected var _buffInfo:DictionaryData = new DictionaryData();
        private var _pvePermission:String;
        public var _isDupSimpleTip:Boolean = false;
        private var _fightLibMission:String;
        private var _masterOrApprentices:DictionaryData;
        private var _masterID:int;
        private var _graduatesCount:int;
        private var _honourOfMaster:String = "";
        public var _freezesDate:Date;
        private var _cardEquipDic:DictionaryData;
        private var _cardBagDic:DictionaryData;
        public var OptionOnOff:int;
        private var _shopFinallyGottenTime:Date;
        private var _lastDate:Date;
        private var _isSameCity:Boolean;
        public var _IsShowConsortia:Boolean;
        private var _badLuckNumber:int;
        protected var _isSelf:Boolean = false;
        protected var _pets:DictionaryData;
        private var _currentPet:PetInfo;
        private var _damageScores:int = 0;
        private var _totemScores:int = 0;
        private var _suidLevel:int;
        private var _runeLevel:int;
        private var _EquipNum:int;
        private var _texpItemLevel:int;
        private var _texpNum:int;
        public var beadGetStatus:int = 1;
        public var onLevelUp:Boolean;
        private var _beadScore:int;
        private var _fatigue:int;
        private var _fatigueupDateTimer:Date;
        private var _needFatigue:int;
        private var _totemId:int;
        public var isRobot:Boolean;
        public var isBeadUpdate:Boolean;
        private var _militaryRankScores:int;
        private var _militaryRankTotalScores:int;
        private var _fatigueCount:int;
        private var _fightCount:int;
        private var _isLearnSkill:DictionaryData;
        private var _consortionStatus:Boolean = true;
        private var _chracter:RoomCharacter;
        private var _isYellowVip:Boolean;
        private var _isYearVip:Boolean;
        private var _memberDiamondLevel:int;
        private var _Level3366:int;
        private var _returnEnergy:int;


        override public function updateProperties():void
        {
            if ((((((((_changedPropeties[ARM]) || (_changedPropeties[SEX])) || (_changedPropeties[STYLE])) || (_changedPropeties[HIDE])) || (_changedPropeties[SKIN])) || (_changedPropeties[COLORS])) || (_changedPropeties[NIMBUS])))
            {
                this.parseHide();
                this.parseStyle();
                this.parseColos();
                this._showSuits = ((!(this._modifyStyle.split(",")[7].split("|")[0] == "13101")) && (!(this._modifyStyle.split(",")[7].split("|")[0] == "13201")));
                _changedPropeties[PlayerInfo.STYLE] = true;
            };
            super.updateProperties();
        }

        private function parseHide():void
        {
            this._hidehat = (String(this._hide).charAt(8) == "2");
            this._hideGlass = (String(this._hide).charAt(7) == "2");
            this._suitesHide = (String(this._hide).charAt(6) == "2");
            this._wingHide = (String(this._hide).charAt(5) == "2");
        }

        private function parseStyle():void
        {
            var _local_3:String;
            if (this._style == "")
            {
                this._style = ",,,,,,,,,";
            };
            var _local_1:Array = this._style.split(",");
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                _local_3 = this.getTID(_local_1[_local_2]);
                if ((((((_local_3 == "") || (_local_3 == "0")) || (_local_3 == "-1")) && (!((_local_2 + 1) == EquipType.ARM))) && (_local_2 < 7)))
                {
                    if (_local_2 == 0)
                    {
                        _local_1[_local_2] = this.replaceTID(_local_1[_local_2], (("5" + ((Sex) ? "1" : "2")) + "01"));
                    }
                    else
                    {
                        if (_local_2 == 4)
                        {
                            _local_1[_local_2] = this.replaceTID(_local_1[_local_2], (("1" + ((Sex) ? "1" : "2")) + "01"));
                        }
                        else
                        {
                            _local_1[_local_2] = this.replaceTID(_local_1[_local_2], ((String((_local_2 + 1)) + ((Sex) ? "1" : "2")) + "01"));
                        };
                    };
                }
                else
                {
                    if (((((_local_3 == "") || (_local_3 == "0")) || (_local_3 == "-1")) && ((_local_2 + 1) == EquipType.ARM)))
                    {
                        _local_1[_local_2] = this.replaceTID(_local_1[_local_2], "400105", false);
                    };
                };
                if (((((_local_3 == "") || (_local_3 == "0")) || (_local_3 == "-1")) && (_local_2 == 7)))
                {
                    _local_1[_local_2] = this.replaceTID(_local_1[_local_2], (("13" + ((Sex) ? "1" : "2")) + "01"));
                };
                if (((((_local_3 == "") || (_local_3 == "0")) || (_local_3 == "-1")) && (_local_2 == 8)))
                {
                    _local_1[_local_2] = this.replaceTID(_local_1[_local_2], "15001");
                };
                if (((((_local_3 == "") || (_local_3 == "0")) || (_local_3 == "-1")) && (_local_2 == 9)))
                {
                    _local_1[_local_2] = this.replaceTID(_local_1[_local_2], "16000");
                };
                _local_2++;
            };
            if ((((this._hidehat) || (this._hideGlass)) || (this._suitesHide)))
            {
                if (this._hidehat)
                {
                    _local_1[4] = this.replaceTID(_local_1[4], (("1" + ((Sex) ? "1" : "2")) + "01"));
                };
                if (this._hideGlass)
                {
                    _local_1[1] = this.replaceTID(_local_1[1], (("2" + ((Sex) ? "1" : "2")) + "01"));
                };
                if (this._suitesHide)
                {
                    _local_1[7] = this.replaceTID(_local_1[7], (("13" + ((Sex) ? "1" : "2")) + "01"));
                };
            };
            this._modifyStyle = _local_1.join(",");
        }

        public function get lastLuckNum():int
        {
            return (this._lastLuckNum);
        }

        public function set lastLuckNum(_arg_1:int):void
        {
            if (this._lastLuckNum == _arg_1)
            {
                return;
            };
            this._lastLuckNum = _arg_1;
            onPropertiesChanged(PlayerPropertyType.LastLuckyNum);
        }

        public function get luckyNum():int
        {
            return (this._luckyNum);
        }

        public function set luckyNum(_arg_1:int):void
        {
            if (this._luckyNum == _arg_1)
            {
                return;
            };
            this._luckyNum = _arg_1;
        }

        public function get lastLuckyNumDate():Date
        {
            return (this._lastLuckyNumDate);
        }

        public function set lastLuckyNumDate(_arg_1:Date):void
        {
            if (this._lastLuckyNumDate == _arg_1)
            {
                return;
            };
            this._lastLuckyNumDate = _arg_1;
        }

        public function get attachtype():int
        {
            return (this._attachtype);
        }

        public function get attachvalue():int
        {
            return (this._attachvalue);
        }

        private function parseColos():void
        {
            var _local_1:Array = this._colors.split(",");
            var _local_2:Array = _local_1[EquipType.CategeryIdToCharacterload(EquipType.FACE)[0]].split("|");
            _local_1[EquipType.CategeryIdToCharacterload(EquipType.FACE)[0]] = ((((_local_2[0] + "|") + this._skin) + "|") + ((_local_2[2] == undefined) ? "" : _local_2[2]));
            _local_2 = _local_1[EquipType.CategeryIdToCharacterload(EquipType.CLOTH)[0]].split("|");
            _local_1[EquipType.CategeryIdToCharacterload(EquipType.CLOTH)[0]] = ((((_local_2[0] + "|") + this._skin) + "|") + ((_local_2[2] == undefined) ? "" : _local_2[2]));
            this._colors = _local_1.join(",");
        }

        public function get Hide():int
        {
            return (this._hide);
        }

        public function set Hide(_arg_1:int):void
        {
            if (this._hide == _arg_1)
            {
                return;
            };
            this._hide = _arg_1;
            onPropertiesChanged("Hide");
        }

        public function getHatHide():Boolean
        {
            return (this._hidehat);
        }

        public function setHatHide(_arg_1:Boolean):void
        {
            this.Hide = int(((String(this._hide).slice(0, 8) + ((_arg_1) ? "2" : "1")) + String(this._hide).slice(9)));
        }

        public function getGlassHide():Boolean
        {
            return (this._hideGlass);
        }

        public function setGlassHide(_arg_1:Boolean):void
        {
            this.Hide = int(((String(this._hide).slice(0, 7) + ((_arg_1) ? "2" : "1")) + String(this._hide).slice(8, 9)));
        }

        public function getSuitesHide():Boolean
        {
            return (this._suitesHide);
        }

        public function setSuiteHide(_arg_1:Boolean):void
        {
            this.Hide = int(((String(this._hide).slice(0, 6) + ((_arg_1) ? "2" : "1")) + String(this._hide).slice(7, 9)));
        }

        public function getShowSuits():Boolean
        {
            return (this._showSuits);
        }

        public function get wingHide():Boolean
        {
            return (this._wingHide);
        }

        public function set wingHide(_arg_1:Boolean):void
        {
            this.Hide = int(((String(this._hide).slice(0, 5) + ((_arg_1) ? "2" : "1")) + String(this._hide).slice(6, 9)));
        }

        public function set Nimbus(_arg_1:int):void
        {
            if (this.Nimbus == _arg_1)
            {
                return;
            };
            this._nimbus = _arg_1;
            onPropertiesChanged("Nimbus");
        }

        public function get Nimbus():int
        {
            return (this._nimbus);
        }

        public function set Sinple(_arg_1:int):void
        {
            if (this._sinple == _arg_1)
            {
                return;
            };
            this._sinple = _arg_1;
        }

        public function get Sinple():int
        {
            return (this._sinple);
        }

        public function getHaveLight():Boolean
        {
            var _local_1:int = TotemManager.instance.getTotemPointLevel(this.totemId);
            var _local_2:int = TotemManager.instance.getCurrentLv(_local_1);
            if (_local_2 < 10)
            {
                return (false);
            };
            if (((_local_2 >= 10) && (_local_2 < 20)))
            {
                this.Sinple = 100;
            }
            else
            {
                if (((_local_2 >= 20) && (_local_2 < 30)))
                {
                    this.Sinple = 200;
                }
                else
                {
                    if (((_local_2 >= 30) && (_local_2 < 40)))
                    {
                        this.Sinple = 300;
                    }
                    else
                    {
                        if (((_local_2 >= 40) && (_local_2 < 50)))
                        {
                            this.Sinple = 400;
                        }
                        else
                        {
                            if (((_local_2 >= 50) && (_local_2 < 60)))
                            {
                                this.Sinple = 500;
                            };
                        };
                    };
                };
            };
            return (true);
        }

        public function getHaveCircle():Boolean
        {
            var _local_3:InventoryItemInfo;
            var _local_7:int;
            var _local_1:Array = new Array();
            var _local_2:Array = new Array();
            var _local_4:int = int.MAX_VALUE;
            var _local_5:int = 10;
            while (_local_5 < 16)
            {
                _local_3 = this.Bag.getItemAt(_local_5);
                if (_local_3 != null)
                {
                    _local_1.push(_local_3);
                };
                _local_5++;
            };
            var _local_6:int;
            while (_local_6 < _local_1.length)
            {
                _local_2.push(_local_1[_local_6].StrengthenLevel);
                _local_6++;
            };
            for each (_local_7 in _local_2)
            {
                _local_4 = ((_local_7 > _local_4) ? _local_4 : _local_7);
            };
            if (6 > _local_1.length)
            {
                this.Nimbus = 0;
                return (false);
            };
            if (((_local_4 >= 30) && (_local_4 < 40)))
            {
                this.Nimbus = 200;
            }
            else
            {
                if (((_local_4 >= 40) && (_local_4 < 50)))
                {
                    this.Nimbus = 300;
                }
                else
                {
                    if (_local_4 >= 50)
                    {
                        this.Nimbus = 500;
                    }
                    else
                    {
                        this.Nimbus = 0;
                        return (false);
                    };
                };
            };
            return (true);
        }

        public function get Style():String
        {
            if (this._style == null)
            {
                return (null);
            };
            return (this._modifyStyle);
        }

        public function set Style(_arg_1:String):void
        {
            var _local_3:int;
            var _local_4:int;
            if (this._style == _arg_1)
            {
                return;
            };
            if (_arg_1 == null)
            {
                return;
            };
            var _local_2:Array = _arg_1.split(",");
            if (_local_2.length < 10)
            {
                _local_3 = (10 - _local_2.length);
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    _local_2.push("|");
                    _local_4++;
                };
                _arg_1 = _local_2.join(",");
            };
            this._style = _arg_1;
            onPropertiesChanged("Style");
        }

        public function getHairType():int
        {
            return (int(ItemManager.Instance.getTemplateById(this._modifyStyle.split(",")[EquipType.CategeryIdToCharacterload(EquipType.HEAD)[0]].split("|")[0]).Property1));
        }

        public function getSuitsType():int
        {
            var _local_1:int = int(ItemManager.Instance.getTemplateById(this._modifyStyle.split(",")[7].split("|")[0]).Property1);
            if (_local_1)
            {
                return (_local_1);
            };
            return (2);
        }

        public function getPrivateStyle():String
        {
            return (this._style);
        }

        public function get TutorialProgress():int
        {
            return (this._tutorialProgress);
        }

        public function set TutorialProgress(_arg_1:int):void
        {
            if (this._tutorialProgress == _arg_1)
            {
                return;
            };
            this._tutorialProgress = _arg_1;
            onPropertiesChanged("TutorialProgress");
        }

        public function setPartStyle(_arg_1:ItemTemplateInfo, _arg_2:int, _arg_3:int=-1, _arg_4:String="", _arg_5:Boolean=true):void
        {
            if (this.Style == null)
            {
                return;
            };
            var _local_6:Array = this._style.split(",");
            if (EquipType.isWeapon(_arg_1.TemplateID))
            {
                _local_6[EquipType.CategeryIdToCharacterload(_arg_1.CategoryID)[0]] = this.replaceTID(_local_6[EquipType.CategeryIdToCharacterload(_arg_1.CategoryID)[0]], (((_arg_3 == -1) || (_arg_3 == 0)) ? ("700" + String(((PlayerManager.Instance.Self.Sex) ? "1" : "2"))) : String(_arg_3)), false);
            }
            else
            {
                if (_arg_1.CategoryID == EquipType.SUITS)
                {
                    _local_6[7] = this.replaceTID(_local_6[7], (((_arg_3 == -1) || (_arg_3 == 0)) ? (String(_arg_1.CategoryID) + "101") : String(_arg_3)));
                }
                else
                {
                    if (_arg_1.CategoryID == EquipType.WING)
                    {
                        _local_6[8] = this.replaceTID(_local_6[8], (((_arg_3 == -1) || (_arg_3 == 0)) ? "15001" : String(_arg_3)));
                    }
                    else
                    {
                        _local_6[EquipType.CategeryIdToCharacterload(_arg_1.CategoryID)[0]] = this.replaceTID(_local_6[EquipType.CategeryIdToCharacterload(_arg_1.CategoryID)[0]], (((_arg_3 == -1) || (_arg_3 == 0)) ? ((String(_arg_1.CategoryID) + String(((_arg_2 == 0) ? "1" : _arg_2))) + "01") : String(_arg_3)));
                    };
                };
            };
            this._style = _local_6.join(",");
            onPropertiesChanged("Style");
            this.setPartColor(_arg_1.CategoryID, _arg_4);
        }

        private function jionPic(_arg_1:String, _arg_2:String):String
        {
            return ((_arg_1 + "|") + _arg_2);
        }

        private function getTID(_arg_1:String):String
        {
            return (_arg_1.split("|")[0]);
        }

        private function replaceTID(_arg_1:String, _arg_2:String, _arg_3:Boolean=true):String
        {
            return ((_arg_2 + "|") + ((_arg_3) ? ItemManager.Instance.getTemplateById(int(_arg_2)).Pic : _arg_1.split("|")[1]));
        }

        public function getPartStyle(_arg_1:int):int
        {
            return (int(this.Style.split(",")[(_arg_1 - 1)].split("|")[0]));
        }

        public function get Colors():String
        {
            return (this._colors);
        }

        public function set Colors(_arg_1:String):void
        {
            if (this._intuitionalColor == _arg_1)
            {
                return;
            };
            this._intuitionalColor = _arg_1;
            if (this.colorEqual(this._colors, _arg_1))
            {
                return;
            };
            this._colors = _arg_1;
            onPropertiesChanged("Colors");
        }

        private function colorEqual(_arg_1:String, _arg_2:String):Boolean
        {
            if (_arg_1 == _arg_2)
            {
                return (true);
            };
            if (((_arg_1 == null) || (_arg_2 == null)))
            {
                return (false);
            };
            var _local_3:Array = _arg_1.split(",");
            var _local_4:Array = _arg_2.split(",");
            var _local_5:int;
            while (_local_5 < _local_4.length)
            {
                if (_local_5 == 4)
                {
                    if (_local_3[_local_5].split("|").length > 2)
                    {
                        _local_3[_local_5] = ((_local_3[_local_5].split("|")[0] + "||") + _local_3[_local_5].split("|")[2]);
                    };
                };
                if (_local_3[_local_5] != _local_4[_local_5])
                {
                    if (!((((_local_3[_local_5] == "|") || (_local_3[_local_5] == "||")) || (_local_3[_local_5] == "")) && (((_local_4[_local_5] == "|") || (_local_4[_local_5] == "||")) || (_local_4[_local_5] == ""))))
                    {
                        return (false);
                    };
                };
                _local_5++;
            };
            return (true);
        }

        public function setPartColor(_arg_1:int, _arg_2:String):void
        {
            var _local_3:Array = this._colors.split(",");
            if (_arg_1 != EquipType.SUITS)
            {
                _local_3[EquipType.CategeryIdToCharacterload(_arg_1)[0]] = _arg_2;
            };
            this.Colors = _local_3.join(",");
            onPropertiesChanged(PlayerInfo.COLORS);
        }

        public function getPartColor(_arg_1:int):String
        {
            var _local_2:Array = this.Colors.split(",");
            return (_local_2[(_arg_1 - 1)]);
        }

        public function setSkinColor(_arg_1:String):void
        {
            this.Skin = _arg_1;
        }

        public function set Skin(_arg_1:String):void
        {
            if (this._skin == _arg_1)
            {
                return;
            };
            this._skin = _arg_1;
            onPropertiesChanged("Colors");
        }

        public function get Skin():String
        {
            return (this.getSkinColor());
        }

        public function getSkinColor():String
        {
            var _local_1:Array = this.Colors.split(",");
            if (_local_1[EquipType.CategeryIdToCharacterload(EquipType.FACE)[0]] == undefined)
            {
                return ("");
            };
            var _local_2:String = _local_1[EquipType.CategeryIdToCharacterload(EquipType.FACE)[0]].split("|")[1];
            return ((_local_2 == null) ? "" : _local_2);
        }

        public function clearColors():void
        {
            this.Colors = ",,,,,,,,";
        }

        public function updateStyle(_arg_1:Boolean, _arg_2:int, _arg_3:String, _arg_4:String, _arg_5:String):void
        {
            beginChanges();
            Sex = _arg_1;
            this.Hide = _arg_2;
            this.Style = _arg_3;
            this.Colors = _arg_4;
            this.Skin = _arg_5;
            commitChanges();
        }

        public function get paopaoType():int
        {
            var _local_1:String = this._style.split(",")[9].split("|")[0];
            _local_1.slice(4);
            if (((((_local_1 == null) || (_local_1 == "")) || (_local_1 == "0")) || (_local_1 == "-1")))
            {
                return (0);
            };
            return (int(_local_1.slice(3)));
        }

        public function get Attack():int
        {
            return (this._attack);
        }

        public function set Attack(_arg_1:int):void
        {
            if (this._attack == _arg_1)
            {
                return;
            };
            this._attack = _arg_1;
            onPropertiesChanged("Attack");
        }

        public function get Crit():int
        {
            return (this._crit);
        }

        public function set Crit(_arg_1:int):void
        {
            if (this._crit == _arg_1)
            {
                return;
            };
            this._crit = _arg_1;
            onPropertiesChanged("Crit");
        }

        public function get Stormdamage():int
        {
            return (this._Stormdamage);
        }

        public function set Stormdamage(_arg_1:int):void
        {
            if (this._Stormdamage == _arg_1)
            {
                return;
            };
            this._Stormdamage = _arg_1;
            onPropertiesChanged("Stormdamage");
        }

        public function get Uprisinginjury():int
        {
            return (this._Uprisinginjury);
        }

        public function set Uprisinginjury(_arg_1:int):void
        {
            if (this._Uprisinginjury == _arg_1)
            {
                return;
            };
            this._Uprisinginjury = _arg_1;
            onPropertiesChanged("Uprisinginjury");
        }

        public function get Uprisingstrike():int
        {
            return (this._Uprisingstrike);
        }

        public function set Uprisingstrike(_arg_1:int):void
        {
            if (this._Uprisingstrike == _arg_1)
            {
                return;
            };
            this._Uprisingstrike = _arg_1;
            onPropertiesChanged("Uprisingstrike");
        }

        public function set userGuildProgress(_arg_1:int):void
        {
            this._answerSite = _arg_1;
            this.TutorialProgress = _arg_1;
        }

        public function get userGuildProgress():int
        {
            return (this._answerSite);
        }

        public function get Defence():int
        {
            return (this._defence);
        }

        public function set Defence(_arg_1:int):void
        {
            if (this._defence == _arg_1)
            {
                return;
            };
            this._defence = _arg_1;
            onPropertiesChanged("Defence");
        }

        public function get Luck():int
        {
            return (this._luck);
        }

        public function set Luck(_arg_1:int):void
        {
            if (this._luck == _arg_1)
            {
                return;
            };
            this._luck = _arg_1;
            onPropertiesChanged("Luck");
        }

        public function get hp():int
        {
            return (this._hp);
        }

        public function set hp(_arg_1:int):void
        {
            if (this._hp != _arg_1)
            {
                this.increaHP = (_arg_1 - this._hp);
            };
            this._hp = _arg_1;
        }

        public function get Agility():int
        {
            return (this._agility);
        }

        public function set Agility(_arg_1:int):void
        {
            if (this._agility == _arg_1)
            {
                return;
            };
            this._agility = _arg_1;
            onPropertiesChanged("Agility");
        }

        public function get Damage():int
        {
            return (this._Damage);
        }

        public function set Damage(_arg_1:int):void
        {
            if (this._Damage == _arg_1)
            {
                return;
            };
            this._Damage = _arg_1;
            onPropertiesChanged("Damage");
        }

        public function get Guard():int
        {
            return (this._Guard);
        }

        public function set Guard(_arg_1:int):void
        {
            if (this._Guard == _arg_1)
            {
                return;
            };
            this._Guard = _arg_1;
            onPropertiesChanged("Guard");
        }

        public function get Energy():int
        {
            return (this._Energy);
        }

        public function set Energy(_arg_1:int):void
        {
            if (this._Energy == _arg_1)
            {
                return;
            };
            this._Energy = _arg_1;
            onPropertiesChanged("Energy");
        }

        public function setAttackDefenseValues(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            this.Attack = _arg_1;
            this.Defence = _arg_2;
            this.Agility = _arg_3;
            this.Luck = _arg_4;
            onPropertiesChanged("setAttackDefenseValues");
        }

        public function get dungeonFlag():Object
        {
            if (this._dungeonFlag == null)
            {
                this._dungeonFlag = new Object();
            };
            return (this._dungeonFlag);
        }

        public function set dungeonFlag(_arg_1:Object):void
        {
            if (this._dungeonFlag == _arg_1)
            {
                return;
            };
            this._dungeonFlag = _arg_1;
        }

        public function get propertyAddition():DictionaryData
        {
            if ((!(this._propertyAddition)))
            {
                this._propertyAddition = new DictionaryData();
            };
            return (this._propertyAddition);
        }

        public function set propertyAddition(_arg_1:DictionaryData):void
        {
            this._propertyAddition = _arg_1;
        }

        public function getPropertyAdditionByType(_arg_1:String):DictionaryData
        {
            return (this._propertyAddition[_arg_1]);
        }

        public function get Bag():BagInfo
        {
            if (this._bag == null)
            {
                this._bag = new BagInfo(BagInfo.EQUIPBAG, 56);
            };
            return (this._bag);
        }

        public function get BeadBag():BagInfo
        {
            if (this._beadBag == null)
            {
                this._beadBag = new BagInfo(BagInfo.BEADBAG, 40);
            };
            return (this._beadBag);
        }

        public function get DeputyWeapon():InventoryItemInfo
        {
            return (PlayerManager.Instance.Self.Bag.getItemAt(20));
        }

        public function set DeputyWeaponID(_arg_1:int):void
        {
            if (this._deputyWeaponID == _arg_1)
            {
                return;
            };
            this._deputyWeaponID = _arg_1;
            onPropertiesChanged("DeputyWeaponID");
        }

        public function get DeputyWeaponID():int
        {
            return (this._deputyWeaponID);
        }

        public function get webSpeed():int
        {
            return (this._webSpeed);
        }

        public function set webSpeed(_arg_1:int):void
        {
            this._webSpeed = _arg_1;
            dispatchEvent(new WebSpeedEvent(WebSpeedEvent.STATE_CHANE));
        }

        public function get WeaponID():int
        {
            return (this._weaponID);
        }

        public function set WeaponID(_arg_1:int):void
        {
            if (this._weaponID == _arg_1)
            {
                return;
            };
            this._weaponID = _arg_1;
            onPropertiesChanged("WeaponID");
        }

        public function set paopaoType(_arg_1:int):void
        {
            if (((this._paopaoType) && (this._paopaoType == _arg_1)))
            {
                return;
            };
            this._paopaoType = _arg_1;
            onPropertiesChanged("paopaoType");
        }

        public function get buffInfo():DictionaryData
        {
            return (this._buffInfo);
        }

        protected function set buffInfo(_arg_1:DictionaryData):void
        {
            if (this._buffInfo == _arg_1)
            {
                return;
            };
            this._buffInfo = _arg_1;
            onPropertiesChanged("buffInfo");
        }

        public function addBuff(_arg_1:BuffInfo):void
        {
            this._buffInfo.add(_arg_1.Type, _arg_1);
        }

        public function clearBuff():void
        {
            this._buffInfo.clear();
        }

        public function hasBuff(_arg_1:int):Boolean
        {
            if (_arg_1 == BuffInfo.FREE)
            {
                return (true);
            };
            var _local_2:BuffInfo = this.getBuff(_arg_1);
            return ((!(_local_2 == null)) && (_local_2.IsExist));
        }

        public function getBuff(_arg_1:int):BuffInfo
        {
            return (this._buffInfo[_arg_1]);
        }

        public function get PvePermission():String
        {
            return (this._pvePermission);
        }

        public function set PvePermission(_arg_1:String):void
        {
            if (this._pvePermission == _arg_1)
            {
                return;
            };
            if (_arg_1 == "")
            {
                this._pvePermission = "11111111111111111111111111111111111111111111111111";
            }
            else
            {
                if (this._pvePermission != null)
                {
                    if (((this._pvePermission.substr(0, 1) == "1") && (_arg_1.substr(0, 1) == "3")))
                    {
                        this._isDupSimpleTip = true;
                    };
                };
                this._pvePermission = _arg_1;
            };
            onPropertiesChanged("PvePermission");
        }

        public function get fightLibMission():String
        {
            return (((this._fightLibMission == null) || (this._fightLibMission == "")) ? "0000000000" : this._fightLibMission);
        }

        public function set fightLibMission(_arg_1:String):void
        {
            this._fightLibMission = _arg_1;
            onPropertiesChanged("fightLibMission");
        }

        public function setMasterOrApprentices(_arg_1:String):void
        {
            var _local_2:Array;
            var _local_3:int;
            var _local_4:Array;
            if ((!(this._masterOrApprentices)))
            {
                this._masterOrApprentices = new DictionaryData();
            };
            this._masterOrApprentices.clear();
            if (_arg_1 != "")
            {
                _local_2 = _arg_1.split(",");
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    _local_4 = _local_2[_local_3].split("|");
                    this._masterOrApprentices.add(int(_local_4[0]), _local_4[1]);
                    _local_3++;
                };
            };
            onPropertiesChanged("masterOrApprentices");
        }

        public function getMasterOrApprentices():DictionaryData
        {
            if ((!(this._masterOrApprentices)))
            {
                this._masterOrApprentices = new DictionaryData();
            };
            return (this._masterOrApprentices);
        }

        public function set masterID(_arg_1:int):void
        {
            this._masterID = _arg_1;
        }

        public function get masterID():int
        {
            return (this._masterID);
        }

        public function isMyMaster(_arg_1:int):Boolean
        {
            return (_arg_1 == this._masterID);
        }

        public function isMyApprent(_arg_1:int):Boolean
        {
            return (this._masterOrApprentices[_arg_1]);
        }

        public function set graduatesCount(_arg_1:int):void
        {
            this._graduatesCount = _arg_1;
        }

        public function get graduatesCount():int
        {
            return (this._graduatesCount);
        }

        public function set honourOfMaster(_arg_1:String):void
        {
            this._honourOfMaster = _arg_1;
        }

        public function get honourOfMaster():String
        {
            return (this._honourOfMaster);
        }

        public function set freezesDate(_arg_1:Date):void
        {
            this._freezesDate = _arg_1;
        }

        public function get freezesDate():Date
        {
            return (this._freezesDate);
        }

        public function get cardEquipDic():DictionaryData
        {
            if (this._cardEquipDic == null)
            {
                this._cardEquipDic = new DictionaryData();
            };
            return (this._cardEquipDic);
        }

        public function set cardEquipDic(_arg_1:DictionaryData):void
        {
            if (this._cardEquipDic == _arg_1)
            {
                return;
            };
            this._cardEquipDic = _arg_1;
            onPropertiesChanged("cardEquipDic");
        }

        public function get cardBagDic():DictionaryData
        {
            if (this._cardBagDic == null)
            {
                this._cardBagDic = new DictionaryData();
            };
            return (this._cardBagDic);
        }

        public function set cardBagDic(_arg_1:DictionaryData):void
        {
            if (this._cardBagDic == _arg_1)
            {
                return;
            };
            this._cardBagDic = _arg_1;
            onPropertiesChanged("cardBagDic");
        }

        public function getOptionState(_arg_1:int):Boolean
        {
            var _local_2:int = (this.OptionOnOff & _arg_1);
            return (_local_2 == _arg_1);
        }

        public function get shopFinallyGottenTime():Date
        {
            return (this._shopFinallyGottenTime);
        }

        public function set shopFinallyGottenTime(_arg_1:Date):void
        {
            if (this._shopFinallyGottenTime == _arg_1)
            {
                return;
            };
            this._shopFinallyGottenTime = _arg_1;
            dispatchEvent(new Event(UPDATE_SHOP_FINALLY_TIME));
        }

        public function getLastDate():int
        {
            var _local_1:int;
            var _local_2:Date = TimeManager.Instance.Now();
            var _local_3:int = int(((_local_2.valueOf() - this._lastDate.valueOf()) / 3600000));
            return ((_local_3 < 1) ? 1 : _local_3);
        }

        public function set lastDate(_arg_1:Date):void
        {
            this._lastDate = _arg_1;
        }

        public function get lastDate():Date
        {
            return (this._lastDate);
        }

        public function get isSameCity():Boolean
        {
            return (this._isSameCity);
        }

        public function set isSameCity(_arg_1:Boolean):void
        {
            this._isSameCity = _arg_1;
        }

        public function set IsShowConsortia(_arg_1:Boolean):void
        {
            this._IsShowConsortia = _arg_1;
        }

        public function get IsShowConsortia():Boolean
        {
            return (this._IsShowConsortia);
        }

        public function get showDesignation():String
        {
            var _local_1:String = ((this.IsShowConsortia) ? ConsortiaName : honor);
            if ((!(_local_1)))
            {
                _local_1 = ConsortiaName;
            };
            if ((!(_local_1)))
            {
                _local_1 = honor;
            };
            return (_local_1);
        }

        public function get badLuckNumber():int
        {
            return (this._badLuckNumber);
        }

        public function set badLuckNumber(_arg_1:int):void
        {
            if (this._badLuckNumber != _arg_1)
            {
                this._badLuckNumber = _arg_1;
                onPropertiesChanged("BadLuckNumber");
            };
        }

        public function get isSelf():Boolean
        {
            return (this._isSelf);
        }

        public function get pets():DictionaryData
        {
            if (this._pets == null)
            {
                this._pets = new DictionaryData();
            };
            return (this._pets);
        }

        public function addPets(_arg_1:PetInfo):void
        {
            this.pets.add(_arg_1.Place, _arg_1);
            onPropertiesChanged("Pets");
        }

        public function get currentPet():PetInfo
        {
            return (this._currentPet);
        }

        public function set currentPet(_arg_1:PetInfo):void
        {
            this._currentPet = _arg_1;
        }

        public function set damageScores(_arg_1:int):void
        {
            this._damageScores = _arg_1;
        }

        public function get damageScores():int
        {
            return (this._damageScores);
        }

        public function get totemScores():int
        {
            return (this._totemScores);
        }

        public function set totemScores(_arg_1:int):void
        {
            if (this._totemScores == _arg_1)
            {
                return;
            };
            this._totemScores = _arg_1;
            onPropertiesChanged("totemScores");
        }

        public function get SuidLevel():int
        {
            return (this._suidLevel);
        }

        public function set SuidLevel(_arg_1:int):void
        {
            this._suidLevel = _arg_1;
        }

        public function get runeLevel():int
        {
            return (this._runeLevel);
        }

        public function set runeLevel(_arg_1:int):void
        {
            this._runeLevel = _arg_1;
        }

        public function get EquipNum():int
        {
            return (this._EquipNum);
        }

        public function set EquipNum(_arg_1:int):void
        {
            this._EquipNum = _arg_1;
        }

        public function get TexpItemLevel():int
        {
            return (this._texpItemLevel);
        }

        public function set TexpItemLevel(_arg_1:int):void
        {
            this._texpItemLevel = _arg_1;
        }

        public function get TexpNum():int
        {
            return (this._texpNum);
        }

        public function set TexpNum(_arg_1:int):void
        {
            this._texpNum = _arg_1;
        }

        public function get beadScore():int
        {
            return (this._beadScore);
        }

        public function set beadScore(_arg_1:int):void
        {
            if (this._beadScore == _arg_1)
            {
                return;
            };
            this._beadScore = _arg_1;
            onPropertiesChanged(PlayerInfo.BEAD_SCORE);
        }

        public function get Fatigue():int
        {
            var _local_1:int;
            var _local_2:int;
            if (PlayerManager.Instance.Self.ID == ID)
            {
                if ((!(this.FatigueupDateTimer)))
                {
                    return (0);
                };
                _local_1 = int(((TimeManager.Instance.Now().time - this.FatigueupDateTimer.getTime()) / 1000));
                _local_2 = this._fatigue;
                if (_local_2 > 100)
                {
                    return (_local_2);
                };
                if (_local_1 < 0)
                {
                    return (_local_2);
                };
                _local_2 = int((_local_2 + (_local_1 / 600)));
                return ((_local_2 > 100) ? 100 : _local_2);
            };
            return (this._fatigue);
        }

        public function set Fatigue(_arg_1:int):void
        {
            if (this._fatigue == _arg_1)
            {
                return;
            };
            this._fatigue = _arg_1;
            onPropertiesChanged("Fatigue");
        }

        public function get FatigueupDateTimer():Date
        {
            return (this._fatigueupDateTimer);
        }

        public function set FatigueupDateTimer(_arg_1:Date):void
        {
            this._fatigueupDateTimer = _arg_1;
        }

        public function set NeedFatigue(_arg_1:int):void
        {
            this._needFatigue = _arg_1;
        }

        public function get NeedFatigue():int
        {
            return (this._needFatigue);
        }

        public function get totemId():int
        {
            return (this._totemId);
        }

        public function set totemId(_arg_1:int):void
        {
            if (this._totemId == _arg_1)
            {
                return;
            };
            this._totemId = _arg_1;
            onPropertiesChanged("totemId");
        }

        public function get MilitaryRankScores():int
        {
            return (this._militaryRankScores);
        }

        public function set MilitaryRankScores(_arg_1:int):void
        {
            this._militaryRankScores = _arg_1;
        }

        public function get MilitaryRankTotalScores():int
        {
            return (this._militaryRankTotalScores);
        }

        public function set MilitaryRankTotalScores(_arg_1:int):void
        {
            this._militaryRankTotalScores = _arg_1;
        }

        public function get fatigueCount():int
        {
            return (this._fatigueCount);
        }

        public function set fatigueCount(_arg_1:int):void
        {
            this._fatigueCount = _arg_1;
        }

        public function get FightCount():int
        {
            return (this._fightCount);
        }

        public function set FightCount(_arg_1:int):void
        {
            if (this._fightCount == _arg_1)
            {
                return;
            };
            this._fightCount = _arg_1;
            onPropertiesChanged("FightCount");
        }

        public function get isLearnSkill():DictionaryData
        {
            if (this._isLearnSkill == null)
            {
                this._isLearnSkill = new DictionaryData();
            };
            return (this._isLearnSkill);
        }

        public function set consortionStatus(_arg_1:Boolean):void
        {
            this._consortionStatus = _arg_1;
        }

        public function get consortionStatus():Boolean
        {
            if (PlayerManager.Instance.Self.ConsortiaID == 0)
            {
                return (false);
            };
            return (this._consortionStatus);
        }

        public function get isYellowVip():Boolean
        {
            return (this._isYellowVip);
        }

        public function set isYellowVip(_arg_1:Boolean):void
        {
            this._isYellowVip = _arg_1;
        }

        public function get isYearVip():Boolean
        {
            return (this._isYearVip);
        }

        public function set isYearVip(_arg_1:Boolean):void
        {
            this._isYearVip = _arg_1;
        }

        public function get MemberDiamondLevel():int
        {
            return (this._memberDiamondLevel);
        }

        public function set MemberDiamondLevel(_arg_1:int):void
        {
            this._memberDiamondLevel = _arg_1;
        }

        public function get Level3366():int
        {
            return (this._Level3366);
        }

        public function set Level3366(_arg_1:int):void
        {
            this._Level3366 = _arg_1;
        }

        public function get returnEnergy():int
        {
            return (this._returnEnergy);
        }

        public function set returnEnergy(_arg_1:int):void
        {
            this._returnEnergy = _arg_1;
            dispatchEvent(new WeekendEvent(WeekendEvent.ENERGY_CHANGE));
        }


    }
}//package ddt.data.player

