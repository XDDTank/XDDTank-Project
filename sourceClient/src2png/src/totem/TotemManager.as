// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.TotemManager

package totem
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import totem.data.TotemDataAnalyz;
    import totem.data.TotemDataVo;
    import totem.data.TotemAddInfo;
    import ddt.manager.PlayerManager;
    import ddt.data.Experience;
    import road7th.data.DictionaryData;
    import ddt.manager.LanguageMgr;

    public class TotemManager extends EventDispatcher 
    {

        private static var _instance:TotemManager;

        private var _dataList:Object;
        private var _dataList2:Object;
        private var _func:Function;
        private var _funcParams:Array;
        public var isUpgrade:Boolean = false;
        public var isLast:Boolean = false;
        public var isLastFail:Boolean = false;

        public function TotemManager(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public static function get instance():TotemManager
        {
            if (_instance == null)
            {
                _instance = new (TotemManager)();
            };
            return (_instance);
        }


        public function loadTotemModule(_arg_1:Function=null, _arg_2:Array=null):void
        {
            this._func = _arg_1;
            this._funcParams = _arg_2;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.loadCompleteHandler);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.onUimoduleLoadProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TOTEM);
        }

        private function onUimoduleLoadProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.TOTEM)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function loadCompleteHandler(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.TOTEM)
            {
                UIModuleSmallLoading.Instance.hide();
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.loadCompleteHandler);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.onUimoduleLoadProgress);
                if (null != this._func)
                {
                    this._func.apply(null, this._funcParams);
                };
                this._func = null;
                this._funcParams = null;
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.onUimoduleLoadProgress);
        }

        public function setup(_arg_1:TotemDataAnalyz):void
        {
            this._dataList = _arg_1.dataList;
            this._dataList2 = _arg_1.dataList2;
        }

        public function getCurInfoByLevel(_arg_1:int):TotemDataVo
        {
            return (this._dataList2[_arg_1]);
        }

        public function getCurInfoById(_arg_1:int):TotemDataVo
        {
            if (_arg_1 == 0)
            {
                return (new TotemDataVo());
            };
            return (this._dataList[_arg_1]);
        }

        public function getNextInfoByLevel(_arg_1:int):TotemDataVo
        {
            return (this._dataList2[(_arg_1 + 1)]);
        }

        public function getNextInfoById(_arg_1:int):TotemDataVo
        {
            var _local_2:int;
            if (_arg_1 == 0)
            {
                _local_2 = 0;
            }
            else
            {
                _local_2 = this._dataList[_arg_1].Point;
            };
            return (this._dataList2[(_local_2 + 1)]);
        }

        public function getAddInfo(_arg_1:int, _arg_2:int=1):TotemAddInfo
        {
            var _local_4:TotemDataVo;
            var _local_3:TotemAddInfo = new TotemAddInfo();
            for each (_local_4 in this._dataList)
            {
                if (((_local_4.Point <= _arg_1) && (_local_4.Point >= _arg_2)))
                {
                    _local_3.Agility = (_local_3.Agility + _local_4.AddAgility);
                    _local_3.Attack = (_local_3.Attack + _local_4.AddAttack);
                    _local_3.Blood = (_local_3.Blood + _local_4.AddBlood);
                    _local_3.Damage = (_local_3.Damage + _local_4.AddDamage);
                    _local_3.Defence = (_local_3.Defence + _local_4.AddDefence);
                    _local_3.Guard = (_local_3.Guard + _local_4.AddGuard);
                    _local_3.Luck = (_local_3.Luck + _local_4.AddLuck);
                };
            };
            return (_local_3);
        }

        public function getAddInfoNow(_arg_1:int, _arg_2:int=0):TotemAddInfo
        {
            var _local_4:TotemDataVo;
            var _local_3:TotemAddInfo = new TotemAddInfo();
            var _local_5:int = int(Math.ceil(((_arg_1 - 10000) / 70)));
            var _local_6:int = ((10000 + (70 * (_arg_2 - 1))) + 1);
            var _local_7:int = (10000 + (70 * _arg_2));
            var _local_8:int = ((_arg_1 < _local_7) ? _arg_1 : _local_7);
            var _local_9:int = _local_6;
            while (_local_9 <= _local_8)
            {
                _local_4 = this._dataList[_local_9];
                _local_3.Agility = (_local_3.Agility + _local_4.AddAgility);
                _local_3.Attack = (_local_3.Attack + _local_4.AddAttack);
                _local_3.Blood = (_local_3.Blood + _local_4.AddBlood);
                _local_3.Damage = (_local_3.Damage + _local_4.AddDamage);
                _local_3.Defence = (_local_3.Defence + _local_4.AddDefence);
                _local_3.Guard = (_local_3.Guard + _local_4.AddGuard);
                _local_3.Luck = (_local_3.Luck + _local_4.AddLuck);
                _local_9++;
            };
            return (_local_3);
        }

        public function getCurruntAddInfo(_arg_1:TotemDataVo, _arg_2:int=0):TotemAddInfo
        {
            var _local_3:TotemAddInfo;
            if (_arg_1)
            {
                _local_3 = TotemManager.instance.getAddInfoNow((_arg_1.ID - 1), _arg_2);
            }
            else
            {
                _local_3 = TotemManager.instance.getAddInfoNow(10350, _arg_2);
            };
            return (_local_3);
        }

        public function getTotemPointLevel(_arg_1:int):int
        {
            if (_arg_1 == 0)
            {
                return (0);
            };
            return (this._dataList[_arg_1].Point);
        }

        public function get usableGP():int
        {
            return (PlayerManager.Instance.Self.GP - Experience.expericence[(PlayerManager.Instance.Self.Grade - 1)]);
        }

        public function getCurrentLv(_arg_1:int):int
        {
            return (int((_arg_1 / 7)));
        }

        public function getCurrentLvList(_arg_1:int, _arg_2:int, _arg_3:TotemDataVo=null):Array
        {
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_4:Array = [];
            if (((Math.ceil((_arg_1 / 70)) == _arg_2) || (_arg_1 == 0)))
            {
                if ((_arg_1 % 7) == 0)
                {
                    _local_5 = int((_arg_1 / 7));
                    _local_6 = 0;
                    while (_local_6 < 7)
                    {
                        _local_4.push(_local_5);
                        _local_6++;
                    };
                }
                else
                {
                    _local_7 = (_arg_1 % 7);
                    _local_8 = int(Math.floor((_arg_1 / 7)));
                    _local_9 = 0;
                    while (_local_9 < 7)
                    {
                        if (_local_9 < _local_7)
                        {
                            _local_4.push((_local_8 + 1));
                        }
                        else
                        {
                            _local_4.push(_local_8);
                        };
                        _local_9++;
                    };
                };
            }
            else
            {
                if ((((_arg_3) && (_arg_3.Location == 1)) && (_arg_3.Layers == 1)))
                {
                    _local_10 = ((_arg_2 - 1) * 10);
                }
                else
                {
                    _local_10 = (_arg_2 * 10);
                };
                _local_11 = 0;
                while (_local_11 < 7)
                {
                    _local_4.push(_local_10);
                    _local_11++;
                };
            };
            return (_local_4);
        }

        public function updatePropertyAddtion(_arg_1:int, _arg_2:DictionaryData):void
        {
            if ((!(_arg_2["Attack"])))
            {
                return;
            };
            var _local_3:TotemAddInfo = this.getAddInfo(this.getCurInfoById(_arg_1).Point);
            _arg_2["Attack"]["Totem"] = _local_3.Attack;
            _arg_2["Defence"]["Totem"] = _local_3.Defence;
            _arg_2["Agility"]["Totem"] = _local_3.Agility;
            _arg_2["Luck"]["Totem"] = _local_3.Luck;
            _arg_2["HP"]["Totem"] = _local_3.Blood;
            _arg_2["Damage"]["Totem"] = _local_3.Damage;
            _arg_2["Armor"]["Totem"] = _local_3.Guard;
        }

        public function getSamePageLocationList(_arg_1:int, _arg_2:int):Array
        {
            var _local_4:TotemDataVo;
            var _local_3:Array = [];
            for each (_local_4 in this._dataList)
            {
                if (((_local_4.Page == _arg_1) && (_local_4.Location == _arg_2)))
                {
                    _local_3.push(_local_4);
                };
            };
            _local_3.sortOn("Layers", Array.NUMERIC);
            return (_local_3);
        }

        public function getValueByIndex(_arg_1:int, _arg_2:TotemDataVo):int
        {
            var _local_3:int;
            switch (_arg_1)
            {
                case 0:
                    _local_3 = _arg_2.AddAttack;
                    break;
                case 1:
                    _local_3 = _arg_2.AddDefence;
                    break;
                case 2:
                    _local_3 = _arg_2.AddAgility;
                    break;
                case 3:
                    _local_3 = _arg_2.AddLuck;
                    break;
                case 4:
                    _local_3 = _arg_2.AddBlood;
                    break;
                case 5:
                    _local_3 = _arg_2.AddDamage;
                    break;
                case 6:
                    _local_3 = _arg_2.AddGuard;
                    break;
                default:
                    _local_3 = 0;
            };
            return (_local_3);
        }

        public function getAddValue(_arg_1:int, _arg_2:TotemAddInfo):int
        {
            var _local_3:int;
            switch (_arg_1)
            {
                case 1:
                    _local_3 = _arg_2.Attack;
                    break;
                case 2:
                    _local_3 = _arg_2.Defence;
                    break;
                case 3:
                    _local_3 = _arg_2.Agility;
                    break;
                case 4:
                    _local_3 = _arg_2.Luck;
                    break;
                case 5:
                    _local_3 = _arg_2.Blood;
                    break;
                case 6:
                    _local_3 = _arg_2.Damage;
                    break;
                case 7:
                    _local_3 = _arg_2.Guard;
                    break;
            };
            return (_local_3);
        }

        public function getDisplayNum(_arg_1:int):String
        {
            if (_arg_1 >= 100000000)
            {
                return (Math.floor((_arg_1 / 100000000)) + LanguageMgr.GetTranslation("yi"));
            };
            if (_arg_1 >= 100000)
            {
                return (Math.floor((_arg_1 / 10000)) + LanguageMgr.GetTranslation("wan"));
            };
            return (_arg_1.toString());
        }


    }
}//package totem

