package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.DebugManager;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import game.view.smallMap.SmallLiving;
   import phy.object.PhysicalObj;
   import phy.object.PhysicsLayer;
   import phy.object.SmallObject;
   import road.game.resource.ActionMovie;
   
   public class SimpleObject extends PhysicalObj
   {
       
      
      protected var m_model:String;
      
      protected var m_action:String;
      
      protected var m_movie:MovieClip;
      
      protected var actionMapping:Dictionary;
      
      private var _smallMapView:SmallObject;
      
      private var _isBottom:Boolean;
      
      private var _timer:Timer;
      
      public function SimpleObject(param1:int, param2:int, param3:String, param4:String, param5:Boolean = false)
      {
         super(param1,param2);
         this.actionMapping = new Dictionary();
         mouseChildren = false;
         mouseEnabled = false;
         scrollRect = null;
         this.m_model = param3;
         this.m_action = param4;
         this._isBottom = param5;
         this.creatMovie(this.m_model);
         this.playAction(this.m_action);
         this.initSmallMapView();
      }
      
      override public function get layer() : int
      {
         if(this._isBottom)
         {
            return PhysicsLayer.AppointBottom;
         }
         return PhysicsLayer.SimpleObject;
      }
      
      protected function creatMovie(param1:String) : void
      {
         var _loc2_:Class = null;
         if(ModuleLoader.hasDefinition(this.m_model))
         {
            _loc2_ = ModuleLoader.getDefinition(this.m_model) as Class;
            if(this.m_movie)
            {
               ObjectUtils.disposeObject(this.m_movie);
               this.m_movie = null;
            }
         }
         else
         {
            DebugManager.getInstance().handle("#game 缺少资源:" + param1);
         }
         if(_loc2_)
         {
            this.m_movie = new _loc2_();
            addChild(this.m_movie);
         }
         else
         {
            this.m_movie = new MovieClip();
            addChild(this.m_movie);
            this._timer = new Timer(500);
            this._timer.addEventListener(TimerEvent.TIMER,this.__checkActionIsReady);
            this._timer.start();
         }
      }
      
      protected function __checkActionIsReady(param1:TimerEvent) : void
      {
         if(ModuleLoader.hasDefinition(this.m_model))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__checkActionIsReady);
            this._timer = null;
            this.creatMovie(this.m_model);
         }
      }
      
      protected function initSmallMapView() : void
      {
         if(layerType == 0)
         {
            this._smallMapView = new SmallLiving();
            this._smallMapView.visible = false;
         }
      }
      
      override public function get smallView() : SmallObject
      {
         return this._smallMapView;
      }
      
      public function playAction(param1:String) : void
      {
         var _loc2_:FrameLabel = null;
         if(this.actionMapping[param1])
         {
            param1 = this.actionMapping[param1];
         }
         if(this.m_movie is ActionMovie)
         {
            if(param1 != "")
            {
               this.m_movie.gotoAndPlay(param1);
            }
            return;
         }
         if(this.m_movie)
         {
            if(param1 is String)
            {
               for each(_loc2_ in this.m_movie.currentLabels)
               {
                  if(_loc2_.name == param1)
                  {
                     this.m_movie.gotoAndPlay(param1);
                  }
               }
            }
         }
         if(param1 == "1" || param1 == "2")
         {
            this.m_movie.gotoAndPlay(param1);
         }
         if(this._smallMapView != null)
         {
            this._smallMapView.visible = param1 == "2";
         }
      }
      
      override public function collidedByObject(param1:PhysicalObj) : void
      {
         this.playAction("pick");
      }
      
      override public function setActionMapping(param1:String, param2:String) : void
      {
         if(this.m_movie is ActionMovie)
         {
            (this.m_movie as ActionMovie).setActionMapping(param1,param2);
            return;
         }
         this.actionMapping[param1] = param2;
      }
      
      override public function dispose() : void
      {
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__checkActionIsReady);
         }
         this._timer = null;
         var _loc1_:SoundTransform = new SoundTransform();
         _loc1_.volume = 0;
         if(this.m_movie)
         {
            this.m_movie.stop();
            this.m_movie.soundTransform = _loc1_;
         }
         super.dispose();
         if(this.m_movie && this.m_movie.parent)
         {
            removeChild(this.m_movie);
         }
         this.m_movie = null;
         if(this._smallMapView)
         {
            this._smallMapView.dispose();
            this._smallMapView = null;
         }
      }
      
      public function get movie() : MovieClip
      {
         return this.m_movie;
      }
   }
}
