// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//farm.view.FarmSwitchView

package farm.view
{
    import ddt.states.BaseStateView;
    import farm.FarmModelController;
    import ddt.view.MainToolBar;
    import ddt.manager.ChatManager;
    import ddt.states.StateType;

    public class FarmSwitchView extends BaseStateView 
    {

        private var _farmMainView:FarmMainView;


        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            super.enter(_arg_1, _arg_2);
            FarmModelController.instance.refreshFarm();
            this._farmMainView = new FarmMainView();
            addChild(this._farmMainView);
            MainToolBar.Instance.show();
            ChatManager.Instance.state = ChatManager.CHAT_FARM;
            addChild(ChatManager.Instance.view);
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            FarmModelController.instance.farmBack();
            super.leaving(_arg_1);
            this.dispose();
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }

        override public function getType():String
        {
            return (StateType.FARM);
        }

        override public function refresh():void
        {
            super.refresh();
        }

        override public function dispose():void
        {
            this._farmMainView.dispose();
            this._farmMainView = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package farm.view

