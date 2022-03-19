// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.GameOverAction

package game.actions
{
    import ddt.events.CrazyTankSocketEvent;
    import game.view.map.MapView;
    import game.model.GameInfo;
    import game.GameManager;
    import room.RoomManager;
    import road7th.comm.PackageIn;
    import game.model.Living;
    import game.model.Player;
    import game.view.experience.ExpView;
    import road7th.utils.MovieClipWrapper;
    import flash.display.MovieClip;
    import com.pickgliss.utils.ClassUtils;
    import SingleDungeon.SingleDungeonManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.manager.SoundManager;

    public class GameOverAction extends BaseAction 
    {

        private var _event:CrazyTankSocketEvent;
        private var _executed:Boolean;
        private var _count:int;
        private var _map:MapView;
        private var _current:GameInfo;
        private var _func:Function;

        public function GameOverAction(_arg_1:MapView, _arg_2:CrazyTankSocketEvent, _arg_3:Function, _arg_4:Number=3000)
        {
            this._func = _arg_3;
            this._event = _arg_2;
            this._map = _arg_1;
            this._count = (_arg_4 / 40);
            this._current = GameManager.Instance.Current;
            this.readInfo(_arg_2);
            if (RoomManager.Instance.current.selfRoomPlayer.isViewer)
            {
                this._executed = true;
            };
        }

        private function readInfo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn;
            var _local_3:int;
            var _local_4:int;
            var _local_5:Living;
            var _local_6:int;
            var _local_7:Boolean;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:Object;
            var _local_17:Player;
            if (this._current)
            {
                _local_2 = _arg_1.pkg;
                _local_3 = _local_2.readInt();
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    _local_6 = _local_2.readInt();
                    _local_7 = _local_2.readBoolean();
                    _local_8 = _local_2.readInt();
                    _local_9 = _local_2.readInt();
                    _local_10 = _local_2.readInt();
                    _local_11 = _local_2.readInt();
                    _local_12 = _local_2.readInt();
                    _local_13 = _local_2.readInt();
                    _local_14 = _local_2.readInt();
                    _local_15 = _local_2.readInt();
                    _local_16 = {};
                    _local_16.killGP = _local_2.readInt();
                    _local_16.hertGP = _local_2.readInt();
                    _local_16.baseExp = _local_2.readInt();
                    _local_16.ghostGP = _local_2.readInt();
                    _local_16.gpForVIP = _local_2.readInt();
                    _local_16.gpForConsortia = _local_2.readInt();
                    _local_16.gpForSpouse = _local_2.readInt();
                    _local_16.gpForServer = _local_2.readInt();
                    _local_16.gpForApprenticeOnline = _local_2.readInt();
                    _local_16.gpForApprenticeTeam = _local_2.readInt();
                    _local_16.gpForDoubleCard = _local_2.readInt();
                    _local_16.gpForPower = _local_2.readInt();
                    _local_16.consortiaSkill = _local_2.readInt();
                    _local_16.luckyExp = _local_2.readInt();
                    _local_16.gainGP = _local_2.readInt();
                    _local_16.offerFight = _local_2.readInt();
                    _local_16.offerDoubleCard = _local_2.readInt();
                    _local_16.offerVIP = _local_2.readInt();
                    _local_16.offerService = _local_2.readInt();
                    _local_16.offerBuff = _local_2.readInt();
                    _local_16.offerConsortia = _local_2.readInt();
                    _local_16.luckyOffer = _local_2.readInt();
                    _local_16.gainOffer = _local_2.readInt();
                    _local_16.canTakeOut = _local_2.readInt();
                    _local_16.militaryScore = _local_2.readInt();
                    _local_16.exploit = _local_2.readInt();
                    _local_16.gameOverType = ExpView.GAME_OVER_TYPE_1;
                    _local_17 = this._current.findPlayer(_local_6);
                    if (_local_17)
                    {
                        _local_17.isWin = _local_7;
                        _local_17.CurrentGP = _local_9;
                        _local_17.CurrentLevel = _local_8;
                        _local_17.expObj = _local_16;
                        _local_17.GainGP = _local_16.gainGP;
                        _local_17.GainOffer = _local_16.gainOffer;
                        _local_17.GetCardCount = _local_16.canTakeOut;
                        _local_17.playerInfo.MilitaryRankScores = _local_2.readInt();
                        _local_17.playerInfo.FightCount = _local_2.readInt();
                        _local_17.playerInfo.FightPower = _local_10;
                        _local_17.playerInfo.Damage = _local_11;
                        _local_17.playerInfo.Guard = _local_12;
                        _local_17.playerInfo.Agility = _local_13;
                        _local_17.playerInfo.Luck = _local_14;
                        _local_17.playerInfo.hp = _local_15;
                        _local_17.fightRobotRewardGold = _local_2.readInt();
                        _local_17.fightRobotRewardMagicSoul = _local_2.readInt();
                    };
                    _local_4++;
                };
                this._current.GainRiches = _local_2.readInt();
                for each (_local_5 in this._current.livings)
                {
                    if (_local_5.character)
                    {
                        _local_5.character.resetShowBitmapBig();
                    };
                };
            };
        }

        override public function cancel():void
        {
            this._event.executed = true;
            this._current = null;
            this._map = null;
            this._event = null;
            this._func = null;
        }

        override public function execute():void
        {
            var _local_1:MovieClipWrapper;
            if (RoomManager.Instance.current.selfRoomPlayer.isViewer)
            {
                this._executed = true;
            };
            if ((!(this._executed)))
            {
                if (((this._map.hasSomethingMoving() == false) && ((this._map.currentPlayer == null) || (this._map.currentPlayer.actionCount == 0))))
                {
                    this._executed = true;
                    this._event.executed = true;
                    if (((this._map.currentPlayer) && (this._map.currentPlayer.isExist)))
                    {
                        this._map.currentPlayer.beginNewTurn();
                    };
                    if (GameManager.Instance.Current.selfGamePlayer.isWin)
                    {
                        _local_1 = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.winAsset")), true, true);
                    }
                    else
                    {
                        if (((StateManager.currentStateType == StateType.SINGLEDUNGEON) && ((SingleDungeonManager.Instance.currentFightType == 3) || (SingleDungeonManager.Instance.currentFightType == 4))))
                        {
                            _local_1 = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.endAsset")), true, true);
                        }
                        else
                        {
                            _local_1 = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.lostAsset")), true, true);
                        };
                    };
                    SoundManager.instance.play("040");
                    _local_1.movie.x = 500;
                    _local_1.movie.y = 360;
                    this._map.gameView.addChild(_local_1.movie);
                };
            }
            else
            {
                this._count--;
                if (this._count <= 0)
                {
                    this._func();
                    _isFinished = true;
                    this.cancel();
                };
            };
        }


    }
}//package game.actions

