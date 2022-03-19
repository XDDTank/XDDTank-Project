// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.LeavePageManager

package ddt.manager
{
    import flash.external.ExternalInterface;
    import ddt.data.PathInfo;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.LoadInterfaceManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import platformapi.tencent.DiamondManager;
    import platformapi.tencent.TencentExternalInterfaceManager;
    import flash.net.URLVariables;
    import com.pickgliss.loader.BaseLoader;

    public class LeavePageManager 
    {


        public static function leaveToLoginPurely():void
        {
            var _local_1:String;
            if (ExternalInterface.available)
            {
                _local_1 = (('function redict () {top.location.href="' + PathManager.solveLogin()) + '"}');
                ExternalInterface.call(_local_1);
            };
        }

        public static function leaveToLoginPath():void
        {
            var _local_1:String;
            if (DesktopManager.Instance.isDesktop)
            {
                DesktopManager.Instance.backToLogin();
            }
            else
            {
                if (((PathInfo.ISTOPDERIICT) && (ExternalInterface.available)))
                {
                    _local_1 = (('function redict () {top.location.href="' + PathManager.solveLogin()) + '"}');
                    ExternalInterface.call(_local_1);
                }
                else
                {
                    if (ExternalInterface.available)
                    {
                        ExternalInterface.call("setFlashCall");
                    };
                    navigateToURL(new URLRequest(PathManager.solveLogin()), "_self");
                };
            };
        }

        public static function forcedToLoginPath(msg:String):void
        {
            if (DesktopManager.Instance.isDesktop)
            {
                DesktopManager.Instance.backToLogin();
                return;
            };
            if (LoadResourceManager.instance.isMicroClient)
            {
                LoadInterfaceManager.alertAndRestart(msg);
                return;
            };
            PageInterfaceManager.askForFavorite();
            if (ExternalInterface.available)
            {
                ExternalInterface.call("toLocation", PathManager.solveLogin(), msg);
            }
            else
            {
                AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"), LanguageMgr.GetTranslation("tank.manager.RoomManager.break")).addEventListener(FrameEvent.RESPONSE, function (_arg_1:FrameEvent):void
                {
                    _arg_1.target.dispose();
                });
            };
        }

        public static function showFillFrame():BaseAlerFrame
        {
            var _local_1:BaseAlerFrame;
            _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.comon.lack"), "", LanguageMgr.GetTranslation("cancel"), true, false, false, 2);
            _local_1.addEventListener(FrameEvent.RESPONSE, __onResponse);
            return (_local_1);
        }

        private static function __onResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, __onResponse);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                leaveToFillPath();
            };
        }

        public static function leaveToFillPath():void
        {
            SoundManager.instance.play("008");
            if (DiamondManager.instance.pfType > 0)
            {
                TencentExternalInterfaceManager.buy();
            }
            else
            {
                if (sinaWeiBoFill())
                {
                    return;
                };
                if ((((ExternalInterface.available) && (PathManager.solveFillJSCommandEnable())) && (!(DesktopManager.Instance.isDesktop))))
                {
                    ExternalInterface.call(PathManager.solveFillJSCommandValue());
                }
                else
                {
                    if (((ExternalInterface.available) && (!(DesktopManager.Instance.isDesktop))))
                    {
                        ExternalInterface.call("setFlashCall");
                    };
                    navigateToURL(new URLRequest(encodeURI(PathManager.solveFillPage())), "_blank");
                };
            };
        }

        private static function sinaWeiBoFill():Boolean
        {
            var _local_2:String;
            var _local_3:String;
            var _local_4:Array;
            var _local_1:Boolean;
            if (((((ExternalInterface.available) && (PathManager.CommnuntyMicroBlog())) && (PathManager.CommnuntySinaSecondMicroBlog())) && (PathManager.solveFillJSCommandEnable())))
            {
                _local_1 = true;
                _local_2 = PathManager.solveFillJSCommandValue();
                _local_3 = _local_2.substr(0, _local_2.indexOf("("));
                _local_4 = _local_2.substring((_local_2.indexOf("(") + 1), _local_2.indexOf(")")).split(",");
                ExternalInterface.call(_local_3, PlayerManager.Instance.Self.LoginName, _local_4[1].substring(1, (_local_4[1].length - 1)), _local_4[2].substring(1, (_local_4[2].length - 1)), _local_4[3].substring(1, (_local_4[3].length - 1)));
            };
            return (_local_1);
        }

        private static function chargeMoney():void
        {
            var _local_1:URLVariables = new URLVariables();
            _local_1["userName"] = PlayerManager.Instance.Self.LoginName;
            _local_1["money"] = 10000;
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ChargeMoneyForTest.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("tank.leavaPageManager.chargeMoney.error");
            _local_2.analyzer = new ChargeMoneyAnalyzer(chargeResult);
            LoadResourceManager.instance.startLoad(_local_2);
        }

        private static function chargeResult(_arg_1:ChargeMoneyAnalyzer):void
        {
            if (_arg_1.result)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.leavaPageManager.chargeMoney.success"));
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.leavaPageManager.chargeMoney.fail"));
            };
        }

        public static function setFavorite(_arg_1:Boolean):void
        {
            if (ExternalInterface.available)
            {
                if (DesktopManager.Instance.isDesktop)
                {
                    return;
                };
                if ((!(PathManager.solveAllowPopupFavorite())))
                {
                    return;
                };
                if (_arg_1)
                {
                    ExternalInterface.call("setFavorite", PathManager.solveLogin(), StatisticManager.siteName, "3");
                }
                else
                {
                    ExternalInterface.call("setFavorite", PathManager.solveLogin(), StatisticManager.siteName, "2");
                };
            };
        }


    }
}//package ddt.manager

