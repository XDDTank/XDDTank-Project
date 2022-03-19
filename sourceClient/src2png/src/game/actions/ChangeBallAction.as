// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.ChangeBallAction

package game.actions
{
    import game.model.Player;

    public class ChangeBallAction extends BaseAction 
    {

        private var _player:Player;
        private var _currentBomb:int;
        private var _isSpecialSkill:Boolean;

        public function ChangeBallAction(_arg_1:Player, _arg_2:Boolean, _arg_3:int)
        {
            this._player = _arg_1;
            this._currentBomb = _arg_3;
            this._isSpecialSkill = _arg_2;
        }

        override public function executeAtOnce():void
        {
            super.executeAtOnce();
            if ((!(this._player.isExist)))
            {
                return;
            };
            this._player.isSpecialSkill = this._isSpecialSkill;
            this._player.currentBomb = this._currentBomb;
            if (this._player.isSpecialSkill)
            {
                this._player.addState(-1);
            };
        }


    }
}//package game.actions

