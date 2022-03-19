// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.WeaponBallManager

package ddt.manager
{
    import flash.utils.Dictionary;
    import ddt.data.analyze.WeaponBallInfoAnalyze;

    public class WeaponBallManager 
    {

        private static var bobms:Dictionary;


        public static function setup(_arg_1:WeaponBallInfoAnalyze):void
        {
            bobms = _arg_1.bombs;
        }

        public static function getWeaponBallInfo(_arg_1:int):Array
        {
            return (bobms[_arg_1]);
        }


    }
}//package ddt.manager

