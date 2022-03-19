// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.GhostMoveAction

package game.actions
{
    import flash.geom.Point;
    import game.objects.GameTurnedLiving;
    import ddt.manager.SoundManager;
    import ddt.view.character.GameCharacter;
    import game.model.Player;
    import game.objects.GameLocalPlayer;
    import game.objects.BossLocalPlayer;

    public class GhostMoveAction extends BaseAction 
    {

        private var _startPos:Point;
        private var _target:Point;
        private var _player:GameTurnedLiving;
        private var _vp:Point;
        private var _start:Point;
        private var _life:int = 0;
        private var _pickBoxActions:Array;

        public function GhostMoveAction(_arg_1:GameTurnedLiving, _arg_2:Point, _arg_3:Array=null)
        {
            this._target = _arg_2;
            this._player = _arg_1;
            this._startPos = this._player.pos;
            this._pickBoxActions = _arg_3;
            this._vp = this._target.subtract(this._startPos);
            this._vp.normalize(2);
        }

        override public function prepare():void
        {
            if (_isPrepare)
            {
                return;
            };
            _isPrepare = true;
            SoundManager.instance.play("010", true);
            this._player.startMoving();
            this._player["body"].doAction(GameCharacter.SOUL_MOVE);
        }

        override public function execute():void
        {
            var _local_1:PickBoxAction;
            var _local_2:Point;
            var _local_3:Point;
            this._player.info.direction = ((this._vp.x > 0) ? 1 : -1);
            if (Point.distance(this._startPos, this._target) > this._vp.length)
            {
                if (this._vp.length < Player.GHOST_MOVE_SPEED)
                {
                    this._vp.normalize((this._vp.length * 1.1));
                };
                _local_2 = this._startPos;
                this._startPos = this._startPos.add(this._vp);
                this._player.info.pos = this._startPos;
                _local_3 = this._startPos;
                if ((this._player is GameLocalPlayer))
                {
                    (this._player as GameLocalPlayer).localPlayer.energy = ((this._player as GameLocalPlayer).localPlayer.energy - Math.round((Point.distance(_local_2, _local_3) / 1.5)));
                }
                else
                {
                    if ((this._player is BossLocalPlayer))
                    {
                        (this._player as BossLocalPlayer).localPlayer.energy = ((this._player as BossLocalPlayer).localPlayer.energy - Math.round((Point.distance(_local_2, _local_3) / 1.5)));
                    };
                };
            }
            else
            {
                this._player.info.pos = this._target;
                if ((this._player is GameLocalPlayer))
                {
                    GameLocalPlayer(this._player).hideTargetMouseTip();
                }
                else
                {
                    if ((this._player is BossLocalPlayer))
                    {
                        (this._player as BossLocalPlayer).hideTargetMouseTip();
                    };
                };
                this.finish();
            };
            this._life = (this._life + 40);
            for each (_local_1 in this._pickBoxActions)
            {
                if (((this._life >= _local_1.time) && (!(_local_1.executed))))
                {
                    _local_1.execute(this._player);
                };
            };
        }

        public function finish():void
        {
            this._player["body"].doAction(GameCharacter.SOUL);
            this._player.stopMoving();
            _isFinished = true;
        }

        override public function executeAtOnce():void
        {
            this._player.pos = this._target;
            super.executeAtOnce();
        }


    }
}//package game.actions

