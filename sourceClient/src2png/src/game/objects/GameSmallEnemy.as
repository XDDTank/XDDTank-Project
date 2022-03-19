// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.GameSmallEnemy

package game.objects
{
    import ddt.events.LivingEvent;
    import game.model.SmallEnemy;
    import phy.maps.Map;
    import game.model.Living;
    import com.pickgliss.utils.ObjectUtils;
    import phy.object.PhysicalObj;
    import game.actions.MonsterShootBombAction;
    import game.model.Player;
    import road7th.data.StringObject;
    import game.animations.AnimationLevel;
    import game.animations.AnimationSet;

    public class GameSmallEnemy extends GameLiving 
    {

        private var _bombEvent:LivingEvent;
        private var _noDispose:Boolean = false;
        private var _disposedOverTurns:Boolean = true;

        public function GameSmallEnemy(_arg_1:SmallEnemy)
        {
            super(_arg_1);
            _arg_1.defaultAction = "stand";
        }

        override protected function initView():void
        {
            super.initView();
            initMovie();
        }

        override public function setMap(_arg_1:Map):void
        {
            super.setMap(_arg_1);
            if (_arg_1)
            {
                __posChanged(null);
            };
        }

        public function get smallEnemy():SmallEnemy
        {
            return (info as SmallEnemy);
        }

        override protected function __bloodChanged(_arg_1:LivingEvent):void
        {
            super.__bloodChanged(_arg_1);
            if ((_arg_1.value - _arg_1.old) < 0)
            {
                doAction(Living.CRY_ACTION);
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
            if (_doDieAction)
            {
                if (_info.typeLiving == 2)
                {
                    _actionMovie.doAction(Living.DIE_ACTION, this.clearEnemy);
                }
                else
                {
                    if (this._noDispose)
                    {
                        _actionMovie.doAction(Living.DIE_ACTION);
                    }
                    else
                    {
                        _actionMovie.doAction(Living.DIE_ACTION, this.dispose);
                    };
                };
            }
            else
            {
                if (_info.typeLiving == 2)
                {
                    this.clearEnemy();
                }
                else
                {
                    this.dispose();
                };
            };
            ObjectUtils.disposeObject(_chatballview);
            _chatballview = null;
            _isDie = true;
        }

        override public function collidedByObject(_arg_1:PhysicalObj):void
        {
            if ((_arg_1 is SimpleBomb))
            {
                if ((_arg_1 as SimpleBomb).info.Template.ID != 3)
                {
                    info.isHidden = false;
                };
            };
        }

        override protected function fitChatBallPos():void
        {
            _chatballview.x = 20;
            _chatballview.y = -50;
            if ((!(actionMovie["popupPos"])))
            {
                return;
            };
            super.fitChatBallPos();
        }

        private function clearEnemy():void
        {
            this.removeEvents(true);
            deleteSmallView();
        }

        private function removeEvents(_arg_1:Boolean=false):void
        {
            super.removeListener();
            if (_arg_1)
            {
                _info.addEventListener(LivingEvent.BEGIN_NEW_TURN, this.__beginNewTurn);
            };
        }

        override protected function __shoot(_arg_1:LivingEvent):void
        {
            map.act(new MonsterShootBombAction(this, _arg_1.paras[0], _arg_1.paras[1], Player.SHOOT_INTERVAL));
        }

        override protected function __beginNewTurn(_arg_1:LivingEvent):void
        {
            if ((!(this._disposedOverTurns)))
            {
                return;
            };
            if (_isDie)
            {
                _turns++;
            };
            if (_turns >= 5)
            {
                this.dispose();
            };
        }

        override public function dispose():void
        {
            _info.dispose();
            super.dispose();
        }

        override public function setProperty(_arg_1:String, _arg_2:String):void
        {
            var _local_3:StringObject = new StringObject(_arg_2);
            super.setProperty(_arg_1, _arg_2);
            switch (_arg_1)
            {
                case "disposedOverTurns":
                    this._disposedOverTurns = _local_3.getBoolean();
                    return;
                case "noDispose":
                    this._noDispose = _local_3.getBoolean();
            };
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

