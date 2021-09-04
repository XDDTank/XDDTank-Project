package church.view.weddingRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.geom.Point;
   import platformapi.tencent.DiamondManager;
   
   public class CalculateDate
   {
       
      
      public function CalculateDate()
      {
         super();
      }
      
      public static function start(param1:Date, param2:int) : Array
      {
         var _loc3_:Date = TimeManager.Instance.Now();
         var _loc4_:Array = new Array();
         var _loc5_:Point = ComponentFactory.Instance.creatCustomObject("church.view.weddingRoomList.pointout");
         _loc5_.y = needMoney(param1,param2);
         var _loc6_:int = (_loc3_.valueOf() - param1.valueOf()) / (60 * 60000);
         if(_loc6_ >= 720)
         {
            _loc4_[0] = "<font COLOR=\'#FFFFFF\'>" + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.exceedmounth") + "</font>";
            _loc4_[1] = "<font COLOR=\'#FFFFFF\'>" + String(_loc5_.y) + "</font>";
         }
         else if(_loc6_ >= 24 && _loc6_ < 720)
         {
            _loc4_[0] = "<font COLOR=\'#FFFFFF\'>" + String(int(_loc6_ / 24)) + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.day") + "</font>";
            if(param2 < 3)
            {
               _loc4_[1] = "<font COLOR=\'#FFFFFF\'>" + String(_loc5_.y) + "</font>";
            }
            else
            {
               _loc4_[1] = "<font COLOR=\'#FFFFFF\'>" + String(_loc5_.x) + "</font>";
            }
         }
         else if(_loc6_ < 24)
         {
            _loc4_[0] = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.notenoughday");
            if(param2 < 3)
            {
               _loc4_[1] = "<font COLOR=\'#FFFFFF\'>" + String(_loc5_.y) + "</font>";
            }
            else
            {
               _loc4_[1] = "<font COLOR=\'#FFFFFF\'>" + String(_loc5_.x) + "</font>";
            }
         }
         return _loc4_;
      }
      
      public static function needMoney(param1:Date, param2:int) : int
      {
         var _loc5_:int = 0;
         var _loc3_:Date = TimeManager.Instance.Now();
         var _loc4_:int = (_loc3_.valueOf() - param1.valueOf()) / (60 * 60000);
         if(_loc4_ >= 720)
         {
            _loc5_ = getDivoceMoney2();
         }
         else
         {
            _loc5_ = 520;
         }
         if(param2 < 3)
         {
            _loc5_ = getDivoceMoney2();
         }
         return _loc5_;
      }
      
      public static function getDivoceMoney2() : int
      {
         if(DiamondManager.instance.isInTencent)
         {
            return 123;
         }
         return 99;
      }
   }
}
