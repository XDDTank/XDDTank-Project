// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.PlayerBeatAction

package game.actions
{
    import game.objects.GamePlayer;
    import ddt.view.character.GameCharacter;
    import game.objects.GameLocalPlayer;

    public class PlayerBeatAction extends BaseAction 
    {

        private var _player:GamePlayer;
        private var _count:int;

        public function PlayerBeatAction(_arg_1:GamePlayer)
        {
            this._player = _arg_1;
            this._count = 0;
        }

        override public function prepare():void
        {
            this._player.body.doAction(GameCharacter.HIT);
            this._player.map.setTopPhysical(this._player);
            if ((this._player is GameLocalPlayer))
            {
                GameLocalPlayer(this._player).aim.visible = false;
            };
        }

        override public function execute():void
        {
            this._count++;
            if (this._count >= 50)
            {
                if ((this._player is GameLocalPlayer))
                {
                    GameLocalPlayer(this._player).aim.visible = true;
                };
                _isFinished = true;
            };
        }


    }
}//package game.actions

