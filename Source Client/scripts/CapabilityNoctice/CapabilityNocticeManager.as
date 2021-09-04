package CapabilityNoctice
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   
   public class CapabilityNocticeManager
   {
      
      public static const ARENA_LEVEL:int = 20;
      
      public static var ARENA_NAME:String;
      
      private static var _instance:CapabilityNocticeManager;
       
      
      private var _viewDic:Array;
      
      private var _noticeDic:Array;
      
      public function CapabilityNocticeManager()
      {
         super();
         this._noticeDic = new Array();
         this._viewDic = new Array();
         ARENA_NAME = LanguageMgr.GetTranslation("ddt.capabilitynotice.arena");
         this.initEvent();
      }
      
      public static function get instance() : CapabilityNocticeManager
      {
         if(!_instance)
         {
            _instance = new CapabilityNocticeManager();
         }
         return _instance;
      }
      
      public function hide() : void
      {
         var _loc1_:CapabilityNocticeView = null;
         for each(_loc1_ in this._viewDic)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._viewDic = new Array();
      }
      
      public function addNotice(param1:int, param2:String, param3:String) : void
      {
         var _loc4_:CapabilityNoticeInfo = null;
         var _loc5_:CapabilityNoticeInfo = null;
         for each(_loc4_ in this._noticeDic)
         {
            if(_loc4_.level == param1 && _loc4_.name == param3)
            {
               return;
            }
         }
         _loc5_ = new CapabilityNoticeInfo();
         _loc5_.level = param1;
         _loc5_.pic = param2;
         _loc5_.name = param3;
         this._noticeDic.push(_loc5_);
      }
      
      public function check() : void
      {
         this.showNotice();
      }
      
      private function __update(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[PlayerInfo.GRADE] && this.checkState())
         {
            this.showNotice();
         }
      }
      
      private function showNotice() : void
      {
         var _loc2_:CapabilityNoticeInfo = null;
         var _loc3_:CapabilityNocticeView = null;
         var _loc1_:Object = SharedManager.Instance.capabilityNotice;
         for each(_loc2_ in this._noticeDic)
         {
            if(_loc2_.level == PlayerManager.Instance.Self.Grade && !_loc1_[_loc2_.name])
            {
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("ddt.capabilityNoctice.CapabilityNocticeView");
               _loc3_.info = _loc2_;
               _loc3_.show();
               this._viewDic.push(_loc3_);
               _loc1_[_loc2_.name] = true;
               SharedManager.Instance.capabilityNotice = _loc1_;
               SharedManager.Instance.save();
            }
         }
      }
      
      private function checkState() : Boolean
      {
         if(StateManager.currentStateType == StateType.MAIN)
         {
            return true;
         }
         return false;
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__update);
      }
   }
}
