// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.VipController

package vip
{
    import flash.events.EventDispatcher;
    import vip.data.VipModelInfo;
    import vip.view.VipFrame;
    import vip.view.VipViewFrame;
    import vip.view.VIPHelpFrame;
    import vip.view.VIPRechargeAlertFrame;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import ddt.manager.PlayerManager;
    import ddt.data.player.SelfInfo;
    import vip.view.RechargeAlertTxt;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import platformapi.tencent.DiamondManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.text.GradientText;
    import ddt.manager.ServerConfigManager;
    import ddt.manager.VipPrivilegeConfigManager;
    import ddt.data.VipConfigInfo;

    public class VipController extends EventDispatcher 
    {

        private static var _instance:VipController;
        public static var useFirst:Boolean = true;
        public static var loadComplete:Boolean = false;

        private var _vipUILoaded:Boolean = false;
        public var info:VipModelInfo;
        public var isRechargePoped:Boolean;
        private var _vipFrame:VipFrame;
        private var _vipViewFrame:VipViewFrame;
        private var _helpframe:VIPHelpFrame;
        private var _isShow:Boolean = true;
        private var _rechargeAlertFrame:VIPRechargeAlertFrame;
        private var _rechargeAlertLoad:Boolean = false;


        public static function get instance():VipController
        {
            if ((!(_instance)))
            {
                _instance = new (VipController)();
            };
            return (_instance);
        }


        public function show():void
        {
            if (loadComplete)
            {
                this.showVipFrame();
            }
            else
            {
                if (useFirst)
                {
                    UIModuleSmallLoading.Instance.progress = 0;
                    UIModuleSmallLoading.Instance.show();
                    UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                    UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_VIEW);
                };
            };
        }

        public function showWhenPass():void
        {
            this.show();
            this._isShow = false;
        }

        public function checkVipExpire():Boolean
        {
            if ((((PlayerManager.Instance.Self.VIPLevel > 0) && (!(PlayerManager.Instance.Self.IsVIP))) && (PlayerManager.Instance.Self.openVipType)))
            {
                return (true);
            };
            return (false);
        }

        public function get isShow():Boolean
        {
            return (this._isShow);
        }

        public function showRechargeAlert():void
        {
            var _local_1:SelfInfo;
            var _local_2:RechargeAlertTxt;
            if (loadComplete)
            {
                if (this._rechargeAlertFrame == null)
                {
                    this._rechargeAlertFrame = ComponentFactory.Instance.creatComponentByStylename("vip.vipRechargeAlertFrame");
                    _local_1 = PlayerManager.Instance.Self;
                    _local_2 = new RechargeAlertTxt();
                    _local_2.AlertContent = _local_1.VIPLevel;
                    this._rechargeAlertFrame.content = _local_2;
                    this._rechargeAlertFrame.show();
                    this._rechargeAlertFrame.addEventListener(FrameEvent.RESPONSE, this.__responseRechargeAlertHandler);
                };
            }
            else
            {
                if (useFirst)
                {
                    this._rechargeAlertLoad = true;
                    UIModuleSmallLoading.Instance.progress = 0;
                    UIModuleSmallLoading.Instance.show();
                    UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                    UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_VIEW);
                    UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.MEMBER_DIAMOND_GIFT);
                    useFirst = false;
                };
            };
        }

        public function helpframeNull():void
        {
            if (this._helpframe)
            {
                this._helpframe = null;
            };
        }

        protected function __responseHandler(_arg_1:FrameEvent):void
        {
            this._helpframe.removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this._helpframe.dispose();
                    return;
            };
        }

        protected function __responseRechargeAlertHandler(_arg_1:FrameEvent):void
        {
            this._rechargeAlertFrame.removeEventListener(FrameEvent.RESPONSE, this.__responseRechargeAlertHandler);
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this._rechargeAlertFrame.dispose();
                    break;
            };
            if (this._rechargeAlertFrame)
            {
                this._rechargeAlertFrame = null;
            };
        }

        private function showVipFrame():void
        {
            this.hide();
            this._vipFrame = ComponentFactory.Instance.creatComponentByStylename("vip.VipFrame");
            this._vipFrame.show();
        }

        private function __complainShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.VIP_VIEW)
            {
                this._vipUILoaded = true;
            };
            loadComplete = ((this._vipUILoaded) && ((!(DiamondManager.instance.isInTencent)) || (DiamondManager.instance.hasUI)));
            if (loadComplete)
            {
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                UIModuleSmallLoading.Instance.hide();
                useFirst = false;
                if (this._rechargeAlertLoad)
                {
                    this.showRechargeAlert();
                }
                else
                {
                    this.show();
                };
            };
        }

        private function __progressShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.VIP_VIEW)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
        }

        public function sendOpenVip(_arg_1:String, _arg_2:int):void
        {
            SocketManager.Instance.out.sendOpenVip(_arg_1, _arg_2);
        }

        public function hide():void
        {
            ObjectUtils.disposeObject(this._vipFrame);
            this._vipFrame = null;
        }

        public function getVipNameTxt(_arg_1:int=-1, _arg_2:int=1):GradientText
        {
            var _local_3:GradientText;
            switch (_arg_2)
            {
                case 0:
                    throw (new Error("会员类型错误,不能为非会员玩家创建会员字体."));
                case 1:
                    _local_3 = ComponentFactory.Instance.creatComponentByStylename("vipName");
                    break;
                case 2:
                    _local_3 = ComponentFactory.Instance.creatComponentByStylename("vipName");
                    break;
            };
            if (_local_3)
            {
                if (_arg_1 != -1)
                {
                    _local_3.textField.width = _arg_1;
                }
                else
                {
                    _local_3.textField.autoSize = "left";
                };
                return (_local_3);
            };
            return (ComponentFactory.Instance.creatComponentByStylename("vipName"));
        }

        public function getVIPStrengthenEx(_arg_1:int):Number
        {
            if ((_arg_1 - 1) < 0)
            {
                return (0);
            };
            var _local_2:Array = ServerConfigManager.instance.VIPStrengthenEx;
            if (_local_2)
            {
                return (_local_2[(_arg_1 - 1)]);
            };
            return (0);
        }

        public function getPrivilegeByIndex(_arg_1:int):Boolean
        {
            if ((!(PlayerManager.Instance.Self.IsVIP)))
            {
                return (false);
            };
            var _local_2:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(_arg_1);
            var _local_3:int = int(_local_2[("Level" + PlayerManager.Instance.Self.VIPLevel)]);
            return ((_local_3 > 0) ? true : false);
        }

        public function getPrivilegeByIndexAndLevel(_arg_1:int, _arg_2:int):Boolean
        {
            if (_arg_2 <= 0)
            {
                return (false);
            };
            var _local_3:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(_arg_1);
            var _local_4:int = int(_local_3[("Level" + _arg_2)]);
            return ((_local_4 > 0) ? true : false);
        }


    }
}//package vip

