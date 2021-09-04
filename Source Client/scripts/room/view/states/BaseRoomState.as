package room.view.states
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.LayerManager;
   import ddt.constants.CacheConsts;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import game.GameManager;
   import par.ParticleManager;
   import par.ShapeManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.roomView.BaseRoomView;
   
   public class BaseRoomState extends BaseStateView
   {
       
      
      protected var _info:RoomInfo;
      
      protected var _roomView:BaseRoomView;
      
      public function BaseRoomState()
      {
         super();
         if(!ShapeManager.ready)
         {
            ParticleManager.initPartical(PathManager.FLASHSITE);
         }
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         if(!StartupResourceLoader.firstEnterHall)
         {
            SoundManager.instance.playMusic("065");
         }
         this._info = RoomManager.Instance.current;
         MainToolBar.Instance.show();
         if(this._info.selfRoomPlayer.isViewer)
         {
            MainToolBar.Instance.setRoomStartState();
            MainToolBar.Instance.setReturnEnable(true);
         }
         MainToolBar.Instance.setReturnEnable(true);
         if(PlayerManager.Instance.hasTempStyle)
         {
            PlayerManager.Instance.readAllTempStyleEvent();
         }
         this.initEvents();
         CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT,1200);
         addChild(ChatManager.Instance.view);
         ChatManager.Instance.state = ChatManager.CHAT_ROOM_STATE;
         ChatManager.Instance.setFocus();
         RoomManager.Instance.findLoginRoom = false;
      }
      
      protected function initEvents() : void
      {
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_1 = true;
      }
      
      protected function removeEvents() : void
      {
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_8 = true;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.removeEvents();
         if(this._roomView)
         {
            this._roomView.dispose();
            this._roomView = null;
         }
         this._info = null;
         if(StateManager.isExitRoom(param1.getType()) && !RoomManager.Instance.findLoginRoom)
         {
            GameInSocketOut.sendGamePlayerExit();
            GameManager.Instance.reset();
            RoomManager.Instance.reset();
         }
         MainToolBar.Instance.enableAll();
         super.leaving(param1);
      }
      
      protected function __startLoading(param1:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         GameManager.Instance.gotoRoomLoading();
         StateManager.getInGame_Step_7 = true;
      }
      
      private function __onFightNpc(param1:CrazyTankSocketEvent) : void
      {
      }
   }
}
