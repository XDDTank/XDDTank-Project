// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.ConsortiaDutyManager

package ddt.manager
{
    import flash.events.EventDispatcher;

    public class ConsortiaDutyManager extends EventDispatcher 
    {

        private static var _instance:ConsortiaDutyManager;


        public static function GetRight(_arg_1:int, _arg_2:int):Boolean
        {
            return (!((_arg_1 & int(_arg_2)) == 0));
        }

        public static function get Instance():ConsortiaDutyManager
        {
            if (_instance == null)
            {
                _instance = new (ConsortiaDutyManager)();
            };
            return (_instance);
        }


    }
}//package ddt.manager

