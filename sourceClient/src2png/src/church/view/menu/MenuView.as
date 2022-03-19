// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.menu.MenuView

package church.view.menu
{
    import ddt.data.player.PlayerInfo;

    public class MenuView 
    {

        private static var _menu:MenuPanel;


        public static function show(_arg_1:PlayerInfo):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            if (_menu == null)
            {
                _menu = new MenuPanel();
            };
            _menu.playerInfo = _arg_1;
            _menu.show();
        }

        public static function hide():void
        {
            if (_menu)
            {
                _menu.hide();
            };
        }


        public function dispose():void
        {
            if (((_menu) && (_menu.parent)))
            {
                _menu.parent.removeChild(_menu);
            };
            if (_menu)
            {
                _menu.dispose();
            };
            _menu = null;
        }


    }
}//package church.view.menu

