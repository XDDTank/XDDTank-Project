// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.PVEMapPermissionManager

package ddt.manager
{
    import flash.utils.Dictionary;

    public class PVEMapPermissionManager 
    {

        private static var _instance:PVEMapPermissionManager;

        private var allPermission:Dictionary = new Dictionary();


        public static function get Instance():PVEMapPermissionManager
        {
            if (_instance == null)
            {
                _instance = new (PVEMapPermissionManager)();
            };
            return (_instance);
        }


        public function getPermisitonKey(_arg_1:int, _arg_2:int):int
        {
            var _local_3:Array = [String(_arg_1), String(_arg_2)];
            var _local_4:String = _local_3.join("|");
            return (this.allPermission[_local_4]);
        }

        public function getPermission(_arg_1:int, _arg_2:int, _arg_3:String):Boolean
        {
            var _local_4:String = _arg_3.substr((_arg_1 - 1), 1).toUpperCase();
            if (_local_4 == "")
            {
                return (false);
            };
            if (_arg_2 == 0)
            {
                return (true);
            };
            if (_arg_2 == 1)
            {
                return ((!(_local_4 == "1")) ? true : false);
            };
            if (_arg_2 == 2)
            {
                if (((_local_4 == "F") || (_local_4 == "7")))
                {
                    return (true);
                };
                return (false);
            };
            if (_arg_2 == 3)
            {
                return ((_local_4 == "F") ? true : false);
            };
            return (false);
        }


    }
}//package ddt.manager

