// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.model.WebSpeedInfo

package room.model
{
    import flash.events.EventDispatcher;
    import ddt.manager.LanguageMgr;
    import ddt.events.WebSpeedEvent;

    [Event(name="stateChange", type="tank.view.game.webspeed.WebSpeedEvent")]
    public class WebSpeedInfo extends EventDispatcher 
    {

        public static const BEST:String = ddt.manager.LanguageMgr.GetTranslation("tank.data.WebSpeedInfo.good");
        public static const BETTER:String = ddt.manager.LanguageMgr.GetTranslation("tank.data.WebSpeedInfo.find");
        public static const WORST:String = ddt.manager.LanguageMgr.GetTranslation("tank.data.WebSpeedInfo.bad");

        private var _fps:int;
        private var _delay:int;

        public function WebSpeedInfo(_arg_1:int)
        {
            this._delay = _arg_1;
        }

        public function get fps():int
        {
            return (this._fps);
        }

        public function set fps(_arg_1:int):void
        {
            if (this._fps == _arg_1)
            {
                return;
            };
            this._fps = _arg_1;
            dispatchEvent(new WebSpeedEvent(WebSpeedEvent.STATE_CHANE));
        }

        public function get delay():int
        {
            return (this._delay);
        }

        public function set delay(_arg_1:int):void
        {
            if (this._delay == _arg_1)
            {
                return;
            };
            this._delay = _arg_1;
            dispatchEvent(new WebSpeedEvent(WebSpeedEvent.STATE_CHANE));
        }

        public function get stateId():int
        {
            if (this._delay > 600)
            {
                return (3);
            };
            if (this._delay > 300)
            {
                return (2);
            };
            return (1);
        }

        public function get state():String
        {
            if (this._delay > 600)
            {
                return (WORST);
            };
            if (this._delay > 300)
            {
                return (BETTER);
            };
            return (BEST);
        }


    }
}//package room.model

