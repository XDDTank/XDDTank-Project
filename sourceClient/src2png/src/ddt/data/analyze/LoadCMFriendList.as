// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.LoadCMFriendList

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import ddt.data.CMFriendInfo;
    import road7th.data.DictionaryData;
    import ddt.manager.PlayerManager;

    public class LoadCMFriendList extends DataAnalyzer 
    {

        public function LoadCMFriendList(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_5:int;
            var _local_6:CMFriendInfo;
            var _local_7:int;
            var _local_8:String;
            var _local_2:DictionaryData = new DictionaryData();
            var _local_3:XML = new XML(_arg_1);
            var _local_4:XMLList = _local_3..Item;
            if (_local_3.@value == "true")
            {
                _local_5 = 0;
                while (_local_5 < _local_4.length())
                {
                    _local_6 = new CMFriendInfo();
                    _local_6.NickName = _local_4[_local_5].@NickName;
                    _local_6.UserName = _local_4[_local_5].@UserName;
                    _local_6.UserId = _local_4[_local_5].@UserId;
                    _local_6.Photo = _local_4[_local_5].@Photo;
                    _local_6.PersonWeb = _local_4[_local_5].@PersonWeb;
                    _local_6.OtherName = _local_4[_local_5].@OtherName;
                    _local_6.level = _local_4[_local_5].@Level;
                    _local_7 = int(_local_4[_local_5].@Sex);
                    if (_local_7 == 0)
                    {
                        _local_6.sex = false;
                    }
                    else
                    {
                        _local_6.sex = true;
                    };
                    _local_8 = _local_4[_local_5].@IsExist;
                    if (_local_8 == "true")
                    {
                        _local_6.IsExist = true;
                    }
                    else
                    {
                        _local_6.IsExist = false;
                    };
                    if (!((_local_6.IsExist) && (PlayerManager.Instance.friendList[_local_6.UserId])))
                    {
                        _local_2.add(_local_6.UserName, _local_6);
                    };
                    _local_5++;
                };
                PlayerManager.Instance.CMFriendList = _local_2;
                onAnalyzeComplete();
            }
            else
            {
                message = _local_3.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }


    }
}//package ddt.data.analyze

