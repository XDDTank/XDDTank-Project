package petsBag.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import flash.events.MouseEvent;
   
   public class PetBaseFrame extends Frame
   {
       
      
      protected var _helpTextStyle:String;
      
      protected var _helpTextPos;
      
      public function PetBaseFrame()
      {
         super();
         this._helpTextPos = "petsBag.view.baseView.helpPos";
      }
      
      protected function __helpClick(param1:MouseEvent) : void
      {
         onResponse(FrameEvent.HELP_CLICK);
      }
      
      public function showHelp() : void
      {
         var _loc1_:PetHelpFrame = ComponentFactory.Instance.creat("petsBag.frame.HelpFrame");
         if(this._helpTextStyle)
         {
            _loc1_.setView(ComponentFactory.Instance.creat(this._helpTextStyle),this._helpTextPos);
         }
         _loc1_.show();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      public function get helpTextStyle() : String
      {
         return this._helpTextStyle;
      }
      
      public function set helpTextStyle(param1:String) : void
      {
         this._helpTextStyle = param1;
      }
      
      public function get helpTextPos() : *
      {
         return this._helpTextPos;
      }
      
      public function set helpTextPos(param1:*) : void
      {
         this._helpTextPos = param1;
      }
   }
}
