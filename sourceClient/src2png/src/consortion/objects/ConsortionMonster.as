// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.objects.ConsortionMonster

package consortion.objects
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import consortion.data.MonsterInfo;
    import flash.geom.Point;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import road.game.resource.ActionMovie;
    import flash.utils.Timer;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import consortion.event.ConsortionMonsterEvent;
    import flash.utils.setTimeout;
    import com.pickgliss.loader.ModuleLoader;
    import flash.media.SoundTransform;
    import flash.events.TimerEvent;
    import com.pickgliss.utils.ClassUtils;
    import consortion.managers.ConsortionMonsterManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;
    import com.greensock.TweenLite;
    import flash.utils.clearTimeout;

    public class ConsortionMonster extends Sprite implements Disposeable 
    {

        private static const Time:int = 5;
        private static const Distance:int = 300;

        private var _monsterInfo:MonsterInfo;
        private var _pos:Point;
        private var _expeditionAlert:BaseAlerFrame;
        private var LastPos:Point;
        protected var _actionMovie:ActionMovie;
        private var _timer:Timer;
        private var _walkTimer:Timer;
        private var _monsterNameTxt:FilterFrameText;
        private var _state:int;
        private var aimX:int;
        private var timeoutID1:uint;
        private var timeoutID2:uint;

        public function ConsortionMonster(_arg_1:MonsterInfo, _arg_2:Point)
        {
            this._pos = _arg_2.clone();
            this.LastPos = _arg_2;
            this._monsterInfo = _arg_1;
            this.initMovie();
            this._monsterNameTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.monster.name");
            this._monsterNameTxt.text = this._monsterInfo.MonsterName;
            this._monsterNameTxt.x = -31;
            this._monsterNameTxt.y = 13;
            addChild(this._monsterNameTxt);
            this.x = this._pos.x;
            this.y = this._pos.y;
            this.initEvent();
            if (this._monsterInfo.State == MonsterInfo.FIGHTING)
            {
                this.visible = false;
            };
        }

        public function set Pos(_arg_1:Point):void
        {
            this._pos = _arg_1;
            this.LastPos = _arg_1;
        }

        private function TimeEx():Number
        {
            return (Time / Distance);
        }

        public function get MonsterState():int
        {
            return (this._state);
        }

        public function set MonsterState(_arg_1:int):void
        {
            this._state = _arg_1;
            if (this._state == MonsterInfo.DEAD)
            {
                this.dispose();
            }
            else
            {
                if (this._state == MonsterInfo.FIGHTING)
                {
                    this.visible = false;
                    if (((this._walkTimer) && (this._walkTimer.running)))
                    {
                        this._walkTimer.stop();
                    };
                }
                else
                {
                    this.visible = true;
                    if (((this._walkTimer) && (!(this._walkTimer.running))))
                    {
                        this.startTimer();
                    };
                };
            };
        }

        public function get monsterInfo():MonsterInfo
        {
            return (this._monsterInfo);
        }

        private function initEvent():void
        {
            this.addEventListener(MouseEvent.CLICK, this.__onMonsterClick);
            this._monsterInfo.addEventListener(ConsortionMonsterEvent.UPDATE_MONSTER_STATE, this.__onStateChange);
        }

        private function removeEvent():void
        {
            this.removeEventListener(MouseEvent.CLICK, this.__onMonsterClick);
            this._monsterInfo.removeEventListener(ConsortionMonsterEvent.UPDATE_MONSTER_STATE, this.__onStateChange);
        }

        private function __onStateChange(_arg_1:ConsortionMonsterEvent):void
        {
            this.MonsterState = (_arg_1.data as int);
        }

        private function startTimer():void
        {
            this.timeoutID1 = setTimeout(this._walkTimer.start, Math.abs((Math.random() * 5000)));
        }

        private function initMovie():void
        {
            var _local_1:Class;
            if (ModuleLoader.hasDefinition(this._monsterInfo.ActionMovieName))
            {
                _local_1 = (ModuleLoader.getDefinition(this._monsterInfo.ActionMovieName) as Class);
                if (this._actionMovie)
                {
                    this._actionMovie.dispose();
                    this._actionMovie = null;
                };
                this._actionMovie = new (_local_1)();
                this._actionMovie.mouseEnabled = true;
                this._actionMovie.mouseChildren = true;
                this._actionMovie.buttonMode = true;
                this._actionMovie.scrollRect = null;
                addChild(this._actionMovie);
                this.soundTransform = new SoundTransform(0);
                this._actionMovie.doAction("stand");
                this._actionMovie.scaleX = -1;
                this._walkTimer = new Timer(5000);
                this._walkTimer.addEventListener(TimerEvent.TIMER, this.__walkingNow);
                if (this.monsterInfo.State != MonsterInfo.FIGHTING)
                {
                    this.startTimer();
                };
            }
            else
            {
                this._actionMovie = (ClassUtils.CreatInstance("asset.game.defaultImage") as ActionMovie);
                this._actionMovie.mouseEnabled = false;
                this._actionMovie.mouseChildren = false;
                this._actionMovie.scrollRect = null;
                addChild(this._actionMovie);
                this._timer = new Timer(500);
                this._timer.addEventListener(TimerEvent.TIMER, this.__checkActionIsReady);
                this._timer.start();
            };
        }

        protected function __checkActionIsReady(_arg_1:TimerEvent):void
        {
            if (ModuleLoader.hasDefinition(this._monsterInfo.ActionMovieName))
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, this.__checkActionIsReady);
                this._timer = null;
                this.initMovie();
            };
        }

        private function __onMonsterClick(_arg_1:MouseEvent):void
        {
            ConsortionMonsterManager.Instance.curMonster = this;
        }

        public function StartFight():void
        {
            if ((((!(ConsortionMonsterManager.Instance.isFighting)) && (this.MonsterState == MonsterInfo.LIVIN)) && (this.visible)))
            {
                if (PlayerManager.Instance.Self.Bag.getItemAt(14))
                {
                    this.checkExpedition();
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                };
            };
        }

        private function checkExpedition():void
        {
            if (PlayerManager.Instance.checkExpedition())
            {
                this._expeditionAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                this._expeditionAlert.moveEnable = false;
                this._expeditionAlert.addEventListener(FrameEvent.RESPONSE, this.__expeditionConfirmResponse);
            }
            else
            {
                this.sendStartFight();
            };
        }

        private function __expeditionConfirmResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__expeditionConfirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                SocketManager.Instance.out.sendExpeditionCancle();
                this.sendStartFight();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function sendStartFight():void
        {
            SocketManager.Instance.out.sendStartFightWithMonster(this._monsterInfo.ID);
            ConsortionMonsterManager.Instance.isFighting = true;
            ConsortionMonsterManager.Instance.CurrentMonster = this._monsterInfo;
            ConsortionMonsterManager.Instance.setupFightEvent();
            this.timeoutID2 = setTimeout(this.resetStartState, 3000);
        }

        private function resetStartState():void
        {
            ConsortionMonsterManager.Instance.isFighting = false;
        }

        private function __walkingNow(_arg_1:TimerEvent):void
        {
            this.walk();
        }

        public function walk(_arg_1:Point=null):void
        {
            var _local_2:int;
            this.aimX = ((Math.abs(Math.random()) * 300) + (this._pos.x - 150));
            if (this.aimX >= this.LastPos.x)
            {
                _local_2 = (this.aimX - this.LastPos.x);
                this._actionMovie.scaleX = -1;
                this._actionMovie.doAction("walk");
            }
            else
            {
                _local_2 = (this.LastPos.x - this.aimX);
                this._actionMovie.scaleX = 1;
                this._actionMovie.doAction("walk");
            };
            TweenLite.to(this, (_local_2 * this.TimeEx()), {
                "x":this.aimX,
                "onComplete":this.onTweenComplete
            });
        }

        private function onTweenComplete():void
        {
            this._actionMovie.doAction("stand");
            this.LastPos.x = this.aimX;
        }

        public function dispose():void
        {
            clearTimeout(this.timeoutID1);
            clearTimeout(this.timeoutID2);
            if (this._walkTimer)
            {
                this._walkTimer.stop();
                this._walkTimer.removeEventListener(TimerEvent.TIMER, this.__walkingNow);
                this._walkTimer = null;
            };
            TweenLite.killTweensOf(this);
            if (this._actionMovie)
            {
                this._actionMovie.dispose();
                this._actionMovie = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package consortion.objects

