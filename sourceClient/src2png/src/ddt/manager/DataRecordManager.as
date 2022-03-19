// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.DataRecordManager

package ddt.manager
{
    public class DataRecordManager 
    {

        private static var instance:DataRecordManager;


        public static function getInstance():DataRecordManager
        {
            if (instance == null)
            {
                instance = new (DataRecordManager)();
            };
            return (instance);
        }


        public function recordClick(_arg_1:int):void
        {
        }


    }
}//package ddt.manager

