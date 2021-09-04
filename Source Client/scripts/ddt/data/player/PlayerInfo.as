package ddt.data.player
{
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.WebSpeedEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import ddt.view.character.RoomCharacter;
   import flash.events.Event;
   import pet.date.PetInfo;
   import road7th.data.DictionaryData;
   import totem.TotemManager;
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
      
      public static const CHARM_LEVEL_NEED_EXP:Array = [0,10,50,120,210,320,450,600,770,960,1170,1410,1680,1980,2310,2670,3060,3480,3930,4410,4920,5470,6060,6690,7360,8070,8820,9610,10440,11310,12220,13190,14220,15310,16460,17670,18940,20270,21660,23110,25110,27660,30760,34410,38610,43360,48660,54510,60910,67860,75360,83460,92160,101460,111360,121860,132960,144660,156960,169860,183360,197460,212160,227460,243360,259860,276960,294660,312960,331860,351360,371460,392160,413460,435360,457860,480960,504660,528960,553860,579360,605460,632160,659460,687360,715860,744960,774660,804960,835860,867360,899460,932160,965460,999360,1033860,1068960,1104660,1140960,1177860];
      
      public static const CHARM_LEVEL_ALL_EXP:Array = [0,10,60,180,390,710,1160,1760,2530,3490,4660,6070,7750,9730,12040,14710,17770,21250,25180,29590,34510,39980,46040,52730,60090,68160,76980,86590,97030,108340,120560,133750,147970,163280,179740,197410,216350,236620,258280,281390,306500,334160,364920,399330,437940,481300,529960,584470,645380,713240,788600,872060,964220,1065680,1177040,1298900,1431860,1576520,1733480,1903340,2086700,2284160,2496320,2723780,2967140,3227000,3503960,3798620,4111580,4443440,4794800,5166260,5558420,5971880,6407240,6865100,7346060,7850720,8379680,8933540,9512900,10118360,10750520,11409980,12097340,12813200,13558160,14332820,15137780,15973640,16841000,17740460,18672620,19638080,20637440,21671300,22740260,23844920,24985880,26163740];
      
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
      
      protected var _buffInfo:DictionaryData;
      
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
      
      public function PlayerInfo()
      {
         this._buffInfo = new DictionaryData();
         super();
      }
      
      override public function updateProperties() : void
      {
         if(_changedPropeties[ARM] || _changedPropeties[SEX] || _changedPropeties[STYLE] || _changedPropeties[HIDE] || _changedPropeties[SKIN] || _changedPropeties[COLORS] || _changedPropeties[NIMBUS])
         {
            this.parseHide();
            this.parseStyle();
            this.parseColos();
            this._showSuits = this._modifyStyle.split(",")[7].split("|")[0] != "13101" && this._modifyStyle.split(",")[7].split("|")[0] != "13201";
            _changedPropeties[PlayerInfo.STYLE] = true;
         }
         super.updateProperties();
      }
      
      private function parseHide() : void
      {
         this._hidehat = String(this._hide).charAt(8) == "2";
         this._hideGlass = String(this._hide).charAt(7) == "2";
         this._suitesHide = String(this._hide).charAt(6) == "2";
         this._wingHide = String(this._hide).charAt(5) == "2";
      }
      
      private function parseStyle() : void
      {
         var _loc3_:String = null;
         if(this._style == "")
         {
            this._style = ",,,,,,,,,";
         }
         var _loc1_:Array = this._style.split(",");
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = this.getTID(_loc1_[_loc2_]);
            if((_loc3_ == "" || _loc3_ == "0" || _loc3_ == "-1") && _loc2_ + 1 != EquipType.ARM && _loc2_ < 7)
            {
               if(_loc2_ == 0)
               {
                  _loc1_[_loc2_] = this.replaceTID(_loc1_[_loc2_],"5" + (!!Sex ? "1" : "2") + "01");
               }
               else if(_loc2_ == 4)
               {
                  _loc1_[_loc2_] = this.replaceTID(_loc1_[_loc2_],"1" + (!!Sex ? "1" : "2") + "01");
               }
               else
               {
                  _loc1_[_loc2_] = this.replaceTID(_loc1_[_loc2_],String(_loc2_ + 1) + (!!Sex ? "1" : "2") + "01");
               }
            }
            else if((_loc3_ == "" || _loc3_ == "0" || _loc3_ == "-1") && _loc2_ + 1 == EquipType.ARM)
            {
               _loc1_[_loc2_] = this.replaceTID(_loc1_[_loc2_],"400105",false);
            }
            if((_loc3_ == "" || _loc3_ == "0" || _loc3_ == "-1") && _loc2_ == 7)
            {
               _loc1_[_loc2_] = this.replaceTID(_loc1_[_loc2_],"13" + (!!Sex ? "1" : "2") + "01");
            }
            if((_loc3_ == "" || _loc3_ == "0" || _loc3_ == "-1") && _loc2_ == 8)
            {
               _loc1_[_loc2_] = this.replaceTID(_loc1_[_loc2_],"15001");
            }
            if((_loc3_ == "" || _loc3_ == "0" || _loc3_ == "-1") && _loc2_ == 9)
            {
               _loc1_[_loc2_] = this.replaceTID(_loc1_[_loc2_],"16000");
            }
            _loc2_++;
         }
         if(this._hidehat || this._hideGlass || this._suitesHide)
         {
            if(this._hidehat)
            {
               _loc1_[4] = this.replaceTID(_loc1_[4],"1" + (!!Sex ? "1" : "2") + "01");
            }
            if(this._hideGlass)
            {
               _loc1_[1] = this.replaceTID(_loc1_[1],"2" + (!!Sex ? "1" : "2") + "01");
            }
            if(this._suitesHide)
            {
               _loc1_[7] = this.replaceTID(_loc1_[7],"13" + (!!Sex ? "1" : "2") + "01");
            }
         }
         this._modifyStyle = _loc1_.join(",");
      }
      
      public function get lastLuckNum() : int
      {
         return this._lastLuckNum;
      }
      
      public function set lastLuckNum(param1:int) : void
      {
         if(this._lastLuckNum == param1)
         {
            return;
         }
         this._lastLuckNum = param1;
         onPropertiesChanged(PlayerPropertyType.LastLuckyNum);
      }
      
      public function get luckyNum() : int
      {
         return this._luckyNum;
      }
      
      public function set luckyNum(param1:int) : void
      {
         if(this._luckyNum == param1)
         {
            return;
         }
         this._luckyNum = param1;
      }
      
      public function get lastLuckyNumDate() : Date
      {
         return this._lastLuckyNumDate;
      }
      
      public function set lastLuckyNumDate(param1:Date) : void
      {
         if(this._lastLuckyNumDate == param1)
         {
            return;
         }
         this._lastLuckyNumDate = param1;
      }
      
      public function get attachtype() : int
      {
         return this._attachtype;
      }
      
      public function get attachvalue() : int
      {
         return this._attachvalue;
      }
      
      private function parseColos() : void
      {
         var _loc1_:Array = this._colors.split(",");
         var _loc2_:Array = _loc1_[EquipType.CategeryIdToCharacterload(EquipType.FACE)[0]].split("|");
         _loc1_[EquipType.CategeryIdToCharacterload(EquipType.FACE)[0]] = _loc2_[0] + "|" + this._skin + "|" + (_loc2_[2] == undefined ? "" : _loc2_[2]);
         _loc2_ = _loc1_[EquipType.CategeryIdToCharacterload(EquipType.CLOTH)[0]].split("|");
         _loc1_[EquipType.CategeryIdToCharacterload(EquipType.CLOTH)[0]] = _loc2_[0] + "|" + this._skin + "|" + (_loc2_[2] == undefined ? "" : _loc2_[2]);
         this._colors = _loc1_.join(",");
      }
      
      public function get Hide() : int
      {
         return this._hide;
      }
      
      public function set Hide(param1:int) : void
      {
         if(this._hide == param1)
         {
            return;
         }
         this._hide = param1;
         onPropertiesChanged("Hide");
      }
      
      public function getHatHide() : Boolean
      {
         return this._hidehat;
      }
      
      public function setHatHide(param1:Boolean) : void
      {
         this.Hide = int(String(this._hide).slice(0,8) + (!!param1 ? "2" : "1") + String(this._hide).slice(9));
      }
      
      public function getGlassHide() : Boolean
      {
         return this._hideGlass;
      }
      
      public function setGlassHide(param1:Boolean) : void
      {
         this.Hide = int(String(this._hide).slice(0,7) + (!!param1 ? "2" : "1") + String(this._hide).slice(8,9));
      }
      
      public function getSuitesHide() : Boolean
      {
         return this._suitesHide;
      }
      
      public function setSuiteHide(param1:Boolean) : void
      {
         this.Hide = int(String(this._hide).slice(0,6) + (!!param1 ? "2" : "1") + String(this._hide).slice(7,9));
      }
      
      public function getShowSuits() : Boolean
      {
         return this._showSuits;
      }
      
      public function get wingHide() : Boolean
      {
         return this._wingHide;
      }
      
      public function set wingHide(param1:Boolean) : void
      {
         this.Hide = int(String(this._hide).slice(0,5) + (!!param1 ? "2" : "1") + String(this._hide).slice(6,9));
      }
      
      public function set Nimbus(param1:int) : void
      {
         if(this.Nimbus == param1)
         {
            return;
         }
         this._nimbus = param1;
         onPropertiesChanged("Nimbus");
      }
      
      public function get Nimbus() : int
      {
         return this._nimbus;
      }
      
      public function set Sinple(param1:int) : void
      {
         if(this._sinple == param1)
         {
            return;
         }
         this._sinple = param1;
      }
      
      public function get Sinple() : int
      {
         return this._sinple;
      }
      
      public function getHaveLight() : Boolean
      {
         var _loc1_:int = TotemManager.instance.getTotemPointLevel(this.totemId);
         var _loc2_:int = TotemManager.instance.getCurrentLv(_loc1_);
         if(_loc2_ < 10)
         {
            return false;
         }
         if(_loc2_ >= 10 && _loc2_ < 20)
         {
            this.Sinple = 100;
         }
         else if(_loc2_ >= 20 && _loc2_ < 30)
         {
            this.Sinple = 200;
         }
         else if(_loc2_ >= 30 && _loc2_ < 40)
         {
            this.Sinple = 300;
         }
         else if(_loc2_ >= 40 && _loc2_ < 50)
         {
            this.Sinple = 400;
         }
         else if(_loc2_ >= 50 && _loc2_ < 60)
         {
            this.Sinple = 500;
         }
         return true;
      }
      
      public function getHaveCircle() : Boolean
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc7_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc4_:int = int.MAX_VALUE;
         var _loc5_:int = 10;
         while(_loc5_ < 16)
         {
            _loc3_ = this.Bag.getItemAt(_loc5_);
            if(_loc3_ != null)
            {
               _loc1_.push(_loc3_);
            }
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc1_.length)
         {
            _loc2_.push(_loc1_[_loc6_].StrengthenLevel);
            _loc6_++;
         }
         for each(_loc7_ in _loc2_)
         {
            _loc4_ = _loc7_ > _loc4_ ? int(_loc4_) : int(_loc7_);
         }
         if(6 > _loc1_.length)
         {
            this.Nimbus = 0;
            return false;
         }
         if(_loc4_ >= 30 && _loc4_ < 40)
         {
            this.Nimbus = 200;
         }
         else if(_loc4_ >= 40 && _loc4_ < 50)
         {
            this.Nimbus = 300;
         }
         else
         {
            if(_loc4_ < 50)
            {
               this.Nimbus = 0;
               return false;
            }
            this.Nimbus = 500;
         }
         return true;
      }
      
      public function get Style() : String
      {
         if(this._style == null)
         {
            return null;
         }
         return this._modifyStyle;
      }
      
      public function set Style(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._style == param1)
         {
            return;
         }
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = param1.split(",");
         if(_loc2_.length < 10)
         {
            _loc3_ = 10 - _loc2_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_.push("|");
               _loc4_++;
            }
            param1 = _loc2_.join(",");
         }
         this._style = param1;
         onPropertiesChanged("Style");
      }
      
      public function getHairType() : int
      {
         return int(ItemManager.Instance.getTemplateById(this._modifyStyle.split(",")[EquipType.CategeryIdToCharacterload(EquipType.HEAD)[0]].split("|")[0]).Property1);
      }
      
      public function getSuitsType() : int
      {
         var _loc1_:int = int(ItemManager.Instance.getTemplateById(this._modifyStyle.split(",")[7].split("|")[0]).Property1);
         if(_loc1_)
         {
            return _loc1_;
         }
         return 2;
      }
      
      public function getPrivateStyle() : String
      {
         return this._style;
      }
      
      public function get TutorialProgress() : int
      {
         return this._tutorialProgress;
      }
      
      public function set TutorialProgress(param1:int) : void
      {
         if(this._tutorialProgress == param1)
         {
            return;
         }
         this._tutorialProgress = param1;
         onPropertiesChanged("TutorialProgress");
      }
      
      public function setPartStyle(param1:ItemTemplateInfo, param2:int, param3:int = -1, param4:String = "", param5:Boolean = true) : void
      {
         if(this.Style == null)
         {
            return;
         }
         var _loc6_:Array = this._style.split(",");
         if(EquipType.isWeapon(param1.TemplateID))
         {
            _loc6_[EquipType.CategeryIdToCharacterload(param1.CategoryID)[0]] = this.replaceTID(_loc6_[EquipType.CategeryIdToCharacterload(param1.CategoryID)[0]],param3 == -1 || param3 == 0 ? "700" + String(!!PlayerManager.Instance.Self.Sex ? "1" : "2") : String(param3),false);
         }
         else if(param1.CategoryID == EquipType.SUITS)
         {
            _loc6_[7] = this.replaceTID(_loc6_[7],param3 == -1 || param3 == 0 ? String(param1.CategoryID) + "101" : String(param3));
         }
         else if(param1.CategoryID == EquipType.WING)
         {
            _loc6_[8] = this.replaceTID(_loc6_[8],param3 == -1 || param3 == 0 ? "15001" : String(param3));
         }
         else
         {
            _loc6_[EquipType.CategeryIdToCharacterload(param1.CategoryID)[0]] = this.replaceTID(_loc6_[EquipType.CategeryIdToCharacterload(param1.CategoryID)[0]],param3 == -1 || param3 == 0 ? String(param1.CategoryID) + String(param2 == 0 ? "1" : param2) + "01" : String(param3));
         }
         this._style = _loc6_.join(",");
         onPropertiesChanged("Style");
         this.setPartColor(param1.CategoryID,param4);
      }
      
      private function jionPic(param1:String, param2:String) : String
      {
         return param1 + "|" + param2;
      }
      
      private function getTID(param1:String) : String
      {
         return param1.split("|")[0];
      }
      
      private function replaceTID(param1:String, param2:String, param3:Boolean = true) : String
      {
         return param2 + "|" + (!!param3 ? ItemManager.Instance.getTemplateById(int(param2)).Pic : param1.split("|")[1]);
      }
      
      public function getPartStyle(param1:int) : int
      {
         return int(this.Style.split(",")[param1 - 1].split("|")[0]);
      }
      
      public function get Colors() : String
      {
         return this._colors;
      }
      
      public function set Colors(param1:String) : void
      {
         if(this._intuitionalColor == param1)
         {
            return;
         }
         this._intuitionalColor = param1;
         if(this.colorEqual(this._colors,param1))
         {
            return;
         }
         this._colors = param1;
         onPropertiesChanged("Colors");
      }
      
      private function colorEqual(param1:String, param2:String) : Boolean
      {
         if(param1 == param2)
         {
            return true;
         }
         if(param1 == null || param2 == null)
         {
            return false;
         }
         var _loc3_:Array = param1.split(",");
         var _loc4_:Array = param2.split(",");
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_loc5_ == 4)
            {
               if(_loc3_[_loc5_].split("|").length > 2)
               {
                  _loc3_[_loc5_] = _loc3_[_loc5_].split("|")[0] + "||" + _loc3_[_loc5_].split("|")[2];
               }
            }
            if(_loc3_[_loc5_] != _loc4_[_loc5_])
            {
               if(!((_loc3_[_loc5_] == "|" || _loc3_[_loc5_] == "||" || _loc3_[_loc5_] == "") && (_loc4_[_loc5_] == "|" || _loc4_[_loc5_] == "||" || _loc4_[_loc5_] == "")))
               {
                  return false;
               }
            }
            _loc5_++;
         }
         return true;
      }
      
      public function setPartColor(param1:int, param2:String) : void
      {
         var _loc3_:Array = this._colors.split(",");
         if(param1 != EquipType.SUITS)
         {
            _loc3_[EquipType.CategeryIdToCharacterload(param1)[0]] = param2;
         }
         this.Colors = _loc3_.join(",");
         onPropertiesChanged(PlayerInfo.COLORS);
      }
      
      public function getPartColor(param1:int) : String
      {
         var _loc2_:Array = this.Colors.split(",");
         return _loc2_[param1 - 1];
      }
      
      public function setSkinColor(param1:String) : void
      {
         this.Skin = param1;
      }
      
      public function set Skin(param1:String) : void
      {
         if(this._skin == param1)
         {
            return;
         }
         this._skin = param1;
         onPropertiesChanged("Colors");
      }
      
      public function get Skin() : String
      {
         return this.getSkinColor();
      }
      
      public function getSkinColor() : String
      {
         var _loc1_:Array = this.Colors.split(",");
         if(_loc1_[EquipType.CategeryIdToCharacterload(EquipType.FACE)[0]] == undefined)
         {
            return "";
         }
         var _loc2_:String = _loc1_[EquipType.CategeryIdToCharacterload(EquipType.FACE)[0]].split("|")[1];
         return _loc2_ == null ? "" : _loc2_;
      }
      
      public function clearColors() : void
      {
         this.Colors = ",,,,,,,,";
      }
      
      public function updateStyle(param1:Boolean, param2:int, param3:String, param4:String, param5:String) : void
      {
         beginChanges();
         Sex = param1;
         this.Hide = param2;
         this.Style = param3;
         this.Colors = param4;
         this.Skin = param5;
         commitChanges();
      }
      
      public function get paopaoType() : int
      {
         var _loc1_:String = this._style.split(",")[9].split("|")[0];
         _loc1_.slice(4);
         if(_loc1_ == null || _loc1_ == "" || _loc1_ == "0" || _loc1_ == "-1")
         {
            return 0;
         }
         return int(_loc1_.slice(3));
      }
      
      public function get Attack() : int
      {
         return this._attack;
      }
      
      public function set Attack(param1:int) : void
      {
         if(this._attack == param1)
         {
            return;
         }
         this._attack = param1;
         onPropertiesChanged("Attack");
      }
      
      public function get Crit() : int
      {
         return this._crit;
      }
      
      public function set Crit(param1:int) : void
      {
         if(this._crit == param1)
         {
            return;
         }
         this._crit = param1;
         onPropertiesChanged("Crit");
      }
      
      public function get Stormdamage() : int
      {
         return this._Stormdamage;
      }
      
      public function set Stormdamage(param1:int) : void
      {
         if(this._Stormdamage == param1)
         {
            return;
         }
         this._Stormdamage = param1;
         onPropertiesChanged("Stormdamage");
      }
      
      public function get Uprisinginjury() : int
      {
         return this._Uprisinginjury;
      }
      
      public function set Uprisinginjury(param1:int) : void
      {
         if(this._Uprisinginjury == param1)
         {
            return;
         }
         this._Uprisinginjury = param1;
         onPropertiesChanged("Uprisinginjury");
      }
      
      public function get Uprisingstrike() : int
      {
         return this._Uprisingstrike;
      }
      
      public function set Uprisingstrike(param1:int) : void
      {
         if(this._Uprisingstrike == param1)
         {
            return;
         }
         this._Uprisingstrike = param1;
         onPropertiesChanged("Uprisingstrike");
      }
      
      public function set userGuildProgress(param1:int) : void
      {
         this._answerSite = param1;
         this.TutorialProgress = param1;
      }
      
      public function get userGuildProgress() : int
      {
         return this._answerSite;
      }
      
      public function get Defence() : int
      {
         return this._defence;
      }
      
      public function set Defence(param1:int) : void
      {
         if(this._defence == param1)
         {
            return;
         }
         this._defence = param1;
         onPropertiesChanged("Defence");
      }
      
      public function get Luck() : int
      {
         return this._luck;
      }
      
      public function set Luck(param1:int) : void
      {
         if(this._luck == param1)
         {
            return;
         }
         this._luck = param1;
         onPropertiesChanged("Luck");
      }
      
      public function get hp() : int
      {
         return this._hp;
      }
      
      public function set hp(param1:int) : void
      {
         if(this._hp != param1)
         {
            this.increaHP = param1 - this._hp;
         }
         this._hp = param1;
      }
      
      public function get Agility() : int
      {
         return this._agility;
      }
      
      public function set Agility(param1:int) : void
      {
         if(this._agility == param1)
         {
            return;
         }
         this._agility = param1;
         onPropertiesChanged("Agility");
      }
      
      public function get Damage() : int
      {
         return this._Damage;
      }
      
      public function set Damage(param1:int) : void
      {
         if(this._Damage == param1)
         {
            return;
         }
         this._Damage = param1;
         onPropertiesChanged("Damage");
      }
      
      public function get Guard() : int
      {
         return this._Guard;
      }
      
      public function set Guard(param1:int) : void
      {
         if(this._Guard == param1)
         {
            return;
         }
         this._Guard = param1;
         onPropertiesChanged("Guard");
      }
      
      public function get Energy() : int
      {
         return this._Energy;
      }
      
      public function set Energy(param1:int) : void
      {
         if(this._Energy == param1)
         {
            return;
         }
         this._Energy = param1;
         onPropertiesChanged("Energy");
      }
      
      public function setAttackDefenseValues(param1:int, param2:int, param3:int, param4:int) : void
      {
         this.Attack = param1;
         this.Defence = param2;
         this.Agility = param3;
         this.Luck = param4;
         onPropertiesChanged("setAttackDefenseValues");
      }
      
      public function get dungeonFlag() : Object
      {
         if(this._dungeonFlag == null)
         {
            this._dungeonFlag = new Object();
         }
         return this._dungeonFlag;
      }
      
      public function set dungeonFlag(param1:Object) : void
      {
         if(this._dungeonFlag == param1)
         {
            return;
         }
         this._dungeonFlag = param1;
      }
      
      public function get propertyAddition() : DictionaryData
      {
         if(!this._propertyAddition)
         {
            this._propertyAddition = new DictionaryData();
         }
         return this._propertyAddition;
      }
      
      public function set propertyAddition(param1:DictionaryData) : void
      {
         this._propertyAddition = param1;
      }
      
      public function getPropertyAdditionByType(param1:String) : DictionaryData
      {
         return this._propertyAddition[param1];
      }
      
      public function get Bag() : BagInfo
      {
         if(this._bag == null)
         {
            this._bag = new BagInfo(BagInfo.EQUIPBAG,56);
         }
         return this._bag;
      }
      
      public function get BeadBag() : BagInfo
      {
         if(this._beadBag == null)
         {
            this._beadBag = new BagInfo(BagInfo.BEADBAG,40);
         }
         return this._beadBag;
      }
      
      public function get DeputyWeapon() : InventoryItemInfo
      {
         return PlayerManager.Instance.Self.Bag.getItemAt(20);
      }
      
      public function set DeputyWeaponID(param1:int) : void
      {
         if(this._deputyWeaponID == param1)
         {
            return;
         }
         this._deputyWeaponID = param1;
         onPropertiesChanged("DeputyWeaponID");
      }
      
      public function get DeputyWeaponID() : int
      {
         return this._deputyWeaponID;
      }
      
      public function get webSpeed() : int
      {
         return this._webSpeed;
      }
      
      public function set webSpeed(param1:int) : void
      {
         this._webSpeed = param1;
         dispatchEvent(new WebSpeedEvent(WebSpeedEvent.STATE_CHANE));
      }
      
      public function get WeaponID() : int
      {
         return this._weaponID;
      }
      
      public function set WeaponID(param1:int) : void
      {
         if(this._weaponID == param1)
         {
            return;
         }
         this._weaponID = param1;
         onPropertiesChanged("WeaponID");
      }
      
      public function set paopaoType(param1:int) : void
      {
         if(this._paopaoType && this._paopaoType == param1)
         {
            return;
         }
         this._paopaoType = param1;
         onPropertiesChanged("paopaoType");
      }
      
      public function get buffInfo#2() : DictionaryData
      {
         return this._buffInfo;
      }
      
      protected function set buffInfo#8(param1:DictionaryData) : void
      {
         if(this._buffInfo == param1)
         {
            return;
         }
         this._buffInfo = param1;
         onPropertiesChanged("buffInfo");
      }
      
      public function addBuff(param1:BuffInfo) : void
      {
         this._buffInfo.add(param1.Type,param1);
      }
      
      public function clearBuff() : void
      {
         this._buffInfo.clear();
      }
      
      public function hasBuff(param1:int) : Boolean
      {
         if(param1 == BuffInfo.FREE)
         {
            return true;
         }
         var _loc2_:BuffInfo = this.getBuff(param1);
         return _loc2_ != null && _loc2_.IsExist;
      }
      
      public function getBuff(param1:int) : BuffInfo
      {
         return this._buffInfo[param1];
      }
      
      public function get PvePermission() : String
      {
         return this._pvePermission;
      }
      
      public function set PvePermission(param1:String) : void
      {
         if(this._pvePermission == param1)
         {
            return;
         }
         if(param1 == "")
         {
            this._pvePermission = "11111111111111111111111111111111111111111111111111";
         }
         else
         {
            if(this._pvePermission != null)
            {
               if(this._pvePermission.substr(0,1) == "1" && param1.substr(0,1) == "3")
               {
                  this._isDupSimpleTip = true;
               }
            }
            this._pvePermission = param1;
         }
         onPropertiesChanged("PvePermission");
      }
      
      public function get fightLibMission() : String
      {
         return this._fightLibMission == null || this._fightLibMission == "" ? "0000000000" : this._fightLibMission;
      }
      
      public function set fightLibMission(param1:String) : void
      {
         this._fightLibMission = param1;
         onPropertiesChanged("fightLibMission");
      }
      
      public function setMasterOrApprentices(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         if(!this._masterOrApprentices)
         {
            this._masterOrApprentices = new DictionaryData();
         }
         this._masterOrApprentices.clear();
         if(param1 != "")
         {
            _loc2_ = param1.split(",");
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_].split("|");
               this._masterOrApprentices.add(int(_loc4_[0]),_loc4_[1]);
               _loc3_++;
            }
         }
         onPropertiesChanged("masterOrApprentices");
      }
      
      public function getMasterOrApprentices() : DictionaryData
      {
         if(!this._masterOrApprentices)
         {
            this._masterOrApprentices = new DictionaryData();
         }
         return this._masterOrApprentices;
      }
      
      public function set masterID(param1:int) : void
      {
         this._masterID = param1;
      }
      
      public function get masterID() : int
      {
         return this._masterID;
      }
      
      public function isMyMaster(param1:int) : Boolean
      {
         return param1 == this._masterID;
      }
      
      public function isMyApprent(param1:int) : Boolean
      {
         return this._masterOrApprentices[param1];
      }
      
      public function set graduatesCount(param1:int) : void
      {
         this._graduatesCount = param1;
      }
      
      public function get graduatesCount() : int
      {
         return this._graduatesCount;
      }
      
      public function set honourOfMaster(param1:String) : void
      {
         this._honourOfMaster = param1;
      }
      
      public function get honourOfMaster() : String
      {
         return this._honourOfMaster;
      }
      
      public function set freezesDate(param1:Date) : void
      {
         this._freezesDate = param1;
      }
      
      public function get freezesDate() : Date
      {
         return this._freezesDate;
      }
      
      public function get cardEquipDic() : DictionaryData
      {
         if(this._cardEquipDic == null)
         {
            this._cardEquipDic = new DictionaryData();
         }
         return this._cardEquipDic;
      }
      
      public function set cardEquipDic(param1:DictionaryData) : void
      {
         if(this._cardEquipDic == param1)
         {
            return;
         }
         this._cardEquipDic = param1;
         onPropertiesChanged("cardEquipDic");
      }
      
      public function get cardBagDic() : DictionaryData
      {
         if(this._cardBagDic == null)
         {
            this._cardBagDic = new DictionaryData();
         }
         return this._cardBagDic;
      }
      
      public function set cardBagDic(param1:DictionaryData) : void
      {
         if(this._cardBagDic == param1)
         {
            return;
         }
         this._cardBagDic = param1;
         onPropertiesChanged("cardBagDic");
      }
      
      public function getOptionState(param1:int) : Boolean
      {
         var _loc2_:int = this.OptionOnOff & param1;
         return _loc2_ == param1;
      }
      
      public function get shopFinallyGottenTime() : Date
      {
         return this._shopFinallyGottenTime;
      }
      
      public function set shopFinallyGottenTime(param1:Date) : void
      {
         if(this._shopFinallyGottenTime == param1)
         {
            return;
         }
         this._shopFinallyGottenTime = param1;
         dispatchEvent(new Event(UPDATE_SHOP_FINALLY_TIME));
      }
      
      public function getLastDate() : int
      {
         var _loc1_:int = 0;
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:int = (_loc2_.valueOf() - this._lastDate.valueOf()) / 3600000;
         return int(_loc3_ < 1 ? int(1) : int(_loc3_));
      }
      
      public function set lastDate(param1:Date) : void
      {
         this._lastDate = param1;
      }
      
      public function get lastDate() : Date
      {
         return this._lastDate;
      }
      
      public function get isSameCity() : Boolean
      {
         return this._isSameCity;
      }
      
      public function set isSameCity(param1:Boolean) : void
      {
         this._isSameCity = param1;
      }
      
      public function set IsShowConsortia(param1:Boolean) : void
      {
         this._IsShowConsortia = param1;
      }
      
      public function get IsShowConsortia() : Boolean
      {
         return this._IsShowConsortia;
      }
      
      public function get showDesignation() : String
      {
         var _loc1_:String = !!this.IsShowConsortia ? ConsortiaName : honor;
         if(!_loc1_)
         {
            _loc1_ = ConsortiaName;
         }
         if(!_loc1_)
         {
            _loc1_ = honor;
         }
         return _loc1_;
      }
      
      public function get badLuckNumber() : int
      {
         return this._badLuckNumber;
      }
      
      public function set badLuckNumber(param1:int) : void
      {
         if(this._badLuckNumber != param1)
         {
            this._badLuckNumber = param1;
            onPropertiesChanged("BadLuckNumber");
         }
      }
      
      public function get isSelf() : Boolean
      {
         return this._isSelf;
      }
      
      public function get pets() : DictionaryData
      {
         if(this._pets == null)
         {
            this._pets = new DictionaryData();
         }
         return this._pets;
      }
      
      public function addPets(param1:PetInfo) : void
      {
         this.pets.add(param1.Place,param1);
         onPropertiesChanged("Pets");
      }
      
      public function get currentPet() : PetInfo
      {
         return this._currentPet;
      }
      
      public function set currentPet(param1:PetInfo) : void
      {
         this._currentPet = param1;
      }
      
      public function set damageScores(param1:int) : void
      {
         this._damageScores = param1;
      }
      
      public function get damageScores() : int
      {
         return this._damageScores;
      }
      
      public function get totemScores() : int
      {
         return this._totemScores;
      }
      
      public function set totemScores(param1:int) : void
      {
         if(this._totemScores == param1)
         {
            return;
         }
         this._totemScores = param1;
         onPropertiesChanged("totemScores");
      }
      
      public function get SuidLevel() : int
      {
         return this._suidLevel;
      }
      
      public function set SuidLevel(param1:int) : void
      {
         this._suidLevel = param1;
      }
      
      public function get runeLevel() : int
      {
         return this._runeLevel;
      }
      
      public function set runeLevel(param1:int) : void
      {
         this._runeLevel = param1;
      }
      
      public function get EquipNum() : int
      {
         return this._EquipNum;
      }
      
      public function set EquipNum(param1:int) : void
      {
         this._EquipNum = param1;
      }
      
      public function get TexpItemLevel() : int
      {
         return this._texpItemLevel;
      }
      
      public function set TexpItemLevel(param1:int) : void
      {
         this._texpItemLevel = param1;
      }
      
      public function get TexpNum() : int
      {
         return this._texpNum;
      }
      
      public function set TexpNum(param1:int) : void
      {
         this._texpNum = param1;
      }
      
      public function get beadScore() : int
      {
         return this._beadScore;
      }
      
      public function set beadScore(param1:int) : void
      {
         if(this._beadScore == param1)
         {
            return;
         }
         this._beadScore = param1;
         onPropertiesChanged(PlayerInfo.BEAD_SCORE);
      }
      
      public function get Fatigue() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(PlayerManager.Instance.Self.ID == ID)
         {
            if(!this.FatigueupDateTimer)
            {
               return 0;
            }
            _loc1_ = (TimeManager.Instance.Now().time - this.FatigueupDateTimer.getTime()) / 1000;
            _loc2_ = this._fatigue;
            if(_loc2_ > 100)
            {
               return _loc2_;
            }
            if(_loc1_ < 0)
            {
               return _loc2_;
            }
            _loc2_ += _loc1_ / 600;
            return int(_loc2_ > 100 ? int(100) : int(_loc2_));
         }
         return this._fatigue;
      }
      
      public function set Fatigue(param1:int) : void
      {
         if(this._fatigue == param1)
         {
            return;
         }
         this._fatigue = param1;
         onPropertiesChanged("Fatigue");
      }
      
      public function get FatigueupDateTimer() : Date
      {
         return this._fatigueupDateTimer;
      }
      
      public function set FatigueupDateTimer(param1:Date) : void
      {
         this._fatigueupDateTimer = param1;
      }
      
      public function set NeedFatigue(param1:int) : void
      {
         this._needFatigue = param1;
      }
      
      public function get NeedFatigue() : int
      {
         return this._needFatigue;
      }
      
      public function get totemId() : int
      {
         return this._totemId;
      }
      
      public function set totemId(param1:int) : void
      {
         if(this._totemId == param1)
         {
            return;
         }
         this._totemId = param1;
         onPropertiesChanged("totemId");
      }
      
      public function get MilitaryRankScores() : int
      {
         return this._militaryRankScores;
      }
      
      public function set MilitaryRankScores(param1:int) : void
      {
         this._militaryRankScores = param1;
      }
      
      public function get MilitaryRankTotalScores() : int
      {
         return this._militaryRankTotalScores;
      }
      
      public function set MilitaryRankTotalScores(param1:int) : void
      {
         this._militaryRankTotalScores = param1;
      }
      
      public function get fatigueCount() : int
      {
         return this._fatigueCount;
      }
      
      public function set fatigueCount(param1:int) : void
      {
         this._fatigueCount = param1;
      }
      
      public function get FightCount() : int
      {
         return this._fightCount;
      }
      
      public function set FightCount(param1:int) : void
      {
         if(this._fightCount == param1)
         {
            return;
         }
         this._fightCount = param1;
         onPropertiesChanged("FightCount");
      }
      
      public function get isLearnSkill() : DictionaryData
      {
         if(this._isLearnSkill == null)
         {
            this._isLearnSkill = new DictionaryData();
         }
         return this._isLearnSkill;
      }
      
      public function set consortionStatus(param1:Boolean) : void
      {
         this._consortionStatus = param1;
      }
      
      public function get consortionStatus() : Boolean
      {
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            return false;
         }
         return this._consortionStatus;
      }
      
      public function get isYellowVip() : Boolean
      {
         return this._isYellowVip;
      }
      
      public function set isYellowVip(param1:Boolean) : void
      {
         this._isYellowVip = param1;
      }
      
      public function get isYearVip() : Boolean
      {
         return this._isYearVip;
      }
      
      public function set isYearVip(param1:Boolean) : void
      {
         this._isYearVip = param1;
      }
      
      public function get MemberDiamondLevel() : int
      {
         return this._memberDiamondLevel;
      }
      
      public function set MemberDiamondLevel(param1:int) : void
      {
         this._memberDiamondLevel = param1;
      }
      
      public function get Level3366() : int
      {
         return this._Level3366;
      }
      
      public function set Level3366(param1:int) : void
      {
         this._Level3366 = param1;
      }
      
      public function get returnEnergy() : int
      {
         return this._returnEnergy;
      }
      
      public function set returnEnergy(param1:int) : void
      {
         this._returnEnergy = param1;
         dispatchEvent(new WeekendEvent(WeekendEvent.ENERGY_CHANGE));
      }
   }
}
