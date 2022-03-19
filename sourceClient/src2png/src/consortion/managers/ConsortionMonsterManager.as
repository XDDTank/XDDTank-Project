// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.managers.ConsortionMonsterManager

package consortion.managers
{
    import flash.events.EventDispatcher;
    import consortion.data.MonsterInfo;
    import consortion.objects.ConsortionMonster;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import room.model.RoomInfo;
    import worldboss.player.RankingPersonInfo;
    import consortion.event.ConsortionMonsterEvent;
    import room.RoomManager;
    import game.GameManager;
    import ddt.manager.GameInSocketOut;
    import ddt.manager.StateManager;
    import com.pickgliss.ui.LayerManager;
    import flash.events.Event;
    import worldboss.player.WorldBossActiveTimeInfo;
    import worldboss.WorldBossRoomController;
    import road7th.utils.DateUtils;

    public class ConsortionMonsterManager extends EventDispatcher 
    {

        private static var _instance:ConsortionMonsterManager;

        public var currentRank:Object;
        public var currentSelfInfo:Object;
        public var RankArray:Array;
        private var _monsterInfo:MonsterInfo;
        public var isFighting:Boolean = false;
        private var _activeState:Boolean = false;
        public var curMonster:ConsortionMonster;
        public var currentTimes:int;

        public function ConsortionMonsterManager(_arg_1:ThisIsSingleTon)
        {
            if (_arg_1 == null)
            {
                throw (new Error("this is singleton,can't be new like this!"));
            };
            this.initEvent();
        }

        public static function get Instance():ConsortionMonsterManager
        {
            if (_instance == null)
            {
                _instance = new ConsortionMonsterManager(new ThisIsSingleTon());
            };
            return (_instance);
        }


        public function setup():void
        {
        }

        private function initEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_MONSTER, this.__onFightReturned);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MONSTER_RANK_INFO, this.__monsterRankInfo);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SELF_MONSTER_INFO, this.__selfMonsterInfo);
        }

        private function __onFightReturned(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            if (_local_3 == 0)
            {
                SocketManager.Instance.out.createUserGuide(RoomInfo.CONSORTION_MONSTER);
            };
        }

        private function __monsterRankInfo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:RankingPersonInfo;
            var _local_7:int;
            var _local_8:int;
            var _local_2:Array = new Array();
            var _local_3:PackageIn = _arg_1.pkg;
            var _local_4:int = _local_3.readInt();
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_6 = new RankingPersonInfo();
                _local_7 = _local_3.readInt();
                _local_6.isVip = (_local_7 >= 1);
                _local_6.name = _local_3.readUTF();
                _local_6.damage = _local_3.readInt();
                _local_2.push(_local_6);
                _local_5++;
            };
            if (this.RankArray)
            {
                _local_8 = 0;
                while (_local_8 < this.RankArray.length)
                {
                    this.RankArray.shift();
                    _local_8--;
                    _local_8++;
                };
            };
            this.RankArray = _local_2;
            this.currentRank = _local_2;
            dispatchEvent(new ConsortionMonsterEvent(ConsortionMonsterEvent.UPDATE_RANKING, _local_2));
        }

        private function __selfMonsterInfo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            this.currentSelfInfo = {
                "Count":_local_3,
                "Scores":_local_4
            };
            dispatchEvent(new ConsortionMonsterEvent(ConsortionMonsterEvent.UPDATE_SELF_RANK_INFO, this.currentSelfInfo));
        }

        public function set CurrentMonster(_arg_1:MonsterInfo):void
        {
            this._monsterInfo = _arg_1;
        }

        public function set ActiveState(_arg_1:Boolean):void
        {
            this._activeState = _arg_1;
            ConsortionMonsterManager.Instance.dispatchEvent(new ConsortionMonsterEvent(ConsortionMonsterEvent.MONSTER_ACTIVE_START, _arg_1));
        }

        public function get ActiveState():Boolean
        {
            return (this._activeState);
        }

        public function removeFightEvent():void
        {
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__gameStart);
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__onSetupChanged);
            GameManager.Instance.removeEventListener(GameManager.START_LOAD, this.__startLoading);
        }

        public function setupFightEvent():void
        {
            RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__gameStart);
            RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__onSetupChanged);
        }

        private function __gameStart(_arg_1:CrazyTankSocketEvent):void
        {
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__gameStart);
            GameInSocketOut.sendGameRoomSetUp(this._monsterInfo.MissionID, RoomInfo.CONSORTION_MONSTER, false, "", "", 3, 1, 0, false, this._monsterInfo.MissionID);
            ConsortionMonsterManager.Instance.curMonster = null;
        }

        private function __onSetupChanged(_arg_1:CrazyTankSocketEvent):void
        {
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__onSetupChanged);
            GameInSocketOut.sendGameStart();
            GameManager.Instance.addEventListener(GameManager.START_LOAD, this.__startLoading);
        }

        protected function __startLoading(_arg_1:Event):void
        {
            GameManager.Instance.removeEventListener(GameManager.START_LOAD, this.__startLoading);
            StateManager.getInGame_Step_6 = true;
            if (GameManager.Instance.Current == null)
            {
                return;
            };
            LayerManager.Instance.clearnGameDynamic();
            GameManager.Instance.gotoRoomLoading();
            StateManager.getInGame_Step_7 = true;
        }

        public function getCountDownStr(_arg_1:int):String
        {
            var _local_2:int = int(Math.floor((_arg_1 / 60)));
            var _local_3:int = (_arg_1 % 60);
            return ((_local_2 + " : ") + _local_3);
        }

        public function beginTime():Date
        {
            var _local_1:Date;
            var _local_2:WorldBossActiveTimeInfo;
            for each (_local_2 in WorldBossRoomController.Instance._sceneModel.timeList)
            {
                if (_local_2.worldBossId == 11)
                {
                    _local_1 = DateUtils.dealWithStringDate(_local_2.worldBossBeginTime);
                    break;
                };
            };
            return (_local_1);
        }


    }
}//package consortion.managers

class ThisIsSingleTon 
{


}


