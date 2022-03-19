// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.SkillBomb

package game.objects
{
    import phy.bombs.BaseBomb;
    import game.view.Bomb;
    import game.model.Living;
    import game.actions.SkillActions.LaserAction;
    import game.model.GameInfo;
    import game.view.map.MapView;
    import phy.maps.Map;
    import game.model.Player;
    import ddt.manager.SocketManager;
    import flash.events.Event;

    public class SkillBomb extends BaseBomb 
    {

        private var _info:Bomb;
        private var _owner:Living;
        private var _lifeTime:int;
        private var _cunrrentAction:BombAction;
        private var _laserAction:LaserAction;
        private var _game:GameInfo;

        public function SkillBomb(_arg_1:Bomb, _arg_2:Living)
        {
            this._info = _arg_1;
            this._lifeTime = 0;
            this._owner = _arg_2;
            super(this._info.Id);
        }

        public function get map():MapView
        {
            return (_map as MapView);
        }

        override public function setMap(_arg_1:Map):void
        {
            super.setMap(_arg_1);
            if (_arg_1)
            {
                this._game = this.map.game;
            };
        }

        override public function update(_arg_1:Number):void
        {
            var _local_2:Living;
            var _local_3:Living;
            if (this._cunrrentAction == null)
            {
                this._cunrrentAction = this._info.Actions.shift();
            };
            if (this._cunrrentAction == null)
            {
                bomb();
            }
            else
            {
                if (this._cunrrentAction.type == ActionType.Laser)
                {
                    if (this._laserAction == null)
                    {
                        _local_2 = this._game.findLiving(this._cunrrentAction.param1);
                        this._laserAction = new LaserAction(_local_2, this.map, this._cunrrentAction.param2);
                        this._laserAction.prepare();
                    }
                    else
                    {
                        if (this._laserAction.isFinished)
                        {
                            this._cunrrentAction = this._info.Actions.shift();
                        }
                        else
                        {
                            this._laserAction.execute();
                        };
                    };
                }
                else
                {
                    if (this._cunrrentAction.type == ActionType.KILL_PLAYER)
                    {
                        _local_3 = this._game.findLiving(this._cunrrentAction.param1);
                        if (_local_3)
                        {
                            if (((Math.abs((_local_3.blood - this._cunrrentAction.param4)) > 30000) && (this._owner is Player)))
                            {
                                SocketManager.Instance.out.sendErrorMsg((((("客户端发现异常:" + this._owner.playerInfo.NickName) + "打出单发炮弹") + Math.abs((_local_3.blood - this._cunrrentAction.param4))) + "的伤害"));
                            };
                            _local_3.updateBlood(this._cunrrentAction.param4, this._cunrrentAction.param3, (0 - this._cunrrentAction.param2));
                            _local_3.isHidden = false;
                            _local_3.bomd();
                        };
                        this._cunrrentAction = this._info.Actions.shift();
                    }
                    else
                    {
                        this._cunrrentAction = this._info.Actions.shift();
                    };
                };
            };
        }

        override protected function DigMap():void
        {
        }

        override public function die():void
        {
            dispatchEvent(new Event(Event.COMPLETE));
            super.die();
            dispose();
        }


    }
}//package game.objects

