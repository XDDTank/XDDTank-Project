// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.SelfSkipAction

package game.actions
{
    import game.model.LocalPlayer;
    import ddt.manager.GameInSocketOut;

    public class SelfSkipAction extends BaseAction 
    {

        private var _info:LocalPlayer;

        public function SelfSkipAction(_arg_1:LocalPlayer)
        {
            this._info = _arg_1;
        }

        override public function prepare():void
        {
            if (_isPrepare)
            {
                return;
            };
            GameInSocketOut.sendGameSkipNext(this._info.shootTime);
            _isPrepare = true;
        }


    }
}//package game.actions

