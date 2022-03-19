// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.WorldBossRankAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import worldboss.player.RankingPersonInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class WorldBossRankAnalyzer extends DataAnalyzer 
    {

        public var list:Vector.<RankingPersonInfo>;

        public function WorldBossRankAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
            this.list = new Vector.<RankingPersonInfo>();
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_4:XML;
            var _local_5:RankingPersonInfo;
            var _local_2:XML = new XML(_arg_1);
            var _local_3:XMLList = _local_2..item;
            for each (_local_4 in _local_3)
            {
                _local_5 = new RankingPersonInfo();
                ObjectUtils.copyPorpertiesByXML(_local_5, _local_4);
                this.list.push(_local_5);
            };
            onAnalyzeComplete();
        }


    }
}//package ddt.data.analyze

