// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//militaryrank.MilitaryRankManager

package militaryrank
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import flash.events.Event;
    import road7th.comm.PackageIn;
    import ddt.manager.PlayerManager;
    import militaryrank.model.MilitaryLevelModel;
    import ddt.manager.ServerConfigManager;
    import com.pickgliss.ui.ComponentFactory;
    import militaryrank.view.MilitaryFrameView;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.UIModuleSmallLoading;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;

    public class MilitaryRankManager extends EventDispatcher 
    {

        public static const GET_RECORD:String = "getRecord";
        private static var _instance:MilitaryRankManager;

        private var _func:Function;
        private var _funcParams:Array;
        private var _loadComplete:Boolean = false;
        private var _rankDataDic:DictionaryData;
        private var _rankShopRecord:DictionaryData;

        public function MilitaryRankManager()
        {
            this._rankDataDic = new DictionaryData();
            this._rankShopRecord = new DictionaryData();
            this.initRankData();
        }

        public static function get Instance():MilitaryRankManager
        {
            if (_instance == null)
            {
                _instance = new (MilitaryRankManager)();
            };
            return (_instance);
        }


        public function get loadComplete():Boolean
        {
            return (this._loadComplete);
        }

        public function setRankShopRecord(_arg_1:PackageIn):void
        {
            var _local_2:int = _arg_1.readInt();
            this._rankShopRecord = new DictionaryData();
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                this._rankShopRecord[_arg_1.readInt()] = _arg_1.readInt();
                _local_3++;
            };
            dispatchEvent(new Event(GET_RECORD));
        }

        public function getRankShopRecordByID(_arg_1:int):int
        {
            return (this._rankShopRecord[_arg_1]);
        }

        public function getRankShopItemCount(_arg_1:int):int
        {
            var _local_2:MilitaryLevelModel = MilitaryRankManager.Instance.getMilitaryRankInfo(PlayerManager.Instance.Self.MilitaryRankTotalScores);
            var _local_3:int = ServerConfigManager.instance.getRankShopLimitByIDandLevel(_arg_1, _local_2.CurrKey);
            var _local_4:int = this.getRankShopRecordByID(_arg_1);
            return (_local_3 - _local_4);
        }

        public function show():void
        {
            if (this.loadComplete)
            {
                this.showMilitaryFrame();
            }
            else
            {
                this.loadModule(this.show);
            };
        }

        private function showMilitaryFrame():void
        {
            var _local_1:MilitaryFrameView = ComponentFactory.Instance.creatComponentByStylename("militaryrank.MilitaryFrame");
            LayerManager.Instance.addToLayer(_local_1, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        public function loadModule(_arg_1:Function=null, _arg_2:Array=null):void
        {
            this._func = _arg_1;
            this._funcParams = _arg_2;
            if (this.loadComplete)
            {
                if (null != this._func)
                {
                    this._func.apply(null, this._funcParams);
                };
                this._func = null;
                this._funcParams = null;
            }
            else
            {
                UIModuleSmallLoading.Instance.progress = 0;
                UIModuleSmallLoading.Instance.show();
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.loadCompleteHandler);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.onUimoduleLoadProgress);
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.MILITARY_RANK);
            };
        }

        private function onUimoduleLoadProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.MILITARY_RANK)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function loadCompleteHandler(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.MILITARY_RANK)
            {
                this._loadComplete = true;
                UIModuleSmallLoading.Instance.hide();
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

        private function initRankData():void
        {
            var _local_5:MilitaryLevelModel;
            var _local_1:Array = ServerConfigManager.instance.getMilitaryData();
            var _local_2:Array = ServerConfigManager.instance.getMilitaryName();
            var _local_3:int;
            while (_local_3 < (_local_1.length - 1))
            {
                _local_5 = new MilitaryLevelModel();
                _local_5.MinScore = int(_local_1[_local_3]);
                _local_5.MaxScore = int(_local_1[(_local_3 + 1)]);
                _local_5.Name = _local_2[_local_3];
                _local_5.CurrKey = _local_3;
                this._rankDataDic.add(_local_3, _local_5);
                _local_3++;
            };
            var _local_4:MilitaryLevelModel = new MilitaryLevelModel();
            _local_4.MinScore = int(_local_1[(_local_1.length - 1)]);
            _local_4.MaxScore = int.MAX_VALUE;
            _local_4.Name = _local_2[(_local_1.length - 1)];
            _local_4.CurrKey = (_local_1.length - 1);
            this._rankDataDic.add((_local_1.length - 1), _local_4);
        }

        public function getMilitaryRankInfo(_arg_1:int):MilitaryLevelModel
        {
            var _local_2:MilitaryLevelModel;
            var _local_3:MilitaryLevelModel;
            for each (_local_3 in this._rankDataDic)
            {
                if (_local_3.isThisLevel(_arg_1))
                {
                    _local_2 = _local_3;
                    break;
                };
            };
            return (_local_2);
        }

        public function getMilitaryFrameNum(_arg_1:int):int
        {
            var _local_2:int;
            var _local_3:MilitaryLevelModel;
            for each (_local_3 in this._rankDataDic)
            {
                if (_local_3.isThisLevel(_arg_1))
                {
                    _local_2 = (_local_3.CurrKey + 1);
                    break;
                };
            };
            return (_local_2);
        }

        public function getMilitaryInfoByLevel(_arg_1:int):MilitaryLevelModel
        {
            return (this._rankDataDic[_arg_1]);
        }

        public function getOtherMilitaryName(_arg_1:int):Array
        {
            var _local_2:Array = [];
            switch (_arg_1)
            {
                case 1:
                    _local_2.push(ServerConfigManager.instance.getMilitaryName()[15]);
                    _local_2.push(16);
                    break;
                case 2:
                    _local_2.push(ServerConfigManager.instance.getMilitaryName()[14]);
                    _local_2.push(15);
                    break;
                case 3:
                    _local_2.push(ServerConfigManager.instance.getMilitaryName()[13]);
                    _local_2.push(14);
                    break;
            };
            return (_local_2);
        }


    }
}//package militaryrank

