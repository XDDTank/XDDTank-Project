// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.LoadPlayerWebsiteInfoAnalyze

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;

    public class LoadPlayerWebsiteInfoAnalyze extends DataAnalyzer 
    {

        public var info:Dictionary = new Dictionary(true);

        public function LoadPlayerWebsiteInfoAnalyze(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:XML = new XML(_arg_1);
            if (_local_2)
            {
                this.info["uid"] = _local_2.uid.toString();
                this.info["name"] = _local_2.name.toString();
                this.info["gender"] = _local_2.gender.toString();
                this.info["userName"] = _local_2.userName.toString();
                this.info["university"] = _local_2.university.toString();
                this.info["city"] = _local_2.city.toString();
                this.info["tinyHeadUrl"] = _local_2.tinyHeadUrl.toString();
                this.info["largeHeadUrl"] = _local_2.largeHeadUrl.toString();
                this.info["personWeb"] = _local_2.personWeb.toString();
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }


    }
}//package ddt.data.analyze

