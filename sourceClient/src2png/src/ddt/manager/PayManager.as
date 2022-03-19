// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.PayManager

package ddt.manager
{
    public class PayManager 
    {

        private static var _ins:PayManager;


        public static function Instance():PayManager
        {
            return (_ins = ((_ins) || (new (PayManager)())));
        }


    }
}//package ddt.manager

