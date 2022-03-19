// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.LikeFriendAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import ddt.data.player.LikeFriendInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class LikeFriendAnalyzer extends DataAnalyzer 
    {

        public var likeFriendList:Array;

        public function LikeFriendAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_4:int;
            var _local_5:LikeFriendInfo;
            this.likeFriendList = new Array();
            var _local_2:XML = new XML(_arg_1);
            var _local_3:XMLList = _local_2..Item;
            if (_local_2.@value == "true")
            {
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new LikeFriendInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    _local_5.isOld = (int(_local_3[_local_4].@OldPlayer) == 1);
                    this.likeFriendList.push(_local_5);
                    _local_4++;
                };
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

