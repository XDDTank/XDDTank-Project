package ddt.manager
{
   import com.pickgliss.toplevel.StageReferance;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   
   public class KeyboardShortcutsManager
   {
      
      private static var _instance:KeyboardShortcutsManager;
       
      
      private var isAddEvent:Boolean = true;
      
      public function KeyboardShortcutsManager()
      {
         super();
      }
      
      public static function get Instance() : KeyboardShortcutsManager
      {
         if(_instance == null)
         {
            _instance = new KeyboardShortcutsManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         if(this.isAddEvent)
         {
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_UP,this.__onKeyDown);
            this.isAddEvent = false;
         }
      }
      
      private function __onKeyDown(param1:KeyboardEvent) : void
      {
         DialogManager.Instance.KeyDown();
         if(param1.target is TextField && (param1.target as TextField).type == TextFieldType.INPUT)
         {
            return;
         }
      }
   }
}
