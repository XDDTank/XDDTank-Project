package ddt.data.quest
{
   public class QuestImproveInfo
   {
       
      
      private var _bindMoneyRate:Array;
      
      private var _expRate:Array;
      
      private var _goldRate:Array;
      
      private var _exploitRate:Array;
      
      private var _canOneKeyFinishTime:int;
      
      public function QuestImproveInfo()
      {
         super();
      }
      
      public function get canOneKeyFinishTime() : int
      {
         return this._canOneKeyFinishTime;
      }
      
      public function set canOneKeyFinishTime(param1:int) : void
      {
         this._canOneKeyFinishTime = param1;
      }
      
      public function get exploitRate() : Array
      {
         return this._exploitRate;
      }
      
      public function set exploitRate(param1:Array) : void
      {
         this._exploitRate = param1;
      }
      
      public function get goldRate() : Array
      {
         return this._goldRate;
      }
      
      public function set goldRate(param1:Array) : void
      {
         this._goldRate = param1;
      }
      
      public function get expRate() : Array
      {
         return this._expRate;
      }
      
      public function set expRate(param1:Array) : void
      {
         this._expRate = param1;
      }
      
      public function get bindMoneyRate() : Array
      {
         return this._bindMoneyRate;
      }
      
      public function set bindMoneyRate(param1:Array) : void
      {
         this._bindMoneyRate = param1;
      }
   }
}
