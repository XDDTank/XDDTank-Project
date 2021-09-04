package platformapi.tencent
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.RequestVairableCreater;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLVariables;
   
   public class TencentExternalInterfaceManager
   {
      
      private static var loader:URLLoader;
      
      private static var funShare:Function;
      
      private static var waitingForBuying:Boolean = false;
       
      
      public function TencentExternalInterfaceManager()
      {
         super();
      }
      
      public static function setupSP(param1:String) : void
      {
         switch(param1)
         {
            case "pengyou.com":
               funShare = sharedByShuoshuo;
         }
      }
      
      public static function shareByOpenAPI(param1:String, param2:String, param3:Function = null) : void
      {
         sharedByShuoshuo(param1,param2,param3);
      }
      
      public static function sharedByShuoshuo(param1:String, param2:String, param3:Function = null) : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.addCallback("shareCallback",param3 == null ? nullFunction : param3);
         param2 = PathManager.FLASHSITE + "images/share/" + param2;
         var _loc4_:String = "sendToShuoShuo";
         ExternalInterface.call(_loc4_,param1,param2);
      }
      
      public static function buy() : void
      {
         waitingForBuying = true;
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["openid"] = DiamondManager.instance.model.pfdata.openID;
         _loc1_["openkey"] = DiamondManager.instance.model.pfdata.openKey;
         _loc1_["pf"] = DiamondManager.instance.model.pfdata.pf;
         _loc1_["pfkey"] = DiamondManager.instance.model.pfdata.pfKey;
         _loc1_["userid"] = PlayerManager.Instance.Self.ID;
         _loc1_["username"] = PlayerManager.Instance.Account.Account;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ChargeMoneyForTX.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.addEventListener(LoaderEvent.COMPLETE,__onBuyReturn);
         LoaderManager.Instance.startLoad(_loc2_);
      }
      
      private static function __onBuyReturn(param1:LoaderEvent) : void
      {
         waitingForBuying = false;
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,__onBuyReturn);
         var _loc2_:String = "";
         var _loc3_:XML = XML(param1.loader.content);
         if(_loc3_.@value == "true")
         {
            if(!ExternalInterface.available)
            {
               return;
            }
            _loc2_ = _loc3_.@message;
            switch(DiamondManager.instance.model.pfdata.pfType)
            {
               case DiamondType.YELLOW_DIAMOND:
                  ExternalInterface.call("sendBuyPengyou",_loc2_);
                  break;
               case DiamondType.BLUE_DIAMOND:
                  ExternalInterface.call("sendBuy3366",_loc2_ + "&platform=30006","Buy");
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("core.refill.needRelogin"));
         }
      }
      
      public static function invite(param1:Function = null) : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.addCallback("inviteCallback",param1 == null ? nullFunction : param1);
         switch(DiamondManager.instance.model.pfdata.pfType)
         {
            case DiamondType.YELLOW_DIAMOND:
               ExternalInterface.call("invite");
               break;
            case DiamondType.BLUE_DIAMOND:
               ExternalInterface.call("invite3366");
               break;
            case DiamondType.MEMBER_DIAMOND:
               ExternalInterface.call("inviteQPlus");
         }
      }
      
      private static function nullFunction(... rest) : void
      {
      }
      
      public static function shareFeed(param1:String, param2:String, param3:String, param4:Function = null) : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.addCallback("shareCallback",param4 == null ? nullFunction : param4);
         ExternalInterface.call("shareFeed",param1,param2,param3);
      }
      
      public static function share(param1:String, param2:String, param3:String) : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.call("share",param1,param2,param3);
      }
      
      public static function logToConsole(param1:String) : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.call("console.log",param1);
      }
      
      public static function openDiamond(param1:Boolean = false) : void
      {
         switch(DiamondManager.instance.pfType)
         {
            case DiamondType.YELLOW_DIAMOND:
               loadYellowDiamondInfo();
               break;
            case DiamondType.BLUE_DIAMOND:
               ExternalInterface.call(!!param1 ? "openBlueDiamondYear" : "openBlueDiamond");
               break;
            case DiamondType.MEMBER_DIAMOND:
         }
      }
      
      private static function loadYellowDiamondInfo() : void
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["openid"] = DiamondManager.instance.model.pfdata.openID;
         _loc1_["openkey"] = DiamondManager.instance.model.pfdata.openKey;
         _loc1_["pf"] = DiamondManager.instance.model.pfdata.pf;
         _loc1_["pfkey"] = DiamondManager.instance.model.pfdata.pfKey;
         _loc1_["userid"] = PlayerManager.Instance.Self.ID;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActiveYellowVip.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.addEventListener(LoaderEvent.COMPLETE,__onOpenDiamond);
         LoaderManager.Instance.startLoad(_loc2_);
      }
      
      protected static function __onOpenDiamond(param1:LoaderEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,__onBuyReturn);
         var _loc5_:String = DiamondManager.instance.model.pfdata.openID;
         var _loc6_:XML = XML(param1.loader.content);
         if(_loc6_.@value == "true")
         {
            if(!ExternalInterface.available)
            {
               return;
            }
            _loc2_ = _loc6_.@token;
            _loc3_ = _loc6_.@discountid;
            _loc4_ = _loc6_.@areaId;
            switch(DiamondManager.instance.pfType)
            {
               case DiamondType.YELLOW_DIAMOND:
                  ExternalInterface.call("openDiamond",_loc2_,_loc3_,_loc4_,_loc5_);
                  break;
               case DiamondType.BLUE_DIAMOND:
                  ExternalInterface.call("openBlueDiamond");
                  break;
               case DiamondType.MEMBER_DIAMOND:
            }
         }
      }
   }
}
