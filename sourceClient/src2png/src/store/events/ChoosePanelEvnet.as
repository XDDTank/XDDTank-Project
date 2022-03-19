// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.events.ChoosePanelEvnet

package store.events
{
    import flash.events.Event;

    public class ChoosePanelEvnet extends Event 
    {

        public static const CHOOSEPANELEVENT:String = "ChoosePanelEvent";

        private var _currentPanel:int;

        public function ChoosePanelEvnet(_arg_1:int)
        {
            this._currentPanel = _arg_1;
            super(CHOOSEPANELEVENT, true);
        }

        public function get currentPanle():int
        {
            return (this._currentPanel);
        }


    }
}//package store.events

