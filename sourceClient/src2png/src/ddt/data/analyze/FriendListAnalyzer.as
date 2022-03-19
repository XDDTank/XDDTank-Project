// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.FriendListAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import im.info.CustomInfo;
    import road7th.data.DictionaryData;
    import ddt.data.player.FriendListPlayer;
    import ddt.data.player.PlayerState;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.PathManager;
    import ddt.manager.PlayerManager;
    import im.IMController;
    import __AS3__.vec.*;

    public class FriendListAnalyzer extends DataAnalyzer 
    {

        public var customList:Vector.<CustomInfo>;
        public var friendlist:DictionaryData;
        public var blackList:DictionaryData;

        public function FriendListAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:int;
            var _local_6:XMLList;
            var _local_7:int;
            var _local_8:CustomInfo;
            var _local_9:CustomInfo;
            var _local_10:FriendListPlayer;
            var _local_11:PlayerState;
            var _local_12:Array;
            var _local_2:XML = new XML(_arg_1);
            this.friendlist = new DictionaryData();
            this.blackList = new DictionaryData();
            this.customList = new Vector.<CustomInfo>();
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..customList;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    if (_local_3[_local_4].@Name != "")
                    {
                        _local_8 = new CustomInfo();
                        ObjectUtils.copyPorpertiesByXML(_local_8, _local_3[_local_4]);
                        this.customList.push(_local_8);
                    };
                    _local_4++;
                };
                _local_5 = 0;
                while (_local_5 < this.customList.length)
                {
                    if (this.customList[_local_5].ID == 1)
                    {
                        _local_9 = this.customList[_local_5];
                        this.customList.splice(_local_5, 1);
                        this.customList.push(_local_9);
                    };
                    _local_5++;
                };
                _local_6 = _local_2..Item;
                _local_7 = 0;
                while (_local_7 < _local_6.length())
                {
                    _local_10 = new FriendListPlayer();
                    ObjectUtils.copyPorpertiesByXML(_local_10, _local_6[_local_7]);
                    _local_10.isOld = (int(_local_6[_local_7].@OldPlayer) == 1);
                    if (_local_10.Birthday != "Null")
                    {
                        _local_12 = _local_10.Birthday.split(/-/g);
                        _local_10.BirthdayDate = new Date();
                        _local_10.BirthdayDate.fullYearUTC = Number(_local_12[0]);
                        _local_10.BirthdayDate.monthUTC = (Number(_local_12[1]) - 1);
                        _local_10.BirthdayDate.dateUTC = Number(_local_12[2]);
                    };
                    _local_11 = new PlayerState(int(_local_2.Item[_local_7].@State));
                    _local_10.playerState = _local_11;
                    _local_10.apprenticeshipState = _local_2.Item[_local_7].@ApprenticeshipState;
                    if (_local_10.Relation != 1)
                    {
                        this.friendlist.add(_local_10.ID, _local_10);
                    }
                    else
                    {
                        this.blackList.add(_local_10.ID, _local_10);
                    };
                    _local_7++;
                };
                if (((PlayerManager.Instance.Self.IsFirst == 1) && (PathManager.CommunityExist())))
                {
                    IMController.Instance.createConsortiaLoader();
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

