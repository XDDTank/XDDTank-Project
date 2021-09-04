package consortion.transportSence
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.TimeEvents;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class TransportHijackWaitTime extends Sprite implements Disposeable
   {
       
      
      private var _bgShape:Shape;
      
      private var _timeBG:Bitmap;
      
      private var _timeBgTxt:Bitmap;
      
      private var _timeCD:MovieClip;
      
      private var _totalTime:uint = 10;
      
      public function TransportHijackWaitTime()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bgShape = new Shape();
         this._bgShape.graphics.beginFill(1,0);
         this._bgShape.graphics.drawRect(0,0,1000,600);
         this._bgShape.graphics.endFill();
         this._timeBG = ComponentFactory.Instance.creatBitmap("asset.consortiontransport.hijack.waitTime");
         this._timeBgTxt = ComponentFactory.Instance.creatBitmap("asset.consortiontransport.hijack.waitTime.txt");
         this._timeCD = ComponentFactory.Instance.creat("asset.consortionConvoy.hijack.timeCD");
         addChild(this._bgShape);
         addChild(this._timeBG);
         addChild(this._timeBgTxt);
         addChild(this._timeCD);
         (this._timeCD["timeSecond2"] as MovieClip).gotoAndStop("num_1");
         (this._timeCD["timeSecond"] as MovieClip).gotoAndStop("num_0");
      }
      
      private function addEvent() : void
      {
         TimeManager.addEventListener(TimeEvents.SECONDS,this.__timeCount);
      }
      
      private function removeEvent() : void
      {
         TimeManager.removeEventListener(TimeEvents.SECONDS,this.__timeCount);
      }
      
      private function __timeCount(param1:TimeEvents) : void
      {
         if(this._totalTime <= 0)
         {
            this.dispose();
            return;
         }
         var _loc2_:String = this.setFormat(this._totalTime);
         (this._timeCD["timeSecond2"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(0));
         (this._timeCD["timeSecond"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(1));
         --this._totalTime;
      }
      
      private function setFormat(param1:int) : String
      {
         var _loc2_:String = null;
         if(param1 >= 10)
         {
            _loc2_ = String(param1);
         }
         else
         {
            _loc2_ = "0" + param1;
         }
         return _loc2_;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bgShape);
         this._bgShape = null;
         ObjectUtils.disposeObject(this._timeBG);
         this._timeBG = null;
         ObjectUtils.disposeObject(this._timeBgTxt);
         this._timeBgTxt = null;
         ObjectUtils.disposeObject(this._timeCD);
         this._timeCD = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
