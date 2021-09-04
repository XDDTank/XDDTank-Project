package worldboss
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.loader.LoaderCreate;
   import ddt.manager.InviteManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import hall.FightPowerAndFatigue;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.view.WorldBossAwardViewFrame;
   
   public class WorldBossAwardController extends BaseStateView
   {
      
      private static var _instance:WorldBossAwardController;
       
      
      private var _optionView:WorldBossAwardViewFrame;
      
      private var _mapLoader:BaseLoader;
      
      private var loader:BaseLoader;
      
      public function WorldBossAwardController()
      {
         super();
      }
      
      public static function get Instance() : WorldBossAwardController
      {
         if(_instance == null)
         {
            _instance = new WorldBossAwardController();
         }
         return _instance;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this.loadWorldBossRank();
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         this.init();
         this.addEvent();
      }
      
      public function setup() : void
      {
         this.loadWorldBossRank();
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         FightPowerAndFatigue.Instance.show();
         this.init();
         this.addEvent();
      }
      
      private function loadWorldBossRank() : void
      {
         this.loader = LoaderCreate.Instance.creatWorldBossRankLoader();
         LoadResourceManager.instance.startLoad(this.loader);
      }
      
      private function init() : void
      {
         this._optionView = ComponentFactory.Instance.creatCustomObject("ddtWorldBossAwardViewFrame");
         this._optionView.show();
      }
      
      private function addEvent() : void
      {
         this._optionView.addEventListener(WorldBossRoomEvent.WORLDBOSS_AWARD_CLOSE,this.__closeAward);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.ALLOW_ENTER,this.__gotoWorldBossRoom);
         WorldBossManager.Instance.addEventListener(WorldBossManager.UPDATE_WORLDBOSS_SCORE,this.__updateWorldBossScore);
      }
      
      private function __closeAward(param1:WorldBossRoomEvent) : void
      {
         this._optionView.removeEventListener(WorldBossRoomEvent.WORLDBOSS_AWARD_CLOSE,this.__closeAward);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.ALLOW_ENTER,this.__gotoWorldBossRoom);
         this.dispose();
      }
      
      private function __gotoWorldBossRoom(param1:WorldBossRoomEvent) : void
      {
         this._mapLoader = LoadResourceManager.instance.createLoader(WorldBossManager.Instance.mapPath,BaseLoader.MODULE_LOADER);
         this._mapLoader.addEventListener(LoaderEvent.COMPLETE,this.onMapSrcLoadedComplete);
         LoadResourceManager.instance.startLoad(this._mapLoader);
      }
      
      private function __updateWorldBossScore(param1:Event) : void
      {
         this._optionView.leftView.updateScore();
      }
      
      private function onMapSrcLoadedComplete(param1:Event) : void
      {
         if(StateManager.getState(StateType.WORLDBOSS_ROOM) == null)
         {
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingIsCloseRoom);
         }
         StateManager.setState(StateType.WORLDBOSS_ROOM);
      }
      
      private function __loadingIsCloseRoom(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsCloseRoom);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.WORLDBOSS_AWARD;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.ALLOW_ENTER,this.__gotoWorldBossRoom);
         this.dispose();
      }
      
      override public function dispose() : void
      {
         if(this.loader)
         {
            this.loader = null;
         }
         if(this._optionView)
         {
            ObjectUtils.disposeObject(this._optionView);
         }
         this._optionView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
