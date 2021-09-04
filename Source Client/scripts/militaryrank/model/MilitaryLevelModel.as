package militaryrank.model
{
   public class MilitaryLevelModel
   {
       
      
      public var Name:String;
      
      public var MinScore:int;
      
      public var MaxScore:int;
      
      public var CurrKey:int;
      
      public function MilitaryLevelModel()
      {
         super();
      }
      
      public function isThisLevel(param1:int) : Boolean
      {
         return param1 >= this.MinScore && param1 < this.MaxScore;
      }
   }
}
