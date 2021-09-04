package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import pet.date.PetInfo;
   import road.game.resource.ActionMovie;
   
   public class GamePetMovie extends Sprite implements Disposeable
   {
      
      public static const PlayEffect:String = "PlayEffect";
       
      
      private var _petInfo:PetInfo;
      
      private var _player:GameTurnedLiving;
      
      private var _petMovie:ActionMovie;
      
      private var _isPlaying:Boolean = false;
      
      private var _actionTimer:Timer;
      
      private var _callBack:Function;
      
      private var _args:Array;
      
      public function GamePetMovie(param1:PetInfo, param2:GameTurnedLiving)
      {
         super();
         this._petInfo = param1;
         this._player = param2;
         this.init();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         if(this._petMovie)
         {
            this._petMovie.addEventListener("effect",this.__playPlayerEffect);
         }
      }
      
      protected function __playPlayerEffect(param1:Event) : void
      {
         dispatchEvent(new Event(PlayEffect));
      }
      
      public function init() : void
      {
         var _loc1_:Class = null;
         if(this._petInfo.assetReady && !this._player.info.isBoss)
         {
            _loc1_ = ModuleLoader.getDefinition(this._petInfo.actionMovieName) as Class;
            this._petMovie = new _loc1_();
            addChild(this._petMovie);
         }
      }
      
      public function show(param1:int = 0, param2:int = 0) : void
      {
         var _loc3_:Class = null;
         if(this._petMovie == null && this._petInfo.assetReady && !this._player.info.isBoss)
         {
            _loc3_ = ModuleLoader.getDefinition(this._petInfo.actionMovieName) as Class;
            this._petMovie = new _loc3_();
            addChild(this._petMovie);
         }
         this._player.map.addToPhyLayer(this);
         PositionUtils.setPos(this,new Point(param1,param2));
      }
      
      public function hide() : void
      {
         this._isPlaying = false;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get info() : PetInfo
      {
         return this._petInfo;
      }
      
      public function set direction(param1:int) : void
      {
         if(this._petMovie)
         {
            this._petMovie.scaleX = -param1;
         }
      }
      
      public function doAction(param1:String, param2:Function = null, param3:Array = null) : void
      {
         this._callBack = param2;
         this._args = param3;
         this._isPlaying = true;
         if(this._petMovie)
         {
            this._petMovie.doAction(param1,param2,param3);
         }
         else
         {
            if(this._actionTimer == null)
            {
               this._actionTimer = new Timer(1000);
               this._actionTimer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
            }
            this._actionTimer.reset();
            this._actionTimer.start();
         }
      }
      
      protected function __timerHandler(param1:TimerEvent) : void
      {
         this._actionTimer.stop();
         this.callFun(this._callBack,this._args);
      }
      
      private function callFun(param1:Function, param2:Array) : void
      {
         this._isPlaying = false;
         if(param2 == null || param2.length == 0)
         {
            param1();
         }
         else if(param2.length == 1)
         {
            param1(param2[0]);
         }
         else if(param2.length == 2)
         {
            param1(param2[0],param2[1]);
         }
         else if(param2.length == 3)
         {
            param1(param2[0],param2[1],param2[2]);
         }
         else if(param2.length == 4)
         {
            param1(param2[0],param2[1],param2[2],param2[3]);
         }
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function dispose() : void
      {
         if(this._petMovie)
         {
            this._petMovie.removeEventListener("effect",this.__playPlayerEffect);
         }
         ObjectUtils.disposeObject(this._petMovie);
         this._petMovie = null;
         if(this._actionTimer)
         {
            this._actionTimer.removeEventListener(TimerEvent.TIMER,this.__timerHandler);
            this._actionTimer.stop();
            this._actionTimer = null;
         }
         this._petInfo = null;
         this._player = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
