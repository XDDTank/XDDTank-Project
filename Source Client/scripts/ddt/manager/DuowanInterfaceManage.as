package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.utils.MD5;
   import ddt.events.DuowanInterfaceEvent;
   import flash.events.EventDispatcher;
   
   public class DuowanInterfaceManage extends EventDispatcher
   {
      
      private static var _instance:DuowanInterfaceManage;
       
      
      private var key:String;
      
      public function DuowanInterfaceManage()
      {
         super();
         this.key = "sdkxccjlqaoehtdwjkdycdrw";
         addEventListener(DuowanInterfaceEvent.ADD_ROLE,this.__userActionNotice);
         addEventListener(DuowanInterfaceEvent.UP_GRADE,this.__upGradeNotice);
         addEventListener(DuowanInterfaceEvent.ONLINE,this.__onLineNotice);
         addEventListener(DuowanInterfaceEvent.OUTLINE,this.__outLineNotice);
      }
      
      public static function get Instance() : DuowanInterfaceManage
      {
         if(_instance == null)
         {
            _instance = new DuowanInterfaceManage();
         }
         return _instance;
      }
      
      private function __userActionNotice(param1:DuowanInterfaceEvent) : void
      {
         var _loc2_:String = "4";
         var _loc3_:String = PlayerManager.Instance.Self.ID.toString();
         _loc3_ = encodeURI(_loc3_);
         var _loc4_:String = MD5.hash(_loc3_ + _loc2_ + this.key);
         this.send(_loc2_,_loc3_,_loc4_);
      }
      
      private function __upGradeNotice(param1:DuowanInterfaceEvent) : void
      {
         var _loc2_:String = "1";
         var _loc3_:String = PlayerManager.Instance.Self.ID.toString();
         _loc3_ = encodeURI(_loc3_);
         var _loc4_:String = MD5.hash(_loc3_ + _loc2_ + this.key);
         this.send(_loc2_,_loc3_,_loc4_);
      }
      
      private function __onLineNotice(param1:DuowanInterfaceEvent) : void
      {
         var _loc2_:String = "2";
         var _loc3_:String = PlayerManager.Instance.Self.ID.toString();
         _loc3_ = encodeURI(_loc3_);
         var _loc4_:String = MD5.hash(_loc3_ + _loc2_ + this.key);
         this.send(_loc2_,_loc3_,_loc4_);
      }
      
      private function __outLineNotice(param1:DuowanInterfaceEvent) : void
      {
         var _loc2_:String = "3";
         var _loc3_:String = PlayerManager.Instance.Self.ID.toString();
         _loc3_ = encodeURI(_loc3_);
         var _loc4_:String = MD5.hash(_loc3_ + _loc2_ + this.key);
         this.send(_loc2_,_loc3_,_loc4_);
      }
      
      private function send(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:String = PathManager.userActionNotice();
         if(_loc4_ == "")
         {
            return;
         }
         _loc4_ = _loc4_.replace("{username}",param2);
         _loc4_ = _loc4_.replace("{type}",param1);
         _loc4_ = _loc4_.replace("{sign}",param3);
         var _loc5_:RequestLoader = LoadResourceManager.instance.createLoader(_loc4_,BaseLoader.REQUEST_LOADER);
         _loc5_.addEventListener(LoaderEvent.COMPLETE,this.__loaderComplete2);
         LoadResourceManager.instance.startLoad(_loc5_);
      }
      
      private function __loaderComplete2(param1:LoaderEvent) : void
      {
      }
   }
}
