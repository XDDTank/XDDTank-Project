// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.SelfPlayerWalkAction

package game.actions
{
    import game.objects.GameLocalPlayer;
    import flash.geom.Point;
    import org.aswing.KeyboardManager;
    import flash.ui.Keyboard;
    import org.aswing.KeyStroke;
    import game.animations.AnimationLevel;
    import playerParticle.PlayerParticleManager;
    import ddt.view.character.GameCharacter;
    import ddt.manager.SoundManager;
    import game.objects.GameLiving;
    import ddt.manager.GameInSocketOut;
    import game.GameManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;

    public class SelfPlayerWalkAction extends BaseAction 
    {

        private var _player:GameLocalPlayer;
        private var _end:Point;
        private var _count:int;

        public function SelfPlayerWalkAction(_arg_1:GameLocalPlayer)
        {
            this._player = _arg_1;
            this._count = 0;
            _isFinished = false;
        }

        override public function connect(_arg_1:BaseAction):Boolean
        {
            return (_arg_1 is SelfPlayerWalkAction);
        }

        private function isDirkeyDown():Boolean
        {
            if (((!(this._player)) || (!(this._player.info))))
            {
                return (false);
            };
            if (this._player.mouseDown)
            {
                return (true);
            };
            if (this._player.info.direction == -1)
            {
                return ((KeyboardManager.isDown(KeyStroke.VK_A.getCode())) || (KeyboardManager.isDown(Keyboard.LEFT)));
            };
            return ((KeyboardManager.isDown(KeyStroke.VK_D.getCode())) || (KeyboardManager.isDown(Keyboard.RIGHT)));
        }

        override public function prepare():void
        {
            this._player.startMoving();
            this._player.needFocus(0, 0, {
                "strategy":"directly",
                "priority":AnimationLevel.MIDDLE
            }, true);
        }

        override public function execute():void
        {
            var _local_1:Point;
            var _local_2:Point;
            var _local_3:Number;
            if ((((((this.isDirkeyDown()) && ((this._player.localPlayer.powerRatio == 0) || (this._player.localPlayer.energy > 0))) && (this._player.localPlayer.isAttacking)) && (!(this._player.localPlayer.forbidMoving))) && (!(this._player.localPlayer.isBeginShoot))))
            {
                _local_1 = this._player.getNextWalkPoint((this._player.info.direction * this._player.player.reverse));
                if (_local_1)
                {
                    _local_2 = new Point(this._player.info.pos.x, this._player.info.pos.y);
                    PlayerParticleManager.instance.saveParticlePos(_local_2, this._player.info.direction, this._player.Id);
                    this._player.info.pos = _local_1;
                    this._player.body.doAction(this._player.body.walkAction);
                    this._player.body.WingState = GameCharacter.GAME_WING_MOVE;
                    SoundManager.instance.play("044", false, false);
                    this._player.needFocus(0, 0, {
                        "strategy":"directly",
                        "priority":AnimationLevel.MIDDLE
                    });
                    this._count++;
                    if (this._count >= 20)
                    {
                        this.sendAction();
                    };
                }
                else
                {
                    this.sendAction();
                    this.finish();
                    _local_3 = (this._player.x + (this._player.info.direction * this._player.stepX));
                    if (((this._player.canMoveDirection(this._player.info.direction)) && (this._player.canStand(_local_3, this._player.y) == false)))
                    {
                        _local_1 = this._player.map.findYLineNotEmptyPointDown(_local_3, (this._player.y - GameLiving.stepY), this._player.map.bound.height);
                        if (_local_1)
                        {
                            this._player.act(new PlayerFallingAction(this._player, _local_1, true, false));
                            GameInSocketOut.sendGameStartMove(1, _local_1.x, _local_1.y, 0, true, GameManager.Instance.Current.currentTurn);
                        }
                        else
                        {
                            this._player.act(new PlayerFallingAction(this._player, new Point(_local_3, (this._player.map.bound.height - 70)), false, false));
                            GameInSocketOut.sendGameStartMove(1, _local_3, this._player.map.bound.height, 0, false, GameManager.Instance.Current.currentTurn);
                        };
                    };
                };
            }
            else
            {
                if (((this._player.localPlayer.energy <= 0) && (!(PlayerManager.Instance.Self.isRunQuicklyByVip))))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.actions.SelfPlayerWalkAction"));
                };
                if ((!(_isFinished)))
                {
                    this.sendAction();
                };
                this.finish();
            };
        }

        private function sendAction():void
        {
            GameInSocketOut.sendGameStartMove(0, this._player.x, this._player.y, this._player.info.direction, this._player.isLiving, GameManager.Instance.Current.currentTurn);
            this._count = 0;
        }

        private function finish():void
        {
            this._player.stopMoving();
            this._player.doAction(GameCharacter.STAND);
            _isFinished = true;
        }


    }
}//package game.actions

