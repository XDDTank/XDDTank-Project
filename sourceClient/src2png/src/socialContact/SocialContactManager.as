// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//socialContact.SocialContactManager

package socialContact
{
    import socialContact.microcobol.MicrocobolFrame;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;

    public class SocialContactManager 
    {

        private static var _instance:SocialContactManager;

        private var _view:MicrocobolFrame;


        public static function get Instance():SocialContactManager
        {
            if (_instance == null)
            {
                _instance = new (SocialContactManager)();
            };
            return (_instance);
        }


        public function showView():void
        {
            this._view = ComponentFactory.Instance.creatComponentByStylename("MicrocobolFrame");
            this._view.show();
            this._view.addEventListener("submit", this._submitExit);
        }

        private function _submitExit(_arg_1:Event):void
        {
        }


    }
}//package socialContact

