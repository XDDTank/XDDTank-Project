package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class ShineSelectButton extends SelectedButton
   {
       
      
      private var _shineBg:DisplayObject;
      
      private var _textField:TextField;
      
      private var _timer:Timer;
      
      private var _delay:int = 200;
      
      public function ShineSelectButton()
      {
         this._timer = new Timer(this._delay);
         super();
      }
      
      public function set delay(param1:int) : void
      {
         this._delay = param1;
      }
      
      public function set shineStyle(param1:String) : void
      {
         if(this._shineBg)
         {
            ObjectUtils.disposeObject(this._shineBg);
         }
         this._shineBg = ComponentFactory.Instance.creat(param1);
         this._shineBg.visible = false;
      }
      
      public function set textStyle(param1:String) : void
      {
         if(this._textField)
         {
            ObjectUtils.disposeObject(this._textField);
         }
         this._textField = ComponentFactory.Instance.creat(param1);
      }
      
      public function set text(param1:String) : void
      {
         if(this._textField)
         {
            this._textField.text = param1;
         }
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._shineBg)
         {
            addChild(this._shineBg);
         }
         if(this._textField)
         {
            addChild(this._textField);
         }
      }
      
      public function shine() : void
      {
         this._timer.reset();
         this._timer.addEventListener(TimerEvent.TIMER,this.__onTimer);
         this._timer.start();
      }
      
      public function stopShine() : void
      {
         if(this._timer && this._timer.running)
         {
            this._timer.reset();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._timer.stop();
            this._shineBg.visible = false;
         }
      }
      
      override public function dispose() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._timer = null;
         }
         if(this._shineBg)
         {
            ObjectUtils.disposeObject(this._shineBg);
            this._shineBg = null;
         }
         if(this._textField)
         {
            ObjectUtils.disposeObject(this._textField);
            this._textField = null;
         }
         super.dispose();
      }
      
      private function __onTimer(param1:TimerEvent) : void
      {
         this._shineBg.visible = this._timer.currentCount % 2 == 1;
      }
   }
}
