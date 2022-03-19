// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.loader.TempleteLoader

package ddt.loader
{
    import flash.events.EventDispatcher;
    import com.pickgliss.loader.BaseLoader;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import ddt.manager.PathManager;
    import com.pickgliss.ui.ComponentSetting;
    import com.pickgliss.loader.LoadInterfaceManager;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.events.TempleteLoaderEvent;
    import flash.utils.ByteArray;
    import deng.fzip.FZip;
    import flash.events.Event;
    import deng.fzip.FZipErrorEvent;
    import deng.fzip.FZipFile;
    import flash.utils.getTimer;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.LeavePageManager;

    public class TempleteLoader extends EventDispatcher 
    {

        public static const LOAD_ZIP:Number = 0.4;
        public static const UNZIP:Number = 0.7;
        private static var _instance:TempleteLoader;

        private var _zipPath:String = "";
        private var _zipLoadComplete:Boolean = true;
        private var _zipLoader:BaseLoader;
        private var _isSecondLoad:Boolean = false;
        private var _typeDic:Vector.<TempleteObject>;
        private var _resDic:Dictionary;
        private var _progress:Number;
        private var _index:int = -1;
        private var _lastTimer:int;

        public function TempleteLoader()
        {
            this._typeDic = new TempleteType().Types;
        }

        public static function get instance():TempleteLoader
        {
            if ((!(_instance)))
            {
                _instance = new (TempleteLoader)();
            };
            return (_instance);
        }


        public function start():void
        {
            this._zipPath = PathManager.solveRequestPath(((ComponentSetting.getTempleteZIPPath() + "?rnd=") + Math.random()));
            LoadInterfaceManager.traceMsg(("开始加载模板:" + this._zipPath));
            this._zipLoadComplete = false;
            this.loadZipConfig();
        }

        private function loadZipConfig():void
        {
            this._progress = 0;
            this._zipLoader = LoadResourceManager.instance.createOriginLoader(this._zipPath, LoadResourceManager.instance.loadingUrl, BaseLoader.BYTE_LOADER);
            this._zipLoader.addEventListener(LoaderEvent.COMPLETE, this.__onLoadZipComplete);
            this._zipLoader.addEventListener(LoaderEvent.PROGRESS, this.__onLoading);
            this._zipLoader.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoadFromLoadingUrl(this._zipLoader, PathManager.getRequestPath(), false, false);
        }

        protected function __onLoading(_arg_1:LoaderEvent):void
        {
            this._progress = (_arg_1.loader.progress * LOAD_ZIP);
            dispatchEvent(new TempleteLoaderEvent(TempleteLoaderEvent.LOAD_PROGRESS, _arg_1.loader));
        }

        private function __onLoadZipComplete(_arg_1:LoaderEvent):void
        {
            this._progress = LOAD_ZIP;
            this._zipLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onLoadZipComplete);
            this._zipLoader.removeEventListener(LoaderEvent.PROGRESS, this.__onLoading);
            this._zipLoader.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            dispatchEvent(new TempleteLoaderEvent(TempleteLoaderEvent.LOAD_COMPLETE, _arg_1.loader));
            var _local_2:ByteArray = this._zipLoader.content;
            this.zipLoad(_local_2);
        }

        protected function __onLoadError(_arg_1:LoaderEvent):void
        {
            LoadInterfaceManager.traceMsg(("模板加载出错:" + _arg_1.loader.url));
        }

        private function zipLoad(_arg_1:ByteArray):void
        {
            var _local_2:FZip = new FZip();
            _local_2.addEventListener(Event.COMPLETE, this.__onZipParaComplete);
            _local_2.addEventListener(FZipErrorEvent.PARSE_ERROR, this.__onZipParaError);
            _local_2.loadBytes(_arg_1);
        }

        private function __onZipParaComplete(_arg_1:Event):void
        {
            var _local_5:FZipFile;
            var _local_6:ByteArray;
            var _local_7:String;
            this._progress = UNZIP;
            var _local_2:FZip = (_arg_1.currentTarget as FZip);
            _local_2.removeEventListener(Event.COMPLETE, this.__onZipParaComplete);
            dispatchEvent(new TempleteLoaderEvent(TempleteLoaderEvent.ZIP_COMPLETE));
            this._resDic = new Dictionary();
            var _local_3:int = _local_2.getFileCount();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = _local_2.getFileAt(_local_4);
                _local_6 = _local_5.content;
                _local_6.uncompress();
                _local_6.position = 0;
                _local_7 = _local_6.readUTFBytes(_local_6.bytesAvailable);
                this._resDic[this.getfileName(_local_5.filename)] = _local_7;
                _local_4++;
            };
            this.analyzeNext();
            this._zipLoadComplete = true;
        }

        private function getfileName(_arg_1:String):String
        {
            if (_arg_1.indexOf("/") > 0)
            {
                return (_arg_1.substr((_arg_1.lastIndexOf("/") + 1)));
            };
            return (_arg_1);
        }

        private function analyzeNext():void
        {
            this._lastTimer = getTimer();
            this._index++;
            this._progress = ((((this._index + 1) / this._typeDic.length) * (1 - UNZIP)) + UNZIP);
            if (this._index < this._typeDic.length)
            {
                this._typeDic[this._index].analyzer.analyzeCompleteCall = this.analyzeNext;
                this._typeDic[this._index].analyzer.analyzeErrorCall = function ():void
                {
                    var _local_1:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"), ("xml解析錯誤:" + _typeDic[_index].filename), LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
                    _local_1.addEventListener(FrameEvent.RESPONSE, __onAlertResponse);
                    analyzeNext();
                };
                this._typeDic[this._index].analyzer.analyze(this._resDic[this._typeDic[this._index].filename]);
            }
            else
            {
                this._progress = 1;
                dispatchEvent(new Event(Event.COMPLETE));
            };
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            LeavePageManager.leaveToLoginPath();
        }

        private function __onZipParaError(_arg_1:FZipErrorEvent):void
        {
        }

        public function get progress():Number
        {
            return (this._progress);
        }

        public function get zipLoadComplete():Boolean
        {
            return (this._zipLoadComplete);
        }


    }
}//package ddt.loader

