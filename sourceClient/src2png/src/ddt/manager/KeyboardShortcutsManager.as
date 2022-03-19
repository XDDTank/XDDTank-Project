// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.KeyboardShortcutsManager

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


        public static function get Instance():KeyboardShortcutsManager
        {
            if (_instance == null)
            {
                _instance = new (KeyboardShortcutsManager)();
            };
            return (_instance);
        }


        public function setup():void
        {
            if (this.isAddEvent)
            {
                StageReferance.stage.addEventListener(KeyboardEvent.KEY_UP, this.__onKeyDown);
                this.isAddEvent = false;
            };
        }

        private function __onKeyDown(_arg_1:KeyboardEvent):void
        {
            DialogManager.Instance.KeyDown();
            if (((_arg_1.target is TextField) && ((_arg_1.target as TextField).type == TextFieldType.INPUT)))
            {
                return;
            };
        }


    }
}//package ddt.manager

