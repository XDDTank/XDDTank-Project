package com.pickgliss.loader
{
   import com.pickgliss.events.LoaderResourceEvent;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   
   [Event(name="progress",type="com.pickgliss.events.LoaderResourceEvent")]
   [Event(name="loadError",type="com.pickgliss.events.LoaderResourceEvent")]
   [Event(name="delete",type="com.pickgliss.events.LoaderResourceEvent")]
   [Event(name="complete",type="com.pickgliss.events.LoaderResourceEvent")]
   [Event(name="init complete",type="com.pickgliss.events.LoaderResourceEvent")]
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
      
      public function LoadResourceManager(param1:Singleton)
      {
         super();
         if(!param1)
         {
            throw Error("单例无法实例化");
         }
      }
      
      public static function get instance() : LoadResourceManager
      {
         return _instance = _instance || new LoadResourceManager(new Singleton());
      }
      
      public function init(param1:String = "") : void
      {
         this._infoSite = param1;
         var _loc2_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         LoaderManager.Instance.setup(_loc2_,String(Math.random()));
         LoadInterfaceManager.initAppInterface();
         LoadInterfaceManager.checkClientType();
      }
      
      public function addMicroClientEvent() : void
      {
         LoadInterfaceManager.eventDispatcher.addEventListener(LoadInterfaceEvent.CHECK_COMPLETE,this.__checkComplete);
         LoadInterfaceManager.eventDispatcher.addEventListener(LoadInterfaceEvent.DELETE_COMPLETE,this.__deleteComplete);
         LoadInterfaceManager.eventDispatcher.addEventListener(LoadInterfaceEvent.FLASH_GOTO_AND_PLAY,this.__flashGotoAndPlay);
      }
      
      public function setLoginType(param1:Number, param2:String = "", param3:String = "-1") : void
      {
         this._clientType = int(param1);
         this._loadingUrl = param2;
         LoaderSavingManager.Version = int(param3);
         this.setup();
         LoadInterfaceManager.traceMsg("loadingUrl:" + this._loadingUrl);
         LoadInterfaceManager.traceMsg("初始化完成");
         dispatchEvent(new LoaderResourceEvent(LoaderResourceEvent.INIT_COMPLETE));
      }
      
      public function setup() : void
      {
         this._loadDic = new Dictionary();
         this._deleteList = new Vector.<String>();
      }
      
      public function createLoader(param1:String, param2:int, param3:URLVariables = null, param4:String = "GET", param5:ApplicationDomain = null) : *
      {
         if(param2 != BaseLoader.COMPRESS_REQUEST_LOADER && param2 != BaseLoader.COMPRESS_TEXT_LOADER && param2 != BaseLoader.TEXT_LOADER && param2 != BaseLoader.REQUEST_LOADER && param2 != BaseLoader.BYTE_LOADER)
         {
            param1 = param1.toLowerCase();
         }
         return this.createOriginLoader(param1,this._infoSite,param2,param3,param4,param5,true);
      }
      
      public function createOriginLoader(param1:String, param2:String, param3:int, param4:URLVariables = null, param5:String = "GET", param6:ApplicationDomain = null, param7:Boolean = false) : *
      {
         var _loc8_:BaseLoader = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:String = null;
         if(param7 && this._clientType == 1 && [BaseLoader.TEXT_LOADER,BaseLoader.COMPRESS_TEXT_LOADER,BaseLoader.REQUEST_LOADER,BaseLoader.COMPRESS_REQUEST_LOADER].indexOf(param3) == -1)
         {
            LoadInterfaceManager.traceMsg("请求加载:" + param1);
            _loc9_ = param2.length;
            _loc10_ = param1.substring(_loc9_,param1.length) + "?loaderID=" + this._loaderID;
            _loc8_ = LoaderManager.Instance.creatLoaderByType(_loc10_,param3,param4,param5,param6);
            this._loadDic[_loc8_.id] = _loc8_;
            ++this._loaderID;
         }
         else
         {
            _loc11_ = this.fixedVariablesURL(param1,param3,param4);
            _loc8_ = LoaderManager.Instance.creatLoaderByType(_loc11_,param3,param4,param5,param6);
         }
         return _loc8_;
      }
      
      public function creatAndStartLoad(param1:String, param2:int) : void
      {
         this.startLoad(this.createLoader(param1,param2));
      }
      
      public function startLoad(param1:BaseLoader, param2:Boolean = false, param3:Boolean = true) : void
      {
         this.startLoadFromLoadingUrl(param1,this._infoSite,param2,param3);
      }
      
      public function startLoadFromLoadingUrl(param1:BaseLoader, param2:String, param3:Boolean = false, param4:Boolean = true) : void
      {
         var _loc5_:String = param1.url;
         _loc5_ = _loc5_.replace(/\?.*/,"");
         if(param4 && this._clientType == 1 && [BaseLoader.TEXT_LOADER,BaseLoader.COMPRESS_TEXT_LOADER,BaseLoader.REQUEST_LOADER,BaseLoader.COMPRESS_REQUEST_LOADER].indexOf(param1.type) == -1)
         {
            LoadInterfaceManager.checkResource(param1.id,param2,_loc5_,param3);
         }
         else
         {
            this.beginLoad(param1,param3);
         }
      }
      
      public function fixedVariablesURL(param1:String, param2:int, param3:URLVariables) : String
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         if(param2 != BaseLoader.REQUEST_LOADER && param2 != BaseLoader.COMPRESS_REQUEST_LOADER)
         {
            _loc4_ = "";
            if(param3 == null)
            {
               param3 = new URLVariables();
            }
            if(param2 == BaseLoader.BYTE_LOADER || param2 == BaseLoader.DISPLAY_LOADER || param2 == BaseLoader.BITMAP_LOADER || param2 == BaseLoader.MODULE_LOADER)
            {
               param3["lv"] = LoaderSavingManager.Version;
            }
            else if(param2 == BaseLoader.COMPRESS_TEXT_LOADER || param2 == BaseLoader.TEXT_LOADER)
            {
               param3["rnd"] = TextLoader.TextLoaderKey;
            }
            _loc5_ = 0;
            for(_loc6_ in param3)
            {
               if(_loc5_ >= 1)
               {
                  _loc4_ += "&" + _loc6_ + "=" + param3[_loc6_];
               }
               else
               {
                  _loc4_ += _loc6_ + "=" + param3[_loc6_];
               }
               _loc5_++;
            }
            return param1 + "?" + _loc4_;
         }
         return param1;
      }
      
      private function beginLoad(param1:BaseLoader, param2:Boolean = false) : void
      {
         this.addLoaderEvent(param1);
         LoadInterfaceManager.traceMsg("flash下载:" + param1.url + "是否立刻加载:" + param2);
         LoaderManager.Instance.startLoad(param1,param2);
      }
      
      protected function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.target as BaseLoader;
         this.removeLoaderEvent(_loc2_);
         LoadInterfaceManager.traceMsg("本地加载错误:" + _loc2_.url);
      }
      
      protected function __onProgress(param1:LoaderEvent) : void
      {
         var _loc3_:LoaderResourceEvent = null;
         var _loc2_:BaseLoader = param1.target as BaseLoader;
         if(!this.isMicroClient)
         {
            this._progress = _loc2_.progress;
            _loc3_ = new LoaderResourceEvent(LoaderResourceEvent.PROGRESS);
            _loc3_.data = _loc2_.progress;
            dispatchEvent(_loc3_);
         }
      }
      
      protected function __onComplete(param1:LoaderEvent) : void
      {
         var _loc3_:LoaderResourceEvent = null;
         var _loc2_:BaseLoader = param1.target as BaseLoader;
         LoadInterfaceManager.traceMsg("flash下载完成:" + _loc2_.url);
         this.removeLoaderEvent(_loc2_);
         delete this._loadDic[_loc2_.id];
         if(_loc2_.isSuccess)
         {
            _loc3_ = new LoaderResourceEvent(LoaderResourceEvent.COMPLETE);
            _loc3_.filePath = _loc2_.url;
            dispatchEvent(_loc3_);
         }
      }
      
      private function addLoaderEvent(param1:BaseLoader) : void
      {
         param1.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         param1.addEventListener(LoaderEvent.PROGRESS,this.__onProgress);
         param1.addEventListener(LoaderEvent.COMPLETE,this.__onComplete);
      }
      
      private function removeLoaderEvent(param1:BaseLoader) : void
      {
         param1.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         param1.removeEventListener(LoaderEvent.PROGRESS,this.__onProgress);
         param1.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
      }
      
      public function addDeleteRequest(param1:String) : void
      {
         this._deleteList.push(param1);
      }
      
      public function startDelete() : void
      {
         if(this._clientType != 1)
         {
            this._deleteList.length = 0;
         }
         this.deleteNext();
      }
      
      private function deleteNext() : void
      {
         var _loc1_:LoaderResourceEvent = null;
         if(this._deleteList.length > 0)
         {
            this._currentDeletePath = this._deleteList.shift();
            this.deleteResource(this._currentDeletePath);
         }
         else
         {
            _loc1_ = new LoaderResourceEvent(LoaderResourceEvent.DELETE);
            dispatchEvent(_loc1_);
         }
      }
      
      public function deleteResource(param1:String) : void
      {
         LoadInterfaceManager.traceMsg("删除:" + param1);
         LoadInterfaceManager.deleteResource(param1);
      }
      
      protected function __checkComplete(param1:LoadInterfaceEvent) : void
      {
         this.checkComplete(param1.paras[0],param1.paras[1],param1.paras[2],param1.paras[3]);
      }
      
      protected function __deleteComplete(param1:LoadInterfaceEvent) : void
      {
         if(this._currentDeletePath == param1.paras[1])
         {
            this.deleteComlete(param1.paras[0],param1.paras[1]);
         }
      }
      
      protected function __flashGotoAndPlay(param1:LoadInterfaceEvent) : void
      {
         this.flashGotoAndPlay(param1.paras[0]);
      }
      
      public function checkComplete(param1:String, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:LoaderResourceEvent = null;
         if(param2 == "true")
         {
            LoadInterfaceManager.traceMsg("微端下载成功,id=" + param1 + ",flag=" + param2 + ",httpurl=" + param3 + ",filename" + param4);
            this.beginLoad(this._loadDic[int(param1)]);
            _loc5_ = new LoaderResourceEvent(LoaderResourceEvent.COMPLETE);
            _loc5_.filePath = param3;
            _loc5_.data = param2;
            dispatchEvent(_loc5_);
         }
         else
         {
            this.beginLoad(this._loadDic[int(param1)]);
            LoadInterfaceManager.traceMsg("微端下载失败" + param2 + ":" + param4);
            _loc5_ = new LoaderResourceEvent(LoaderResourceEvent.LOAD_ERROR);
            _loc5_.filePath = param3;
            _loc5_.data = param2;
            dispatchEvent(_loc5_);
         }
         this._progress = 100;
      }
      
      public function deleteComlete(param1:String, param2:String) : void
      {
         LoadInterfaceManager.traceMsg("微端删除" + param1 + ":" + param2);
         this.deleteNext();
      }
      
      public function flashGotoAndPlay(param1:Number) : void
      {
         this._progress = param1;
         var _loc2_:LoaderResourceEvent = new LoaderResourceEvent(LoaderResourceEvent.PROGRESS);
         _loc2_.data = param1;
         dispatchEvent(_loc2_);
      }
      
      public function get Progress() : int
      {
         return this._progress;
      }
      
      public function get isMicroClient() : Boolean
      {
         return this._clientType == 1;
      }
      
      public function get clientType() : int
      {
         return this._clientType;
      }
      
      public function get infoSite() : String
      {
         return this._infoSite;
      }
      
      public function set infoSite(param1:String) : void
      {
         this._infoSite = param1;
      }
      
      public function get loadingUrl() : String
      {
         return this._loadingUrl;
      }
   }
}

class Singleton
{
    
   
   function Singleton()
   {
      super();
   }
}
