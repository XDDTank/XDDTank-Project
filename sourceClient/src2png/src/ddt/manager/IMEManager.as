// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.IMEManager

package ddt.manager
{
    import flash.system.Capabilities;
    import flash.system.IME;

    public class IMEManager 
    {


        public static function enable():void
        {
            if (Capabilities.hasIME)
            {
                try
                {
                    IME.enabled = true;
                }
                catch(e:Error)
                {
                };
            };
        }

        public static function disable():void
        {
            if (Capabilities.hasIME)
            {
                try
                {
                    IME.enabled = false;
                }
                catch(e:Error)
                {
                };
            };
        }


    }
}//package ddt.manager

