// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.map.MissionInfo

package ddt.data.map
{
    import flash.events.EventDispatcher;
    import game.model.BaseSettleInfo;
    import ddt.events.RoomEvent;

    public class MissionInfo extends EventDispatcher 
    {

        public static const BIG_TACK_CARD:int = 2;
        public static const SMALL_TAKE_CARD:int = 1;
        public static const HAVE_NO_CARD:int = 0;

        public var id:int;
        public var missionIndex:int;
        public var nextMissionIndex:int;
        public var totalMissiton:int;
        public var totalCount:int;
        public var currentCount:int;
        public var title1:String = "";
        public var title2:String = "";
        public var title3:String = "";
        public var title4:String = "";
        public var currentValue1:int;
        public var currentValue2:int;
        public var currentValue3:int;
        public var currentValue4:int;
        public var totalValue1:int;
        public var totalValue2:int;
        public var totalValue3:int;
        public var totalValue4:int;
        public var countAssetPlace:int = 1;
        public var currentTurn:int;
        public var totalTurn:int;
        public var name:String;
        public var success:String = "";
        public var failure:String = "";
        public var description:String = "";
        public var missionOverPlayer:Array;
        public var missionOverNPCMovies:Array;
        public var maxTime:int;
        public var canEnterFinall:Boolean;
        public var pic:String;
        public var param1:int;
        public var param2:int;
        public var tackCardType:int = 0;
        public var tryagain:int = 0;
        private var _maxTurnCount:int = 0;
        private var _turnCount:int;


        public function findMissionOverInfo(_arg_1:int):BaseSettleInfo
        {
            if (this.missionOverPlayer == null)
            {
                return (null);
            };
            var _local_2:int;
            while (_local_2 < this.missionOverPlayer.length)
            {
                if (this.missionOverPlayer[_local_2].playerid == _arg_1)
                {
                    return (this.missionOverPlayer[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function parseString(_arg_1:String):void
        {
            var _local_2:Array = _arg_1.split(",");
            this.title1 = "";
            this.title2 = "";
            this.title3 = "";
            this.title4 = "";
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_local_2[_local_3] != null)
                {
                    this[("title" + (_local_3 + 1))] = _local_2[_local_3].toString();
                }
                else
                {
                    return;
                };
                _local_3++;
            };
        }

        public function get maxTurnCount():int
        {
            return (this._maxTurnCount);
        }

        public function set maxTurnCount(_arg_1:int):void
        {
            this._maxTurnCount = _arg_1;
        }

        public function get turnCount():int
        {
            return (this._turnCount);
        }

        public function set turnCount(_arg_1:int):void
        {
            if (this._turnCount != _arg_1)
            {
                this._turnCount = _arg_1;
                dispatchEvent(new RoomEvent(RoomEvent.TURNCOUNT_CHANGED));
            };
        }


    }
}//package ddt.data.map

