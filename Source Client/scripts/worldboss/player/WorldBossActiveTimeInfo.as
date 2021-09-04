package worldboss.player
{
   public class WorldBossActiveTimeInfo
   {
       
      
      private var _worldBossId:int;
      
      private var _worldBossName:String;
      
      private var _worldBossBeginTime:String;
      
      private var _worldBossEndTime:String;
      
      public function WorldBossActiveTimeInfo()
      {
         super();
      }
      
      public function get worldBossEndTime() : String
      {
         return this._worldBossEndTime;
      }
      
      public function set worldBossEndTime(param1:String) : void
      {
         this._worldBossEndTime = param1;
      }
      
      public function get worldBossId() : int
      {
         return this._worldBossId;
      }
      
      public function set worldBossId(param1:int) : void
      {
         this._worldBossId = param1;
      }
      
      public function get worldBossName() : String
      {
         return this._worldBossName;
      }
      
      public function set worldBossName(param1:String) : void
      {
         this._worldBossName = param1;
      }
      
      public function get worldBossBeginTime() : String
      {
         return this._worldBossBeginTime;
      }
      
      public function set worldBossBeginTime(param1:String) : void
      {
         this._worldBossBeginTime = param1;
      }
   }
}
