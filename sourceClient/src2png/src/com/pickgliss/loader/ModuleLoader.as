// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.ModuleLoader

package com.pickgliss.loader
{
    import cmodule.decry.CLibInit;
    import flash.system.ApplicationDomain;
    import flash.utils.ByteArray;
    import flash.utils.getDefinitionByName;
    import flash.utils.getTimer;
    import flash.events.Event;
    import com.pickgliss.ui.ComponentSetting;
    import flash.external.ExternalInterface;
    import flash.system.LoaderContext;

    public class ModuleLoader extends DisplayLoader 
    {

        private static var loader:CLibInit = new CLibInit();

        private var _isEqual:Boolean;
        private var _name:String;
        private var _isSecondLoad:Boolean = false;

        public function ModuleLoader(_arg_1:int, _arg_2:String, _arg_3:ApplicationDomain)
        {
            this.domain = _arg_3;
            super(_arg_1, _arg_2);
        }

        public static function decry(_arg_1:ByteArray):ByteArray
        {
            var _local_2:Object = loader.init();
            return (_local_2.decry(_arg_1));
        }

        public static function getDefinition(_arg_1:String):*
        {
            return (getDefinitionByName(_arg_1));
        }

        public static function hasDefinition(_arg_1:String):Boolean
        {
            return (DisplayLoader.Context.applicationDomain.hasDefinition(_arg_1));
        }


        override public function loadFromBytes(_arg_1:ByteArray):void
        {
            _starTime = getTimer();
            _displayLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, __onContentLoadComplete);
            this.analyMd5(_arg_1);
        }

        override protected function __onDataLoadComplete(_arg_1:Event):void
        {
            var _local_2:ByteArray;
            var _local_3:ByteArray;
            if (DisplayLoader.isDebug)
            {
                removeEvent();
                _loader.close();
                _displayLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, __onContentLoadComplete);
                if (_loader.data.length == 0)
                {
                    return;
                };
                _local_2 = _loader.data;
                if ((((!(_local_2[0] == 67)) || (!(_local_2[1] == 87))) || (!(_local_2[2] == 83))))
                {
                    _local_2 = decry(_local_2);
                };
                if (domain != null)
                {
                    _displayLoader.loadBytes(_local_2, DisplayLoader.Context);
                }
                else
                {
                    _displayLoader.loadBytes(_local_2, Context);
                };
            }
            else
            {
                _loader.close();
                _displayLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, __onContentLoadComplete);
                if (_loader.data.length == 0)
                {
                    return;
                };
                _local_3 = _loader.data;
                LoaderSavingManager.cacheFile(_url, _local_3, false);
                this.analyMd5(_local_3);
            };
        }

        public function analyMd5(_arg_1:ByteArray):void
        {
            var _local_3:ByteArray;
            var _local_2:String = this.getName();
            if (((ComponentSetting.USEMD5) && ((ComponentSetting.md5Dic[_local_2]) || (this.hasHead(_arg_1)))))
            {
                if (this.compareMD5(_arg_1, _local_2))
                {
                    _local_3 = new ByteArray();
                    _arg_1.position = 37;
                    _arg_1.readBytes(_local_3);
                    this.handleModule(_local_3);
                }
                else
                {
                    LoaderSavingManager.clearAllCache();
                    LoadInterfaceManager.alertAndRestart((_currentLoadPath + ":is old"));
                    if (this._isSecondLoad)
                    {
                        if (ExternalInterface.available)
                        {
                            ExternalInterface.call("alert", (_currentLoadPath + ":is old"));
                        };
                    }
                    else
                    {
                        _url = _url.replace(ComponentSetting.FLASHSITE, ComponentSetting.BACKUP_FLASHSITE);
                        _isLoading = false;
                        startLoad(_url);
                    };
                    this._isSecondLoad = true;
                };
            }
            else
            {
                this.handleModule(_arg_1);
            };
        }

        private function getName():String
        {
            var _local_1:String = "";
            var _local_2:int;
            while (_local_2 < ComponentSetting.MD5_OBJECT.length)
            {
                if (_url.indexOf(ComponentSetting.MD5_OBJECT[_local_2]) != -1)
                {
                    _local_1 = _url.substring((_url.lastIndexOf("/") + 1), (_url.indexOf(ComponentSetting.MD5_OBJECT[_local_2]) + ComponentSetting.MD5_OBJECT[_local_2].length));
                };
                _local_2++;
            };
            return (_local_1.toLowerCase());
        }

        private function compareMD5(_arg_1:ByteArray, _arg_2:String):Boolean
        {
            var _local_4:int;
            var _local_5:int;
            var _local_3:ByteArray = new ByteArray();
            _local_3.writeUTFBytes(ComponentSetting.md5Dic[_arg_2]);
            _local_3.position = 0;
            _arg_1.position = 5;
            while (_local_3.bytesAvailable > 0)
            {
                _local_4 = _local_3.readByte();
                _local_5 = _arg_1.readByte();
                if (_local_4 != _local_5)
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

        private function handleModule(_arg_1:ByteArray):void
        {
            _arg_1.position = 0;
            if ((((!(_arg_1[0] == 67)) || (!(_arg_1[1] == 87))) || (!(_arg_1[2] == 83))))
            {
                _arg_1 = decry(_arg_1);
            };
            if (domain != null)
            {
                _displayLoader.loadBytes(_arg_1, new LoaderContext(false, domain));
            }
            else
            {
                _displayLoader.loadBytes(_arg_1, Context);
            };
        }

        override public function get type():int
        {
            return (BaseLoader.MODULE_LOADER);
        }


    }
}//package com.pickgliss.loader

