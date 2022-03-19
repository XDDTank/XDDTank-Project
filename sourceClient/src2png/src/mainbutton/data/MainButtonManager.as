// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//mainbutton.data.MainButtonManager

package mainbutton.data
{
    import flash.utils.Dictionary;
    import mainbutton.MainButton;

    public class MainButtonManager 
    {

        private static var _instance:MainButtonManager;

        private var _HallIconList:Dictionary;


        public static function get instance():MainButtonManager
        {
            if (_instance == null)
            {
                _instance = new (MainButtonManager)();
            };
            return (_instance);
        }


        public function gethallIconInfo(_arg_1:HallIconDataAnalyz):void
        {
            this._HallIconList = _arg_1.list;
        }

        public function getInfoByID(_arg_1:String):MainButton
        {
            return (this._HallIconList[_arg_1]);
        }


    }
}//package mainbutton.data

