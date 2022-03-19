// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.StrengthDataManager

package store
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.events.IEventDispatcher;
    import store.analyze.StrengthenDataAnalyzer;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class StrengthDataManager extends EventDispatcher 
    {

        private static var _instance:StrengthDataManager;

        public var _strengthData:Vector.<Dictionary>;

        public function StrengthDataManager(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public static function get instance():StrengthDataManager
        {
            if (_instance == null)
            {
                _instance = new (StrengthDataManager)();
            };
            return (_instance);
        }


        public function setup():void
        {
        }

        public function searchResult(_arg_1:StrengthenDataAnalyzer):void
        {
            this._strengthData = _arg_1._strengthData;
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
            var _local_2:String = _arg_1.loader.loadErrorMessage;
            if (_arg_1.loader.analyzer)
            {
                _local_2 = ((_arg_1.loader.loadErrorMessage + "\n") + _arg_1.loader.analyzer.message);
            };
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"), _arg_1.loader.loadErrorMessage, LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        public function getRecoverDongAddition(_arg_1:int, _arg_2:int):Number
        {
            return (this._strengthData[_arg_2][_arg_1]);
        }


    }
}//package store

