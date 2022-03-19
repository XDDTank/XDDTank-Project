// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.MultiPlaySpellSkillAction

package game.actions
{
    import __AS3__.vec.Vector;
    import game.objects.GamePlayer;
    import game.view.map.MapView;
    import ddt.manager.SharedManager;
    import __AS3__.vec.*;

    public class MultiPlaySpellSkillAction extends BaseAction 
    {

        private var _playerList:Vector.<GamePlayer>;
        private var _mapView:MapView;

        public function MultiPlaySpellSkillAction(_arg_1:MapView, _arg_2:Vector.<GamePlayer>)
        {
            this._mapView = _arg_1;
            this._playerList = _arg_2;
        }

        override public function execute():void
        {
            if (_isFinished)
            {
                return;
            };
            _isFinished = (!(this._mapView.isPlayingMovie));
        }

        override public function executeAtOnce():void
        {
            super.executeAtOnce();
        }

        override public function get isFinished():Boolean
        {
            return (super.isFinished);
        }

        override public function prepare():void
        {
            var _local_1:Vector.<GamePlayer> = new Vector.<GamePlayer>();
            var _local_2:int;
            while (_local_2 < this._playerList.length)
            {
                if (((((this._playerList[_local_2].player.skill >= 0) || (this._playerList[_local_2].player.isSpecialSkill)) && (SharedManager.Instance.showParticle)) && (!(PrepareShootAction.hasDoSkillAnimation))))
                {
                    _local_1.push(this._playerList[_local_2]);
                };
                _local_2++;
            };
            if (_local_1.length > 0)
            {
                PrepareShootAction.hasDoSkillAnimation = true;
                this._mapView.playMultiSpellkill(_local_1);
            }
            else
            {
                _isFinished = true;
            };
        }


    }
}//package game.actions

