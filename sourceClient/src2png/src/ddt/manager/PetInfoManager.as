// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.PetInfoManager

package ddt.manager
{
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import ddt.data.analyze.PetAdvanceAnalyzer;
    import ddt.data.analyze.PetInfoAnalyzer;
    import ddt.data.analyze.PetEggInfoAnalyzer;
    import pet.date.PetInfo;
    import com.pickgliss.utils.ObjectUtils;
    import pet.date.PetTemplateInfo;
    import pet.date.PetAdvanceInfo;
    import road7th.data.DictionaryData;
    import pet.date.PetEggInfo;
    import ddt.data.quest.QuestInfo;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import ddt.view.MainToolBar;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import com.pickgliss.action.FunctionAction;
    import __AS3__.vec.*;

    public class PetInfoManager 
    {

        private static var _instance:PetInfoManager;

        private var _petAdvanceList:Dictionary;
        private var _petTempletelist:Dictionary;
        private var _petEggList:Dictionary;
        public var petTransformCheckBtn:Boolean = false;
        private var _hasShowList:Vector.<int> = new Vector.<int>();


        public static function get instance():PetInfoManager
        {
            return (_instance = ((_instance) || (new (PetInfoManager)())));
        }


        public function setupAdvanceList(_arg_1:PetAdvanceAnalyzer):void
        {
            this._petAdvanceList = _arg_1.list;
        }

        public function setupTemplete(_arg_1:PetInfoAnalyzer):void
        {
            this._petTempletelist = _arg_1.list;
        }

        public function setupEgg(_arg_1:PetEggInfoAnalyzer):void
        {
            this._petEggList = _arg_1.list;
        }

        public function getTransformPet(_arg_1:PetInfo, _arg_2:PetInfo):PetInfo
        {
            if (((!(_arg_1)) || (!(_arg_2))))
            {
                return (null);
            };
            var _local_3:PetInfo = new PetInfo();
            ObjectUtils.copyProperties(_local_3, _arg_1);
            var _local_4:PetTemplateInfo = PetInfoManager.instance.getPetInfoByTemplateID(_arg_1.TemplateID);
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int = _arg_1.OrderNumber;
            var _local_11:int = _arg_2.OrderNumber;
            var _local_12:int = ((_local_10 > _local_11) ? _local_11 : _local_10);
            var _local_13:int = ((_local_10 > _local_11) ? _local_10 : _local_11);
            var _local_14:int = _local_12;
            while (_local_14 < _local_13)
            {
                _local_5 = (_local_5 + Math.floor((_local_4.VBloodGrow * PetBagManager.instance().petModel.getAddLife(_local_14))));
                _local_6 = (_local_6 + Math.floor((_local_4.VAttackGrow * PetBagManager.instance().petModel.getAddProperty(_local_14))));
                _local_7 = (_local_7 + Math.floor((_local_4.VDefenceGrow * PetBagManager.instance().petModel.getAddProperty(_local_14))));
                _local_8 = (_local_8 + Math.floor((_local_4.VAgilityGrow * PetBagManager.instance().petModel.getAddProperty(_local_14))));
                _local_9 = (_local_9 + Math.floor((_local_4.VLuckGrow * PetBagManager.instance().petModel.getAddProperty(_local_14))));
                _local_14++;
            };
            if (_local_10 > _local_11)
            {
                _local_3.Blood = (_local_3.Blood - _local_5);
                _local_3.Attack = (_local_3.Attack - _local_6);
                _local_3.Defence = (_local_3.Defence - _local_7);
                _local_3.Agility = (_local_3.Agility - _local_8);
                _local_3.Luck = (_local_3.Luck - _local_9);
            }
            else
            {
                _local_3.Blood = (_local_3.Blood + _local_5);
                _local_3.Attack = (_local_3.Attack + _local_6);
                _local_3.Defence = (_local_3.Defence + _local_7);
                _local_3.Agility = (_local_3.Agility + _local_8);
                _local_3.Luck = (_local_3.Luck + _local_9);
            };
            return (_local_3);
        }

        public function getBlessedPetInfo(_arg_1:PetInfo):PetInfo
        {
            var _local_2:PetInfo = this.getPetInfoByTemplateID(_arg_1.TemplateID);
            var _local_3:PetInfo = this.getPetInfoByTemplateID((_arg_1.TemplateID + 100));
            var _local_4:PetInfo = new PetInfo();
            ObjectUtils.copyProperties(_local_4, _local_3);
            _local_4.Level = _arg_1.Level;
            _local_4.OrderNumber = _arg_1.OrderNumber;
            _local_4.Attack = ((((_arg_1.Attack + _local_3.Attack) - _local_2.Attack) + ((_local_4.AttackGrow - _local_2.AttackGrow) * (_local_4.Level - 1))) + ((_local_4.VAttackGrow - _local_2.VAttackGrow) * (_local_4.OrderNumber - 1)));
            _local_4.Defence = ((((_arg_1.Defence + _local_3.Defence) - _local_2.Defence) + ((_local_4.DefenceGrow - _local_2.DefenceGrow) * (_local_4.Level - 1))) + ((_local_4.VDefenceGrow - _local_2.VDefenceGrow) * (_local_4.OrderNumber - 1)));
            _local_4.Agility = ((((_arg_1.Agility + _local_3.Agility) - _local_2.Agility) + ((_local_4.AgilityGrow - _local_2.AgilityGrow) * (_local_4.Level - 1))) + ((_local_4.VAgilityGrow - _local_2.VAgilityGrow) * (_local_4.OrderNumber - 1)));
            _local_4.Luck = ((((_arg_1.Luck + _local_3.Luck) - _local_2.Luck) + ((_local_4.LuckGrow - _local_2.LuckGrow) * (_local_4.Level - 1))) + ((_local_4.VLuckGrow - _local_2.VLuckGrow) * (_local_4.OrderNumber - 1)));
            _local_4.Blood = ((((_arg_1.Blood + _local_3.Blood) - _local_2.Blood) + ((_local_4.BloodGrow - _local_2.BloodGrow) * (_local_4.Level - 1))) + ((_local_4.VBloodGrow - _local_2.VBloodGrow) * (_local_4.OrderNumber - 1)));
            return (_local_4);
        }

        public function getAdvanceInfo(_arg_1:int):PetAdvanceInfo
        {
            var _local_3:PetAdvanceInfo;
            var _local_2:PetAdvanceInfo = this._petAdvanceList[_arg_1];
            if (_local_2)
            {
                _local_3 = new PetAdvanceInfo();
                ObjectUtils.copyProperties(_local_3, _local_2);
                return (_local_3);
            };
            return (null);
        }

        public function getpetListSorted(pets:DictionaryData):Vector.<PetInfo>
        {
            var petInfo:PetInfo;
            var result:Vector.<PetInfo> = new Vector.<PetInfo>();
            var i:int;
            for each (petInfo in pets)
            {
                result.push(petInfo);
            };
            result.sort(function (_arg_1:PetInfo, _arg_2:PetInfo):int
            {
                return ((_arg_1.ID > _arg_2.ID) ? 1 : -1);
            });
            return (result);
        }

        public function getPetListAdvanced(_arg_1:DictionaryData):Vector.<PetInfo>
        {
            var _local_4:PetInfo;
            var _local_2:Vector.<PetInfo> = this.getpetListSorted(_arg_1);
            var _local_3:Vector.<PetInfo> = new Vector.<PetInfo>();
            for each (_local_4 in _local_2)
            {
                if (_local_4.MagicLevel > 0)
                {
                    _local_3.push(_local_4);
                };
            };
            return (_local_3);
        }

        public function getPetInfoByTemplateID(_arg_1:int):PetInfo
        {
            var _local_2:PetInfo = new PetInfo();
            var _local_3:PetTemplateInfo = this._petTempletelist[_arg_1];
            ObjectUtils.copyProperties(_local_2, _local_3);
            return (_local_2);
        }

        public function getPetEggListByKind(_arg_1:int):Vector.<PetEggInfo>
        {
            return (this._petEggList[_arg_1]);
        }

        public function fillPetInfo(_arg_1:PetInfo):void
        {
            var _local_2:PetTemplateInfo = this._petTempletelist[_arg_1.TemplateID];
            if (_local_2)
            {
                ObjectUtils.copyProperties(_arg_1, _local_2);
            };
        }

        public function getPetByLevel(_arg_1:int, _arg_2:int):PetInfo
        {
            var _local_3:PetInfo = this.getPetInfoByTemplateID(_arg_1);
            _local_3.Level = _arg_2;
            _local_3.Attack = (_local_3.Attack + (_local_3.AttackGrow * (_arg_2 - 1)));
            _local_3.Defence = (_local_3.Defence + (_local_3.DefenceGrow * (_arg_2 - 1)));
            _local_3.Agility = (_local_3.Agility + (_local_3.AgilityGrow * (_arg_2 - 1)));
            _local_3.Blood = (_local_3.Blood + (_local_3.BloodGrow * (_arg_2 - 1)));
            _local_3.Luck = (_local_3.Luck + (_local_3.LuckGrow * (_arg_2 - 1)));
            return (_local_3);
        }

        public function checkIsSamePetBase(_arg_1:int, _arg_2:int):Boolean
        {
            return (int((_arg_1 / 100)) == int((_arg_2 / 100)));
        }

        public function getNeedMagicPets():Array
        {
            var _local_4:PetInfo;
            var _local_1:Array = [];
            var _local_2:DictionaryData = PlayerManager.Instance.Self.pets;
            var _local_3:int = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_MAGIC_LEVEL1).Value);
            for each (_local_4 in _local_2)
            {
                if (_local_4.Level >= _local_3)
                {
                    _local_1.push(_local_4.KindID);
                };
            };
            return (_local_1);
        }

        public function getAdvanceEffectUrl(_arg_1:PetInfo):String
        {
            var _local_2:int = int((((_arg_1.OrderNumber / 10) > 5) ? 5 : int((_arg_1.OrderNumber / 10))));
            var _local_3:int = ((Math.log(_local_2) * Math.LOG10E) + 1);
            var _local_4:String = "";
            while (_local_3 < 3)
            {
                _local_4 = (_local_4 + "0");
                _local_3++;
            };
            return (("advance" + _local_4) + _local_2);
        }

        public function checkAllPetCanMagic():void
        {
            var _local_2:PetInfo;
            var _local_1:DictionaryData = PlayerManager.Instance.Self.pets;
            for each (_local_2 in _local_1)
            {
                this.checkPetCanMagic(_local_2);
            };
        }

        public function checkPetCanMagic(info:PetInfo):void
        {
            var itemName:String;
            var questInfo:QuestInfo;
            var showFunc:Function;
            var petMagicLevel1:int = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_MAGIC_LEVEL1).Value);
            itemName = ItemManager.Instance.getTemplateById(info.ItemId).Name;
            if (this._hasShowList.indexOf(info.ID) == -1)
            {
                if (info.Level >= petMagicLevel1)
                {
                    questInfo = TaskManager.instance.getPetMagicTask(info);
                    if (questInfo)
                    {
                        showFunc = function ():void
                        {
                            var _local_1:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ddt.pet.magicTipText", info.Name, itemName), LanguageMgr.GetTranslation("lookover"), "", false, true, true);
                            _local_1.info.carryData = questInfo;
                            _local_1.addEventListener(FrameEvent.RESPONSE, __alertSubmit);
                        };
                        if ((!(MainToolBar.Instance.canOpenBag())))
                        {
                            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_FIGHT, new FunctionAction(showFunc));
                        }
                        else
                        {
                            (showFunc());
                        };
                        this._hasShowList.push(info.ID);
                    };
                };
            };
        }

        public function checkPetCanBless(_arg_1:PetInfo, _arg_2:int):Boolean
        {
            return (((_arg_1) && ((int(((_arg_1.TemplateID % 100000) / 10000)) + 1) == _arg_2)) && (((_arg_1.TemplateID % 1000) / 100) < 2));
        }

        protected function __alertSubmit(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__alertSubmit);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    if (_local_2.info.carryData)
                    {
                        TaskManager.instance.showQuest(QuestInfo(_local_2.info.carryData), 1);
                    };
                    break;
            };
            _local_2.dispose();
        }


    }
}//package ddt.manager

