// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.PlayerFallingAction

package game.actions
{
    import game.objects.GameLiving;
    import game.model.Living;
    import flash.geom.Point;
    import game.model.LocalPlayer;
    import game.GameManager;
    import game.model.Player;
    import game.animations.AnimationLevel;

    public class PlayerFallingAction extends BaseAction 
    {

        protected var _player:GameLiving;
        private var _info:Living;
        private var _target:Point;
        private var _isLiving:Boolean;
        private var _canIgnore:Boolean;
        private var _self:LocalPlayer;

        public function PlayerFallingAction(_arg_1:GameLiving, _arg_2:Point, _arg_3:Boolean, _arg_4:Boolean)
        {
            this._target = _arg_2;
            this._isLiving = _arg_3;
            if ((!(this._isLiving)))
            {
                this._target.y = (this._target.y + 70);
            };
            this._info = _arg_1.info;
            this._player = _arg_1;
            this._self = GameManager.Instance.Current.selfGamePlayer;
            this._canIgnore = _arg_4;
        }

        override public function connect(_arg_1:BaseAction):Boolean
        {
            var _local_2:PlayerFallingAction = (_arg_1 as PlayerFallingAction);
            if (((_local_2) && (_local_2._target.y < this._target.y)))
            {
                return (true);
            };
            return (false);
        }

        override public function canReplace(_arg_1:BaseAction):Boolean
        {
            if ((_arg_1 is PlayerWalkAction))
            {
                if (this._canIgnore)
                {
                    return (true);
                };
            };
            return (false);
        }

        override public function prepare():void
        {
            if (_isPrepare)
            {
                return;
            };
            _isPrepare = true;
            if (this._player.isLiving)
            {
                if (((this._player.x == this._target.x) || (!(this._canIgnore))))
                {
                    this._player.startMoving();
                    this._player.info.isFalling = true;
                }
                else
                {
                    this.finish();
                };
            }
            else
            {
                this.finish();
            };
        }

        override public function execute():void
        {
            if ((this._target.y - this._info.pos.y) <= Player.FALL_SPEED)
            {
                this.executeAtOnce();
            }
            else
            {
                this._info.pos = new Point(this._target.x, (this._info.pos.y + Player.FALL_SPEED));
                this._player.needFocus(0, 0, {
                    "strategy":"directly",
                    "priority":AnimationLevel.LOW
                });
            };
        }

        override public function executeAtOnce():void
        {
            super.executeAtOnce();
            this._info.pos = this._target;
            if (this._self.isLiving)
            {
                this._player.map.setCenter(this._info.pos.x, (this._info.pos.y - 150), false, AnimationLevel.MIDDLE, this._info.LivingID);
            };
            if ((!(this._isLiving)))
            {
                this._info.die();
            };
            this.finish();
        }

        private function finish():void
        {
            _isFinished = true;
            this._player.doAction("stand");
            this._player.stopMoving();
            this._player.info.isFalling = false;
        }


    }
}//package game.actions

