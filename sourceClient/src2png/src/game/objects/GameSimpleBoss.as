// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.GameSimpleBoss

package game.objects
{
    import ddt.events.CrazyTankSocketEvent;
    import game.model.Living;
    import game.model.SimpleBoss;
    import room.RoomManager;
    import ddt.view.chat.chatBall.ChatBallPlayer;
    import ddt.view.chat.chatBall.ChatBallBoss;
    import flash.geom.Rectangle;
    import game.actions.LivingFallingAction;
    import ddt.events.LivingEvent;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.MovieClip;
    import game.actions.ChangeDirectionAction;
    import phy.maps.Map;
    import game.actions.MonsterShootBombAction;
    import game.model.Player;
    import flash.events.Event;
    import game.animations.AnimationLevel;
    import game.animations.AnimationSet;

    public class GameSimpleBoss extends GameTurnedLiving 
    {

        private var bombList:Array = [];
        private var shootEvt:CrazyTankSocketEvent;
        private var shoots:Array = [];

        public function GameSimpleBoss(_arg_1:SimpleBoss)
        {
            super(_arg_1);
            _arg_1.defaultAction = Living.STAND_ACTION;
        }

        override protected function initView():void
        {
            initMovie();
            this.initFreezonRect();
            super.initView();
            _nickName.x = (_nickName.x - 2);
            _nickName.y = (_nickName.y + 2);
        }

        override protected function initChatball():void
        {
            if (RoomManager.Instance.current.mapId == 18)
            {
                _chatballview = new ChatBallPlayer();
            }
            else
            {
                _chatballview = new ChatBallBoss();
            };
            _originalHeight = this.height;
            _originalWidth = this.width;
            addChild(_chatballview);
        }

        override protected function initFreezonRect():void
        {
            _effRect = new Rectangle(-10, 35, (bodyWidth * 1.3), (bodyHeight * 1.4));
        }

        override protected function __fall(_arg_1:LivingEvent):void
        {
            if ((!(_isDie)))
            {
                _info.act(new LivingFallingAction(this, _arg_1.paras[0], _arg_1.paras[1], _arg_1.paras[3]));
            };
        }

        override protected function __forzenChanged(_arg_1:LivingEvent):void
        {
            if (_info.isFrozen)
            {
                effectForzen = (ComponentFactory.Instance.creatCustomObject("asset.gameFrostEffectAsset") as MovieClip);
                effectForzen.width = _effRect.width;
                effectForzen.height = _effRect.height;
                effectForzen.x = _effRect.x;
                effectForzen.y = _effRect.y;
                addChild(effectForzen);
            }
            else
            {
                if (effectForzen)
                {
                    removeChild(effectForzen);
                    effectForzen = null;
                };
            };
        }

        override protected function __dirChanged(_arg_1:LivingEvent):void
        {
            _info.act(new ChangeDirectionAction(this, _info.direction));
        }

        override public function setMap(_arg_1:Map):void
        {
            super.setMap(_arg_1);
            if (_arg_1)
            {
                this.__posChanged(null);
            };
        }

        override protected function __shoot(_arg_1:LivingEvent):void
        {
            map.act(new MonsterShootBombAction(this, _arg_1.paras[0], _arg_1.paras[1], Player.SHOOT_INTERVAL));
        }

        override protected function __attackingChanged(_arg_1:LivingEvent):void
        {
        }

        override protected function __posChanged(_arg_1:LivingEvent):void
        {
            super.__posChanged(_arg_1);
        }

        public function get simpleBoss():SimpleBoss
        {
            return (info as SimpleBoss);
        }

        override protected function __bloodChanged(_arg_1:LivingEvent):void
        {
            if (_arg_1.paras[0] == 0)
            {
                if (_actionMovie != null)
                {
                    _actionMovie.doAction(Living.RENEW, super.__bloodChanged, [_arg_1]);
                };
            }
            else
            {
                if (_arg_1.paras[0] == 10)
                {
                    super.__bloodChanged(_arg_1);
                }
                else
                {
                    if (_arg_1.paras[0] == 5)
                    {
                        updateBloodStrip();
                        return;
                    };
                    super.__bloodChanged(_arg_1);
                    if (_info.State != 1)
                    {
                        doAction(Living.CRY_ACTION);
                    };
                };
            };
        }

        override protected function __die(_arg_1:LivingEvent):void
        {
            if (isMoving())
            {
                stopMoving();
            };
            super.__die(_arg_1);
        }

        override protected function doDieAction():void
        {
            if (_info.typeLiving == 6)
            {
                _actionMovie.doAction("specialDie");
                return;
            };
            if (_doDieAction)
            {
                if (_info.typeLiving == 5)
                {
                    _actionMovie.doAction(Living.DIE_ACTION, this.clearEnemy);
                }
                else
                {
                    _actionMovie.doAction(Living.DIE_ACTION, this.dispose);
                };
            }
            else
            {
                if (_info.typeLiving == 5)
                {
                    this.clearEnemy();
                }
                else
                {
                    this.dispose();
                };
            };
            _isDie = true;
        }

        private function clearEnemy():void
        {
            removeListener();
            deleteSmallView();
        }

        override protected function __changeState(_arg_1:LivingEvent):void
        {
            if (_info.State == 1)
            {
                doAction(Living.ANGRY_ACTION);
            }
            else
            {
                doAction(Living.STAND_ACTION);
            };
        }

        override public function dispose():void
        {
            if (((_chatballview.visible) && (_chatballview.parent)))
            {
                _chatballview.addEventListener(Event.COMPLETE, this.__disposeLater);
                return;
            };
            if (((map) && (map.currentPlayer == _info)))
            {
                map.currentPlayer = null;
            };
            super.dispose();
        }

        private function __disposeLater(_arg_1:Event):void
        {
            _chatballview.removeEventListener(Event.COMPLETE, this.__disposeLater);
            this.dispose();
        }

        override public function needFocus(_arg_1:int=0, _arg_2:int=0, _arg_3:Object=null, _arg_4:Boolean=false):void
        {
            map.livingSetCenter((x + _arg_1), ((y + _arg_2) - 150), _arg_4, AnimationLevel.HIGHT, AnimationSet.PUBLIC_OWNER, _arg_3);
        }

        override public function followFocus(_arg_1:int=0, _arg_2:int=0, _arg_3:Object=null, _arg_4:Boolean=false):void
        {
            map.livingSetCenter((x + _arg_1), ((y + _arg_2) - 150), _arg_4, AnimationLevel.HIGHT, AnimationSet.PUBLIC_OWNER, _arg_3);
        }


    }
}//package game.objects

