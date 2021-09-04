package arena.view
{
   import arena.ArenaManager;
   import arena.model.ArenaEvent;
   import arena.model.ArenaPlayerStates;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.InviteManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.chat.ChatOutputView;
   import ddt.view.chat.ChatView;
   import flash.events.Event;
   import game.GameManager;
   import worldboss.view.RoomMenuView;
   
   public class ArenaStateView extends BaseStateView
   {
       
      
      private var _objectView:ArenaStateObjectView;
      
      private var _informationView:ArenaInformationView;
      
      private var _chatView:ChatView;
      
      private var _reliveView:ArenaReliveView;
      
      private var _roomMenuView:RoomMenuView;
      
      public function ArenaStateView()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         InviteManager.Instance.enabled = false;
         super.enter(param1,param2);
         ChatManager.Instance.output.channel = ChatOutputView.CHAT_OUPUT_CURRENT;
         ChatManager.Instance.view.bg = false;
         ChatManager.Instance.state = ChatManager.CHAT_ARENA;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._objectView = new ArenaStateObjectView();
         addChild(this._objectView);
         this._informationView = new ArenaInformationView();
         addChild(this._informationView);
         this._chatView = ChatManager.Instance.view;
         addChild(this._chatView);
         ChatManager.Instance.setFocus();
         this._roomMenuView = ComponentFactory.Instance.creat("worldboss.room.menuView");
         this._roomMenuView.leaveMsg = "arena.room.leaveroom";
         addChild(this._roomMenuView);
         SoundManager.instance.playMusic("worldbossfight-1");
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ENTER_FRAME,this.__update);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         this._roomMenuView.addEventListener(Event.CLOSE,this._leaveRoom);
      }
      
      private function _leaveRoom(param1:Event) : void
      {
         ArenaManager.instance.sendExit();
      }
      
      private function __startLoading(param1:Event) : void
      {
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_6 = true;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         LayerManager.Instance.clearnGameDynamic();
         GameManager.Instance.gotoRoomLoading();
         StateManager.getInGame_Step_7 = true;
      }
      
      private function __update(param1:Event) : void
      {
         this._objectView.update();
         this._informationView.update();
         if(!this._reliveView && ArenaManager.instance.model.selfInfo.playerStauts == ArenaPlayerStates.DEATH)
         {
            this._reliveView = ComponentFactory.Instance.creatComponentByStylename("ddtarena.arenaReliveView");
            this._reliveView.addEventListener(Event.CLOSE,this.__closeReliveView);
            this._reliveView.show();
         }
      }
      
      private function __closeReliveView(param1:Event) : void
      {
         this._reliveView.removeEventListener(Event.CLOSE,this.__closeReliveView);
         ObjectUtils.disposeObject(this._reliveView);
         this._reliveView = null;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__update);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         this._roomMenuView.removeEventListener(Event.CLOSE,this._leaveRoom);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         this.dispose();
         super.leaving(param1);
         ArenaManager.instance.model.dispatchEvent(new ArenaEvent(ArenaEvent.LEAVE_SCENE));
      }
      
      override public function getType() : String
      {
         return StateType.ARENA;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      private function removeView() : void
      {
         ObjectUtils.disposeObject(this._objectView);
         this._objectView = null;
         ObjectUtils.disposeObject(this._informationView);
         this._informationView = null;
         ObjectUtils.disposeObject(this._chatView);
         this._chatView = null;
         ObjectUtils.disposeObject(this._reliveView);
         this._reliveView = null;
         ObjectUtils.disposeObject(this._roomMenuView);
         this._roomMenuView = null;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
