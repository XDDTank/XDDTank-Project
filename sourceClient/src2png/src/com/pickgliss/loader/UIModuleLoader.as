// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.UIModuleLoader

package com.pickgliss.loader
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.ComponentSetting;
    import flash.utils.ByteArray;
    import flash.external.ExternalInterface;
    import deng.fzip.FZip;
    import flash.events.Event;
    import deng.fzip.FZipFile;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.UIModuleEvent;
    import __AS3__.vec.*;

    [Event(name="uiModuleComplete", type="com.pickgliss.events.UIModuleEvent")]
    [Event(name="uiModuleError", type="com.pickgliss.events.UIModuleEvent")]
    [Event(name="uiMoudleProgress", type="com.pickgliss.events.UIModuleEvent")]
    public class UIModuleLoader extends EventDispatcher 
    {

        public static const XMLPNG:String = "xml.png";
        public static const CONFIG_ZIP:String = "configZip";
        public static const CONFIG_XML:String = "configXml";
        private static var _baseUrl:String = "";
        private static var _instance:UIModuleLoader;

        private var _uiModuleLoadMode:String = "configXml";
        private var _loadedModules:Dictionary;
        private var _loadingLoaders:Vector.<BaseLoader>;
        private var _queue:Vector.<String>;
        private var _backupUrl:String = "";
        private var _zipPath:String = "";
        private var _zipLoadComplete:Boolean = true;
        private var _zipLoader:BaseLoader;
        private var _isSecondLoad:Boolean = false;

        public function UIModuleLoader()
        {
            this._queue = new Vector.<String>();
            this._loadingLoaders = new Vector.<BaseLoader>();
            this._loadedModules = new Dictionary();
        }

        public static function get Instance():UIModuleLoader
        {
            if (_instance == null)
            {
                _instance = new (UIModuleLoader)();
            };
            return (_instance);
        }


        public function addUIModlue(_arg_1:String):void
        {
            if (this._queue.indexOf(_arg_1) != -1)
            {
                return;
            };
            this._queue.push(_arg_1);
            if (((!(this.isLoading)) && (this._zipLoadComplete)))
            {
                this.loadNextModule();
            };
        }

        public function addUIModuleImp(_arg_1:String, _arg_2:String=null):void
        {
            var _local_3:int = this._queue.indexOf(_arg_1);
            if (_local_3 != -1)
            {
                this._queue.splice(_local_3, 1);
            };
            if (this._zipLoadComplete)
            {
                this.loadModuleConfig(_arg_1, _arg_2);
            }
            else
            {
                this._queue.unshift(_arg_1);
                this.loadNextModule();
            };
        }

        public function setup(_arg_1:String="", _arg_2:String=""):void
        {
            _baseUrl = _arg_1;
            this._backupUrl = _arg_2;
            ComponentSetting.FLASHSITE = _baseUrl;
            ComponentSetting.BACKUP_FLASHSITE = this._backupUrl;
            this._zipPath = (_baseUrl + ComponentSetting.getUIConfigZIPPath());
            this._uiModuleLoadMode = CONFIG_ZIP;
            this._zipLoadComplete = false;
            this.loadZipConfig();
        }

        public function get baseUrl():String
        {
            return (_baseUrl);
        }

        public function checkIsLoaded(_arg_1:String):Boolean
        {
            return (this._loadedModules[_arg_1]);
        }

        private function loadZipConfig():void
        {
            if (this._uiModuleLoadMode == CONFIG_XML)
            {
                return;
            };
            this._zipLoader = LoadResourceManager.instance.createLoader(this._zipPath, BaseLoader.BYTE_LOADER);
            this._zipLoader.addEventListener(LoaderEvent.COMPLETE, this.__onLoadZipComplete);
            LoadResourceManager.instance.startLoad(this._zipLoader);
        }

        private function __onLoadZipComplete(_arg_1:LoaderEvent):void
        {
            this._zipLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onLoadZipComplete);
            var _local_2:ByteArray = this._zipLoader.content;
            this.analyMd5(_local_2);
        }

        public function analyMd5(_arg_1:ByteArray):void
        {
            var _local_2:ByteArray;
            if (((ComponentSetting.USEMD5) && ((ComponentSetting.md5Dic[XMLPNG]) || (this.hasHead(_arg_1)))))
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
                    if (this._isSecondLoad)
                    {
                        if (ExternalInterface.available)
                        {
                            ExternalInterface.call("alert", (this._zipPath + ":is old"));
                            LoadInterfaceManager.alertAndRestart((this._zipPath + ":is old"));
                        };
                    }
                    else
                    {
                        this._zipPath = this._zipPath.replace(ComponentSetting.FLASHSITE, ComponentSetting.BACKUP_FLASHSITE);
                        this._zipLoader = LoadResourceManager.instance.createLoader(((this._zipPath + "?rnd=") + Math.random()), BaseLoader.BYTE_LOADER);
                        this._zipLoader.addEventListener(LoaderEvent.COMPLETE, this.__onLoadZipComplete);
                        LoadResourceManager.instance.startLoad(this._zipLoader);
                    };
                    this._isSecondLoad = true;
                };
            }
            else
            {
                this.zipLoad(_arg_1);
            };
        }

        private function compareMD5(_arg_1:ByteArray):Boolean
        {
            var _local_3:int;
            var _local_4:int;
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUTFBytes(ComponentSetting.md5Dic[XMLPNG]);
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

        private function zipLoad(_arg_1:ByteArray):void
        {
            var _local_2:FZip = new FZip();
            _local_2.addEventListener(Event.COMPLETE, this.__onZipParaComplete);
            _local_2.loadBytes(_arg_1);
        }

        private function __onZipParaComplete(_arg_1:Event):void
        {
            var _local_5:FZipFile;
            var _local_6:XML;
            var _local_2:FZip = (_arg_1.currentTarget as FZip);
            _local_2.removeEventListener(Event.COMPLETE, this.__onZipParaComplete);
            var _local_3:int = _local_2.getFileCount();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = _local_2.getFileAt(_local_4);
                _local_6 = new XML(_local_5.content.toString());
                ComponentFactory.Instance.setup(_local_6);
                _local_4++;
            };
            this._zipLoadComplete = true;
            this.loadNextModule();
        }

        public function get isLoading():Boolean
        {
            return (this._loadingLoaders.length > 0);
        }

        private function __onConfigLoadComplete(_arg_1:LoaderEvent):void
        {
            var _local_2:XML;
            var _local_3:String;
            _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__onConfigLoadComplete);
            _arg_1.loader.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            this._loadingLoaders.splice(this._loadingLoaders.indexOf(_arg_1.loader), 1);
            if (_arg_1.loader.isSuccess)
            {
                _local_2 = new XML(_arg_1.loader.content);
                _local_3 = _local_2.@source;
                ComponentFactory.Instance.setup(_local_2);
                this.loadModuleUI(_local_3, _arg_1.loader.loadProgressMessage, _arg_1.loader.loadCompleteMessage);
            }
            else
            {
                this.removeLastLoader(_arg_1.loader);
                dispatchEvent(new UIModuleEvent(UIModuleEvent.UI_MODULE_COMPLETE, _arg_1.loader));
                this.loadNextModule();
            };
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
            dispatchEvent(new UIModuleEvent(UIModuleEvent.UI_MODULE_ERROR, _arg_1.loader));
        }

        private function __onResourceComplete(_arg_1:LoaderEvent):void
        {
            _arg_1.loader.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _arg_1.loader.removeEventListener(LoaderEvent.PROGRESS, this.__onResourceProgress);
            _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__onResourceComplete);
            this.removeLastLoader(_arg_1.loader);
            dispatchEvent(new UIModuleEvent(UIModuleEvent.UI_MODULE_COMPLETE, _arg_1.loader));
            this.loadNextModule();
        }

        private function removeLastLoader(_arg_1:BaseLoader):void
        {
            this._loadedModules[_arg_1.loadProgressMessage] = true;
            this._loadingLoaders.splice(this._loadingLoaders.indexOf(_arg_1), 1);
            this._queue.splice(this._queue.indexOf(_arg_1.loadProgressMessage), 1);
        }

        private function __onResourceProgress(_arg_1:LoaderEvent):void
        {
            dispatchEvent(new UIModuleEvent(UIModuleEvent.UI_MODULE_PROGRESS, _arg_1.loader));
        }

        private function loadNextModule():void
        {
            if (this._queue.length <= 0)
            {
                return;
            };
            var _local_1:String = this._queue[0];
            if ((!(this.isLoadingModule(_local_1))))
            {
                this.loadModuleConfig(_local_1);
            };
        }

        private function isLoadingModule(_arg_1:String):Boolean
        {
            var _local_2:int;
            while (_local_2 < this._loadingLoaders.length)
            {
                if (this._loadingLoaders[_local_2].loadProgressMessage == _arg_1)
                {
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }

        private function loadModuleConfig(_arg_1:String, _arg_2:String=""):void
        {
            var _local_3:BaseLoader;
            if (this._uiModuleLoadMode == CONFIG_XML)
            {
                _local_3 = LoadResourceManager.instance.createLoader((_baseUrl + ComponentSetting.getUIConfigXMLPath(_arg_1)), BaseLoader.TEXT_LOADER);
                _local_3.loadProgressMessage = _arg_1;
                _local_3.loadCompleteMessage = _arg_2;
                _local_3.addEventListener(LoaderEvent.COMPLETE, this.__onConfigLoadComplete);
                _local_3.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
                _local_3.loadErrorMessage = (("加载UI配置文件" + _local_3.url) + "出现错误");
                this._loadingLoaders.push(_local_3);
                LoadResourceManager.instance.startLoad(_local_3, true);
            }
            else
            {
                this.loadModuleUI((_baseUrl + ComponentSetting.getUISourcePath(_arg_1)), _arg_1, _arg_2);
            };
        }

        private function loadModuleUI(_arg_1:String, _arg_2:String="", _arg_3:String=""):void
        {
            var _local_4:BaseLoader = LoadResourceManager.instance.createLoader(_arg_1, BaseLoader.MODULE_LOADER);
            _local_4.loadProgressMessage = _arg_2;
            _local_4.loadCompleteMessage = _arg_3;
            _local_4.loadErrorMessage = (("加载ui资源：" + _local_4.url) + "出现错误");
            _local_4.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_4.addEventListener(LoaderEvent.PROGRESS, this.__onResourceProgress);
            _local_4.addEventListener(LoaderEvent.COMPLETE, this.__onResourceComplete);
            this._loadingLoaders.push(_local_4);
            LoadResourceManager.instance.startLoad(_local_4, true);
        }


    }
}//package com.pickgliss.loader

