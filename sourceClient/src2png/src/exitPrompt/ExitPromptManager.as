// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//exitPrompt.ExitPromptManager

package exitPrompt
{
    import flash.external.ExternalInterface;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.DesktopManager;
    import ddt.manager.PathManager;
    import flash.events.Event;
    import ddt.manager.TaskManager;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.LoadInterfaceManager;

    public class ExitPromptManager 
    {

        private static var _instance:ExitPromptManager;

        private var _exitPromptView:ExitPromptFrame;
        private var _fun:Function;
        private var _isExitToLogin:String;


        public static function get Instance():ExitPromptManager
        {
            if (_instance == null)
            {
                _instance = new (ExitPromptManager)();
            };
            return (_instance);
        }


        public function init():void
        {
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback("swfExitPrompt", this.receivedFromJavaScript);
            };
        }

        public function showView(_arg_1:String="0"):void
        {
            this._isExitToLogin = _arg_1;
            this._exitPromptView = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame");
            this._exitPromptView.show();
            this._exitPromptView.addEventListener("submit", this._submitExit);
            this._exitPromptView.addEventListener("close", this._closeExit);
        }

        private function _submitExit(_arg_1:Event):void
        {
            if (this._exitPromptView)
            {
                this._exitPromptView.dispose();
            };
            this._exitPromptView = null;
            if (DesktopManager.Instance.isDesktop)
            {
                ExternalInterface.call("ExitGameToLogin", this._isExitToLogin, PathManager.solveLogin());
            }
            else
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("closeWindow", this._isExitToLogin, PathManager.solveLogin());
                };
            };
        }

        private function _closeExit(_arg_1:Event):void
        {
            if (this._exitPromptView)
            {
                this._exitPromptView.dispose();
            };
            this._exitPromptView = null;
        }

        public function receivedFromJavaScript(_arg_1:String=""):void
        {
            if ((!(this._exitPromptView)))
            {
                this.showView();
            };
        }

        public function changeJSQuestVar():void
        {
            if (ExternalInterface.available)
            {
                ExternalInterface.call("setDailyTask", String(TaskManager.instance.getAvailableQuests(2).list.length));
                ExternalInterface.call("setDailyActivity", String(TaskManager.instance.getAvailableQuests(3).list.length));
            };
            if (LoadResourceManager.instance.isMicroClient)
            {
                LoadInterfaceManager.setDailyTask(String(TaskManager.instance.getAvailableQuests(2).list.length));
                LoadInterfaceManager.setDailyActivity(String(TaskManager.instance.getAvailableQuests(3).list.length));
            };
        }


    }
}//package exitPrompt

