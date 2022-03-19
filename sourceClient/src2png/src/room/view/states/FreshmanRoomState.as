// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.states.FreshmanRoomState

package room.view.states
{
    import flash.display.Sprite;
    import ddt.loader.StartupResourceLoader;
    import ddt.states.StateType;
    import ddt.view.MainToolBar;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.GameInSocketOut;
    import ddt.states.BaseStateView;

    public class FreshmanRoomState extends BaseRoomState 
    {

        private var black:Sprite;


        override public function getType():String
        {
            if (StartupResourceLoader.firstEnterHall)
            {
                return (StateType.FRESHMAN_ROOM2);
            };
            return (StateType.FRESHMAN_ROOM1);
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            super.enter(_arg_1, _arg_2);
            MainToolBar.Instance.hide();
            LayerManager.Instance.clearnGameDynamic();
            this.black = new Sprite();
            this.black.graphics.beginFill(0, 1);
            this.black.graphics.drawRect(0, 0, 1000, 600);
            this.black.graphics.endFill();
            addChild(this.black);
            GameInSocketOut.sendGameStart();
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            if (((this.black) && (this.black.parent)))
            {
                this.black.parent.removeChild(this.black);
            };
            super.leaving(_arg_1);
        }


    }
}//package room.view.states

