package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.TimeEvents;
   import ddt.manager.TimeManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.Timer;
   import worldboss.WorldBossManager;
   
   public class WorldBossCountDownView extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _timeCD:MovieClip;
      
      private var timer:Timer;
      
      private var _beginTime:Date;
      
      public function WorldBossCountDownView(param1:Date)
      {
         super();
         this.init();
         this.intEvent();
         this._beginTime = param1;
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("worldBossCountDownBg");
         addChild(this._bg);
         this._timeCD = ComponentFactory.Instance.creat("asset.worldboosCountDown.timeCD");
         addChild(this._timeCD);
      }
      
      private function intEvent() : void
      {
         TimeManager.addEventListener(TimeEvents.SECONDS,this.__startCount);
      }
      
      public function __startCount(param1:TimeEvents) : void
      {
         if(WorldBossManager.Instance.isOpen)
         {
            this.dispose();
            return;
         }
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:Date = new Date(_loc2_.fullYear,_loc2_.month,_loc2_.date,this._beginTime.hours,this._beginTime.minutes,this._beginTime.seconds,this._beginTime.milliseconds);
         var _loc4_:Number = _loc3_.time - _loc2_.time;
         var _loc5_:int = _loc4_ % TimeManager.HOUR_TICKS / TimeManager.Minute_TICKS;
         var _loc6_:int = _loc4_ % TimeManager.Minute_TICKS / TimeManager.Second_TICKS;
         if(_loc4_ <= 0)
         {
            this.dispose();
            return;
         }
         var _loc7_:String = this.setFormat(_loc5_) + ":" + this.setFormat(_loc6_);
         (this._timeCD["timeMint2"] as MovieClip).gotoAndStop("num_" + _loc7_.charAt(0));
         (this._timeCD["timeMint"] as MovieClip).gotoAndStop("num_" + _loc7_.charAt(1));
         (this._timeCD["timeSecond2"] as MovieClip).gotoAndStop("num_" + _loc7_.charAt(3));
         (this._timeCD["timeSecond"] as MovieClip).gotoAndStop("num_" + _loc7_.charAt(4));
      }
      
      private function setFormat(param1:int) : String
      {
         var _loc2_:String = param1.toString();
         if(param1 < 10)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      private function removeEvent() : void
      {
         TimeManager.removeEventListener(TimeEvents.SECONDS,this.__startCount);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._timeCD)
         {
            ObjectUtils.disposeObject(this._timeCD);
            this._timeCD = null;
         }
      }
   }
}
