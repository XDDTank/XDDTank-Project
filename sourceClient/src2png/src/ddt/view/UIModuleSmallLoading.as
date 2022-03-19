// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.UIModuleSmallLoading

package ddt.view
{
    import flash.events.EventDispatcher;
    import com.pickgliss.utils.ClassUtils;
    import flash.events.Event;

    [Event(name="close", type="flash.events.Event")]
    public class UIModuleSmallLoading extends EventDispatcher 
    {

        private static var _instance:UIModuleSmallLoading;
        private static const SMALL_LOADING_CLASS:String = "SmallLoading";
        private static var _loadingInstance:*;


        public static function get Instance():UIModuleSmallLoading
        {
            if (_instance == null)
            {
                _instance = new (UIModuleSmallLoading)();
                _loadingInstance = ClassUtils.getDefinition(SMALL_LOADING_CLASS)["Instance"];
                _loadingInstance.addEventListener(Event.CLOSE, __onCloseClick);
            };
            return (_instance);
        }

        private static function __onCloseClick(_arg_1:Event):void
        {
            _instance.dispatchEvent(new Event(Event.CLOSE));
        }


        public function show(_arg_1:Boolean=true, _arg_2:Boolean=true):void
        {
            _loadingInstance.show(_arg_1, _arg_2);
        }

        public function hide():void
        {
            _loadingInstance.hide();
        }

        public function set progress(_arg_1:int):void
        {
            _loadingInstance.progress = _arg_1;
        }

        public function get progress():int
        {
            return (_loadingInstance.progress);
        }


    }
}//package ddt.view

