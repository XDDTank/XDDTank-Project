// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.LoadResourceManager

package com.pickgliss.loader
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import com.pickgliss.events.LoaderResourceEvent;
    import flash.net.URLVariables;
    import __AS3__.vec.*;

    [Event(name="init complete", type="com.pickgliss.events.LoaderResourceEvent")]
    [Event(name="complete", type="com.pickgliss.events.LoaderResourceEvent")]
    [Event(name="delete", type="com.pickgliss.events.LoaderResourceEvent")]
    [Event(name="loadError", type="com.pickgliss.events.LoaderResourceEvent")]
    [Event(name="progress", type="com.pickgliss.events.LoaderResourceEvent")]
    public class LoadResourceManager extends EventDispatcher 
    {

        private static var _instance:LoadResourceManager;

        private var _infoSite:String = "";
        private var _loadingUrl:String = "";
        private var _clientType:int;
        private var _loadDic:Dictionary;
        private var _deleteList:Vector.<String>;
        private var _currentDeletePath:String;
        private var _progress:int;
        private var _loaderID:uint;

        public function LoadResourceManager(_arg_1:Singleton)
        {
            if ((!(_arg_1)))
            {
                throw (Error("单例无法实例化"));
            };
        }

        public static function get instance():LoadResourceManager
        {
            return (_instance = ((_instance) || (new LoadResourceManager(new Singleton()))));
        }


        public function init(_arg_1:String=""):void
        {
            this._infoSite = _arg_1;
            var _local_2:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
            LoaderManager.Instance.setup(_local_2, String(Math.random()));
            LoadInterfaceManager.initAppInterface();
            LoadInterfaceManager.checkClientType();
        }

        public function addMicroClientEvent():void
        {
            LoadInterfaceManager.eventDispatcher.addEventListener(LoadInterfaceEvent.CHECK_COMPLETE, this.__checkComplete);
            LoadInterfaceManager.eventDispatcher.addEventListener(LoadInterfaceEvent.DELETE_COMPLETE, this.__deleteComplete);
            LoadInterfaceManager.eventDispatcher.addEventListener(LoadInterfaceEvent.FLASH_GOTO_AND_PLAY, this.__flashGotoAndPlay);
        }

        public function setLoginType(_arg_1:Number, _arg_2:String="", _arg_3:String="-1"):void
        {
            this._clientType = int(_arg_1);
            this._loadingUrl = _arg_2;
            LoaderSavingManager.Version = int(_arg_3);
            this.setup();
            LoadInterfaceManager.traceMsg(("loadingUrl:" + this._loadingUrl));
            LoadInterfaceManager.traceMsg("初始化完成");
            dispatchEvent(new LoaderResourceEvent(LoaderResourceEvent.INIT_COMPLETE));
        }

        public function setup():void
        {
            this._loadDic = new Dictionary();
            this._deleteList = new Vector.<String>();
        }

        public function createLoader(_arg_1:String, _arg_2:int, _arg_3:URLVariables=null, _arg_4:String="GET", _arg_5:ApplicationDomain=null):*
        {
            if ((((((!(_arg_2 == BaseLoader.COMPRESS_REQUEST_LOADER)) && (!(_arg_2 == BaseLoader.COMPRESS_TEXT_LOADER))) && (!(_arg_2 == BaseLoader.TEXT_LOADER))) && (!(_arg_2 == BaseLoader.REQUEST_LOADER))) && (!(_arg_2 == BaseLoader.BYTE_LOADER))))
            {
                _arg_1 = _arg_1.toLowerCase();
            };
            return (this.createOriginLoader(_arg_1, this._infoSite, _arg_2, _arg_3, _arg_4, _arg_5, true));
        }

        public function createOriginLoader(_arg_1:String, _arg_2:String, _arg_3:int, _arg_4:URLVariables=null, _arg_5:String="GET", _arg_6:ApplicationDomain=null, _arg_7:Boolean=false):*
        {
            var _local_8:BaseLoader;
            var _local_9:int;
            var _local_10:String;
            var _local_11:String;
            if ((((_arg_7) && (this._clientType == 1)) && ([BaseLoader.TEXT_LOADER, BaseLoader.COMPRESS_TEXT_LOADER, BaseLoader.REQUEST_LOADER, BaseLoader.COMPRESS_REQUEST_LOADER].indexOf(_arg_3) == -1)))
            {
                LoadInterfaceManager.traceMsg(("请求加载:" + _arg_1));
                _local_9 = _arg_2.length;
                _local_10 = ((_arg_1.substring(_local_9, _arg_1.length) + "?loaderID=") + this._loaderID);
                _local_8 = LoaderManager.Instance.creatLoaderByType(_local_10, _arg_3, _arg_4, _arg_5, _arg_6);
                this._loadDic[_local_8.id] = _local_8;
                this._loaderID++;
            }
            else
            {
                _local_11 = this.fixedVariablesURL(_arg_1, _arg_3, _arg_4);
                _local_8 = LoaderManager.Instance.creatLoaderByType(_local_11, _arg_3, _arg_4, _arg_5, _arg_6);
            };
            return (_local_8);
        }

        public function creatAndStartLoad(_arg_1:String, _arg_2:int):void
        {
            this.startLoad(this.createLoader(_arg_1, _arg_2));
        }

        public function startLoad(_arg_1:BaseLoader, _arg_2:Boolean=false, _arg_3:Boolean=true):void
        {
            this.startLoadFromLoadingUrl(_arg_1, this._infoSite, _arg_2, _arg_3);
        }

        public function startLoadFromLoadingUrl(_arg_1:BaseLoader, _arg_2:String, _arg_3:Boolean=false, _arg_4:Boolean=true):void
        {
            var _local_5:String = _arg_1.url;
            _local_5 = _local_5.replace(/\?.*/, "");
            if ((((_arg_4) && (this._clientType == 1)) && ([BaseLoader.TEXT_LOADER, BaseLoader.COMPRESS_TEXT_LOADER, BaseLoader.REQUEST_LOADER, BaseLoader.COMPRESS_REQUEST_LOADER].indexOf(_arg_1.type) == -1)))
            {
                LoadInterfaceManager.checkResource(_arg_1.id, _arg_2, _local_5, _arg_3);
            }
            else
            {
                this.beginLoad(_arg_1, _arg_3);
            };
        }

        public function fixedVariablesURL(_arg_1:String, _arg_2:int, _arg_3:URLVariables):String
        {
            var _local_4:String;
            var _local_5:int;
            var _local_6:String;
            if (((!(_arg_2 == BaseLoader.REQUEST_LOADER)) && (!(_arg_2 == BaseLoader.COMPRESS_REQUEST_LOADER))))
            {
                _local_4 = "";
                if (_arg_3 == null)
                {
                    _arg_3 = new URLVariables();
                };
                if (((((_arg_2 == BaseLoader.BYTE_LOADER) || (_arg_2 == BaseLoader.DISPLAY_LOADER)) || (_arg_2 == BaseLoader.BITMAP_LOADER)) || (_arg_2 == BaseLoader.MODULE_LOADER)))
                {
                    _arg_3["lv"] = LoaderSavingManager.Version;
                }
                else
                {
                    if (((_arg_2 == BaseLoader.COMPRESS_TEXT_LOADER) || (_arg_2 == BaseLoader.TEXT_LOADER)))
                    {
                        _arg_3["rnd"] = TextLoader.TextLoaderKey;
                    };
                };
                _local_5 = 0;
                for (_local_6 in _arg_3)
                {
                    if (_local_5 >= 1)
                    {
                        _local_4 = (_local_4 + ((("&" + _local_6) + "=") + _arg_3[_local_6]));
                    }
                    else
                    {
                        _local_4 = (_local_4 + ((_local_6 + "=") + _arg_3[_local_6]));
                    };
                    _local_5++;
                };
                return ((_arg_1 + "?") + _local_4);
            };
            return (_arg_1);
        }

        private function beginLoad(_arg_1:BaseLoader, _arg_2:Boolean=false):void
        {
            this.addLoaderEvent(_arg_1);
            LoadInterfaceManager.traceMsg(((("flash下载:" + _arg_1.url) + "是否立刻加载:") + _arg_2));
            LoaderManager.Instance.startLoad(_arg_1, _arg_2);
        }

        protected function __onLoadError(_arg_1:LoaderEvent):void
        {
            var _local_2:BaseLoader = (_arg_1.target as BaseLoader);
            this.removeLoaderEvent(_local_2);
            LoadInterfaceManager.traceMsg(("本地加载错误:" + _local_2.url));
        }

        protected function __onProgress(_arg_1:LoaderEvent):void
        {
            var _local_3:LoaderResourceEvent;
            var _local_2:BaseLoader = (_arg_1.target as BaseLoader);
            if ((!(this.isMicroClient)))
            {
                this._progress = _local_2.progress;
                _local_3 = new LoaderResourceEvent(LoaderResourceEvent.PROGRESS);
                _local_3.data = _local_2.progress;
                dispatchEvent(_local_3);
            };
        }

        protected function __onComplete(_arg_1:LoaderEvent):void
        {
            var _local_3:LoaderResourceEvent;
            var _local_2:BaseLoader = (_arg_1.target as BaseLoader);
            LoadInterfaceManager.traceMsg(("flash下载完成:" + _local_2.url));
            this.removeLoaderEvent(_local_2);
            delete this._loadDic[_local_2.id];
            if (_local_2.isSuccess)
            {
                _local_3 = new LoaderResourceEvent(LoaderResourceEvent.COMPLETE);
                _local_3.filePath = _local_2.url;
                dispatchEvent(_local_3);
            };
        }

        private function addLoaderEvent(_arg_1:BaseLoader):void
        {
            _arg_1.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _arg_1.addEventListener(LoaderEvent.PROGRESS, this.__onProgress);
            _arg_1.addEventListener(LoaderEvent.COMPLETE, this.__onComplete);
        }

        private function removeLoaderEvent(_arg_1:BaseLoader):void
        {
            _arg_1.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _arg_1.removeEventListener(LoaderEvent.PROGRESS, this.__onProgress);
            _arg_1.removeEventListener(LoaderEvent.COMPLETE, this.__onComplete);
        }

        public function addDeleteRequest(_arg_1:String):void
        {
            this._deleteList.push(_arg_1);
        }

        public function startDelete():void
        {
            if (this._clientType != 1)
            {
                this._deleteList.length = 0;
            };
            this.deleteNext();
        }

        private function deleteNext():void
        {
            var _local_1:LoaderResourceEvent;
            if (this._deleteList.length > 0)
            {
                this._currentDeletePath = this._deleteList.shift();
                this.deleteResource(this._currentDeletePath);
            }
            else
            {
                _local_1 = new LoaderResourceEvent(LoaderResourceEvent.DELETE);
                dispatchEvent(_local_1);
            };
        }

        public function deleteResource(_arg_1:String):void
        {
            LoadInterfaceManager.traceMsg(("删除:" + _arg_1));
            LoadInterfaceManager.deleteResource(_arg_1);
        }

        protected function __checkComplete(_arg_1:LoadInterfaceEvent):void
        {
            this.checkComplete(_arg_1.paras[0], _arg_1.paras[1], _arg_1.paras[2], _arg_1.paras[3]);
        }

        protected function __deleteComplete(_arg_1:LoadInterfaceEvent):void
        {
            if (this._currentDeletePath == _arg_1.paras[1])
            {
                this.deleteComlete(_arg_1.paras[0], _arg_1.paras[1]);
            };
        }

        protected function __flashGotoAndPlay(_arg_1:LoadInterfaceEvent):void
        {
            this.flashGotoAndPlay(_arg_1.paras[0]);
        }

        public function checkComplete(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String):void
        {
            var _local_5:LoaderResourceEvent;
            if (_arg_2 == "true")
            {
                LoadInterfaceManager.traceMsg(((((((("微端下载成功,id=" + _arg_1) + ",flag=") + _arg_2) + ",httpurl=") + _arg_3) + ",filename") + _arg_4));
                this.beginLoad(this._loadDic[int(_arg_1)]);
                _local_5 = new LoaderResourceEvent(LoaderResourceEvent.COMPLETE);
                _local_5.filePath = _arg_3;
                _local_5.data = _arg_2;
                dispatchEvent(_local_5);
            }
            else
            {
                this.beginLoad(this._loadDic[int(_arg_1)]);
                LoadInterfaceManager.traceMsg(((("微端下载失败" + _arg_2) + ":") + _arg_4));
                _local_5 = new LoaderResourceEvent(LoaderResourceEvent.LOAD_ERROR);
                _local_5.filePath = _arg_3;
                _local_5.data = _arg_2;
                dispatchEvent(_local_5);
            };
            this._progress = 100;
        }

        public function deleteComlete(_arg_1:String, _arg_2:String):void
        {
            LoadInterfaceManager.traceMsg(((("微端删除" + _arg_1) + ":") + _arg_2));
            this.deleteNext();
        }

        public function flashGotoAndPlay(_arg_1:Number):void
        {
            this._progress = _arg_1;
            var _local_2:LoaderResourceEvent = new LoaderResourceEvent(LoaderResourceEvent.PROGRESS);
            _local_2.data = _arg_1;
            dispatchEvent(_local_2);
        }

        public function get Progress():int
        {
            return (this._progress);
        }

        public function get isMicroClient():Boolean
        {
            return (this._clientType == 1);
        }

        public function get clientType():int
        {
            return (this._clientType);
        }

        public function get infoSite():String
        {
            return (this._infoSite);
        }

        public function set infoSite(_arg_1:String):void
        {
            this._infoSite = _arg_1;
        }

        public function get loadingUrl():String
        {
            return (this._loadingUrl);
        }


    }
}//package com.pickgliss.loader

class Singleton 
{


}


