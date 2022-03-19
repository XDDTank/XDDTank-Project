// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.ConsortiaRateManager

package store.view
{
    import flash.events.EventDispatcher;
    import ddt.manager.PlayerManager;
    import ddt.events.PlayerPropertyEvent;
    import consortion.ConsortionModelControl;
    import consortion.event.ConsortionEvent;
    import consortion.data.ConsortiaAssetLevelOffer;
    import consortion.analyze.ConsortionBuildingUseConditionAnalyer;
    import ddt.data.ConsortiaInfo;
    import consortion.analyze.ConsortionListAnalyzer;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.Vector;
    import ddt.manager.ServerConfigManager;
    import flash.events.Event;

    public class ConsortiaRateManager extends EventDispatcher 
    {

        public static var _instance:ConsortiaRateManager;
        public static const CHANGE_CONSORTIA:String = "loadComplete_consortia";

        private var _SmithLevel:int = 0;
        private var _data:String;
        private var _rate:int;
        private var _selfRich:int;
        private var _needRich:int = 100;

        public function ConsortiaRateManager()
        {
            this.initEvents();
        }

        public static function get instance():ConsortiaRateManager
        {
            if (_instance == null)
            {
                _instance = new (ConsortiaRateManager)();
            };
            return (_instance);
        }


        private function initEvents():void
        {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this._propertyChange);
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.USE_CONDITION_CHANGE, this._useConditionChange);
        }

        private function __resultConsortiaEquipContro(_arg_1:ConsortionBuildingUseConditionAnalyer):void
        {
            var _local_4:ConsortiaAssetLevelOffer;
            var _local_2:int = _arg_1.useConditionList.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = _arg_1.useConditionList[_local_3];
                if (_local_4.Type == 2)
                {
                    this.setStripTipDataRichs(_local_4.Riches);
                };
                _local_3++;
            };
        }

        private function __consortiaClubSearchResult(_arg_1:ConsortionListAnalyzer):void
        {
            var _local_2:ConsortiaInfo;
            if (_arg_1.consortionList.length > 0)
            {
                _local_2 = _arg_1.consortionList[0];
                if (_local_2)
                {
                    this._SmithLevel = _local_2.SmithLevel;
                };
                this._rate = this._SmithLevel;
                this.setStripTipData();
            };
        }

        private function setStripTipData():void
        {
            if (PlayerManager.Instance.Self.ConsortiaID != 0)
            {
                if (this._SmithLevel <= 0)
                {
                    this._loadComplete();
                }
                else
                {
                    ConsortionModelControl.Instance.loadUseConditionList(this.__resultConsortiaEquipContro, PlayerManager.Instance.Self.ConsortiaID);
                };
            }
            else
            {
                this._loadComplete();
            };
        }

        private function setStripTipDataRichs(_arg_1:int):void
        {
            this._selfRich = (PlayerManager.Instance.Self.RichesOffer + PlayerManager.Instance.Self.RichesRob);
            if (this._selfRich < _arg_1)
            {
                this._rate = 0;
            };
            this._needRich = _arg_1;
            this._loadComplete();
        }

        private function __onLoadErrorII(_arg_1:LoaderEvent):void
        {
            var _local_2:String = _arg_1.loader.loadErrorMessage;
            if (_arg_1.loader.analyzer)
            {
                _local_2 = ((_arg_1.loader.loadErrorMessage + "\n") + _arg_1.loader.analyzer.message);
            };
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"), _arg_1.loader.loadErrorMessage, LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponseII);
        }

        private function __onAlertResponseII(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponseII);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        private function _propertyChange(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties["SmithLevel"])
            {
                this._SmithLevel = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
            };
            if (((_arg_1.changedProperties["RichesOffer"]) || (_arg_1.changedProperties["RichesRob"])))
            {
                this._selfRich = (PlayerManager.Instance.Self.RichesOffer + PlayerManager.Instance.Self.RichesRob);
            };
            this._rate = this._SmithLevel;
            this._loadComplete();
        }

        private function _useConditionChange(_arg_1:ConsortionEvent):void
        {
            var _local_5:ConsortiaAssetLevelOffer;
            var _local_2:Vector.<ConsortiaAssetLevelOffer> = ConsortionModelControl.Instance.model.useConditionList;
            var _local_3:int = _local_2.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = _local_2[_local_4];
                if (_local_5.Type == 2)
                {
                    this.setStripTipDataRichs(_local_5.Riches);
                };
                _local_4++;
            };
        }

        public function reset():void
        {
            this._SmithLevel = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
            this._selfRich = PlayerManager.Instance.Self.Riches;
            ConsortionModelControl.Instance.getConsortionList(this.__consortiaClubSearchResult, 1, 6, "", -1, -1, -1, PlayerManager.Instance.Self.ConsortiaID);
        }

        public function get consortiaTipData():String
        {
            this._rate = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
            if (PlayerManager.Instance.Self.ConsortiaID != 0)
            {
                if (PlayerManager.Instance.Self.consortiaInfo.SmithLevel <= 0)
                {
                    this._data = LanguageMgr.GetTranslation("tank.view.store.consortiaRateIII");
                }
                else
                {
                    if (PlayerManager.Instance.Self.UseOffer < this._needRich)
                    {
                        this._rate = 0;
                        this._data = LanguageMgr.GetTranslation("tank.view.store.consortiaRateII", PlayerManager.Instance.Self.UseOffer, this._needRich);
                    }
                    else
                    {
                        this._data = LanguageMgr.GetTranslation("store.StoreIIComposeBG.consortiaRate_txt", (PlayerManager.Instance.Self.consortiaInfo.SmithLevel * 10));
                    };
                };
            }
            else
            {
                this._rate = 0;
                this._data = LanguageMgr.GetTranslation("tank.view.store.consortiaRateI");
            };
            return (this._data);
        }

        public function get smithLevel():int
        {
            return (PlayerManager.Instance.Self.consortiaInfo.SmithLevel);
        }

        public function get rate():int
        {
            this._rate = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
            if (PlayerManager.Instance.Self.ConsortiaID != 0)
            {
                if (((PlayerManager.Instance.Self.consortiaInfo.SmithLevel > 0) && (PlayerManager.Instance.Self.UseOffer < this._needRich)))
                {
                    this._rate = 0;
                };
            }
            else
            {
                this._rate = 0;
            };
            return (this._rate);
        }

        public function getConsortiaStrengthenEx(_arg_1:int):Number
        {
            if ((_arg_1 - 1) < 0)
            {
                return (0);
            };
            var _local_2:Array = ServerConfigManager.instance.ConsortiaStrengthenEx();
            if (_local_2)
            {
                return (_local_2[(_arg_1 - 1)]);
            };
            return (0);
        }

        private function _loadComplete():void
        {
            dispatchEvent(new Event(CHANGE_CONSORTIA));
        }

        public function dispose():void
        {
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this._propertyChange);
        }


    }
}//package store.view

