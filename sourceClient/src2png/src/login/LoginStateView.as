// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//login.LoginStateView

package login
{
    import ddt.states.BaseStateView;
    import flash.display.Shape;
    import ddt.manager.PlayerManager;
    import ddt.data.AccountInfo;
    import flash.utils.ByteArray;
    import ddt.utils.CrytoUtils;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import ddt.Version;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.LoadInterfaceManager;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.RequestLoader;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.data.analyze.LoginAnalyzer;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.loader.StartupResourceLoader;
    import ddt.manager.ServerManager;
    import flash.events.Event;
    import ddt.view.character.ILayer;
    import ddt.view.character.ShowCharacterLoader;
    import ddt.states.StateType;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.manager.SelectListManager;
    import com.pickgliss.loader.LoaderSavingManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import ddt.view.UIModuleSmallLoading;
    import login.view.ChooseRoleFrame;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.character.LayerFactory;
    import ddt.view.character.BaseLightLayer;
    import ddt.view.character.SinpleLightLayer;

    public class LoginStateView extends BaseStateView 
    {

        private static var w:String = "abcdefghijklmnopqrstuvwxyz";

        private var _shape:Shape;


        public static function creatLoginLoader(_arg_1:String, _arg_2:Function):RequestLoader
        {
            var _local_3:AccountInfo = PlayerManager.Instance.Account;
            var _local_4:Date = new Date();
            var _local_5:ByteArray = new ByteArray();
            _local_5.writeShort(_local_4.fullYearUTC);
            _local_5.writeByte((_local_4.monthUTC + 1));
            _local_5.writeByte(_local_4.dateUTC);
            _local_5.writeByte(_local_4.hoursUTC);
            _local_5.writeByte(_local_4.minutesUTC);
            _local_5.writeByte(_local_4.secondsUTC);
            var _local_6:String = "";
            var _local_7:int;
            while (_local_7 < 6)
            {
                _local_6 = (_local_6 + w.charAt(int((Math.random() * 26))));
                _local_7++;
            };
            _local_5.writeUTFBytes(((((((_local_3.Account + ",") + _local_3.Password) + ",") + _local_6) + ",") + _arg_1));
            var _local_8:String = CrytoUtils.rsaEncry4(_local_3.Key, _local_5);
            var _local_9:URLVariables = RequestVairableCreater.creatWidthKey(false);
            _local_9["p"] = _local_8;
            _local_9["v"] = Version.Build;
            _local_9["site"] = PathManager.solveConfigSite();
            _local_9["rid"] = PlayerManager.Instance.Self.rid;
            LoadInterfaceManager.traceMsg(("login路径:" + PathManager.solveRequestPath("Login.ashx")));
            var _local_10:RequestLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("Login.ashx"), BaseLoader.REQUEST_LOADER, _local_9);
            _local_10.addEventListener(LoaderEvent.LOAD_ERROR, __onLoadLoginError);
            var _local_11:LoginAnalyzer = new LoginAnalyzer(_arg_2);
            _local_11.tempPassword = _local_6;
            _local_10.analyzer = _local_11;
            return (_local_10);
        }

        private static function __onLoadLoginError(_arg_1:LoaderEvent):void
        {
            LeavePageManager.leaveToLoginPurely();
            var _local_2:String = _arg_1.loader.loadErrorMessage;
            if (_arg_1.loader.analyzer)
            {
                _local_2 = (((_arg_1.loader.loadErrorMessage == null) ? "" : (_arg_1.loader.loadErrorMessage + "\n")) + _arg_1.loader.analyzer.message);
            };
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert("警告：", _local_2, "确认");
            _local_3.addEventListener(FrameEvent.RESPONSE, __onAlertResponse);
        }

        private static function __onAlertResponse(_arg_1:FrameEvent):void
        {
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, __onAlertResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            LeavePageManager.leaveToLoginPath();
        }

        private static function onUserGuildResourceComplete(_arg_1:Event):void
        {
            StartupResourceLoader.Instance.removeEventListener(StartupResourceLoader.USER_GUILD_RESOURCE_COMPLETE, onUserGuildResourceComplete);
            if (ServerManager.Instance.canAutoLogin())
            {
                ServerManager.Instance.connentCurrentServer();
            }
            else
            {
                StartupResourceLoader.Instance.finishLoadingProgress();
            };
        }

        private static function onLayerComplete(_arg_1:ILayer):void
        {
            _arg_1.dispose();
        }

        private static function onPreLoadComplete(_arg_1:ShowCharacterLoader):void
        {
            _arg_1.destory();
        }


        override public function getType():String
        {
            return (StateType.LOGIN);
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            this._shape = new Shape();
            this._shape.graphics.beginFill(0, 1);
            this._shape.graphics.drawRect(0, 0, StageReferance.stageWidth, StageReferance.stageHeight);
            this._shape.graphics.endFill();
            addChild(this._shape);
            if (SelectListManager.Instance.mustShowSelectWindow)
            {
                this.loadLoginRes();
            }
            else
            {
                this.loginCurrentRole();
            };
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            super.leaving(_arg_1);
            if (this._shape)
            {
                ObjectUtils.disposeObject(this._shape);
            };
            this._shape = null;
        }

        private function __onShareAlertResponse(_arg_1:FrameEvent):void
        {
            LoaderSavingManager.loadFilesInLocal();
            if (LoaderSavingManager.ReadShareError)
            {
                MessageTipManager.getInstance().show("请清除缓存后再重新登录");
            }
            else
            {
                LeavePageManager.leaveToLoginPath();
            };
        }

        private function loadLoginRes():void
        {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onLoginResComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onLoginResError);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LOGIN);
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onLoginResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onLoginResError);
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
        }

        private function __onLoginResComplete(_arg_1:UIModuleEvent):void
        {
            var _local_2:ChooseRoleFrame;
            if (_arg_1.module == UIModuleTypes.LOGIN)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onLoginResComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onLoginResError);
                UIModuleSmallLoading.Instance.hide();
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("ChooseRoleFrame");
                _local_2.addEventListener(Event.COMPLETE, this.__onChooseRoleComplete);
                LayerManager.Instance.addToLayer(_local_2, LayerManager.STAGE_TOP_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
            };
        }

        private function __onLoginResError(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onLoginResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onLoginResError);
        }

        private function loginCurrentRole():void
        {
            var _local_1:RequestLoader = creatLoginLoader(SelectListManager.Instance.currentLoginRole.NickName, this.onLoginComplete);
            LoadResourceManager.instance.startLoad(_local_1);
        }

        private function __onChooseRoleComplete(_arg_1:Event):void
        {
            var _local_2:ChooseRoleFrame = (_arg_1.currentTarget as ChooseRoleFrame);
            _local_2.removeEventListener(Event.COMPLETE, this.__onChooseRoleComplete);
            _local_2.dispose();
            this.loginCurrentRole();
        }

        private function onLoginComplete(_arg_1:LoginAnalyzer):void
        {
            var _local_2:ShowCharacterLoader = new ShowCharacterLoader(PlayerManager.Instance.Self);
            _local_2.needMultiFrames = false;
            _local_2.setFactory(LayerFactory.instance);
            _local_2.load(onPreLoadComplete);
            var _local_3:BaseLightLayer = new BaseLightLayer(PlayerManager.Instance.Self.Nimbus);
            _local_3.load(onLayerComplete);
            var _local_4:SinpleLightLayer = new SinpleLightLayer(PlayerManager.Instance.Self.Nimbus);
            _local_4.load(onLayerComplete);
            StartupResourceLoader.Instance.addEventListener(StartupResourceLoader.USER_GUILD_RESOURCE_COMPLETE, onUserGuildResourceComplete);
            StartupResourceLoader.Instance.addUserGuildResource();
        }


    }
}//package login

