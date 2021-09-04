package update
{
   import ddt.manager.SharedManager;
   import ddt.manager.TimeManager;
   import road7th.utils.DateUtils;
   import update.analyzer.PopSysNoticeBaseAnalyzer;
   import update.analyzer.PopSysNoticeContentAnalyzer;
   import update.data.PopSysNoticeBaseInfo;
   
   public class UpdateController
   {
      
      private static var _instance:UpdateController;
       
      
      private var _noticeBaseList:Array;
      
      private var _noticeContentList:Array;
      
      public function UpdateController()
      {
         super();
      }
      
      public static function get Instance() : UpdateController
      {
         if(!_instance)
         {
            _instance = new UpdateController();
         }
         return _instance;
      }
      
      public function setPopSysNoticeBase(param1:PopSysNoticeBaseAnalyzer) : void
      {
         var _loc3_:PopSysNoticeBaseInfo = null;
         var _loc2_:Array = param1.list;
         this._noticeBaseList = new Array();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.Type == 0 && _loc3_.Status == 1)
            {
               this._noticeBaseList.push(_loc3_);
            }
         }
         if(this.lastNoticeBase)
         {
            if(this.lastNoticeBase.BeginTime != SharedManager.Instance.showUpdateFrameDate)
            {
               SharedManager.Instance.hasShowUpdateFrame = false;
            }
         }
      }
      
      public function setPopSysNoticeContent(param1:PopSysNoticeContentAnalyzer) : void
      {
         this._noticeContentList = param1.list;
      }
      
      public function get lastNoticeBase() : PopSysNoticeBaseInfo
      {
         var _loc2_:PopSysNoticeBaseInfo = null;
         var _loc4_:PopSysNoticeBaseInfo = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:int = 0;
         var _loc3_:Number = TimeManager.Instance.Now().time;
         for each(_loc4_ in this._noticeBaseList)
         {
            _loc5_ = DateUtils.getDateByStr(_loc4_.BeginTime).time;
            _loc6_ = DateUtils.getDateByStr(_loc4_.EndTime).time;
            if(_loc5_ > _loc1_ && _loc5_ <= _loc3_ && _loc6_ > _loc3_)
            {
               _loc1_ = _loc5_;
               _loc2_ = _loc4_;
            }
         }
         return _loc2_;
      }
      
      public function get noticeContentList() : Array
      {
         return this._noticeContentList;
      }
   }
}
