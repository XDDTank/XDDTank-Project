// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.CalendarSignAnalyze

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import ddt.manager.PlayerManager;

    public class CalendarSignAnalyze extends DataAnalyzer 
    {

        public function CalendarSignAnalyze(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(data:*):void
        {
            var xml:XML;
            var date:Date;
            try
            {
                xml = new XML(data);
                if (xml.@value == "true")
                {
                    PlayerManager.Instance.Self.awardLog = xml.DailyLogList.@AwardLog;
                    PlayerManager.Instance.Self.isAward = (xml.DailyLogList.@IsAward == "true");
                    onAnalyzeComplete();
                }
                else
                {
                    message = xml.@message;
                    onAnalyzeError();
                    onAnalyzeComplete();
                };
            }
            catch(e:Error)
            {
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }


    }
}//package ddt.data.analyze

