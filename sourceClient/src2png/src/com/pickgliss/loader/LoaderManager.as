// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.LoaderManager

package com.pickgliss.loader
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import flash.net.URLVariables;
    import flash.system.ApplicationDomain;
    import flash.utils.ByteArray;
    import flash.external.ExternalInterface;
    import flash.utils.setTimeout;
    import flash.system.LoaderContext;
    import __AS3__.vec.*;

    public class LoaderManager extends EventDispatcher 
    {

        public static const ALLOW_MUTI_LOAD_COUNT:int = 8;
        public static const LOAD_FROM_LOCAL:int = 2;
        public static const LOAD_FROM_WEB:int = 1;
        public static const LOAD_NOT_SET:int = 0;
        private static var _instance:LoaderManager;

        private var _loadMode:int = 0;
        private var _loaderIdCounter:int = 0;
        private var _loaderSaveByID:Dictionary;
        private var _loaderSaveByPath:Dictionary;
        private var _loadingLoaderList:Vector.<BaseLoader>;
        private var _waitingLoaderList:Vector.<BaseLoader>;

        public function LoaderManager()
        {
            this._loaderSaveByID = new Dictionary();
            this._loaderSaveByPath = new Dictionary();
            this._loadingLoaderList = new Vector.<BaseLoader>();
            this._waitingLoaderList = new Vector.<BaseLoader>();
            this.initLoadMode();
        }

        public static function get Instance():LoaderManager
        {
            if (_instance == null)
            {
                _instance = new (LoaderManager)();
            };
            return (_instance);
        }


        public function creatLoaderByType(_arg_1:String, _arg_2:int, _arg_3:URLVariables, _arg_4:String, _arg_5:ApplicationDomain):BaseLoader
        {
            var _local_6:BaseLoader;
            switch (_arg_2)
            {
                case BaseLoader.BITMAP_LOADER:
                    _local_6 = new BitmapLoader(this.getNextLoaderID(), _arg_1);
                    break;
                case BaseLoader.TEXT_LOADER:
                    _local_6 = new TextLoader(this.getNextLoaderID(), _arg_1, _arg_3);
                    break;
                case BaseLoader.DISPLAY_LOADER:
                    _local_6 = new DisplayLoader(this.getNextLoaderID(), _arg_1);
                    break;
                case BaseLoader.BYTE_LOADER:
                    _local_6 = new BaseLoader(this.getNextLoaderID(), _arg_1);
                    break;
                case BaseLoader.COMPRESS_TEXT_LOADER:
                    _local_6 = new CompressTextLoader(this.getNextLoaderID(), _arg_1, _arg_3);
                    break;
                case BaseLoader.MODULE_LOADER:
                    _local_6 = new ModuleLoader(this.getNextLoaderID(), _arg_1, _arg_5);
                    break;
                case BaseLoader.REQUEST_LOADER:
                    _local_6 = new RequestLoader(this.getNextLoaderID(), _arg_1, _arg_3, _arg_4);
                    break;
                case BaseLoader.COMPRESS_REQUEST_LOADER:
                    _local_6 = new CompressRequestLoader(this.getNextLoaderID(), _arg_1, _arg_3, _arg_4);
                    break;
            };
            return (_local_6);
        }

        public function getLoadMode():int
        {
            return (this._loadMode);
        }

        public function creatLoader(_arg_1:String, _arg_2:int, _arg_3:URLVariables=null, _arg_4:String="GET", _arg_5:ApplicationDomain=null):*
        {
            var _local_6:BaseLoader;
            if ((((((!(_arg_2 == BaseLoader.COMPRESS_REQUEST_LOADER)) && (!(_arg_2 == BaseLoader.COMPRESS_TEXT_LOADER))) && (!(_arg_2 == BaseLoader.TEXT_LOADER))) && (!(_arg_2 == BaseLoader.REQUEST_LOADER))) && (!(_arg_2 == BaseLoader.BYTE_LOADER))))
            {
                _arg_1 = _arg_1.toLowerCase();
            };
            var _local_7:String = this.fixedVariablesURL(_arg_1, _arg_2, _arg_3);
            _local_6 = this.getLoaderByURL(_local_7, _arg_3);
            if (_local_6 == null)
            {
                _local_6 = this.creatLoaderByType(_local_7, _arg_2, _arg_3, _arg_4, _arg_5);
            }
            else
            {
                _local_6.domain = _arg_5;
            };
            if ((((!(_arg_2 == BaseLoader.REQUEST_LOADER)) && (!(_arg_2 == BaseLoader.COMPRESS_REQUEST_LOADER))) && (!(_arg_2 == BaseLoader.BITMAP_LOADER))))
            {
                this._loaderSaveByID[_local_6.id] = _local_6;
                this._loaderSaveByPath[_local_6.url] = _local_6;
            };
            return (_local_6);
        }

        public function creatLoaderOriginal(_arg_1:String, _arg_2:int, _arg_3:URLVariables=null, _arg_4:String="GET"):*
        {
            var _local_5:BaseLoader;
            var _local_6:String = this.fixedVariablesURL(_arg_1, _arg_2, _arg_3);
            _local_5 = this.getLoaderByURL(_local_6, _arg_3);
            if (_local_5 == null)
            {
                _local_5 = this.creatLoaderByType(_local_6, _arg_2, _arg_3, _arg_4, null);
            };
            if ((((!(_arg_2 == BaseLoader.REQUEST_LOADER)) && (!(_arg_2 == BaseLoader.COMPRESS_REQUEST_LOADER))) && (!(_arg_2 == BaseLoader.BITMAP_LOADER))))
            {
                this._loaderSaveByID[_local_5.id] = _local_5;
                this._loaderSaveByPath[_local_5.url] = _local_5;
            };
            return (_local_5);
        }

        public function creatAndStartLoad(_arg_1:String, _arg_2:int, _arg_3:URLVariables=null):BaseLoader
        {
            var _local_4:BaseLoader = this.creatLoader(_arg_1, _arg_2, _arg_3);
            this.startLoad(_local_4);
            return (_local_4);
        }

        public function getLoaderByID(_arg_1:int):BaseLoader
        {
            return (this._loaderSaveByID[_arg_1]);
        }

        public function getLoaderByURL(_arg_1:String, _arg_2:URLVariables):BaseLoader
        {
            return (this._loaderSaveByPath[_arg_1]);
        }

        public function getNextLoaderID():int
        {
            return (this._loaderIdCounter++);
        }

        public function saveFileToLocal(_arg_1:BaseLoader):void
        {
        }

        public function startLoad(_arg_1:BaseLoader, _arg_2:Boolean=false):void
        {
            if (_arg_1)
            {
                _arg_1.addEventListener(LoaderEvent.COMPLETE, this.__onLoadFinish);
            };
            if (_arg_1.isComplete)
            {
                _arg_1.dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE, _arg_1));
                return;
            };
            var _local_3:ByteArray = LoaderSavingManager.loadCachedFile(_arg_1.url, true);
            if (_local_3)
            {
                _arg_1.loadFromBytes(_local_3);
                return;
            };
            if ((((this._loadingLoaderList.length >= ALLOW_MUTI_LOAD_COUNT) && (!(_arg_2))) || (this.getLoadMode() == LOAD_NOT_SET)))
            {
                if (this._waitingLoaderList.indexOf(_arg_1) == -1)
                {
                    this._waitingLoaderList.push(_arg_1);
                };
            }
            else
            {
                if (this._loadingLoaderList.indexOf(_arg_1) == -1)
                {
                    this._loadingLoaderList.push(_arg_1);
                };
                if (((this.getLoadMode() == LOAD_FROM_WEB) || (_arg_1.type == BaseLoader.TEXT_LOADER)))
                {
                    _arg_1.loadFromWeb();
                }
                else
                {
                    if (this.getLoadMode() == LOAD_FROM_LOCAL)
                    {
                        _arg_1.getFilePathFromExternal();
                    };
                };
            };
        }

        private function __onLoadFinish(_arg_1:LoaderEvent):void
        {
            _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__onLoadFinish);
            this._loadingLoaderList.splice(this._loadingLoaderList.indexOf(_arg_1.loader), 1);
            this.tryLoadWaiting();
        }

        private function initLoadMode():void
        {
            if ((!(ExternalInterface.available)))
            {
                this.setFlashLoadWeb();
                return;
            };
            ExternalInterface.addCallback("SetFlashLoadExternal", this.setFlashLoadExternal);
            setTimeout(this.setFlashLoadWeb, 200);
        }

        private function onExternalLoadStop(_arg_1:int, _arg_2:String):void
        {
            var _local_3:BaseLoader = this.getLoaderByID(_arg_1);
            _local_3.loadFromExternal(_arg_2);
        }

        private function setFlashLoadExternal():void
        {
            this._loadMode = LOAD_FROM_LOCAL;
            ExternalInterface.addCallback("ExternalLoadStop", this.onExternalLoadStop);
            this.tryLoadWaiting();
        }

        private function setFlashLoadWeb():void
        {
            this._loadMode = LOAD_FROM_WEB;
            this.tryLoadWaiting();
        }

        private function tryLoadWaiting():void
        {
            var _local_2:BaseLoader;
            var _local_1:int;
            while (_local_1 < this._waitingLoaderList.length)
            {
                if (this._loadingLoaderList.length < ALLOW_MUTI_LOAD_COUNT)
                {
                    _local_2 = this._waitingLoaderList.shift();
                    this.startLoad(_local_2);
                };
                _local_1++;
            };
        }

        public function setup(_arg_1:LoaderContext, _arg_2:String):void
        {
            DisplayLoader.Context = _arg_1;
            TextLoader.TextLoaderKey = _arg_2;
            LoaderSavingManager.setup();
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

        public function fixedNewVariablesURL(_arg_1:String, _arg_2:int, _arg_3:URLVariables, _arg_4:int):String
        {
            var _local_5:String;
            var _local_6:int;
            var _local_7:String;
            if (((!(_arg_2 == BaseLoader.REQUEST_LOADER)) && (!(_arg_2 == BaseLoader.COMPRESS_REQUEST_LOADER))))
            {
                _local_5 = "";
                if (_arg_3 == null)
                {
                    _arg_3 = new URLVariables();
                };
                if (((((_arg_2 == BaseLoader.BYTE_LOADER) || (_arg_2 == BaseLoader.DISPLAY_LOADER)) || (_arg_2 == BaseLoader.BITMAP_LOADER)) || (_arg_2 == BaseLoader.MODULE_LOADER)))
                {
                    _arg_3["lv"] = (LoaderSavingManager.Version + _arg_4);
                }
                else
                {
                    if (((_arg_2 == BaseLoader.COMPRESS_TEXT_LOADER) || (_arg_2 == BaseLoader.TEXT_LOADER)))
                    {
                        _arg_3["rnd"] = (TextLoader.TextLoaderKey + _arg_4.toString());
                    };
                };
                _local_6 = 0;
                for (_local_7 in _arg_3)
                {
                    if (_local_6 >= 1)
                    {
                        _local_5 = (_local_5 + ((("&" + _local_7) + "=") + _arg_3[_local_7]));
                    }
                    else
                    {
                        _local_5 = (_local_5 + ((_local_7 + "=") + _arg_3[_local_7]));
                    };
                    _local_6++;
                };
                return ((_arg_1 + "?") + _local_5);
            };
            return (_arg_1);
        }


    }
}//package com.pickgliss.loader

