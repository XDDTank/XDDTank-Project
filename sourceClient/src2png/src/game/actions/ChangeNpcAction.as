// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.ChangeNpcAction

package game.actions
{
    import game.view.GameViewBase;
    import game.view.map.MapView;
    import game.model.Living;
    import road7th.comm.PackageIn;
    import ddt.events.CrazyTankSocketEvent;
    import game.objects.SimpleBox;
    import game.GameManager;
    import ddt.data.PathInfo;
    import game.objects.LivingTypesEnum;
    import game.model.SmallEnemy;
    import game.objects.GameSmallEnemy;
    import game.animations.AnimationLevel;

    public class ChangeNpcAction extends BaseAction 
    {

        private var _gameView:GameViewBase;
        private var _map:MapView;
        private var _info:Living;
        private var _pkg:PackageIn;
        private var _event:CrazyTankSocketEvent;
        private var _ignoreSmallEnemy:Boolean;

        public function ChangeNpcAction(_arg_1:GameViewBase, _arg_2:MapView, _arg_3:Living, _arg_4:CrazyTankSocketEvent, _arg_5:PackageIn, _arg_6:Boolean)
        {
            this._gameView = _arg_1;
            this._event = _arg_4;
            this._event.executed = false;
            this._pkg = _arg_5;
            this._map = _arg_2;
            this._info = _arg_3;
            this._ignoreSmallEnemy = _arg_6;
        }

        private function syncMap():void
        {
            var _local_1:Boolean;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:Array;
            var _local_6:int;
            var _local_7:uint;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:uint;
            var _local_12:SimpleBox;
            if (this._pkg)
            {
                GameManager.Instance.Current.currentTurn = this._pkg.readInt();
                _local_1 = this._pkg.readBoolean();
                _local_2 = this._pkg.readByte();
                _local_3 = this._pkg.readByte();
                _local_4 = this._pkg.readByte();
                _local_5 = new Array();
                _local_5 = [_local_1, _local_2, _local_3, _local_4];
                GameManager.Instance.Current.setWind(GameManager.Instance.Current.wind, false, _local_5);
                this._pkg.readBoolean();
                this._pkg.readInt();
                _local_6 = this._pkg.readInt();
                _local_7 = 0;
                while (_local_7 < _local_6)
                {
                    _local_8 = this._pkg.readInt();
                    _local_9 = this._pkg.readInt();
                    _local_10 = this._pkg.readInt();
                    _local_11 = this._pkg.readInt();
                    _local_12 = new SimpleBox(_local_8, String(PathInfo.GAME_BOXPIC), _local_11);
                    _local_12.x = _local_9;
                    _local_12.y = _local_10;
                    this._map.addPhysical(_local_12);
                    _local_7++;
                };
            };
        }

        private function updateNpc():void
        {
            var _local_1:Living;
            if (GameManager.Instance.Current == null)
            {
                return;
            };
            for each (_local_1 in GameManager.Instance.Current.livings)
            {
                if (((((((!(_local_1.typeLiving == LivingTypesEnum.SIMPLE_NPC_NORMAL)) && (!(_local_1.typeLiving == LivingTypesEnum.AI_PLAYER))) && (!(_local_1.typeLiving == LivingTypesEnum.NORMAL_PLAYER))) && (!(_local_1.typeLiving == LivingTypesEnum.SENIOR_AI_PLAYER))) && (!(_local_1.isBoss))) && (_local_1.blood <= 0)))
                {
                    _local_1.dispose();
                }
                else
                {
                    _local_1.beginNewTurn();
                };
            };
            this._map.cancelFocus();
            this._gameView.setCurrentPlayer(this._info);
            this.focusOnSmallEnemy();
            if ((!(this._ignoreSmallEnemy)))
            {
                this._ignoreSmallEnemy = true;
            }
            else
            {
                return;
            };
            this._gameView.updateControlBarState(GameManager.Instance.Current.selfGamePlayer);
        }

        private function getClosestEnemy():SmallEnemy
        {
            var _local_3:SmallEnemy;
            var _local_4:Living;
            var _local_1:int = -1;
            var _local_2:int = GameManager.Instance.Current.selfGamePlayer.pos.x;
            for each (_local_4 in GameManager.Instance.Current.livings)
            {
                if (((((_local_4 is SmallEnemy) && (_local_4.isLiving)) && (!(_local_4.typeLiving == 3))) && ((!(GameManager.Instance.isSingleDungeonRoom())) || (!(this._map.getContains(_local_4.pos.x, _local_4.pos.y))))))
                {
                    if (((_local_1 == -1) || (Math.abs((_local_4.pos.x - _local_2)) < _local_1)))
                    {
                        _local_1 = Math.abs((_local_4.pos.x - _local_2));
                        _local_3 = (_local_4 as SmallEnemy);
                    };
                };
            };
            return (_local_3);
        }

        private function focusOnSmallEnemy():void
        {
            var _local_1:SmallEnemy = this.getClosestEnemy();
            if (_local_1)
            {
                if (((_local_1.LivingID) && (this._map.getPhysical(_local_1.LivingID))))
                {
                    (this._map.getPhysical(_local_1.LivingID) as GameSmallEnemy).needFocus();
                    this._map.currentFocusedLiving = (this._map.getPhysical(_local_1.LivingID) as GameSmallEnemy);
                };
            };
        }

        override public function execute():void
        {
            this._map.lockOwner = -1;
            this._map.animateSet.lockLevel = AnimationLevel.LOW;
            this._event.executed = true;
            this.syncMap();
            this.updateNpc();
            _isFinished = true;
        }


    }
}//package game.actions

