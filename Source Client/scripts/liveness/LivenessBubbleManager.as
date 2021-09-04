package liveness
{
   import arena.ArenaManager;
   import arena.model.ArenaEvent;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.event.ConsortionMonsterEvent;
   import consortion.managers.ConsortionMonsterManager;
   import ddt.events.LivenessEvent;
   import ddt.events.TimeEvents;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import worldboss.WorldBossManager;
   import worldboss.WorldBossRoomController;
   import worldboss.event.WorldBossRoomEvent;
   
   public class LivenessBubbleManager extends EventDispatcher
   {
      
      private static var _instance:LivenessBubbleManager;
      
      private static const REMIND_TIME:uint = 10 * 60 * 1000;
       
      
      private var _livenessBubble:LivenessBubble;
      
      private var _point:Point;
      
      private var _needShine:Boolean;
      
      private var _hasClickIcon:Boolean;
      
      private var _worldBossIsReady:Boolean;
      
      private var _monsterIsReady:Boolean;
      
      private var _arenaIsReady:Boolean;
      
      private var _leftTime:Number;
      
      private var _secondTimerIsRunning:Boolean;
      
      public function LivenessBubbleManager()
      {
         super();
         this._point = new Point(0,0);
      }
      
      public static function get Instance() : LivenessBubbleManager
      {
         if(!_instance)
         {
            _instance = new LivenessBubbleManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.GAME_INIT,this.__showLivenessBubble);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.WORLDBOSS_OVER,this.__showLivenessBubble);
         ConsortionMonsterManager.Instance.addEventListener(ConsortionMonsterEvent.MONSTER_ACTIVE_START,this.__showLivenessBubble);
         ArenaManager.instance.model.addEventListener(ArenaEvent.ARENA_ACTIVITY,this.__showLivenessBubble);
         TimeManager.addEventListener(TimeEvents.MINUTES,this.__checkActivityOpen);
      }
      
      private function __checkActivityOpen(param1:TimeEvents) : void
      {
         var _loc4_:Date = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:Date = new Date();
         if(!this._worldBossIsReady)
         {
            _loc5_ = WorldBossRoomController.Instance.beginTime();
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc3_.setHours(_loc5_[_loc6_].hours,_loc5_[_loc6_].minutes,_loc5_[_loc6_].seconds,_loc5_[_loc6_].milliseconds);
               if(_loc3_.time - _loc2_.time > 0 && _loc3_.time - _loc2_.time <= REMIND_TIME)
               {
                  this._worldBossIsReady = true;
                  this._leftTime = _loc3_.time - _loc2_.time;
                  if(!this._secondTimerIsRunning)
                  {
                     this.addSecondTimer();
                  }
                  return;
               }
               _loc6_++;
            }
         }
         if(!this._monsterIsReady)
         {
            if(PlayerManager.Instance.Self.consortiaInfo.Level && PlayerManager.Instance.Self.consortiaInfo.Level >= 3)
            {
               _loc4_ = ConsortionMonsterManager.Instance.beginTime();
               if(_loc4_)
               {
                  _loc3_.setHours(_loc4_.hours,_loc4_.minutes,_loc4_.seconds,_loc4_.milliseconds);
                  if(_loc3_.time - _loc2_.time > 0 && _loc3_.time - _loc2_.time <= REMIND_TIME)
                  {
                     this._monsterIsReady = true;
                     this._leftTime = _loc3_.time - _loc2_.time;
                     if(!this._secondTimerIsRunning)
                     {
                        this.addSecondTimer();
                     }
                     return;
                  }
               }
            }
         }
         if(!this._arenaIsReady)
         {
            _loc4_ = ArenaManager.instance.beginTime();
            _loc3_.setHours(_loc4_.hours,_loc4_.minutes,_loc4_.seconds,_loc4_.milliseconds);
            if(_loc3_.time - _loc2_.time > 0 && _loc3_.time - _loc2_.time <= REMIND_TIME)
            {
               this._arenaIsReady = true;
               this._leftTime = _loc3_.time - _loc2_.time;
               if(!this._secondTimerIsRunning)
               {
                  this.addSecondTimer();
               }
               return;
            }
         }
      }
      
      private function addSecondTimer() : void
      {
         TimeManager.addEventListener(TimeEvents.SECONDS,this.__showRemind);
         this._secondTimerIsRunning = true;
      }
      
      private function __showRemind(param1:TimeEvents) : void
      {
         var _loc2_:String = null;
         if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.LOGIN)
         {
            _loc2_ = "";
            if(this._worldBossIsReady)
            {
               _loc2_ = LanguageMgr.GetTranslation("ddt.livenessBubble.worldBossRemind.txt",TimeManager.Instance.formatTimeToString1(this._leftTime,false));
            }
            else if(this._monsterIsReady)
            {
               if(!(PlayerManager.Instance.Self.consortiaInfo.Level && PlayerManager.Instance.Self.consortiaInfo.Level >= 3))
               {
                  TimeManager.removeEventListener(TimeEvents.SECONDS,this.__showRemind);
                  this._secondTimerIsRunning = false;
                  ObjectUtils.disposeObject(this._livenessBubble);
                  this._livenessBubble = null;
                  this._monsterIsReady = false;
                  return;
               }
               _loc2_ = LanguageMgr.GetTranslation("ddt.livenessBubble.monsterRemind.txt",TimeManager.Instance.formatTimeToString1(this._leftTime,false));
            }
            else if(this._arenaIsReady)
            {
               _loc2_ = LanguageMgr.GetTranslation("ddt.livenessBubble.arenaRemind.txt",TimeManager.Instance.formatTimeToString1(this._leftTime,false));
            }
            if(!this._livenessBubble)
            {
               this._livenessBubble = new LivenessBubble(0,false);
               this.offsetPos();
               this._livenessBubble.show();
            }
            this._livenessBubble.setBtnEnable(false);
            this._livenessBubble.setText(_loc2_);
         }
         this._leftTime -= 1000;
         if(this._leftTime < 0)
         {
            this._leftTime = 0;
         }
      }
      
      public function setPos(param1:Point) : void
      {
         this._point = param1;
         if(this._livenessBubble)
         {
            this.offsetPos();
         }
      }
      
      private function offsetPos() : void
      {
         var _loc1_:Point = new Point();
         _loc1_.x = this._point.x;
         _loc1_.y = this._point.y - this._livenessBubble.height;
         _loc1_.y -= 32;
         PositionUtils.setPos(this._livenessBubble,_loc1_);
      }
      
      private function __showLivenessBubble(param1:*) : void
      {
         TimeManager.removeEventListener(TimeEvents.SECONDS,this.__showRemind);
         this._secondTimerIsRunning = false;
         ObjectUtils.disposeObject(this._livenessBubble);
         this._livenessBubble = null;
         if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.LOGIN)
         {
            if(param1 is ConsortionMonsterEvent)
            {
               if(param1.data as Boolean)
               {
                  this._livenessBubble = new LivenessBubble(LivenessBubble.MONSTER_REFLASH,true);
                  this._livenessBubble.setText(LanguageMgr.GetTranslation("ddt.liveness.bubble.monsterReflashTips.txt"));
                  this._needShine = true;
                  this._monsterIsReady = false;
               }
               else
               {
                  this._needShine = false;
               }
               dispatchEvent(new LivenessEvent(LivenessEvent.SHOW_SHINE,this._needShine));
            }
            else if(param1 is ArenaEvent)
            {
               if(WorldBossManager.Instance.isOpen)
               {
                  this._livenessBubble = new LivenessBubble(LivenessBubble.WORLD_BOSS,true);
                  this._livenessBubble.setText(LanguageMgr.GetTranslation("ddt.liveness.bubble.worldbossTips.txt"));
                  this._needShine = true;
                  this._worldBossIsReady = false;
               }
               else if(param1.data as Boolean)
               {
                  this._livenessBubble = new LivenessBubble(LivenessBubble.ARENA,true);
                  this._livenessBubble.setText(LanguageMgr.GetTranslation("ddt.liveness.bubble.arenaTips.txt"));
                  this._needShine = true;
                  this._arenaIsReady = false;
               }
               else
               {
                  this._needShine = false;
               }
            }
            else if(param1 is WorldBossRoomEvent)
            {
               if(WorldBossManager.Instance.isOpen)
               {
                  this._livenessBubble = new LivenessBubble(LivenessBubble.WORLD_BOSS,true);
                  this._livenessBubble.setText(LanguageMgr.GetTranslation("ddt.liveness.bubble.worldbossTips.txt"));
                  this._needShine = true;
                  this._worldBossIsReady = false;
               }
               else
               {
                  this._needShine = false;
               }
               dispatchEvent(new LivenessEvent(LivenessEvent.SHOW_SHINE,this._needShine));
            }
            if(this._livenessBubble)
            {
               this.offsetPos();
               if(StateManager.currentStateType == StateType.MAIN)
               {
                  this._livenessBubble.show();
               }
            }
         }
      }
      
      public function hideBubble() : void
      {
         if(this._livenessBubble && this._livenessBubble.parent)
         {
            this._livenessBubble.parent.removeChild(this._livenessBubble);
         }
      }
      
      public function tryShowBubble() : void
      {
         if(this._livenessBubble && !this._livenessBubble.parent)
         {
            this._livenessBubble.show();
         }
      }
      
      public function removeBubble() : void
      {
         if(this._livenessBubble)
         {
            ObjectUtils.disposeObject(this._livenessBubble);
            this._livenessBubble = null;
         }
      }
      
      public function get needShine() : Boolean
      {
         return this._needShine;
      }
      
      public function get hasClickIcon() : Boolean
      {
         return this._hasClickIcon;
      }
      
      public function set hasClickIcon(param1:Boolean) : void
      {
         this._hasClickIcon = param1;
      }
   }
}
