// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.PlayerTipManager

package ddt.manager
{
    import ddt.view.tips.PlayerTip;
    import ddt.data.player.BasePlayer;

    public class PlayerTipManager 
    {

        private static var _view:PlayerTip;
        private static var _yOffset:int;


        public static function show(_arg_1:BasePlayer, _arg_2:int=-1):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            if (_arg_1.ID == PlayerManager.Instance.Self.ID)
            {
                instance.setSelfDisable(true);
            }
            else
            {
                instance.setSelfDisable(false);
                if (PlayerManager.Instance.Self.IsMarried)
                {
                    instance.proposeEnable(false);
                };
            };
            instance.playerInfo = _arg_1;
            instance.show(_arg_2);
        }

        public static function get instance():PlayerTip
        {
            if (_view == null)
            {
                _view = new PlayerTip();
            };
            return (_view);
        }

        public static function hide():void
        {
            instance.hide();
        }


    }
}//package ddt.manager

