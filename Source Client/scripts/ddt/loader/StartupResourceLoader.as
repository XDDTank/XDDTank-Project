package ddt.loader
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ResourceLoaderEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadInterfaceManager;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.CusCursorManager;
   import ddt.manager.DesktopManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskDirectorManager;
   import deng.fzip.FZip;
   import deng.fzip.FZipFile;
   import email.manager.MailManager;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import flash.system.System;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import platformapi.tencent.DiamondManager;
   import road7th.comm.PackageIn;
   
   public class StartupResourceLoader extends EventDispatcher
   {
      
      public static const NEWBIE:int = 1;
      
      public static const NORMAL:int = 2;
      
      public static const USER_GUILD_RESOURCE_COMPLETE:String = "userGuildResourceComplete";
      
      private static var _instance:StartupResourceLoader;
      
      public static var firstEnterHall:Boolean = false;
       
      
      private var _uiLoadComplete:Boolean;
      
      private var _perloadComplete:Boolean;
      
      private var _templeIsComplete:Boolean;
      
      public var enterFromLoading:Boolean;
      
      private var _currentMode:int = 0;
      
      private var _languageLoader:BaseLoader;
      
      private var _languagePath:String;
      
      private var _isSecondLoad:Boolean = false;
      
      private var _uimoduleProgress:Number;
      
      private var _progressArr:Dictionary;
      
      private var _trainerComplete:Boolean;
      
      private var _trainerUIComplete:Boolean;
      
      private var _trainerFristComplete:Boolean;
      
      private var _loaderQueue:QueueLoader;
      
      private var _requestCompleted:int;
      
      public function StartupResourceLoader()
      {
         super();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIMoudleComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIModuleProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onUIModuleLoadError);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.RELOAD_XML,this.__reloadXML);
      }
      
      public static function get Instance() : StartupResourceLoader
      {
         if(_instance == null)
         {
            _instance = new StartupResourceLoader();
         }
         return _instance;
      }
      
      private function __reloadXML(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = null;
         var _loc4_:BaseLoader = null;
         var _loc5_:BaseLoader = null;
         var _loc6_:BaseLoader = null;
         var _loc7_:BaseLoader = null;
         var _loc3_:PackageIn = param1.pkg;
         _loc2_ = _loc3_.readUTF();
         switch(_loc2_)
         {
            case "item":
               _loc4_ = LoaderCreate.Instance.creatItemTempleteReload();
               LoadResourceManager.instance.startLoad(_loc4_);
               break;
            case "quest":
               _loc4_ = LoaderCreate.Instance.creatQuestTempleteReload();
               LoadResourceManager.instance.startLoad(_loc4_);
               break;
            case "active":
               _loc4_ = LoaderCreate.Instance.creatActivityInfoListLoader();
               _loc5_ = LoaderCreate.Instance.creatActivityConditionListLoader();
               _loc6_ = LoaderCreate.Instance.creatActivityGiftbagListLoader();
               _loc7_ = LoaderCreate.Instance.creatActivityRewardListLoader();
               LoadResourceManager.instance.startLoad(_loc4_);
               LoadResourceManager.instance.startLoad(_loc5_);
               LoadResourceManager.instance.startLoad(_loc6_);
               LoadResourceManager.instance.startLoad(_loc7_);
               break;
            default:
               return;
         }
      }
      
      private function __onUIModuleLoadError(param1:UIModuleEvent) : void
      {
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("ddt.StartupResourceLoader.Error.LoadModuleError",param1.module),LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      public function get progress() : int
      {
         if(!this._uiLoadComplete)
         {
            return int(this._uimoduleProgress * 30) + 40;
         }
         if(!this._templeIsComplete)
         {
            return 75 + Math.ceil(TempleteLoader.instance.progress * 25);
         }
         return 99;
      }
      
      public function start(param1:int) : void
      {
         this._currentMode = param1;
         this.loadLanguage();
      }
      
      private function loadLanguage() : void
      {
         this._languagePath = PathManager.getLanguagePath();
         this._languageLoader = LoadResourceManager.instance.createLoader(this._languagePath,BaseLoader.BYTE_LOADER);
         this._languageLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadLanZipComplete);
         LoadResourceManager.instance.startLoad(this._languageLoader);
      }
      
      private function __onLoadLanZipComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadLanZipComplete);
         var _loc2_:ByteArray = param1.loader.content;
         this.analyMd5(_loc2_);
      }
      
      private function zipLoad(param1:ByteArray) : void
      {
         var _loc2_:FZip = new FZip();
         _loc2_.addEventListener(Event.COMPLETE,this.__onZipParaComplete);
         _loc2_.loadBytes(param1);
      }
      
      private function analyMd5(param1:ByteArray) : void
      {
         var _loc2_:ByteArray = null;
         if(ComponentSetting.USEMD5 && (ComponentSetting.md5Dic["language.png"] || this.hasHead(param1)))
         {
            if(this.compareMD5(param1))
            {
               _loc2_ = new ByteArray();
               param1.position = 37;
               param1.readBytes(_loc2_);
               this.zipLoad(_loc2_);
            }
            else
            {
               LoaderSavingManager.clearAllCache();
               LoadInterfaceManager.alertAndRestart(this._languagePath + ":is old");
               if(this._isSecondLoad)
               {
                  if(ExternalInterface.available)
                  {
                     ExternalInterface.call("alert",this._languagePath + ":is old");
                  }
               }
               else
               {
                  this._languagePath = this._languagePath.replace(ComponentSetting.FLASHSITE,ComponentSetting.BACKUP_FLASHSITE);
                  this._languageLoader.url = this._languagePath + "?rnd=" + Math.random();
                  this._languageLoader.isLoading = false;
                  this._languageLoader.loadFromWeb();
               }
               this._isSecondLoad = true;
            }
         }
         else
         {
            this.zipLoad(param1);
         }
      }
      
      private function hasHead(param1:ByteArray) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(ComponentSetting.swf_head);
         _loc2_.position = 0;
         param1.position = 0;
         while(_loc2_.bytesAvailable > 0)
         {
            _loc3_ = _loc2_.readByte();
            _loc4_ = param1.readByte();
            if(_loc3_ != _loc4_)
            {
               return false;
            }
         }
         return true;
      }
      
      private function compareMD5(param1:ByteArray) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(ComponentSetting.md5Dic["language.png"]);
         _loc2_.position = 0;
         param1.position = 5;
         while(_loc2_.bytesAvailable > 0)
         {
            _loc3_ = _loc2_.readByte();
            _loc4_ = param1.readByte();
            if(_loc3_ != _loc4_)
            {
               return false;
            }
         }
         return true;
      }
      
      private function __onZipParaComplete(param1:Event) : void
      {
         var _loc2_:FZip = param1.currentTarget as FZip;
         _loc2_.removeEventListener(Event.COMPLETE,this.__onZipParaComplete);
         var _loc3_:FZipFile = _loc2_.getFileAt(0);
         var _loc4_:String = _loc3_.content.toString();
         LanguageMgr.setup(_loc4_);
         var _loc5_:QueueLoader = new QueueLoader();
         _loc5_.addLoader(LoaderCreate.Instance.creatZhanLoader());
         _loc5_.addEventListener(Event.COMPLETE,this.__onLoadLanguageComplete);
         _loc5_.start();
      }
      
      private function __onLoadLanguageComplete(param1:Event) : void
      {
         var _loc2_:QueueLoader = param1.currentTarget as QueueLoader;
         _loc2_.removeEventListener(Event.COMPLETE,this.__onLoadLanguageComplete);
         if(this._currentMode == NEWBIE)
         {
            this.addRegisterUIModule();
         }
         else
         {
            this.loadUIModule();
         }
         this._setStageRightMouse();
      }
      
      private function __onUIModuleProgress(param1:UIModuleEvent) : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:BaseLoader = param1.loader;
         this.setLoaderProgressArr(param1.module,_loc2_.progress);
         if(!this._progressArr)
         {
            return;
         }
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         for each(_loc5_ in this._progressArr)
         {
            _loc3_ += _loc5_;
            _loc4_++;
         }
         this._uimoduleProgress = _loc3_ / _loc4_;
      }
      
      private function setLoaderProgressArr(param1:String, param2:Number = 0) : void
      {
         if(!this._progressArr)
         {
            this._progressArr = new Dictionary();
         }
         this._progressArr[param1] = param2;
      }
      
      public function addUserGuildResource() : void
      {
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TRAINER_UI);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.EXPRESSION);
      }
      
      public function finishLoadingProgress() : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIMoudleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIModuleProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onUIModuleLoadError);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function startLoadRelatedInfo() : void
      {
         var _loc1_:QueueLoader = new QueueLoader();
         if(PlayerManager.Instance.Self.Grade >= 20)
         {
            _loc1_.addLoader(LoaderCreate.Instance.creatVoteSubmit());
         }
         this.SendVersion();
         _loc1_.addLoader(LoaderCreate.Instance.creatFriendListLoader());
         _loc1_.addLoader(LoaderCreate.Instance.getMyConsortiaData());
         _loc1_.addLoader(LoaderCreate.Instance.createCalendarRequest());
         _loc1_.addLoader(MailManager.Instance.getAllEmailLoader());
         _loc1_.addLoader(MailManager.Instance.getSendedEmailLoader());
         _loc1_.addLoader(LoaderCreate.Instance.creatFeedbackInfoLoader());
         _loc1_.addLoader(LoaderCreate.Instance.createConsortiaLoader());
         if(DiamondManager.instance.isInTencent)
         {
            _loc1_.addLoader(LoaderCreate.Instance.creatInvitedFriendListLoader());
         }
         _loc1_.start();
      }
      
      private function __onSetupSourceLoadComplete(param1:Event) : void
      {
         var _loc2_:QueueLoader = param1.currentTarget as QueueLoader;
         _loc2_.removeEventListener(Event.COMPLETE,this.__onSetupSourceLoadComplete);
         _loc2_.removeEventListener(Event.CHANGE,this.__onSetupSourceLoadChange);
         _loc2_.dispose();
         _loc2_ = null;
         TaskDirectorManager.instance.setup();
         dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.USER_DATA_COMPLETE));
      }
      
      private function __onUIMoudleComplete(param1:UIModuleEvent) : void
      {
         LoadInterfaceManager.traceMsg("模块加载完成,开始加载模板");
         if(param1.module == UIModuleTypes.TRAINER_UI)
         {
            if(param1.module == UIModuleTypes.TRAINER_UI)
            {
               this._trainerUIComplete = true;
            }
            if(this._trainerUIComplete)
            {
               dispatchEvent(new Event(USER_GUILD_RESOURCE_COMPLETE));
            }
         }
         if(param1.module == UIModuleTypes.IM)
         {
            this._uiLoadComplete = true;
            this._templeIsComplete = false;
            TempleteLoader.instance.addEventListener(Event.COMPLETE,this.__templeteCompleted);
            TempleteLoader.instance.start();
            CusCursorManager.instance.Setup();
         }
      }
      
      protected function __templeteCompleted(param1:Event) : void
      {
         LoadInterfaceManager.traceMsg("模板加载完成");
         TempleteLoader.instance.removeEventListener(Event.COMPLETE,this.__templeteCompleted);
         this._templeIsComplete = true;
         if(this._perloadComplete)
         {
            this.loadUserData();
         }
         BagAndInfoManager.Instance.setup();
         dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.CORE_SETUP_COMPLETE));
      }
      
      public function loadUserData() : Boolean
      {
         if(!this._templeIsComplete)
         {
            this._perloadComplete = true;
            return false;
         }
         this._loaderQueue = new QueueLoader();
         this._loaderQueue.addEventListener(Event.CHANGE,this.__onSetupSourceLoadChange);
         this._loaderQueue.addEventListener(Event.COMPLETE,this.__onSetupSourceLoadComplete);
         this.addLoader(LoaderCreate.Instance.creatServerListLoader());
         this.addLoader(LoaderCreate.Instance.creatSelectListLoader());
         this.addLoader(LoaderCreate.Instance.creatMovingNotificationLoader());
         this._loaderQueue.start();
         return true;
      }
      
      private function addLoader(param1:BaseLoader) : void
      {
         var loader:BaseLoader = param1;
         loader.analyzer.analyzeErrorCall = function():void
         {
         };
         this._loaderQueue.addLoader(loader);
      }
      
      private function __onSetupSourceLoadChange(param1:Event) : void
      {
         this._requestCompleted = (param1.currentTarget as QueueLoader).completeCount;
      }
      
      private function addRegisterUIModule() : void
      {
         if(this._currentMode == NEWBIE)
         {
            this.addUIModlue(UIModuleTypes.ROAD_COMPONENT);
            this.addUIModlue(UIModuleTypes.BUTTON);
            this.addUIModlue(UIModuleTypes.DDTCORESCALEBITMAP);
            this.addUIModlue(UIModuleTypes.NEWCORESCALEBITMAP);
            this.addUIModlue(UIModuleTypes.CORE_ICON_AND_TIP);
            this.addUIModlue(UIModuleTypes.FIRST_CORE);
            this.addUIModlue(UIModuleTypes.DDT_COREI);
            this.addUIModlue(UIModuleTypes.DDT_COREII);
            this.addUIModlue(UIModuleTypes.CHAT);
            this.addUIModlue(UIModuleTypes.CHATII);
            this.addUIModlue(UIModuleTypes.PLAYER_TIP);
            this.addUIModlue(UIModuleTypes.LEVEL_ICON);
            this.addUIModlue(UIModuleTypes.ENTHRALL);
            this.addUIModlue(UIModuleTypes.TOOLBAR);
            this.addUIModlue(UIModuleTypes.DDT_TIMEBOX);
            this.addUIModlue(UIModuleTypes.TRAINER_UI);
            this.addUIModlue(UIModuleTypes.DIALOGHEADIMG);
            this.addUIModlue(UIModuleTypes.DIALOGHEADIMGII);
            this.addUIModlue(UIModuleTypes.CHAT_BALL);
            this.addUIModlue(UIModuleTypes.IM);
         }
      }
      
      public function addThirdGameUI() : void
      {
         firstEnterHall = false;
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_HALL);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_COREI);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_COREII);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTCORESCALEBITMAP);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.NEWCORESCALEBITMAP);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.CORE_ICON_AND_TIP);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.CHATII);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.PLAYER_TIP);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.LEVEL_ICON);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.IM);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_TIMEBOX);
      }
      
      private function loadUIModule() : void
      {
         if(this._currentMode == NORMAL)
         {
            this.addUIModlue(UIModuleTypes.ROAD_COMPONENT);
            this.addUIModlue(UIModuleTypes.BUTTON);
            this.addUIModlue(UIModuleTypes.DDTCORESCALEBITMAP);
            this.addUIModlue(UIModuleTypes.NEWCORESCALEBITMAP);
            this.addUIModlue(UIModuleTypes.CORE_ICON_AND_TIP);
            this.addUIModlue(UIModuleTypes.FIRST_CORE);
            this.addUIModlue(UIModuleTypes.DDT_COREI);
            this.addUIModlue(UIModuleTypes.DDT_COREII);
            this.addUIModlue(UIModuleTypes.CHAT);
            this.addUIModlue(UIModuleTypes.CHATII);
            this.addUIModlue(UIModuleTypes.PLAYER_TIP);
            this.addUIModlue(UIModuleTypes.LEVEL_ICON);
            this.addUIModlue(UIModuleTypes.ENTHRALL);
            this.addUIModlue(UIModuleTypes.DDT_HALL);
            this.addUIModlue(UIModuleTypes.TOOLBAR);
            this.addUIModlue(UIModuleTypes.DDT_TIMEBOX);
            this.addUIModlue(UIModuleTypes.GAMEIII);
            this.addUIModlue(UIModuleTypes.CHAT_BALL);
            this.addUIModlue(UIModuleTypes.TRAINER_UI);
            this.addUIModlue(UIModuleTypes.DIALOGHEADIMG);
            this.addUIModlue(UIModuleTypes.DIALOGHEADIMGII);
            this.addUIModlue(UIModuleTypes.IM);
            this.addUIModlue(UIModuleTypes.WORLDBOSS_MAP);
         }
      }
      
      public function addFirstGameNotStartupNeededResource() : void
      {
         this.addUIModlue(UIModuleTypes.DDTSINGLEDUNGEON);
         this.addUIModlue(UIModuleTypes.WORLDBOSS_MAP);
         this.addUIModlue(UIModuleTypes.GAME);
         this.addUIModlue(UIModuleTypes.GAMEII);
         this.addUIModlue(UIModuleTypes.EXPRESSION);
         this.addUIModlue(UIModuleTypes.GAMEOVER);
      }
      
      public function addNotStartupNeededResource() : void
      {
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTROOMLIST);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTROOM);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTROOMLOADING);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.GAME);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.GAMEII);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.GAMEIII);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.NEWBAGANDINFO);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.WORLDBOSS_MAP);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTSTORE);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.IM);
      }
      
      public function sendGameBegin() : void
      {
         dispatchEvent(new Event("game_begin"));
      }
      
      private function addUIModlue(param1:String) : void
      {
         UIModuleLoader.Instance.addUIModlue(param1);
         this.setLoaderProgressArr(param1);
      }
      
      private function _setStageRightMouse() : void
      {
         LayerManager.Instance.getLayerByType(LayerManager.STAGE_BOTTOM_LAYER).contextMenu = this.creatRightMenu();
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.addCallback("sendSwfNowUrl",this.receivedFromJavaScript);
         }
      }
      
      private function creatRightMenu() : ContextMenu
      {
         var _loc1_:ContextMenu = new ContextMenu();
         _loc1_.hideBuiltInItems();
         var _loc2_:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.share"));
         _loc2_.separatorBefore = true;
         _loc1_.customItems.push(_loc2_);
         _loc2_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onQQMSNClick);
         var _loc3_:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.collection"));
         _loc3_.separatorBefore = true;
         _loc1_.customItems.push(_loc3_);
         _loc3_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.addFavClick);
         var _loc4_:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.supply"));
         _loc4_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.goPayClick);
         _loc1_.customItems.push(_loc4_);
         _loc1_.builtInItems.zoom = true;
         return _loc1_;
      }
      
      private function onQQMSNClick(param1:ContextMenuEvent) : void
      {
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.call("getLocationUrl","");
         }
      }
      
      public function receivedFromJavaScript(param1:String) : void
      {
         this._receivedFromJavaScriptII(param1);
      }
      
      private function _receivedFromJavaScriptII(param1:String) : void
      {
         System.setClipboard(param1);
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("crazytank.copyOK"),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function SendVersion() : void
      {
         var _loc1_:URLVariables = new URLVariables();
         var _loc2_:URLLoader = new URLLoader();
         _loc1_.version = Capabilities.version.split(" ")[1];
         var _loc3_:URLRequest = new URLRequest(PathManager.solveRequestPath("UpdateVersion.ashx"));
         _loc3_.method = URLRequestMethod.POST;
         _loc3_.data = _loc1_;
         _loc2_.load(_loc3_);
      }
      
      private function addFavClick(param1:ContextMenuEvent) : void
      {
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.call("addToFavorite","");
         }
      }
      
      private function goPayClick(param1:ContextMenuEvent) : void
      {
         LeavePageManager.leaveToFillPath();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(param1.target);
      }
   }
}
