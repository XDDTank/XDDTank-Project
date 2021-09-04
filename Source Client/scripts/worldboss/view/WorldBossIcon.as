package worldboss.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import worldboss.WorldBossManager;
   
   public class WorldBossIcon extends Sprite
   {
       
      
      private var _dragon:MovieClip;
      
      private var _isOpen:Boolean;
      
      public function WorldBossIcon(param1:Boolean = false)
      {
         super();
         this._isOpen = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:BaseLoader = LoadResourceManager.instance.createLoader(WorldBossManager.Instance.iconEnterPath,BaseLoader.MODULE_LOADER);
         _loc1_.addEventListener(LoaderEvent.COMPLETE,this.onIconLoadedComplete);
         LoadResourceManager.instance.startLoad(_loc1_);
      }
      
      private function onIconLoadedComplete(param1:Event) : void
      {
         this._dragon = ComponentFactory.Instance.creat("asset.hall.worldBossEntrance-" + WorldBossManager.Instance.BossResourceId);
         this._dragon.mouseChildren = true;
         this._dragon.mouseEnabled = true;
         this._dragon.buttonMode = true;
         addChild(this._dragon);
         this._dragon.gotoAndStop(!!this._isOpen ? 1 : 2);
         this.addEvent();
         PositionUtils.setPos(this,"worldBoss.entranceIcon.pos");
      }
      
      private function addEvent() : void
      {
         this._dragon.addEventListener(MouseEvent.CLICK,this.__enterBossRoom);
      }
      
      private function removeEvent() : void
      {
         if(this._dragon)
         {
            this._dragon.removeEventListener(MouseEvent.CLICK,this.__enterBossRoom);
         }
      }
      
      private function __enterBossRoom(param1:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         if(WorldBossManager.Instance.isOpen)
         {
            if(PlayerManager.Instance.checkExpedition())
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.doing"));
            }
            else
            {
               SocketManager.Instance.out.enterWorldBossRoom();
            }
         }
         else if(PlayerManager.Instance.Self.Grade < ServerConfigManager.instance.getWorldBossMinEnterLevel())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.minenterlevel",ServerConfigManager.instance.getWorldBossMinEnterLevel()));
         }
         else
         {
            StateManager.setState(StateType.WORLDBOSS_AWARD);
         }
      }
      
      public function setFrame(param1:int) : void
      {
         if(this._dragon)
         {
            this._dragon.gotoAndStop(param1);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            this.parent.removeChild(this);
         }
         this._dragon = null;
      }
   }
}
