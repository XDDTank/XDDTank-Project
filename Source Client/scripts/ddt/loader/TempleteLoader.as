package ddt.loader
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadInterfaceManager;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.TempleteLoaderEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import deng.fzip.FZip;
   import deng.fzip.FZipErrorEvent;
   import deng.fzip.FZipFile;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
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
         super();
         this._typeDic = new TempleteType().Types;
      }
      
      public static function get instance() : TempleteLoader
      {
         if(!_instance)
         {
            _instance = new TempleteLoader();
         }
         return _instance;
      }
      
      public function start() : void
      {
         this._zipPath = PathManager.solveRequestPath(ComponentSetting.getTempleteZIPPath() + "?rnd=" + Math.random());
         LoadInterfaceManager.traceMsg("开始加载模板:" + this._zipPath);
         this._zipLoadComplete = false;
         this.loadZipConfig();
      }
      
      private function loadZipConfig() : void
      {
         this._progress = 0;
         this._zipLoader = LoadResourceManager.instance.createOriginLoader(this._zipPath,LoadResourceManager.instance.loadingUrl,BaseLoader.BYTE_LOADER);
         this._zipLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadZipComplete);
         this._zipLoader.addEventListener(LoaderEvent.PROGRESS,this.__onLoading);
         this._zipLoader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.instance.startLoadFromLoadingUrl(this._zipLoader,PathManager.getRequestPath(),false,false);
      }
      
      protected function __onLoading(param1:LoaderEvent) : void
      {
         this._progress = param1.loader.progress * LOAD_ZIP;
         dispatchEvent(new TempleteLoaderEvent(TempleteLoaderEvent.LOAD_PROGRESS,param1.loader));
      }
      
      private function __onLoadZipComplete(param1:LoaderEvent) : void
      {
         this._progress = LOAD_ZIP;
         this._zipLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadZipComplete);
         this._zipLoader.removeEventListener(LoaderEvent.PROGRESS,this.__onLoading);
         this._zipLoader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         dispatchEvent(new TempleteLoaderEvent(TempleteLoaderEvent.LOAD_COMPLETE,param1.loader));
         var _loc2_:ByteArray = this._zipLoader.content;
         this.zipLoad(_loc2_);
      }
      
      protected function __onLoadError(param1:LoaderEvent) : void
      {
         LoadInterfaceManager.traceMsg("模板加载出错:" + param1.loader.url);
      }
      
      private function zipLoad(param1:ByteArray) : void
      {
         var _loc2_:FZip = new FZip();
         _loc2_.addEventListener(Event.COMPLETE,this.__onZipParaComplete);
         _loc2_.addEventListener(FZipErrorEvent.PARSE_ERROR,this.__onZipParaError);
         _loc2_.loadBytes(param1);
      }
      
      private function __onZipParaComplete(param1:Event) : void
      {
         var _loc5_:FZipFile = null;
         var _loc6_:ByteArray = null;
         var _loc7_:String = null;
         this._progress = UNZIP;
         var _loc2_:FZip = param1.currentTarget as FZip;
         _loc2_.removeEventListener(Event.COMPLETE,this.__onZipParaComplete);
         dispatchEvent(new TempleteLoaderEvent(TempleteLoaderEvent.ZIP_COMPLETE));
         this._resDic = new Dictionary();
         var _loc3_:int = _loc2_.getFileCount();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.getFileAt(_loc4_);
            _loc6_ = _loc5_.content;
            _loc6_.uncompress();
            _loc6_.position = 0;
            _loc7_ = _loc6_.readUTFBytes(_loc6_.bytesAvailable);
            this._resDic[this.getfileName(_loc5_.filename)] = _loc7_;
            _loc4_++;
         }
         this.analyzeNext();
         this._zipLoadComplete = true;
      }
      
      private function getfileName(param1:String) : String
      {
         if(param1.indexOf("/") > 0)
         {
            return param1.substr(param1.lastIndexOf("/") + 1);
         }
         return param1;
      }
      
      private function analyzeNext() : void
      {
         this._lastTimer = getTimer();
         ++this._index;
         this._progress = (this._index + 1) / this._typeDic.length * (1 - UNZIP) + UNZIP;
         if(this._index < this._typeDic.length)
         {
            this._typeDic[this._index].analyzer.analyzeCompleteCall = this.analyzeNext;
            this._typeDic[this._index].analyzer.analyzeErrorCall = function():void
            {
               var _loc1_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),"xml解析錯誤:" + _typeDic[_index].filename,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
               _loc1_.addEventListener(FrameEvent.RESPONSE,__onAlertResponse);
               analyzeNext();
            };
            this._typeDic[this._index].analyzer.analyze(this._resDic[this._typeDic[this._index].filename]);
         }
         else
         {
            this._progress = 1;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      private function __onZipParaError(param1:FZipErrorEvent) : void
      {
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function get zipLoadComplete() : Boolean
      {
         return this._zipLoadComplete;
      }
   }
}
