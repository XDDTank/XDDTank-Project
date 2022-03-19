// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//liveness.LivenessBubbleManager

package liveness
{
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import worldboss.WorldBossManager;
    import worldboss.event.WorldBossRoomEvent;
    import consortion.managers.ConsortionMonsterManager;
    import consortion.event.ConsortionMonsterEvent;
    import arena.ArenaManager;
    import arena.model.ArenaEvent;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import worldboss.WorldBossRoomController;
    import ddt.manager.PlayerManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.utils.PositionUtils;
    import ddt.events.LivenessEvent;

    public class LivenessBubbleManager extends EventDispatcher 
    {

        private static var _instance:LivenessBubbleManager;
        private static const REMIND_TIME:uint = ((10 * 60) * 1000);//600000

        private var _livenessBubble:LivenessBubble;
        private var _point:Point;
        private var _needShine:Boolean;
        private var _hasClickIcon:Boolean;
        private var _worldBossIsReady:Boolean;
        private var _monsterIsReady:Boolean;
        private var _arenaIsReady:Boolean;
        private var _leftTime:Number;
        private var _secondTimerIsRunning:Boolean;

        public function LivenessBubbleManager()
        {
            this._point = new Point(0, 0);
        }

        public static function get Instance():LivenessBubbleManager
        {
            if ((!(_instance)))
            {
                _instance = new (LivenessBubbleManager)();
            };
            return (_instance);
        }


        public function setup():void
        {
            WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.GAME_INIT, this.__showLivenessBubble);
            WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.WORLDBOSS_OVER, this.__showLivenessBubble);
            ConsortionMonsterManager.Instance.addEventListener(ConsortionMonsterEvent.MONSTER_ACTIVE_START, this.__showLivenessBubble);
            ArenaManager.instance.model.addEventListener(ArenaEvent.ARENA_ACTIVITY, this.__showLivenessBubble);
            TimeManager.addEventListener(TimeEvents.MINUTES, this.__checkActivityOpen);
        }

        private function __checkActivityOpen(_arg_1:TimeEvents):void
        {
            var _local_4:Date;
            var _local_5:Array;
            var _local_6:uint;
            var _local_2:Date = TimeManager.Instance.Now();
            var _local_3:Date = new Date();
            if ((!(this._worldBossIsReady)))
            {
                _local_5 = WorldBossRoomController.Instance.beginTime();
                _local_6 = 0;
                while (_local_6 < _local_5.length)
                {
                    _local_3.setHours(_local_5[_local_6].hours, _local_5[_local_6].minutes, _local_5[_local_6].seconds, _local_5[_local_6].milliseconds);
                    if ((((_local_3.time - _local_2.time) > 0) && ((_local_3.time - _local_2.time) <= REMIND_TIME)))
                    {
                        this._worldBossIsReady = true;
                        this._leftTime = (_local_3.time - _local_2.time);
                        if ((!(this._secondTimerIsRunning)))
                        {
                            this.addSecondTimer();
                        };
                        return;
                    };
                    _local_6++;
                };
            };
            if ((!(this._monsterIsReady)))
            {
                if (((PlayerManager.Instance.Self.consortiaInfo.Level) && (PlayerManager.Instance.Self.consortiaInfo.Level >= 3)))
                {
                    _local_4 = ConsortionMonsterManager.Instance.beginTime();
                    if (_local_4)
                    {
                        _local_3.setHours(_local_4.hours, _local_4.minutes, _local_4.seconds, _local_4.milliseconds);
                        if ((((_local_3.time - _local_2.time) > 0) && ((_local_3.time - _local_2.time) <= REMIND_TIME)))
                        {
                            this._monsterIsReady = true;
                            this._leftTime = (_local_3.time - _local_2.time);
                            if ((!(this._secondTimerIsRunning)))
                            {
                                this.addSecondTimer();
                            };
                            return;
                        };
                    };
                };
            };
            if ((!(this._arenaIsReady)))
            {
                _local_4 = ArenaManager.instance.beginTime();
                _local_3.setHours(_local_4.hours, _local_4.minutes, _local_4.seconds, _local_4.milliseconds);
                if ((((_local_3.time - _local_2.time) > 0) && ((_local_3.time - _local_2.time) <= REMIND_TIME)))
                {
                    this._arenaIsReady = true;
                    this._leftTime = (_local_3.time - _local_2.time);
                    if ((!(this._secondTimerIsRunning)))
                    {
                        this.addSecondTimer();
                    };
                    return;
                };
            };
        }

        private function addSecondTimer():void
        {
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__showRemind);
            this._secondTimerIsRunning = true;
        }

        private function __showRemind(_arg_1:TimeEvents):void
        {
            var _local_2:String;
            if (((StateManager.currentStateType == StateType.MAIN) || (StateManager.currentStateType == StateType.LOGIN)))
            {
                _local_2 = "";
                if (this._worldBossIsReady)
                {
                    _local_2 = LanguageMgr.GetTranslation("ddt.livenessBubble.worldBossRemind.txt", TimeManager.Instance.formatTimeToString1(this._leftTime, false));
                }
                else
                {
                    if (this._monsterIsReady)
                    {
                        if (((PlayerManager.Instance.Self.consortiaInfo.Level) && (PlayerManager.Instance.Self.consortiaInfo.Level >= 3)))
                        {
                            _local_2 = LanguageMgr.GetTranslation("ddt.livenessBubble.monsterRemind.txt", TimeManager.Instance.formatTimeToString1(this._leftTime, false));
                        }
                        else
                        {
                            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__showRemind);
                            this._secondTimerIsRunning = false;
                            ObjectUtils.disposeObject(this._livenessBubble);
                            this._livenessBubble = null;
                            this._monsterIsReady = false;
                            return;
                        };
                    }
                    else
                    {
                        if (this._arenaIsReady)
                        {
                            _local_2 = LanguageMgr.GetTranslation("ddt.livenessBubble.arenaRemind.txt", TimeManager.Instance.formatTimeToString1(this._leftTime, false));
                        };
                    };
                };
                if ((!(this._livenessBubble)))
                {
                    this._livenessBubble = new LivenessBubble(0, false);
                    this.offsetPos();
                    this._livenessBubble.show();
                };
                this._livenessBubble.setBtnEnable(false);
                this._livenessBubble.setText(_local_2);
            };
            this._leftTime = (this._leftTime - 1000);
            if (this._leftTime < 0)
            {
                this._leftTime = 0;
            };
        }

        public function setPos(_arg_1:Point):void
        {
            this._point = _arg_1;
            if (this._livenessBubble)
            {
                this.offsetPos();
            };
        }

        private function offsetPos():void
        {
            var _local_1:Point = new Point();
            _local_1.x = this._point.x;
            _local_1.y = (this._point.y - this._livenessBubble.height);
            _local_1.y = (_local_1.y - 32);
            PositionUtils.setPos(this._livenessBubble, _local_1);
        }

        private function __showLivenessBubble(_arg_1:*):void
        {
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__showRemind);
            this._secondTimerIsRunning = false;
            ObjectUtils.disposeObject(this._livenessBubble);
            this._livenessBubble = null;
            if (((StateManager.currentStateType == StateType.MAIN) || (StateManager.currentStateType == StateType.LOGIN)))
            {
                if ((_arg_1 is ConsortionMonsterEvent))
                {
                    if ((_arg_1.data as Boolean))
                    {
                        this._livenessBubble = new LivenessBubble(LivenessBubble.MONSTER_REFLASH, true);
                        this._livenessBubble.setText(LanguageMgr.GetTranslation("ddt.liveness.bubble.monsterReflashTips.txt"));
                        this._needShine = true;
                        this._monsterIsReady = false;
                    }
                    else
                    {
                        this._needShine = false;
                    };
                    dispatchEvent(new LivenessEvent(LivenessEvent.SHOW_SHINE, this._needShine));
                }
                else
                {
                    if ((_arg_1 is ArenaEvent))
                    {
                        if (WorldBossManager.Instance.isOpen)
                        {
                            this._livenessBubble = new LivenessBubble(LivenessBubble.WORLD_BOSS, true);
                            this._livenessBubble.setText(LanguageMgr.GetTranslation("ddt.liveness.bubble.worldbossTips.txt"));
                            this._needShine = true;
                            this._worldBossIsReady = false;
                        }
                        else
                        {
                            if ((_arg_1.data as Boolean))
                            {
                                this._livenessBubble = new LivenessBubble(LivenessBubble.ARENA, true);
                                this._livenessBubble.setText(LanguageMgr.GetTranslation("ddt.liveness.bubble.arenaTips.txt"));
                                this._needShine = true;
                                this._arenaIsReady = false;
                            }
                            else
                            {
                                this._needShine = false;
                            };
                        };
                    }
                    else
                    {
                        if ((_arg_1 is WorldBossRoomEvent))
                        {
                            if (WorldBossManager.Instance.isOpen)
                            {
                                this._livenessBubble = new LivenessBubble(LivenessBubble.WORLD_BOSS, true);
                                this._livenessBubble.setText(LanguageMgr.GetTranslation("ddt.liveness.bubble.worldbossTips.txt"));
                                this._needShine = true;
                                this._worldBossIsReady = false;
                            }
                            else
                            {
                                this._needShine = false;
                            };
                            dispatchEvent(new LivenessEvent(LivenessEvent.SHOW_SHINE, this._needShine));
                        };
                    };
                };
                if (this._livenessBubble)
                {
                    this.offsetPos();
                    if (StateManager.currentStateType == StateType.MAIN)
                    {
                        this._livenessBubble.show();
                    };
                };
            };
        }

        public function hideBubble():void
        {
            if (((this._livenessBubble) && (this._livenessBubble.parent)))
            {
                this._livenessBubble.parent.removeChild(this._livenessBubble);
            };
        }

        public function tryShowBubble():void
        {
            if (((this._livenessBubble) && (!(this._livenessBubble.parent))))
            {
                this._livenessBubble.show();
            };
        }

        public function removeBubble():void
        {
            if (this._livenessBubble)
            {
                ObjectUtils.disposeObject(this._livenessBubble);
                this._livenessBubble = null;
            };
        }

        public function get needShine():Boolean
        {
            return (this._needShine);
        }

        public function get hasClickIcon():Boolean
        {
            return (this._hasClickIcon);
        }

        public function set hasClickIcon(_arg_1:Boolean):void
        {
            this._hasClickIcon = _arg_1;
        }


    }
}//package liveness

