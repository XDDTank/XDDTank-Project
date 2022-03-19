// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.WeaponBallInfoAnalyze

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;

    public class WeaponBallInfoAnalyze extends DataAnalyzer 
    {

        public var bombs:Dictionary;

        public function WeaponBallInfoAnalyze(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(data:*):void
        {
            var xmllist:XMLList;
            var i:int;
            var attr:XMLList;
            var bombIds:Array;
            var TemplateID:int;
            var item:XML;
            var propname:String;
            var value:int;
            var xml:XML = new XML(data);
            this.bombs = new Dictionary();
            if (xml.@value == "true")
            {
                xmllist = xml..Item;
                i = 0;
                while (i < xmllist.length())
                {
                    attr = xmllist[i].attributes();
                    bombIds = [];
                    for each (item in attr)
                    {
                        propname = item.name().toString();
                        try
                        {
                            if (propname == "TemplateID")
                            {
                                TemplateID = int(item);
                            }
                            else
                            {
                                value = int(item);
                                bombIds.push(value);
                            };
                        }
                        catch(e:Error)
                        {
                        };
                    };
                    this.bombs[TemplateID] = bombIds;
                    i = (i + 1);
                };
                onAnalyzeComplete();
            }
            else
            {
                message = xml.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }


    }
}//package ddt.data.analyze

