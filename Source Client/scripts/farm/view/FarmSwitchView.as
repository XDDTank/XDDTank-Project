package farm.view
{
   import ddt.manager.ChatManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import farm.FarmModelController;
   
   public class FarmSwitchView extends BaseStateView
   {
       
      
      private var _farmMainView:FarmMainView;
      
      public function FarmSwitchView()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         FarmModelController.instance.refreshFarm();
         this._farmMainView = new FarmMainView();
         addChild(this._farmMainView);
         MainToolBar.Instance.show();
         ChatManager.Instance.state = ChatManager.CHAT_FARM;
         addChild(ChatManager.Instance.view);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         FarmModelController.instance.farmBack();
         super.leaving(param1);
         this.dispose();
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.FARM;
      }
      
      override public function refresh() : void
      {
         super.refresh();
      }
      
      override public function dispose() : void
      {
         this._farmMainView.dispose();
         this._farmMainView = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
