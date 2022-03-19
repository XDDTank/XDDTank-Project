// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.LoaderSavingManager

package com.pickgliss.loader
{
    import flash.utils.Timer;
    import flash.net.SharedObject;
    import flash.events.EventDispatcher;
    import flash.display.Shape;
    import flash.events.NetStatusEvent;
    import flash.events.Event;
    import flash.net.SharedObjectFlushStatus;
    import flash.utils.getTimer;
    import flash.utils.ByteArray;
    import com.pickgliss.events.LoaderResourceEvent;

    public class LoaderSavingManager 
    {

        private static const LOCAL_FILE:String = "7road/files";
        private static var _cacheFile:Boolean = false;
        private static var _version:int = -1;
        private static var _files:Object;
        private static var _saveTimer:Timer;
        private static var _so:SharedObject;
        private static var _changed:Boolean;
        private static var _save:Array;
        private static const READ_ERROR_ID:int = 2030;
        public static var eventDispatcher:EventDispatcher = new EventDispatcher();
        public static var ReadShareError:Boolean = false;
        private static const _reg1:RegExp = /http:\/\/[\w|.|:]+\//i;
        private static const _reg2:RegExp = /[:|.|\/]/g;
        private static var _isSaving:Boolean = false;
        private static var _shape:Shape = new Shape();
        private static var _retryCount:int = 0;


        public static function get Version():int
        {
            return (_version);
        }

        public static function set Version(_arg_1:int):void
        {
            _version = _arg_1;
            LoadInterfaceManager.traceMsg(("版本号设置:" + _arg_1));
        }

        public static function set cacheAble(_arg_1:Boolean):void
        {
            _cacheFile = _arg_1;
        }

        public static function get cacheAble():Boolean
        {
            return (_cacheFile);
        }

        public static function setup():void
        {
            _cacheFile = false;
            _save = new Array();
            loadFilesInLocal();
        }

        public static function applyUpdate(_arg_1:int, _arg_2:int, _arg_3:Array):void
        {
            var _local_4:Array;
            var _local_5:String;
            var _local_6:Array;
            var _local_7:String;
            var _local_8:String;
            var _local_9:String;
            if (_arg_2 <= _arg_1)
            {
                return;
            };
            if (_version < 0)
            {
                throw (new Error("版本为-1的话抛出错误执行catch语句,删除缓存"));
            };
            if (_version < _arg_2)
            {
                if (_version < _arg_1)
                {
                    _so.data["data"] = (_files = new Object());
                    LoadResourceManager.instance.addDeleteRequest("*");
                }
                else
                {
                    _local_4 = new Array();
                    for each (_local_5 in _arg_3)
                    {
                        _local_9 = getPath(_local_5);
                        _local_9 = _local_9.replace("*", "\\w*");
                        _local_4.push(new RegExp(("^" + _local_9)));
                        LoadResourceManager.instance.addDeleteRequest(_local_5);
                    };
                    _local_6 = new Array();
                    for (_local_7 in _files)
                    {
                        _local_7 = _local_7.toLocaleLowerCase();
                        if (hasUpdate(_local_7, _local_4))
                        {
                            _local_6.push(_local_7);
                        };
                    };
                    for each (_local_8 in _local_6)
                    {
                        delete _files[_local_8];
                    };
                };
                _version = _arg_2;
                LoadInterfaceManager.setVersion(_version);
                _files["version"] = _arg_2;
                _changed = true;
            };
        }

        public static function clearFiles(_arg_1:String):void
        {
            var _local_2:Array;
            var _local_3:String;
            var _local_4:Array;
            var _local_5:String;
            var _local_6:String;
            if (_files)
            {
                _local_2 = new Array();
                _local_3 = getPath(_arg_1);
                _local_3 = _local_3.replace("*", "\\w*");
                _local_2.push(new RegExp(("^" + _local_3)));
                _local_4 = new Array();
                for (_local_5 in _files)
                {
                    _local_5 = _local_5.toLocaleLowerCase();
                    if (hasUpdate(_local_5, _local_2))
                    {
                        _local_4.push(_local_5);
                    };
                };
                for each (_local_6 in _local_4)
                {
                    delete _files[_local_6];
                };
                try
                {
                    if (_cacheFile)
                    {
                        _so.flush(((20 * 0x0400) * 0x0400));
                    };
                }
                catch(e:Error)
                {
                };
            };
        }

        public static function loadFilesInLocal():void
        {
            try
            {
                _so = SharedObject.getLocal(LOCAL_FILE, "/");
                _so.addEventListener(NetStatusEvent.NET_STATUS, __netStatus);
                _files = _so.data["data"];
                if (_files == null)
                {
                    _files = new Object();
                    _so.data["data"] = _files;
                    _files["version"] = _version;
                    _cacheFile = false;
                }
                else
                {
                    _version = _files["version"];
                    _cacheFile = true;
                };
            }
            catch(e:Error)
            {
                if (e.errorID == READ_ERROR_ID)
                {
                    resetErrorVersion();
                };
            };
        }

        public static function resetErrorVersion():void
        {
            _version = (Math.random() * -777777);
            ReadShareError = true;
        }

        private static function getPath(_arg_1:String):String
        {
            var _local_2:int = _arg_1.indexOf("?");
            if (_local_2 != -1)
            {
                _arg_1 = _arg_1.substring(0, _local_2);
            };
            _arg_1 = _arg_1.replace(_reg1, "");
            return (_arg_1.replace(_reg2, "-").toLocaleLowerCase());
        }

        public static function saveFilesToLocal():void
        {
            try
            {
                if (((((_files) && (_changed)) && (_cacheFile)) && (!(_isSaving))))
                {
                    _isSaving = true;
                    _shape.addEventListener(Event.ENTER_FRAME, save);
                };
            }
            catch(e:Error)
            {
            };
        }

        private static function save(event:Event):void
        {
            var state:String;
            var tick:int;
            var obj:Object;
            var so:SharedObject;
            try
            {
                state = _so.flush(((20 * 0x0400) * 0x0400));
                if (state != SharedObjectFlushStatus.PENDING)
                {
                    tick = getTimer();
                    if (_save.length > 0)
                    {
                        obj = _save[0];
                        so = SharedObject.getLocal(obj.p, "/");
                        so.data["data"] = obj.d;
                        so.flush();
                        _files[obj.p] = true;
                        _so.flush();
                        _save.shift();
                    };
                    if (_save.length == 0)
                    {
                        _shape.removeEventListener(Event.ENTER_FRAME, save);
                        _changed = false;
                        _isSaving = false;
                    };
                };
            }
            catch(e:Error)
            {
                _shape.removeEventListener(Event.ENTER_FRAME, save);
            };
        }

        private static function hasUpdate(_arg_1:String, _arg_2:Array):Boolean
        {
            var _local_3:RegExp;
            for each (_local_3 in _arg_2)
            {
                if (_arg_1.match(_local_3))
                {
                    return (true);
                };
            };
            return (false);
        }

        public static function loadCachedFile(_arg_1:String, _arg_2:Boolean):ByteArray
        {
            var _local_3:String;
            var _local_4:int;
            var _local_5:ByteArray;
            var _local_6:SharedObject;
            if (_files)
            {
                _local_3 = getPath(_arg_1);
                _local_4 = getTimer();
                _local_5 = findInSave(_local_3);
                if (((_local_5 == null) && (_files[_local_3])))
                {
                    _local_6 = SharedObject.getLocal(_local_3, "/");
                    _local_5 = ByteArray(_local_6.data["data"]);
                };
                if (_local_5)
                {
                    return (_local_5);
                };
            };
            return (null);
        }

        private static function findInSave(_arg_1:String):ByteArray
        {
            var _local_2:Object;
            for each (_local_2 in _save)
            {
                if (_local_2.p == _arg_1)
                {
                    return (ByteArray(_local_2.d));
                };
            };
            return (null);
        }

        public static function cacheFile(_arg_1:String, _arg_2:ByteArray, _arg_3:Boolean):void
        {
            var _local_4:String;
            if (((!(LoadResourceManager.instance.isMicroClient)) && (_files)))
            {
                _local_4 = getPath(_arg_1);
                _save.push({
                    "p":_local_4,
                    "d":_arg_2
                });
                _changed = true;
            };
        }

        private static function __netStatus(_arg_1:NetStatusEvent):void
        {
            switch (_arg_1.info.code)
            {
                case "SharedObject.Flush.Failed":
                    if (_retryCount < 1)
                    {
                        _so.flush(((20 * 0x0400) * 0x0400));
                        _retryCount++;
                    }
                    else
                    {
                        cacheAble = false;
                    };
                    return;
                default:
                    _retryCount = 0;
            };
        }

        public static function updateList(_arg_1:XMLList):void
        {
            var _local_2:XML;
            for each (_local_2 in _arg_1)
            {
                parseUpdate(_local_2);
            };
            LoadResourceManager.instance.addEventListener(LoaderResourceEvent.DELETE, __deleteComplete);
            LoadResourceManager.instance.startDelete();
        }

        public static function parseUpdate(config:XML):void
        {
            var vs:XMLList;
            var unode:XML;
            var fromv:int;
            var tov:int;
            var fs:XMLList;
            var updatelist:Array;
            var fn:XML;
            try
            {
                vs = config..version;
                for each (unode in vs)
                {
                    fromv = int(unode.@from);
                    tov = int(unode.@to);
                    fs = unode..file;
                    updatelist = new Array();
                    for each (fn in fs)
                    {
                        updatelist.push(String(fn.@value));
                    };
                    applyUpdate(fromv, tov, updatelist);
                };
            }
            catch(e:Error)
            {
                _version = -1;
                if (_so)
                {
                    _so.data["data"] = (_files = new Object());
                };
                LoadResourceManager.instance.addDeleteRequest("*");
                _changed = true;
            };
            saveFilesToLocal();
        }

        protected static function __deleteComplete(_arg_1:Event):void
        {
            eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
        }

        public static function get hasFileToSave():Boolean
        {
            return ((_cacheFile) && (_changed));
        }

        public static function clearAllCache():void
        {
            var a:String;
            var file:String;
            var fileSO:SharedObject;
            if (LoadResourceManager.instance.isMicroClient)
            {
                LoadResourceManager.instance.deleteResource("*");
            };
            if ((!(_so)))
            {
                return;
            };
            var fileList:Array = [];
            for (a in _files)
            {
                if (a != "version")
                {
                    a = a.toLocaleLowerCase();
                    fileList.push(a);
                    delete _files[a];
                };
            };
            while ((file = fileList.pop()))
            {
                fileSO = SharedObject.getLocal(file, "/");
                fileSO.data["data"] = new Object();
                fileSO.flush();
            };
            _version = -1;
            _so.data["data"] = (_files = new Object());
            _files["version"] = -1;
            try
            {
                _so.flush();
            }
            catch(e:Error)
            {
            };
        }

        public static function clearCache():void
        {
            _so.data["data"] = (_files = new Object());
            try
            {
                _so.flush();
            }
            catch(err:Error)
            {
                _changed = true;
            };
        }


    }
}//package com.pickgliss.loader

