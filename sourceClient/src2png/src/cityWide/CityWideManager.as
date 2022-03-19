// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cityWide.CityWideManager

package cityWide
{
    import ddt.data.player.PlayerInfo;
    import ddt.manager.PlayerManager;
    import flash.utils.setInterval;
    import ddt.manager.SocketManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import ddt.action.FrameShowAction;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import im.IMEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.ChatManager;
    import com.pickgliss.loader.UIModuleLoader;
    import ddt.view.UIModuleSmallLoading;
    import com.pickgliss.events.UIModuleEvent;

    public class CityWideManager 
    {

        private static var _instance:CityWideManager;

        private const TIMES:int = 300000;

        private var _cityWideView:CityWideFrame;
        private var _playerInfo:PlayerInfo;
        private var _canOpenCityWide:Boolean = true;
        private var _loadedCallBack:Function;
        private var _loadingModuleType:String;


        public static function get Instance():CityWideManager
        {
            if (_instance == null)
            {
                _instance = new (CityWideManager)();
            };
            return (_instance);
        }


        public function init():void
        {
            PlayerManager.Instance.addEventListener(CityWideEvent.ONS_PLAYERINFO, this._updateCityWide);
        }

        private function _updateCityWide(_arg_1:CityWideEvent):void
        {
            this._canOpenCityWide = true;
            if (this._canOpenCityWide)
            {
                this._playerInfo = _arg_1.playerInfo;
                this.showView(this._playerInfo);
                this._canOpenCityWide = false;
                setInterval(this.changeBoolean, this.TIMES);
            };
        }

        public function toSendOpenCityWide():void
        {
            SocketManager.Instance.out.sendOns();
        }

        private function changeBoolean():void
        {
            this._canOpenCityWide = true;
        }

        public function showView(_arg_1:PlayerInfo):void
        {
            this._cityWideView = ComponentFactory.Instance.creatComponentByStylename("CityWideFrame");
            this._cityWideView.playerInfo = _arg_1;
            this._cityWideView.addEventListener("submit", this._submitExit);
            if (CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
            {
                CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT, new FrameShowAction(this._cityWideView));
            }
            else
            {
                this._cityWideView.show();
            };
        }

        private function _submitExit(_arg_1:Event):void
        {
            var _local_3:BaseAlerFrame;
            this._cityWideView = null;
            var _local_2:int;
            if (PlayerManager.Instance.Self.IsVIP)
            {
                _local_2 = (PlayerManager.Instance.Self.VIPLevel + 2);
            };
            if (PlayerManager.Instance.friendList.length >= (200 + (_local_2 * 50)))
            {
                _local_3 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.im.IMController.addFriend", (200 + (_local_2 * 50))), "", "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                _local_3.addEventListener(FrameEvent.RESPONSE, this._close);
                return;
            };
            SocketManager.Instance.out.sendAddFriend(this._playerInfo.NickName, 0, false, true);
            PlayerManager.Instance.addEventListener(IMEvent.ADDNEW_FRIEND, this._addAlert);
        }

        private function _close(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            if (_local_2)
            {
                _local_2.removeEventListener(FrameEvent.RESPONSE, this._close);
                _local_2.dispose();
                _local_2 = null;
            };
        }

        private function _addAlert(_arg_1:IMEvent):void
        {
            PlayerManager.Instance.removeEventListener(IMEvent.ADDNEW_FRIEND, this._addAlert);
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation(""), LanguageMgr.GetTranslation("tank.view.bagII.baglocked.complete"), LanguageMgr.GetTranslation("tank.view.scenechatII.PrivateChatIIView.privatename"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
            _local_2.info.enableHtml = true;
            var _local_3:String = LanguageMgr.GetTranslation("cityWideFrame.ONSAlertInfo");
            _local_3 = _local_3.replace(/r/g, this._playerInfo.NickName);
            _local_2.info.data = _local_3;
            _local_2.moveEnable = false;
            _local_2.addEventListener(FrameEvent.RESPONSE, this._responseII);
        }

        private function _responseII(_arg_1:FrameEvent):void
        {
            var _local_2:int = _arg_1.responseCode;
            SoundManager.instance.play("008");
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this._responseII);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            switch (_local_2)
            {
                case FrameEvent.CANCEL_CLICK:
                    ChatManager.Instance.privateChatTo(this._playerInfo.NickName, this._playerInfo.ID);
                    ChatManager.Instance.setFocus();
                    return;
            };
        }

        public function showCityWide(_arg_1:Function, _arg_2:String):void
        {
            if (UIModuleLoader.Instance.checkIsLoaded(_arg_2))
            {
                if (_arg_1 != null)
                {
                    (_arg_1());
                };
            }
            else
            {
                this._loadingModuleType = _arg_2;
                this._loadedCallBack = _arg_1;
                UIModuleSmallLoading.Instance.progress = 0;
                UIModuleSmallLoading.Instance.show();
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__cityWityComplete);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__cityWityProgress);
                UIModuleLoader.Instance.addUIModuleImp(_arg_2);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            this._loadedCallBack = null;
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__cityWityComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__cityWityProgress);
        }

        private function __cityWityComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__cityWityComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__cityWityProgress);
            this.showCityWide(this._loadedCallBack, this._loadingModuleType);
        }

        private function __cityWityProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == this._loadingModuleType)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }


    }
}//package cityWide

