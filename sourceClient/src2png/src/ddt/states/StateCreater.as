// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.states.StateCreater

package ddt.states
{
    import flash.utils.Dictionary;
    import ddt.view.UIModuleSmallLoading;
    import login.LoginStateView;
    import hall.HallStateView;
    import roomLoading.RoomLoadingState;
    import roomList.pvpRoomList.RoomListController;
    import auctionHouse.controller.AuctionHouseController;
    import tofflist.TofflistController;
    import roomList.pveRoomList.DungeonListController;
    import consortion.consortionsence.ConsortionSenceStateView;
    import consortion.transportSence.TransportSenceStateView;
    import farm.view.FarmSwitchView;
    import church.controller.ChurchRoomController;
    import shop.ShopController;
    import room.view.states.MatchRoomState;
    import room.view.states.DungeonRoomState;
    import room.view.states.ChallengeRoomState;
    import room.view.states.MissionRoomState;
    import game.view.GameView;
    import game.view.MultiShootGameView;
    import room.view.states.FreshmanRoomState;
    import worldboss.WorldBossRoomController;
    import worldboss.WorldBossAwardController;
    import worldboss.view.WorldBossFightRoomState;
    import SingleDungeon.SingleDungeonMainStateView;
    import SingleDungeon.SingleDungeonSenceStateView;
    import arena.view.ArenaStateView;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.manager.PlayerManager;
    import worldboss.WorldBossManager;
    import worldboss.event.WorldBossRoomEvent;
    import com.pickgliss.utils.StringUtils;
    import ddt.data.UIModuleTypes;

    public class StateCreater implements IStateCreator 
    {

        private var _state:Dictionary = new Dictionary();
        private var _currentStateType:String;


        public function create(_arg_1:String):BaseStateView
        {
            UIModuleSmallLoading.Instance.hide();
            switch (_arg_1)
            {
                case StateType.LOGIN:
                    return (new LoginStateView());
                case StateType.MAIN:
                    return (new HallStateView());
                case StateType.ROOM_LOADING:
                    return (new RoomLoadingState());
                case StateType.ROOM_LIST:
                    return (new RoomListController());
                case StateType.AUCTION:
                    return (new AuctionHouseController());
                case StateType.TOFFLIST:
                    return (new TofflistController());
                case StateType.DUNGEON_LIST:
                    return (new DungeonListController());
                case StateType.CONSORTIA:
                    return (new ConsortionSenceStateView());
                case StateType.CONSORTION_TRANSPORT:
                    return (new TransportSenceStateView());
                case StateType.FARM:
                    return (new FarmSwitchView());
                case StateType.CHURCH_ROOM:
                    return (new ChurchRoomController());
                case StateType.SHOP:
                    return (new ShopController());
                case StateType.MATCH_ROOM:
                    return (new MatchRoomState());
                case StateType.DUNGEON_ROOM:
                    return (new DungeonRoomState());
                case StateType.CHALLENGE_ROOM:
                    return (new ChallengeRoomState());
                case StateType.MISSION_ROOM:
                    return (new MissionRoomState());
                case StateType.FIGHTING:
                    return (new GameView());
                case StateType.MULTISHOOT_FIGHTING:
                    return (new MultiShootGameView());
                case StateType.FRESHMAN_ROOM1:
                case StateType.FRESHMAN_ROOM2:
                    return (new FreshmanRoomState());
                case StateType.WORLDBOSS_ROOM:
                    return (WorldBossRoomController.Instance);
                case StateType.WORLDBOSS_AWARD:
                    return (new WorldBossAwardController());
                case StateType.WORLDBOSS_FIGHT_ROOM:
                    return (new WorldBossFightRoomState());
                case StateType.SINGLEDUNGEON:
                    return (new SingleDungeonMainStateView());
                case StateType.SINGLEDUNGEON_WALK_MAP:
                    return (new SingleDungeonSenceStateView());
                case StateType.ARENA:
                    return (new ArenaStateView());
            };
            return (null);
        }

        public function createAsync(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            var _local_5:int;
            this._currentStateType = _arg_1;
            var _local_4:StateLoadingInfo = this.getStateLoadingInfo(_arg_1, this.getNeededUIModuleByType(_arg_1), _arg_2);
            if (_local_4.isComplete)
            {
                (_arg_2(this.create(_arg_1)));
            }
            else
            {
                UIModuleSmallLoading.Instance.progress = 0;
                if ((!(_arg_3)))
                {
                    UIModuleSmallLoading.Instance.show();
                };
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onCloseLoading);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUimoduleLoadComplete);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUimoduleLoadProgress);
                _local_5 = 0;
                while (_local_5 < _local_4.neededUIModule.length)
                {
                    UIModuleLoader.Instance.addUIModuleImp(_local_4.neededUIModule[_local_5], _arg_1);
                    _local_5++;
                };
            };
        }

        private function __onCloseLoading(_arg_1:Event):void
        {
            if (((PlayerManager.Instance.Self.Grade >= 2) && (!(this._currentStateType == StateType.DUNGEON_ROOM))))
            {
                UIModuleSmallLoading.Instance.hide();
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onCloseLoading);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUimoduleLoadComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUimoduleLoadProgress);
                if (this._currentStateType == StateType.WORLDBOSS_FIGHT_ROOM)
                {
                    WorldBossManager.Instance.dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.STOPFIGHT));
                };
            };
        }

        private function getStateLoadingInfo(_arg_1:String, _arg_2:String=null, _arg_3:Function=null):StateLoadingInfo
        {
            var _local_4:StateLoadingInfo;
            var _local_5:Array;
            var _local_6:int;
            _local_4 = this._state[_arg_1];
            if (_local_4 == null)
            {
                _local_4 = new StateLoadingInfo();
                if (((!(_arg_2 == null)) && (!(_arg_2 == ""))))
                {
                    _local_5 = _arg_2.split(",");
                    _local_6 = 0;
                    while (_local_6 < _local_5.length)
                    {
                        _local_4.neededUIModule.push(_local_5[_local_6]);
                        _local_6++;
                    };
                }
                else
                {
                    _local_4.isComplete = true;
                };
                _local_4.state = _arg_1;
                _local_4.callBack = _arg_3;
                this._state[_arg_1] = _local_4;
            };
            return (_local_4);
        }

        private function __onUimoduleLoadComplete(_arg_1:UIModuleEvent):void
        {
            var _local_5:BaseStateView;
            if (StringUtils.isEmpty(_arg_1.state))
            {
                return;
            };
            var _local_2:StateLoadingInfo = this.getStateLoadingInfo(_arg_1.state);
            if (_local_2.completeedUIModule.indexOf(_arg_1.module) == -1)
            {
                _local_2.completeedUIModule.push(_arg_1.module);
            };
            var _local_3:Boolean = true;
            var _local_4:int;
            while (_local_4 < _local_2.neededUIModule.length)
            {
                if (_local_2.completeedUIModule.indexOf(_local_2.neededUIModule[_local_4]) == -1)
                {
                    _local_3 = false;
                };
                _local_4++;
            };
            _local_2.isComplete = _local_3;
            if (((_local_2.isComplete) && (this._currentStateType == _local_2.state)))
            {
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onCloseLoading);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUimoduleLoadComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUimoduleLoadProgress);
                UIModuleSmallLoading.Instance.hide();
                _local_5 = this.create(_arg_1.state);
                if (_local_2.callBack != null)
                {
                    _local_2.callBack(_local_5);
                };
            };
        }

        private function __onUimoduleLoadError(_arg_1:UIModuleEvent):void
        {
        }

        private function __onUimoduleLoadProgress(_arg_1:UIModuleEvent):void
        {
            var _local_2:StateLoadingInfo;
            var _local_3:StateLoadingInfo;
            var _local_4:int;
            var _local_5:int;
            var _local_6:Number;
            for each (_local_2 in this._state)
            {
                if (_local_2.neededUIModule.indexOf(_arg_1.module) != -1)
                {
                    _local_2.progress[_arg_1.module] = _arg_1.loader.progress;
                };
            };
            _local_3 = this.getStateLoadingInfo(_arg_1.state);
            _local_4 = 0;
            _local_5 = 0;
            while (_local_5 < _local_3.neededUIModule.length)
            {
                if (_local_3.progress[_local_3.neededUIModule[_local_5]] != null)
                {
                    _local_6 = _local_3.progress[_local_3.neededUIModule[_local_5]];
                    _local_4 = int((_local_4 + ((_local_6 * 100) / _local_3.neededUIModule.length)));
                };
                _local_5++;
            };
            if (this._currentStateType == _local_3.state)
            {
                UIModuleSmallLoading.Instance.progress = _local_4;
            };
        }

        public function getNeededUIModuleByType(_arg_1:String):String
        {
            if (_arg_1 == StateType.FIGHTING)
            {
                return ("");
            };
            if (_arg_1 == StateType.MAIN)
            {
                return (UIModuleTypes.DDT_HALL);
            };
            if (_arg_1 == StateType.TOFFLIST)
            {
                return (UIModuleTypes.TOFFLIST);
            };
            if (_arg_1 == StateType.AUCTION)
            {
                return ((UIModuleTypes.DDTAUCTION + ",") + UIModuleTypes.NEWBAGANDINFO);
            };
            if (_arg_1 == StateType.FARM)
            {
                return (UIModuleTypes.FARM);
            };
            if (_arg_1 == StateType.CONSORTIA)
            {
                return ((((((((((((UIModuleTypes.CONSORTIAII + ",") + UIModuleTypes.DDTCONSORTIA) + ",") + UIModuleTypes.WORLDBOSS_MAP) + ",") + UIModuleTypes.GAME) + ",") + UIModuleTypes.GAMEII) + ",") + UIModuleTypes.GAMEIII) + ",") + UIModuleTypes.NEWBAGANDINFO);
            };
            if (_arg_1 == StateType.CONSORTION_TRANSPORT)
            {
                return ((((((UIModuleTypes.CONSORTIA_TRANPORT + ",") + UIModuleTypes.GAME) + ",") + UIModuleTypes.GAMEII) + ",") + UIModuleTypes.GAMEIII);
            };
            if (_arg_1 == StateType.SHOP)
            {
                return (UIModuleTypes.DDTSHOP);
            };
            if ((((((_arg_1 == StateType.ROOM_LIST) || (_arg_1 == StateType.DUNGEON_LIST)) || (_arg_1 == StateType.FRESHMAN_ROOM1)) || (_arg_1 == StateType.WORLDBOSS_FIGHT_ROOM)) || (_arg_1 == StateType.SINGLEDUNGEON)))
            {
                return ((((((((((((((((UIModuleTypes.DDTROOM + ",") + UIModuleTypes.DDTROOMLIST) + ",") + UIModuleTypes.CHAT_BALL) + ",") + UIModuleTypes.GAME) + ",") + UIModuleTypes.GAMEII) + ",") + UIModuleTypes.GAMEIII) + ",") + UIModuleTypes.EXPRESSION) + ",") + UIModuleTypes.DDTROOMLOADING) + ",") + UIModuleTypes.GAMEOVER);
            };
            if (_arg_1 == StateType.FRESHMAN_ROOM2)
            {
                return ((UIModuleTypes.DDTROOMLOADING + ",") + UIModuleTypes.GAMEIII);
            };
            if ((((_arg_1 == StateType.MATCH_ROOM) || (_arg_1 == StateType.DUNGEON_ROOM)) || (_arg_1 == StateType.MISSION_ROOM)))
            {
                return ((((((((((((((UIModuleTypes.DDTROOM + ",") + UIModuleTypes.EXPRESSION) + ",") + UIModuleTypes.CHAT_BALL) + ",") + UIModuleTypes.GAME) + ",") + UIModuleTypes.GAMEII) + ",") + UIModuleTypes.GAMEIII) + ",") + UIModuleTypes.DDTROOMLOADING) + ",") + UIModuleTypes.GAMEOVER);
            };
            if (_arg_1 == StateType.CHALLENGE_ROOM)
            {
                return ((((((((((((((UIModuleTypes.CHALLENGE_ROOM + ",") + UIModuleTypes.DDTROOM) + ",") + UIModuleTypes.EXPRESSION) + ",") + UIModuleTypes.CHAT_BALL) + ",") + UIModuleTypes.GAME) + ",") + UIModuleTypes.GAMEII) + ",") + UIModuleTypes.GAMEIII) + ",") + UIModuleTypes.DDTROOMLOADING);
            };
            if (_arg_1 == StateType.DDTCHURCH_ROOM_LIST)
            {
                return (UIModuleTypes.DDTCHURCH_ROOM_LIST);
            };
            if (_arg_1 == StateType.CHURCH_ROOM)
            {
                return ((((UIModuleTypes.CHURCH_ROOM + ",") + UIModuleTypes.CHAT_BALL) + ",") + UIModuleTypes.EXPRESSION);
            };
            if (_arg_1 == StateType.CIVIL)
            {
                return (UIModuleTypes.DDTCIVIL);
            };
            if (_arg_1 == StateType.WORLDBOSS_AWARD)
            {
                return ((UIModuleTypes.WORLDBOSS_MAP + ",") + UIModuleTypes.DDTSHOP);
            };
            if (_arg_1 == StateType.WORLDBOSS_ROOM)
            {
                return ((((((((((((((((((UIModuleTypes.WORLDBOSS_MAP + ",") + UIModuleTypes.DDTROOM) + ",") + UIModuleTypes.DDTROOMLIST) + ",") + UIModuleTypes.CHAT_BALL) + ",") + UIModuleTypes.GAME) + ",") + UIModuleTypes.GAMEII) + ",") + UIModuleTypes.GAMEIII) + ",") + UIModuleTypes.EXPRESSION) + ",") + UIModuleTypes.DDTROOMLOADING) + ",") + UIModuleTypes.GAMEOVER);
            };
            if (_arg_1 == StateType.ARENA)
            {
                return ((((((((((UIModuleTypes.GAME + ",") + UIModuleTypes.GAMEII) + ",") + UIModuleTypes.GAMEIII) + ",") + UIModuleTypes.EXPRESSION) + ",") + UIModuleTypes.DDTROOMLOADING) + ",") + UIModuleTypes.GAMEOVER);
            };
            return ("");
        }


    }
}//package ddt.states

