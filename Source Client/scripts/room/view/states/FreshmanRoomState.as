package room.view.states
{
   import com.pickgliss.ui.LayerManager;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.GameInSocketOut;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.display.Sprite;
   
   public class FreshmanRoomState extends BaseRoomState
   {
       
      
      private var black:Sprite;
      
      public function FreshmanRoomState()
      {
         super();
      }
      
      override public function getType() : String
      {
         if(StartupResourceLoader.firstEnterHall)
         {
            return StateType.FRESHMAN_ROOM2;
         }
         return StateType.FRESHMAN_ROOM1;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         MainToolBar.Instance.hide();
         LayerManager.Instance.clearnGameDynamic();
         this.black = new Sprite();
         this.black.graphics.beginFill(0,1);
         this.black.graphics.drawRect(0,0,1000,600);
         this.black.graphics.endFill();
         addChild(this.black);
         GameInSocketOut.sendGameStart();
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         if(this.black && this.black.parent)
         {
            this.black.parent.removeChild(this.black);
         }
         super.leaving(param1);
      }
   }
}
