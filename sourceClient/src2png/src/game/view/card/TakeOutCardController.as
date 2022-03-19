// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.card.TakeOutCardController

package game.view.card
{
    import flash.events.EventDispatcher;
    import com.pickgliss.ui.core.Disposeable;
    import game.model.GameInfo;
    import room.model.RoomInfo;
    import flash.events.IEventDispatcher;
    import ddt.events.RoomEvent;
    import game.model.Player;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import road7th.data.DictionaryEvent;
    import room.model.RoomPlayer;
    import ddt.manager.PlayerManager;
    import ddt.data.map.MissionInfo;
    import ddt.utils.PositionUtils;
    import flash.events.Event;
    import org.aswing.KeyboardManager;
    import ddt.manager.SocketManager;
    import game.view.experience.ExpTweenManager;

    public class TakeOutCardController extends EventDispatcher implements Disposeable 
    {

        private var _gameInfo:GameInfo;
        private var _roomInfo:RoomInfo;
        private var _cardView:SmallCardsView;
        private var _showSmallCardView:Function;
        private var _showLargeCardView:Function;
        private var _isKicked:Boolean;
        private var _disposeFunc:Function;

        public function TakeOutCardController(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public function setup(_arg_1:GameInfo, _arg_2:RoomInfo):void
        {
            this._gameInfo = _arg_1;
            this._roomInfo = _arg_2;
            this.initEvent();
            if (this._gameInfo.selfGamePlayer.hasGardGet)
            {
                this.drawCardGetBuff();
            };
        }

        private function drawCardGetBuff():void
        {
        }

        public function set disposeFunc(_arg_1:Function):void
        {
            this._disposeFunc = _arg_1;
        }

        public function set showSmallCardView(_arg_1:Function):void
        {
            this._showSmallCardView = _arg_1;
        }

        public function set showLargeCardView(_arg_1:Function):void
        {
            this._showLargeCardView = _arg_1;
        }

        private function initEvent():void
        {
            if (this._gameInfo)
            {
                this._gameInfo.addEventListener(GameInfo.REMOVE_ROOM_PLAYER, this.__removePlayer);
            };
            if (this._roomInfo)
            {
                this._roomInfo.addEventListener(RoomEvent.REMOVE_PLAYER, this.__removeRoomPlayer);
            };
        }

        private function __removePlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:Player = (_arg_1.data as Player);
            if (((_local_2) && (_local_2.isSelf)))
            {
                if (((this._roomInfo.type == RoomInfo.MATCH_ROOM) || (this._roomInfo.type == RoomInfo.CHALLENGE_ROOM)))
                {
                    StateManager.setState(StateType.ROOM_LIST);
                }
                else
                {
                    StateManager.setState(StateType.DUNGEON_LIST);
                };
            };
        }

        private function __removeRoomPlayer(_arg_1:RoomEvent):void
        {
            var _local_2:RoomPlayer = (_arg_1.params[0] as RoomPlayer);
            if (((_local_2) && (_local_2.isSelf)))
            {
                this._isKicked = true;
            };
        }

        public function tryShowCard():void
        {
            if ((((this._gameInfo.roomType == RoomInfo.SINGLE_ROOM) || (this._gameInfo.roomType == RoomInfo.MATCH_ROOM)) || (this._gameInfo.roomType == RoomInfo.CHALLENGE_ROOM)))
            {
                this.__onCardViewComplete();
                return;
            };
            if (this._gameInfo.selfGamePlayer.isWin)
            {
                if (PlayerManager.Instance.Self.Grade < 2)
                {
                    this._gameInfo.missionInfo.tackCardType = MissionInfo.HAVE_NO_CARD;
                };
                if (this._gameInfo.missionInfo.tackCardType == MissionInfo.SMALL_TAKE_CARD)
                {
                    this._cardView = new SmallCardsView();
                    PositionUtils.setPos(this._cardView, "takeoutCard.SmallCardViewPos");
                    this._cardView.addEventListener(Event.COMPLETE, this.__onCardViewComplete);
                    this._showSmallCardView(this._cardView);
                }
                else
                {
                    if (this._gameInfo.missionInfo.tackCardType == MissionInfo.BIG_TACK_CARD)
                    {
                        this._cardView = new LargeCardsView();
                        this._cardView.addEventListener(Event.COMPLETE, this.__onCardViewComplete);
                        PositionUtils.setPos(this._cardView, "takeoutCard.LargeCardViewPos");
                        this._showLargeCardView(this._cardView);
                    }
                    else
                    {
                        this.__onCardViewComplete();
                    };
                };
            }
            else
            {
                this.setState();
            };
        }

        private function __onCardViewComplete(_arg_1:Event=null):void
        {
            if (this._cardView)
            {
                this._cardView.removeEventListener(Event.COMPLETE, this.__onCardViewComplete);
            };
            this.setState();
        }

        private function removeEvent():void
        {
            if (this._cardView)
            {
                this._cardView.removeEventListener(Event.COMPLETE, this.__onCardViewComplete);
                this._cardView.dispose();
            };
            if (this._roomInfo)
            {
                this._gameInfo.removeEventListener(GameInfo.REMOVE_ROOM_PLAYER, this.__removePlayer);
            };
            if (this._roomInfo)
            {
                this._roomInfo.removeEventListener(RoomEvent.REMOVE_PLAYER, this.__removeRoomPlayer);
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            KeyboardManager.getInstance().isStopDispatching = false;
            SocketManager.Instance.out.sendGetTropToBag(-1);
            PlayerManager.Instance.Self.TempBag.clearnAll();
            ExpTweenManager.Instance.isPlaying = false;
            this._cardView = null;
            this._gameInfo = null;
            this._roomInfo = null;
            this._disposeFunc = null;
            this._showSmallCardView = null;
            this._showLargeCardView = null;
        }

        public function setState():void
        {
            this._disposeFunc();
            var _local_1:String = "";
            if (this._isKicked)
            {
                if (((this._roomInfo.type == RoomInfo.MATCH_ROOM) || (this._roomInfo.type == RoomInfo.CHALLENGE_ROOM)))
                {
                    _local_1 = StateType.ROOM_LIST;
                }
                else
                {
                    _local_1 = StateType.DUNGEON_LIST;
                };
            }
            else
            {
                if (this._roomInfo.type == RoomInfo.MATCH_ROOM)
                {
                    _local_1 = StateType.MATCH_ROOM;
                }
                else
                {
                    if (this._roomInfo.type == RoomInfo.SINGLE_ROOM)
                    {
                        _local_1 = StateType.ROOM_LIST;
                    }
                    else
                    {
                        if (this._roomInfo.type == RoomInfo.CHALLENGE_ROOM)
                        {
                            _local_1 = StateType.CHALLENGE_ROOM;
                        }
                        else
                        {
                            if (this._roomInfo.type == RoomInfo.FRESHMAN_ROOM)
                            {
                                _local_1 = StateType.MAIN;
                            }
                            else
                            {
                                if ((((this._roomInfo.type == RoomInfo.DUNGEON_ROOM) || (this._roomInfo.type == RoomInfo.MULTI_DUNGEON)) && (this._gameInfo.hasNextMission)))
                                {
                                    _local_1 = StateType.MISSION_ROOM;
                                }
                                else
                                {
                                    if (this._roomInfo.type == RoomInfo.NULL_ROOM)
                                    {
                                        _local_1 = StateType.DUNGEON_LIST;
                                    }
                                    else
                                    {
                                        if (this._roomInfo.type == RoomInfo.WORLD_BOSS_FIGHT)
                                        {
                                            _local_1 = StateType.WORLDBOSS_ROOM;
                                        }
                                        else
                                        {
                                            if (this._roomInfo.type == RoomInfo.HIJACK_CAR)
                                            {
                                                _local_1 = StateType.MAIN;
                                            }
                                            else
                                            {
                                                _local_1 = StateType.DUNGEON_ROOM;
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            StateManager.setState(_local_1);
            this.dispose();
        }


    }
}//package game.view.card

