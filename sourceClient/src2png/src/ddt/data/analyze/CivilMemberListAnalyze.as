// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.CivilMemberListAnalyze

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import ddt.data.player.PlayerInfo;
    import ddt.data.player.CivilPlayerInfo;
    import ddt.data.player.PlayerState;

    public class CivilMemberListAnalyze extends DataAnalyzer 
    {

        public static const PATH:String = "MarryInfoPageList.ashx";

        public var civilMemberList:Array;
        public var _page:int;
        public var _name:String;
        public var _sex:Boolean;
        public var _totalPage:int;

        public function CivilMemberListAnalyze(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:PlayerInfo;
            var _local_6:Boolean;
            var _local_7:CivilPlayerInfo;
            this.civilMemberList = [];
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..Info;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new PlayerInfo();
                    _local_5.beginChanges();
                    _local_5.ID = _local_3[_local_4].@UserID;
                    _local_5.NickName = _local_3[_local_4].@NickName;
                    _local_5.ConsortiaID = _local_3[_local_4].@ConsortiaID;
                    _local_5.ConsortiaName = _local_3[_local_4].@ConsortiaName;
                    _local_5.Sex = this.converBoolean(_local_3[_local_4].@Sex);
                    _local_5.WinCount = _local_3[_local_4].@Win;
                    _local_5.TotalCount = _local_3[_local_4].@Total;
                    _local_5.EscapeCount = _local_3[_local_4].@Escape;
                    _local_5.GP = _local_3[_local_4].@GP;
                    _local_5.Style = _local_3[_local_4].@Style;
                    _local_5.Colors = _local_3[_local_4].@Colors;
                    _local_5.Hide = _local_3[_local_4].@Hide;
                    _local_5.Grade = _local_3[_local_4].@Grade;
                    _local_5.playerState = new PlayerState(int(_local_3[_local_4].@State));
                    _local_5.Repute = _local_3[_local_4].@Repute;
                    _local_5.Skin = _local_3[_local_4].@Skin;
                    _local_5.Offer = _local_3[_local_4].@Offer;
                    _local_5.IsMarried = this.converBoolean(_local_3[_local_4].@IsMarried);
                    _local_5.Nimbus = int(_local_3[_local_4].@Nimbus);
                    _local_5.DutyName = _local_3[_local_4].@DutyName;
                    _local_5.FightPower = _local_3[_local_4].@FightPower;
                    _local_5.AchievementPoint = _local_3[_local_4].@AchievementPoint;
                    _local_5.honor = _local_3[_local_4].@Rank;
                    _local_6 = ((_local_3[_local_4].@IsVIP == "true") ? true : false);
                    if (_local_6)
                    {
                        _local_5.VIPtype = 2;
                    }
                    else
                    {
                        _local_5.VIPtype = 0;
                    };
                    _local_5.VIPLevel = _local_3[_local_4].@VIPLevel;
                    _local_5.isOld = (int(_local_3[_local_4].@OldPlayer) == 1);
                    _local_7 = new CivilPlayerInfo();
                    _local_7.UserId = _local_5.ID;
                    _local_7.MarryInfoID = _local_3[_local_4].@ID;
                    _local_7.IsPublishEquip = this.converBoolean(_local_3[_local_4].@IsPublishEquip);
                    _local_7.Introduction = _local_3[_local_4].@Introduction;
                    _local_7.IsConsortia = this.converBoolean(_local_3[_local_4].@IsConsortia);
                    _local_7.info = _local_5;
                    this.civilMemberList.push(_local_7);
                    _local_5.commitChanges();
                    _local_4++;
                };
                this._totalPage = Math.ceil((int(_local_2.@total) / 12));
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }

        private function converBoolean(_arg_1:String):Boolean
        {
            if (_arg_1 == "true")
            {
                return (true);
            };
            return (false);
        }


    }
}//package ddt.data.analyze

