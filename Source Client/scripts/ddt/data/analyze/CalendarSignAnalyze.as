package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.manager.PlayerManager;
   
   public class CalendarSignAnalyze extends DataAnalyzer
   {
       
      
      public function CalendarSignAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var xml:XML = null;
         var date:Date = null;
         var data:* = param1;
         try
         {
            xml = new XML(data);
            if(xml.@value == "true")
            {
               PlayerManager.Instance.Self.awardLog = xml.DailyLogList.@AwardLog;
               PlayerManager.Instance.Self.isAward = xml.DailyLogList.@IsAward == "true";
               onAnalyzeComplete();
            }
            else
            {
               message = xml.@message;
               onAnalyzeError();
               onAnalyzeComplete();
            }
         }
         catch(e:Error)
         {
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
