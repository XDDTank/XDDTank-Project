package SingleDungeon.expedition
{
   public class ExpeditionInfo
   {
       
      
      public var SceneID:int;
      
      public var ExpeditionType:int;
      
      public var ExpeditionEnergy:int;
      
      public var ExpeditionTime:int;
      
      public var IsOnExpedition:Boolean = false;
      
      public var StartTime:Date;
      
      public var AccelerateMoney:int;
      
      public function ExpeditionInfo()
      {
         super();
      }
   }
}
