package activity.data
{
   public class ConditionRecord
   {
       
      
      private var _conditionIndex:int;
      
      private var _record:int;
      
      private var _remain1:int;
      
      public function ConditionRecord(param1:int, param2:int, param3:int)
      {
         super();
         this._conditionIndex = param1;
         this._record = param2;
         this._remain1 = param3;
      }
      
      public function get conditionIndex() : int
      {
         return this._conditionIndex;
      }
      
      public function get record() : int
      {
         return this._record;
      }
      
      public function get remain1() : int
      {
         return this._remain1;
      }
   }
}
