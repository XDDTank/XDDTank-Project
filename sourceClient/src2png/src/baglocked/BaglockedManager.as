// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//baglocked.BaglockedManager

package baglocked
{
    public class BaglockedManager 
    {

        private static var _instance:BaglockedManager;

        public var isBagLocked:Boolean = false;
        private var bagLockedController:BagLockedController;


        public static function get Instance():BaglockedManager
        {
            if (_instance == null)
            {
                _instance = new (BaglockedManager)();
            };
            return (_instance);
        }


        public function show():void
        {
            if (this.bagLockedController == null)
            {
                this.bagLockedController = new BagLockedController();
            };
            this.bagLockedController.openBagLockedGetFrame();
        }


    }
}//package baglocked

