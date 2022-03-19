// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.analyze.RankInfoAnalyz

package tofflist.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import tofflist.data.RankInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class RankInfoAnalyz extends DataAnalyzer 
    {

        private var _xml:XML;
        public var info:RankInfo;

        public function RankInfoAnalyz(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:XMLList;
            this._xml = new XML(_arg_1);
            if (this._xml.@value == "true")
            {
                _local_2 = XML(this._xml)..Item;
                this.info = new RankInfo();
                ObjectUtils.copyPorpertiesByXML(this.info, _local_2[0]);
                onAnalyzeComplete();
            }
            else
            {
                message = this._xml.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }


    }
}//package tofflist.analyze

