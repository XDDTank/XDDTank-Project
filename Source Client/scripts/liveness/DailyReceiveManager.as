package liveness
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.analyze.CalendarSignAnalyze;
   import ddt.data.analyze.DaylyGiveAnalyzer;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.RequestVairableCreater;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   
   public class DailyReceiveManager extends EventDispatcher
   {
      
      private static var _instance:DailyReceiveManager;
      
      public static const CLOSE_ICON:String = "closeIcon";
       
      
      private var _dailyAwards:Array;
      
      public function DailyReceiveManager()
      {
         super();
      }
      
      public static function get Instance() : DailyReceiveManager
      {
         if(!_instance)
         {
            _instance = new DailyReceiveManager();
         }
         return _instance;
      }
      
      public function request() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("DailyLogList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,_loc1_);
         _loc2_.analyzer = new CalendarSignAnalyze(null);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.addEventListener(LoaderEvent.COMPLETE,this.__complete);
         LoadResourceManager.instance.startLoad(_loc2_);
         return _loc2_;
      }
      
      private function __complete(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
      }
      
      public function show() : void
      {
         var _loc1_:DailyReceive = ComponentFactory.Instance.creatCustomObject("liveness.hall.DailyReceive");
         _loc1_.show();
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
      }
      
      public function setDailyReceiveInfo(param1:DaylyGiveAnalyzer) : void
      {
         this._dailyAwards = param1.awardList;
      }
      
      public function getByDayTemplateId(param1:int) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < this._dailyAwards.length)
         {
            if(this._dailyAwards[_loc3_].Type == param1)
            {
               _loc2_.push(this._dailyAwards[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getByGradeAwards(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(PlayerManager.Instance.Self.Grade < 20 || PlayerManager.Instance.Self.Grade == 20)
            {
               if(param1[_loc3_].NeedLevel == 20)
               {
                  _loc2_.push(param1[_loc3_]);
               }
            }
            else if(PlayerManager.Instance.Self.Grade < 40 || PlayerManager.Instance.Self.Grade == 40)
            {
               if(param1[_loc3_].NeedLevel == 40)
               {
                  _loc2_.push(param1[_loc3_]);
               }
            }
            else if(param1[_loc3_].NeedLevel == 70)
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
