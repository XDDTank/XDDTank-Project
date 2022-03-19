// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.InvitedFriendListAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import ddt.data.player.InvitedFirendListPlayer;
    import ddt.data.player.PlayerState;
    import com.pickgliss.utils.ObjectUtils;

    public class InvitedFriendListAnalyzer extends DataAnalyzer 
    {

        public var friendlist:DictionaryData;
        public var invitedAwardStep:int;
        public var InviterID:int;

        public function InvitedFriendListAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:InvitedFirendListPlayer;
            var _local_6:PlayerState;
            var _local_2:XML = new XML(_arg_1);
            this.friendlist = new DictionaryData();
            if (_local_2.@value == "true")
            {
                this.invitedAwardStep = _local_2.@AwardStep;
                this.InviterID = _local_2.@InviterID;
                _local_3 = _local_2..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new InvitedFirendListPlayer();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_3[_local_4]);
                    _local_6 = new PlayerState(int(_local_2.Item[_local_4].@State));
                    _local_5.playerState = _local_6;
                    _local_5.apprenticeshipState = _local_2.Item[_local_4].@ApprenticeshipState;
                    this.friendlist.add(_local_5.UserID, _local_5);
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

