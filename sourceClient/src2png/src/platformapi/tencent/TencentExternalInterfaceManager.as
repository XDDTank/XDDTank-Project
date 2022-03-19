// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.TencentExternalInterfaceManager

package platformapi.tencent
{
    import flash.net.URLLoader;
    import flash.external.ExternalInterface;
    import ddt.manager.PathManager;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import ddt.manager.PlayerManager;
    import com.pickgliss.loader.LoaderManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;

    public class TencentExternalInterfaceManager 
    {

        private static var loader:URLLoader;
        private static var funShare:Function;
        private static var waitingForBuying:Boolean = false;


        public static function setupSP(_arg_1:String):void
        {
            switch (_arg_1)
            {
                case "pengyou.com":
                    funShare = sharedByShuoshuo;
                    return;
            };
        }

        public static function shareByOpenAPI(_arg_1:String, _arg_2:String, _arg_3:Function=null):void
        {
            sharedByShuoshuo(_arg_1, _arg_2, _arg_3);
        }

        public static function sharedByShuoshuo(_arg_1:String, _arg_2:String, _arg_3:Function=null):void
        {
            if ((!(ExternalInterface.available)))
            {
                return;
            };
            ExternalInterface.addCallback("shareCallback", ((_arg_3 == null) ? nullFunction : _arg_3));
            _arg_2 = ((PathManager.FLASHSITE + "images/share/") + _arg_2);
            var _local_4:String = "sendToShuoShuo";
            ExternalInterface.call(_local_4, _arg_1, _arg_2);
        }

        public static function buy():void
        {
            waitingForBuying = true;
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_1["openid"] = DiamondManager.instance.model.pfdata.openID;
            _local_1["openkey"] = DiamondManager.instance.model.pfdata.openKey;
            _local_1["pf"] = DiamondManager.instance.model.pfdata.pf;
            _local_1["pfkey"] = DiamondManager.instance.model.pfdata.pfKey;
            _local_1["userid"] = PlayerManager.Instance.Self.ID;
            _local_1["username"] = PlayerManager.Instance.Account.Account;
            var _local_2:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ChargeMoneyForTX.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.addEventListener(LoaderEvent.COMPLETE, __onBuyReturn);
            LoaderManager.Instance.startLoad(_local_2);
        }

        private static function __onBuyReturn(_arg_1:LoaderEvent):void
        {
            waitingForBuying = false;
            _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, __onBuyReturn);
            var _local_2:String = "";
            var _local_3:XML = XML(_arg_1.loader.content);
            if (_local_3.@value == "true")
            {
                if ((!(ExternalInterface.available)))
                {
                    return;
                };
                _local_2 = _local_3.@message;
                switch (DiamondManager.instance.model.pfdata.pfType)
                {
                    case DiamondType.YELLOW_DIAMOND:
                        ExternalInterface.call("sendBuyPengyou", _local_2);
                        break;
                    case DiamondType.BLUE_DIAMOND:
                        ExternalInterface.call("sendBuy3366", (_local_2 + "&platform=30006"), "Buy");
                        break;
                };
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("core.refill.needRelogin"));
            };
        }

        public static function invite(_arg_1:Function=null):void
        {
            if ((!(ExternalInterface.available)))
            {
                return;
            };
            ExternalInterface.addCallback("inviteCallback", ((_arg_1 == null) ? nullFunction : _arg_1));
            switch (DiamondManager.instance.model.pfdata.pfType)
            {
                case DiamondType.YELLOW_DIAMOND:
                    ExternalInterface.call("invite");
                    return;
                case DiamondType.BLUE_DIAMOND:
                    ExternalInterface.call("invite3366");
                    return;
                case DiamondType.MEMBER_DIAMOND:
                    ExternalInterface.call("inviteQPlus");
                    return;
            };
        }

        private static function nullFunction(... _args):void
        {
        }

        public static function shareFeed(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:Function=null):void
        {
            if ((!(ExternalInterface.available)))
            {
                return;
            };
            ExternalInterface.addCallback("shareCallback", ((_arg_4 == null) ? nullFunction : _arg_4));
            ExternalInterface.call("shareFeed", _arg_1, _arg_2, _arg_3);
        }

        public static function share(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            if ((!(ExternalInterface.available)))
            {
                return;
            };
            ExternalInterface.call("share", _arg_1, _arg_2, _arg_3);
        }

        public static function logToConsole(_arg_1:String):void
        {
            if ((!(ExternalInterface.available)))
            {
                return;
            };
            ExternalInterface.call("console.log", _arg_1);
        }

        public static function openDiamond(_arg_1:Boolean=false):void
        {
            switch (DiamondManager.instance.pfType)
            {
                case DiamondType.YELLOW_DIAMOND:
                    loadYellowDiamondInfo();
                    return;
                case DiamondType.BLUE_DIAMOND:
                    ExternalInterface.call(((_arg_1) ? "openBlueDiamondYear" : "openBlueDiamond"));
                    return;
                case DiamondType.MEMBER_DIAMOND:
                    return;
            };
        }

        private static function loadYellowDiamondInfo():void
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_1["openid"] = DiamondManager.instance.model.pfdata.openID;
            _local_1["openkey"] = DiamondManager.instance.model.pfdata.openKey;
            _local_1["pf"] = DiamondManager.instance.model.pfdata.pf;
            _local_1["pfkey"] = DiamondManager.instance.model.pfdata.pfKey;
            _local_1["userid"] = PlayerManager.Instance.Self.ID;
            var _local_2:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActiveYellowVip.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.addEventListener(LoaderEvent.COMPLETE, __onOpenDiamond);
            LoaderManager.Instance.startLoad(_local_2);
        }

        protected static function __onOpenDiamond(_arg_1:LoaderEvent):void
        {
            var _local_2:String;
            var _local_3:String;
            var _local_4:String;
            _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, __onBuyReturn);
            var _local_5:String = DiamondManager.instance.model.pfdata.openID;
            var _local_6:XML = XML(_arg_1.loader.content);
            if (_local_6.@value == "true")
            {
                if ((!(ExternalInterface.available)))
                {
                    return;
                };
                _local_2 = _local_6.@token;
                _local_3 = _local_6.@discountid;
                _local_4 = _local_6.@areaId;
                switch (DiamondManager.instance.pfType)
                {
                    case DiamondType.YELLOW_DIAMOND:
                        ExternalInterface.call("openDiamond", _local_2, _local_3, _local_4, _local_5);
                        return;
                    case DiamondType.BLUE_DIAMOND:
                        ExternalInterface.call("openBlueDiamond");
                        return;
                    case DiamondType.MEMBER_DIAMOND:
                        return;
                };
            };
        }


    }
}//package platformapi.tencent

