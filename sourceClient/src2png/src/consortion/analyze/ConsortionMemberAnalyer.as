// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.analyze.ConsortionMemberAnalyer

package consortion.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import ddt.data.player.ConsortiaPlayerInfo;
    import ddt.data.player.PlayerState;
    import consortion.ConsortionModelControl;
    import ddt.manager.PlayerManager;

    public class ConsortionMemberAnalyer extends DataAnalyzer 
    {

        public var consortionMember:DictionaryData;

        public function ConsortionMemberAnalyer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:int;
            var _local_5:ConsortiaPlayerInfo;
            var _local_6:PlayerState;
            var _local_7:Boolean;
            var _local_2:XML = new XML(_arg_1);
            this.consortionMember = new DictionaryData();
            if (_local_2.@value == "true")
            {
                ConsortionModelControl.Instance.model.systemDate = XML(_local_2).@currentDate;
                _local_3 = _local_2..Item;
                _local_4 = 0;
                while (_local_4 < _local_3.length())
                {
                    _local_5 = new ConsortiaPlayerInfo();
                    _local_5.beginChanges();
                    _local_5.IsVote = this.converBoolean(_local_3[_local_4].@IsVote);
                    _local_5.privateID = _local_3[_local_4].@ID;
                    _local_5.ConsortiaID = PlayerManager.Instance.Self.ConsortiaID;
                    _local_5.ConsortiaName = PlayerManager.Instance.Self.ConsortiaName;
                    _local_5.DutyID = _local_3[_local_4].@DutyID;
                    _local_5.DutyName = _local_3[_local_4].@DutyName;
                    _local_5.GP = _local_3[_local_4].@GP;
                    _local_5.Grade = _local_3[_local_4].@Grade;
                    _local_5.FightPower = _local_3[_local_4].@FightPower;
                    _local_5.AchievementPoint = _local_3[_local_4].@AchievementPoint;
                    _local_5.honor = _local_3[_local_4].@Rank;
                    _local_5.IsChat = this.converBoolean(_local_3[_local_4].@IsChat);
                    _local_5.IsDiplomatism = this.converBoolean(_local_3[_local_4].@IsDiplomatism);
                    _local_5.IsDownGrade = this.converBoolean(_local_3[_local_4].@IsDownGrade);
                    _local_5.IsEditorDescription = this.converBoolean(_local_3[_local_4].@IsEditorDescription);
                    _local_5.IsEditorPlacard = this.converBoolean(_local_3[_local_4].@IsEditorPlacard);
                    _local_5.IsEditorUser = this.converBoolean(_local_3[_local_4].@IsEditorUser);
                    _local_5.IsExpel = this.converBoolean(_local_3[_local_4].@IsExpel);
                    _local_5.IsInvite = this.converBoolean(_local_3[_local_4].@IsInvite);
                    _local_5.IsManageDuty = this.converBoolean(_local_3[_local_4].@IsManageDuty);
                    _local_5.IsRatify = this.converBoolean(_local_3[_local_4].@IsRatify);
                    _local_5.IsUpGrade = this.converBoolean(_local_3[_local_4].@IsUpGrade);
                    _local_5.IsBandChat = this.converBoolean(_local_3[_local_4].@IsBanChat);
                    _local_5.Offer = int(_local_3[_local_4].@Offer);
                    _local_5.RatifierID = _local_3[_local_4].@RatifierID;
                    _local_5.RatifierName = _local_3[_local_4].@RatifierName;
                    _local_5.Remark = _local_3[_local_4].@Remark;
                    _local_5.Repute = _local_3[_local_4].@Repute;
                    _local_6 = new PlayerState(int(_local_3[_local_4].@State));
                    _local_5.playerState = _local_6;
                    _local_5.LastDate = _local_3[_local_4].@LastDate;
                    _local_5.ID = _local_3[_local_4].@UserID;
                    _local_5.NickName = _local_3[_local_4].@UserName;
                    _local_7 = ((_local_3[_local_4].@IsVIP == "true") ? true : false);
                    if (_local_7)
                    {
                        _local_5.VIPtype = 2;
                    }
                    else
                    {
                        _local_5.VIPtype = 0;
                    };
                    _local_5.VIPLevel = _local_3[_local_4].@VIPLevel;
                    _local_5.LoginName = _local_3[_local_4].@LoginName;
                    _local_5.Sex = this.converBoolean(_local_3[_local_4].@Sex);
                    _local_5.EscapeCount = _local_3[_local_4].@EscapeCount;
                    _local_5.Right = _local_3[_local_4].@Right;
                    _local_5.WinCount = _local_3[_local_4].@WinCount;
                    _local_5.TotalCount = _local_3[_local_4].@TotalCount;
                    _local_5.RichesOffer = _local_3[_local_4].@RichesOffer;
                    _local_5.RichesRob = _local_3[_local_4].@RichesRob;
                    _local_5.UseOffer = _local_3[_local_4].@TotalRichesOffer;
                    _local_5.beforeOffer = _local_3[_local_4].@beforeOffer;
                    _local_5.DutyLevel = _local_3[_local_4].@DutyLevel;
                    _local_5.LastWeekRichesOffer = parseInt(_local_3[_local_4].@LastWeekRichesOffer);
                    _local_5.isOld = (int(_local_3[_local_4].@OldPlayer) == 1);
                    _local_5.commitChanges();
                    this.consortionMember.add(_local_5.ID, _local_5);
                    if (_local_5.ID == PlayerManager.Instance.Self.ID)
                    {
                        PlayerManager.Instance.Self.ConsortiaID = _local_5.ConsortiaID;
                        PlayerManager.Instance.Self.DutyLevel = _local_5.DutyLevel;
                        PlayerManager.Instance.Self.DutyName = _local_5.DutyName;
                        PlayerManager.Instance.Self.Right = _local_5.Right;
                    };
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

        private function converBoolean(_arg_1:String):Boolean
        {
            return ((_arg_1 == "true") ? true : false);
        }


    }
}//package consortion.analyze

