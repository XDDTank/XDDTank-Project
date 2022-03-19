// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.BombAction

package game.objects
{
    import phy.object.PhysicalObj;
    import game.model.Living;
    import game.model.Player;
    import flash.utils.Dictionary;
    import game.GameManager;
    import flash.geom.Point;
    import ddt.manager.SocketManager;
    import game.model.GameInfo;

    public class BombAction 
    {

        private var _time:int;
        private var _type:int;
        private var _param1:int;
        public var _param2:int;
        public var _param3:int;
        public var _param4:int;
        private var _index:int;

        public function BombAction(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int)
        {
            this._time = _arg_1;
            this._type = _arg_2;
            this._param1 = _arg_3;
            this._param2 = _arg_4;
            this._param3 = _arg_5;
            this._param4 = _arg_6;
            this._index = _arg_7;
        }

        public function get param1():int
        {
            return (this._param1);
        }

        public function get param2():int
        {
            return (this._param2);
        }

        public function get param3():int
        {
            return (this._param3);
        }

        public function get param4():int
        {
            return (this._param4);
        }

        public function get time():int
        {
            return (this._time);
        }

        public function get type():int
        {
            return (this._type);
        }

        public function execute(_arg_1:SimpleBomb, _arg_2:GameInfo):void
        {
            var _local_3:PhysicalObj;
            var _local_4:Living;
            var _local_5:Living;
            var _local_6:Living;
            var _local_7:Living;
            var _local_8:Player;
            var _local_9:Living;
            var _local_10:Player;
            var _local_11:Living;
            var _local_12:Living;
            var _local_13:int;
            var _local_14:int;
            var _local_15:Living;
            var _local_16:Living;
            var _local_17:Living;
            var _local_18:Player;
            var _local_19:Living;
            var _local_20:Dictionary;
            switch (this._type)
            {
                case ActionType.PICK:
                    _local_3 = _arg_1.map.getPhysical(this._param1);
                    if (_local_3)
                    {
                        _local_3.collidedByObject(_arg_1);
                    };
                    return;
                case ActionType.BOMB:
                    _arg_1.x = this._param1;
                    _arg_1.y = this._param2;
                    _arg_1.bomb();
                    if (((_arg_1.info) && (_arg_1.info.isSelf)))
                    {
                        GameManager.Instance.hitsNumView.start();
                    };
                    return;
                case ActionType.START_MOVE:
                    _local_4 = _arg_2.findLiving(this._param1);
                    if ((_local_4 is Player))
                    {
                        (_local_4 as Player).playerMoveTo(1, new Point(this._param2, this._param3), _local_4.direction, (!(this._param4 == 0)));
                    }
                    else
                    {
                        if (_local_4 != null)
                        {
                            _local_4.fallTo(new Point(this._param2, this._param3), Player.FALL_SPEED);
                        };
                    };
                    return;
                case ActionType.FLY_OUT:
                    _arg_1.die();
                    return;
                case ActionType.KILL_PLAYER:
                    _local_5 = _arg_2.findLiving(this._param1);
                    if (_local_5)
                    {
                        if ((((((Math.abs((_local_5.blood - this._param4)) > 30000) && (_arg_1)) && (_arg_1.owner)) && (_arg_1.owner is Player)) && (_arg_1.owner.playerInfo)))
                        {
                            SocketManager.Instance.out.sendErrorMsg((((("客户端发现异常:" + _arg_1.owner.playerInfo.NickName) + "打出单发炮弹") + Math.abs((_local_5.blood - this._param4))) + "的伤害"));
                        };
                        _local_5.updateBlood(this._param4, this._param3, (0 - this._param2), this.index);
                        _local_5.isHidden = false;
                    };
                    return;
                case ActionType.TRANSLATE:
                    _arg_1.owner.transmit(new Point(this._param1, this._param2));
                    return;
                case ActionType.FORZEN:
                    _local_6 = _arg_2.findLiving(this._param1);
                    if (_local_6)
                    {
                        _local_6.isFrozen = true;
                        _local_6.isHidden = false;
                    };
                    return;
                case ActionType.CHANGE_SPEED:
                    _arg_1.setSpeedXY(new Point(this._param1, this._param2));
                    _arg_1.clearWG();
                    if (this._param3 >= 0)
                    {
                        _local_19 = _arg_2.findLiving(this._param3);
                        if (_local_19)
                        {
                            _local_19.showEffect("asset.game.propanimation.guild");
                        };
                    };
                    return;
                case ActionType.UNFORZEN:
                    _local_7 = _arg_2.findLiving(this._param1);
                    if (_local_7)
                    {
                        _local_7.isFrozen = false;
                    };
                    return;
                case ActionType.DANER:
                    _local_8 = _arg_2.findPlayer(this._param1);
                    if (((_local_8) && (_local_8.isLiving)))
                    {
                        _local_8.dander = this._param2;
                    };
                    return;
                case ActionType.CURE:
                    _local_9 = _arg_2.findLiving(this._param1);
                    if (_local_9)
                    {
                        _local_9.showAttackEffect(2);
                        _local_9.updateBlood(this._param2, 0, this._param3, this.index);
                    };
                    return;
                case ActionType.GEM_DEFENSE_CHANGED:
                    _local_10 = _arg_2.findPlayer(this._param1);
                    if (_local_10)
                    {
                        _local_10.gemDefense = true;
                    };
                    return;
                case ActionType.CHANGE_STATE:
                    _local_11 = _arg_2.findLiving(this._param1);
                    if (_local_11)
                    {
                        _local_11.State = this._param2;
                    };
                    return;
                case ActionType.DO_ACTION:
                    _local_12 = _arg_2.findLiving(this._param1);
                    if (_local_12)
                    {
                        _local_12.playMovie(ActionType.ACTION_TYPES[this._param4]);
                    };
                    return;
                case ActionType.PLAYBUFFER:
                    _local_13 = this._param2;
                    _local_14 = this._param1;
                    return;
                case ActionType.BOMBED:
                    _local_15 = _arg_2.findLiving(this._param1);
                    if (_local_15)
                    {
                        _local_15.bomd();
                    };
                    return;
                case ActionType.PUP:
                    _local_16 = _arg_2.findLiving(this._param1);
                    if (_local_16)
                    {
                        _local_16.showAttackEffect(ActionType.PUP);
                    };
                    return;
                case ActionType.AUP:
                    _local_17 = _arg_2.findLiving(this._param1);
                    if (_local_17)
                    {
                        _local_17.showAttackEffect(ActionType.AUP);
                    };
                    return;
                case ActionType.PET:
                    _local_18 = Player(_arg_2.findLiving(this._param1));
                    if (_local_18)
                    {
                        _local_20 = _local_18.currentPet.petBeatInfo;
                        _local_18.petBeat(String(_local_20["actionName"]), Point(_local_20["targetPoint"]), _local_20["targets"]);
                    };
                    return;
            };
        }

        public function get index():int
        {
            return (this._index);
        }

        public function set index(_arg_1:int):void
        {
            this._index = _arg_1;
        }


    }
}//package game.objects

