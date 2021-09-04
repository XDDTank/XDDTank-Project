package calendar.view
{
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class SignFrame extends Frame
   {
       
      
      private var _signCalendar:ICalendar;
      
      private var _model:CalendarModel;
      
      public function SignFrame(param1:CalendarModel, param2:* = null)
      {
         super();
         this.initView(param1,param2);
         this.addEvent();
      }
      
      private function initView(param1:*, param2:*) : void
      {
         this._signCalendar = ComponentFactory.Instance.creatCustomObject("ddtcalendar.CalendarState",[param1]);
         addToContent(this._signCalendar as DisplayObject);
         if(this._signCalendar)
         {
            this._signCalendar.setData(param2);
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         addEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               CalendarManager.getInstance().close();
               this.dispose();
         }
      }
      
      private function __getFocus(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         StageReferance.stage.focus = this;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._signCalendar);
         this._signCalendar = null;
         super.dispose();
      }
   }
}
