// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.player.ConsortiaPlayerInfo

package ddt.data.player
{
    import ddt.view.character.Direction;
    import ddt.manager.PlayerManager;
    import road7th.utils.DateUtils;
    import consortion.ConsortionModelControl;

    public class ConsortiaPlayerInfo extends BasePlayer 
    {

        public var PosX:int = 300;
        public var PosY:int = 300;
        public var Direct:Direction = Direction.getDirectionFromAngle(2);
        public var privateID:int;
        public var DutyID:int;
        public var IsChat:Boolean;
        public var IsDiplomatism:Boolean;
        public var IsDownGrade:Boolean;
        public var IsEditorDescription:Boolean;
        public var IsEditorPlacard:Boolean;
        public var IsEditorUser:Boolean;
        public var IsExpel:Boolean;
        public var IsInvite:Boolean;
        public var IsManageDuty:Boolean;
        public var IsRatify:Boolean;
        public var RatifierID:int;
        public var RatifierName:String;
        public var Remark:String;
        private var _IsVote:Boolean;
        public var LastWeekRichesOffer:int;
        public var ConvoyTimes:int;
        public var GuardTimes:int;
        public var HijackTimes:int;
        public var MaxHijackTimes:int;
        public var MaxConvoyTimes:int;
        public var MaxGuardTimes:int;
        public var GuardTruckId:int;
        public var IsBandChat:Boolean;
        public var LastDate:String;
        public var isSelected:Boolean;
        public var minute:int;
        public var day:int;


        public function get IsVote():Boolean
        {
            return (this._IsVote);
        }

        public function set IsVote(_arg_1:Boolean):void
        {
            this._IsVote = _arg_1;
        }

        public function get OffLineHour():int
        {
            if (((NickName == PlayerManager.Instance.Self.NickName) || (!(playerState.StateID == PlayerState.OFFLINE))))
            {
                return (-2);
            };
            var _local_1:int;
            var _local_2:Date = DateUtils.dealWithStringDate(this.LastDate);
            var _local_3:Date = DateUtils.dealWithStringDate(ConsortionModelControl.Instance.model.systemDate);
            var _local_4:Number = ((_local_3.valueOf() - _local_2.valueOf()) / 3600000);
            _local_1 = ((_local_4 < 1) ? -1 : Math.floor(_local_4));
            if (_local_4 < 1)
            {
                this.minute = (_local_4 * 60);
                if (this.minute <= 0)
                {
                    this.minute = 1;
                };
            };
            if (((_local_4 > 24) && (_local_4 < 720)))
            {
                this.day = Math.floor((_local_4 / 24));
            };
            return (_local_1);
        }


    }
}//package ddt.data.player

