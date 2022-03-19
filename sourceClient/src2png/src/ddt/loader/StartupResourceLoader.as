// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.loader.StartupResourceLoader

package ddt.loader
{
    import flash.events.EventDispatcher;
    import com.pickgliss.loader.BaseLoader;
    import flash.utils.Dictionary;
    import com.pickgliss.loader.QueueLoader;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.LeavePageManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.LoaderEvent;
    import flash.utils.ByteArray;
    import deng.fzip.FZip;
    import flash.events.Event;
    import com.pickgliss.ui.ComponentSetting;
    import com.pickgliss.loader.LoaderSavingManager;
    import com.pickgliss.loader.LoadInterfaceManager;
    import flash.external.ExternalInterface;
    import deng.fzip.FZipFile;
    import ddt.data.UIModuleTypes;
    import ddt.manager.PlayerManager;
    import email.manager.MailManager;
    import platformapi.tencent.DiamondManager;
    import ddt.manager.TaskDirectorManager;
    import com.pickgliss.events.ResourceLoaderEvent;
    import ddt.manager.CusCursorManager;
    import bagAndInfo.BagAndInfoManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.DesktopManager;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.events.ContextMenuEvent;
    import flash.system.System;
    import flash.net.URLVariables;
    import flash.net.URLLoader;
    import flash.system.Capabilities;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import ddt.manager.SoundManager;

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
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIMoudleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIModuleProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onUIModuleLoadError);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.RELOAD_XML, this.__reloadXML);
        }

        public static function get Instance():StartupResourceLoader
        {
            if (_instance == null)
            {
                _instance = new (StartupResourceLoader)();
            };
            return (_instance);
        }


        private function __reloadXML(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:String;
            var _local_4:BaseLoader;
            var _local_5:BaseLoader;
            var _local_6:BaseLoader;
            var _local_7:BaseLoader;
            var _local_3:PackageIn = _arg_1.pkg;
            _local_2 = _local_3.readUTF();
            switch (_local_2)
            {
                case "item":
                    _local_4 = LoaderCreate.Instance.creatItemTempleteReload();
                    LoadResourceManager.instance.startLoad(_local_4);
                    return;
                case "quest":
                    _local_4 = LoaderCreate.Instance.creatQuestTempleteReload();
                    LoadResourceManager.instance.startLoad(_local_4);
                    return;
                case "active":
                    _local_4 = LoaderCreate.Instance.creatActivityInfoListLoader();
                    _local_5 = LoaderCreate.Instance.creatActivityConditionListLoader();
                    _local_6 = LoaderCreate.Instance.creatActivityGiftbagListLoader();
                    _local_7 = LoaderCreate.Instance.creatActivityRewardListLoader();
                    LoadResourceManager.instance.startLoad(_local_4);
                    LoadResourceManager.instance.startLoad(_local_5);
                    LoadResourceManager.instance.startLoad(_local_6);
                    LoadResourceManager.instance.startLoad(_local_7);
                    return;
                default:
                    return;
            };
        }

        private function __onUIModuleLoadError(_arg_1:UIModuleEvent):void
        {
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"), LanguageMgr.GetTranslation("ddt.StartupResourceLoader.Error.LoadModuleError", _arg_1.module), LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
            _local_2.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            LeavePageManager.leaveToLoginPath();
        }

        public function get progress():int
        {
            if ((!(this._uiLoadComplete)))
            {
                return (int((this._uimoduleProgress * 30)) + 40);
            };
            if ((!(this._templeIsComplete)))
            {
                return (75 + Math.ceil((TempleteLoader.instance.progress * 25)));
            };
            return (99);
        }

        public function start(_arg_1:int):void
        {
            this._currentMode = _arg_1;
            this.loadLanguage();
        }

        private function loadLanguage():void
        {
            this._languagePath = PathManager.getLanguagePath();
            this._languageLoader = LoadResourceManager.instance.createLoader(this._languagePath, BaseLoader.BYTE_LOADER);
            this._languageLoader.addEventListener(LoaderEvent.COMPLETE, this.__onLoadLanZipComplete);
            LoadResourceManager.instance.startLoad(this._languageLoader);
        }

        private function __onLoadLanZipComplete(_arg_1:LoaderEvent):void
        {
            _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__onLoadLanZipComplete);
            var _local_2:ByteArray = _arg_1.loader.content;
            this.analyMd5(_local_2);
        }

        private function zipLoad(_arg_1:ByteArray):void
        {
            var _local_2:FZip = new FZip();
            _local_2.addEventListener(Event.COMPLETE, this.__onZipParaComplete);
            _local_2.loadBytes(_arg_1);
        }

        private function analyMd5(_arg_1:ByteArray):void
        {
            var _local_2:ByteArray;
            if (((ComponentSetting.USEMD5) && ((ComponentSetting.md5Dic["language.png"]) || (this.hasHead(_arg_1)))))
            {
                if (this.compareMD5(_arg_1))
                {
                    _local_2 = new ByteArray();
                    _arg_1.position = 37;
                    _arg_1.readBytes(_local_2);
                    this.zipLoad(_local_2);
                }
                else
                {
                    LoaderSavingManager.clearAllCache();
                    LoadInterfaceManager.alertAndRestart((this._languagePath + ":is old"));
                    if (this._isSecondLoad)
                    {
                        if (ExternalInterface.available)
                        {
                            ExternalInterface.call("alert", (this._languagePath + ":is old"));
                        };
                    }
                    else
                    {
                        this._languagePath = this._languagePath.replace(ComponentSetting.FLASHSITE, ComponentSetting.BACKUP_FLASHSITE);
                        this._languageLoader.url = ((this._languagePath + "?rnd=") + Math.random());
                        this._languageLoader.isLoading = false;
                        this._languageLoader.loadFromWeb();
                    };
                    this._isSecondLoad = true;
                };
            }
            else
            {
                this.zipLoad(_arg_1);
            };
        }

        private function hasHead(_arg_1:ByteArray):Boolean
        {
            var _local_3:int;
            var _local_4:int;
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUTFBytes(ComponentSetting.swf_head);
            _local_2.position = 0;
            _arg_1.position = 0;
            while (_local_2.bytesAvailable > 0)
            {
                _local_3 = _local_2.readByte();
                _local_4 = _arg_1.readByte();
                if (_local_3 != _local_4)
                {
                    return (false);
                };
            };
            return (true);
        }

        private function compareMD5(_arg_1:ByteArray):Boolean
        {
            var _local_3:int;
            var _local_4:int;
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUTFBytes(ComponentSetting.md5Dic["language.png"]);
            _local_2.position = 0;
            _arg_1.position = 5;
            while (_local_2.bytesAvailable > 0)
            {
                _local_3 = _local_2.readByte();
                _local_4 = _arg_1.readByte();
                if (_local_3 != _local_4)
                {
                    return (false);
                };
            };
            return (true);
        }

        private function __onZipParaComplete(_arg_1:Event):void
        {
            var _local_2:FZip = (_arg_1.currentTarget as FZip);
            _local_2.removeEventListener(Event.COMPLETE, this.__onZipParaComplete);
            var _local_3:FZipFile = _local_2.getFileAt(0);
            var _local_4:String = _local_3.content.toString();
            LanguageMgr.setup(_local_4);
            var _local_5:QueueLoader = new QueueLoader();
            _local_5.addLoader(LoaderCreate.Instance.creatZhanLoader());
            _local_5.addEventListener(Event.COMPLETE, this.__onLoadLanguageComplete);
            _local_5.start();
        }

        private function __onLoadLanguageComplete(_arg_1:Event):void
        {
            var _local_2:QueueLoader = (_arg_1.currentTarget as QueueLoader);
            _local_2.removeEventListener(Event.COMPLETE, this.__onLoadLanguageComplete);
            if (this._currentMode == NEWBIE)
            {
                this.addRegisterUIModule();
            }
            else
            {
                this.loadUIModule();
            };
            this._setStageRightMouse();
        }

        private function __onUIModuleProgress(_arg_1:UIModuleEvent):void
        {
            var _local_5:Number;
            var _local_2:BaseLoader = _arg_1.loader;
            this.setLoaderProgressArr(_arg_1.module, _local_2.progress);
            if ((!(this._progressArr)))
            {
                return;
            };
            var _local_3:Number = 0;
            var _local_4:int;
            for each (_local_5 in this._progressArr)
            {
                _local_3 = (_local_3 + _local_5);
                _local_4++;
            };
            this._uimoduleProgress = (_local_3 / _local_4);
        }

        private function setLoaderProgressArr(_arg_1:String, _arg_2:Number=0):void
        {
            if ((!(this._progressArr)))
            {
                this._progressArr = new Dictionary();
            };
            this._progressArr[_arg_1] = _arg_2;
        }

        public function addUserGuildResource():void
        {
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TRAINER_UI);
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.EXPRESSION);
        }

        public function finishLoadingProgress():void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIMoudleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIModuleProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__onUIModuleLoadError);
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function startLoadRelatedInfo():void
        {
            var _local_1:QueueLoader = new QueueLoader();
            if (PlayerManager.Instance.Self.Grade >= 20)
            {
                _local_1.addLoader(LoaderCreate.Instance.creatVoteSubmit());
            };
            this.SendVersion();
            _local_1.addLoader(LoaderCreate.Instance.creatFriendListLoader());
            _local_1.addLoader(LoaderCreate.Instance.getMyConsortiaData());
            _local_1.addLoader(LoaderCreate.Instance.createCalendarRequest());
            _local_1.addLoader(MailManager.Instance.getAllEmailLoader());
            _local_1.addLoader(MailManager.Instance.getSendedEmailLoader());
            _local_1.addLoader(LoaderCreate.Instance.creatFeedbackInfoLoader());
            _local_1.addLoader(LoaderCreate.Instance.createConsortiaLoader());
            if (DiamondManager.instance.isInTencent)
            {
                _local_1.addLoader(LoaderCreate.Instance.creatInvitedFriendListLoader());
            };
            _local_1.start();
        }

        private function __onSetupSourceLoadComplete(_arg_1:Event):void
        {
            var _local_2:QueueLoader = (_arg_1.currentTarget as QueueLoader);
            _local_2.removeEventListener(Event.COMPLETE, this.__onSetupSourceLoadComplete);
            _local_2.removeEventListener(Event.CHANGE, this.__onSetupSourceLoadChange);
            _local_2.dispose();
            _local_2 = null;
            TaskDirectorManager.instance.setup();
            dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.USER_DATA_COMPLETE));
        }

        private function __onUIMoudleComplete(_arg_1:UIModuleEvent):void
        {
            LoadInterfaceManager.traceMsg("模块加载完成,开始加载模板");
            if (_arg_1.module == UIModuleTypes.TRAINER_UI)
            {
                if (_arg_1.module == UIModuleTypes.TRAINER_UI)
                {
                    this._trainerUIComplete = true;
                };
                if (this._trainerUIComplete)
                {
                    dispatchEvent(new Event(USER_GUILD_RESOURCE_COMPLETE));
                };
            };
            if (_arg_1.module == UIModuleTypes.IM)
            {
                this._uiLoadComplete = true;
                this._templeIsComplete = false;
                TempleteLoader.instance.addEventListener(Event.COMPLETE, this.__templeteCompleted);
                TempleteLoader.instance.start();
                CusCursorManager.instance.Setup();
            };
        }

        protected function __templeteCompleted(_arg_1:Event):void
        {
            LoadInterfaceManager.traceMsg("模板加载完成");
            TempleteLoader.instance.removeEventListener(Event.COMPLETE, this.__templeteCompleted);
            this._templeIsComplete = true;
            if (this._perloadComplete)
            {
                this.loadUserData();
            };
            BagAndInfoManager.Instance.setup();
            dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.CORE_SETUP_COMPLETE));
        }

        public function loadUserData():Boolean
        {
            if ((!(this._templeIsComplete)))
            {
                this._perloadComplete = true;
                return (false);
            };
            this._loaderQueue = new QueueLoader();
            this._loaderQueue.addEventListener(Event.CHANGE, this.__onSetupSourceLoadChange);
            this._loaderQueue.addEventListener(Event.COMPLETE, this.__onSetupSourceLoadComplete);
            this.addLoader(LoaderCreate.Instance.creatServerListLoader());
            this.addLoader(LoaderCreate.Instance.creatSelectListLoader());
            this.addLoader(LoaderCreate.Instance.creatMovingNotificationLoader());
            this._loaderQueue.start();
            return (true);
        }

        private function addLoader(loader:BaseLoader):void
        {
            loader.analyzer.analyzeErrorCall = function ():void
            {
            };
            this._loaderQueue.addLoader(loader);
        }

        private function __onSetupSourceLoadChange(_arg_1:Event):void
        {
            this._requestCompleted = (_arg_1.currentTarget as QueueLoader).completeCount;
        }

        private function addRegisterUIModule():void
        {
            if (this._currentMode == NEWBIE)
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
            };
        }

        public function addThirdGameUI():void
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

        private function loadUIModule():void
        {
            if (this._currentMode == NORMAL)
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
            };
        }

        public function addFirstGameNotStartupNeededResource():void
        {
            this.addUIModlue(UIModuleTypes.DDTSINGLEDUNGEON);
            this.addUIModlue(UIModuleTypes.WORLDBOSS_MAP);
            this.addUIModlue(UIModuleTypes.GAME);
            this.addUIModlue(UIModuleTypes.GAMEII);
            this.addUIModlue(UIModuleTypes.EXPRESSION);
            this.addUIModlue(UIModuleTypes.GAMEOVER);
        }

        public function addNotStartupNeededResource():void
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

        public function sendGameBegin():void
        {
            dispatchEvent(new Event("game_begin"));
        }

        private function addUIModlue(_arg_1:String):void
        {
            UIModuleLoader.Instance.addUIModlue(_arg_1);
            this.setLoaderProgressArr(_arg_1);
        }

        private function _setStageRightMouse():void
        {
            LayerManager.Instance.getLayerByType(LayerManager.STAGE_BOTTOM_LAYER).contextMenu = this.creatRightMenu();
            if (((ExternalInterface.available) && (!(DesktopManager.Instance.isDesktop))))
            {
                ExternalInterface.addCallback("sendSwfNowUrl", this.receivedFromJavaScript);
            };
        }

        private function creatRightMenu():ContextMenu
        {
            var _local_1:ContextMenu = new ContextMenu();
            _local_1.hideBuiltInItems();
            var _local_2:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.share"));
            _local_2.separatorBefore = true;
            _local_1.customItems.push(_local_2);
            _local_2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onQQMSNClick);
            var _local_3:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.collection"));
            _local_3.separatorBefore = true;
            _local_1.customItems.push(_local_3);
            _local_3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.addFavClick);
            var _local_4:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.supply"));
            _local_4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.goPayClick);
            _local_1.customItems.push(_local_4);
            _local_1.builtInItems.zoom = true;
            return (_local_1);
        }

        private function onQQMSNClick(_arg_1:ContextMenuEvent):void
        {
            if (((ExternalInterface.available) && (!(DesktopManager.Instance.isDesktop))))
            {
                ExternalInterface.call("getLocationUrl", "");
            };
        }

        public function receivedFromJavaScript(_arg_1:String):void
        {
            this._receivedFromJavaScriptII(_arg_1);
        }

        private function _receivedFromJavaScriptII(_arg_1:String):void
        {
            System.setClipboard(_arg_1);
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("crazytank.copyOK"), "", "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
            _local_2.addEventListener(FrameEvent.RESPONSE, this._response);
        }

        private function SendVersion():void
        {
            var _local_1:URLVariables = new URLVariables();
            var _local_2:URLLoader = new URLLoader();
            _local_1.version = Capabilities.version.split(" ")[1];
            var _local_3:URLRequest = new URLRequest(PathManager.solveRequestPath("UpdateVersion.ashx"));
            _local_3.method = URLRequestMethod.POST;
            _local_3.data = _local_1;
            _local_2.load(_local_3);
        }

        private function addFavClick(_arg_1:ContextMenuEvent):void
        {
            if (((ExternalInterface.available) && (!(DesktopManager.Instance.isDesktop))))
            {
                ExternalInterface.call("addToFavorite", "");
            };
        }

        private function goPayClick(_arg_1:ContextMenuEvent):void
        {
            LeavePageManager.leaveToFillPath();
        }

        private function _response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = BaseAlerFrame(_arg_1.currentTarget);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this._response);
            ObjectUtils.disposeObject(_arg_1.target);
        }


    }
}//package ddt.loader

