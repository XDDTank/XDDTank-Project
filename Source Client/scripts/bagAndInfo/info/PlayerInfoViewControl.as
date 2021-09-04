package bagAndInfo.info
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   
   public class PlayerInfoViewControl
   {
      
      private static var _view:PlayerInfoFrame;
      
      private static var _tempInfo:PlayerInfo;
      
      private static var _loadComplete:Boolean;
      
      private static var _info:PlayerInfo;
      
      private static var _achivEnable:Boolean;
      
      public static var isOpenFromBag:Boolean;
       
      
      public function PlayerInfoViewControl()
      {
         super();
      }
      
      public static function get info() : PlayerInfo
      {
         return _info;
      }
      
      public static function view(param1:PlayerInfo, param2:Boolean = true) : void
      {
         _info = param1;
         _achivEnable = param2;
         if(_loadComplete)
         {
            showView();
         }
         else
         {
            loadUI();
         }
      }
      
      private static function showView() : void
      {
         if(info)
         {
            if(info.ZoneID > 0 && info.ZoneID != PlayerManager.Instance.Self.ZoneID)
            {
               if(_view == null)
               {
                  _view = ComponentFactory.Instance.creatComponentByStylename("bag.personelInfoViewFrame");
               }
               _view.info = info;
               _view.show();
               _view.addEventListener(FrameEvent.RESPONSE,__responseHandler);
               return;
            }
            if(info.Style != null)
            {
               if(_view == null)
               {
                  _view = ComponentFactory.Instance.creatComponentByStylename("bag.personelInfoViewFrame");
               }
               _view.info = info;
               _view.show();
               _view.addEventListener(FrameEvent.RESPONSE,__responseHandler);
            }
            else
            {
               info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__infoChange);
            }
            SocketManager.Instance.out.sendItemEquip(info.ID);
         }
      }
      
      private static function __infoChange(param1:PlayerPropertyEvent) : void
      {
         if(PlayerInfo(param1.currentTarget).Style)
         {
            PlayerInfo(param1.target).removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__infoChange);
            if(_view == null)
            {
               _view = ComponentFactory.Instance.creatComponentByStylename("bag.personelInfoViewFrame");
            }
            _view.info = PlayerInfo(param1.target);
            _view.show();
            _view.addEventListener(FrameEvent.RESPONSE,__responseHandler);
         }
      }
      
      public static function viewByID(param1:int, param2:int = -1, param3:Boolean = true) : void
      {
         var _loc4_:PlayerInfo = PlayerManager.Instance.findPlayer(param1,param2);
         view(_loc4_,param3);
      }
      
      public static function viewByNickName(param1:String, param2:int = -1, param3:Boolean = true) : void
      {
         _tempInfo = new PlayerInfo();
         _tempInfo = PlayerManager.Instance.findPlayerByNickName(_tempInfo,param1);
         if(_tempInfo.ID)
         {
            view(_tempInfo,param3);
         }
         else
         {
            SocketManager.Instance.out.sendItemEquip(_tempInfo.NickName,true);
            _tempInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__IDChange);
         }
      }
      
      private static function __IDChange(param1:PlayerPropertyEvent) : void
      {
         _tempInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__IDChange);
         view(_tempInfo);
      }
      
      private static function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               _view.dispose();
               clearView();
               isOpenFromBag = false;
         }
      }
      
      public static function closeView() : void
      {
         if(_view && _view.parent)
         {
            _view.removeEventListener(FrameEvent.RESPONSE,__responseHandler);
            _view.dispose();
         }
         _view = null;
      }
      
      private static function loadUI() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,__loadingClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__moduleComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,__onProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,__moduleIOError);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NEWBAGANDINFO);
      }
      
      private static function __onProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private static function __moduleIOError(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NEWBAGANDINFO)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,__onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,__moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,__loadingClose);
            UIModuleSmallLoading.Instance.hide();
         }
      }
      
      private static function __moduleComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NEWBAGANDINFO)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,__onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,__moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,__loadingClose);
            UIModuleSmallLoading.Instance.hide();
            _loadComplete = true;
            showView();
         }
      }
      
      private static function __loadingClose(param1:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__moduleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,__onProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,__moduleIOError);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,__loadingClose);
         UIModuleSmallLoading.Instance.hide();
      }
      
      public static function clearView() : void
      {
         if(_view)
         {
            _view.removeEventListener(FrameEvent.RESPONSE,__responseHandler);
         }
         _view = null;
      }
   }
}
