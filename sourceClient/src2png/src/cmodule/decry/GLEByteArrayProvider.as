// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.GLEByteArrayProvider

package cmodule.decry
{
    import flash.utils.ByteArray;
    import cmodule.decry.gdomainClass;
    import cmodule.decry.log;
    import cmodule.decry.*;
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    internal class GLEByteArrayProvider 
    {


        public static function get():ByteArray
        {
            var result:ByteArray;
            try
            {
                result = gdomainClass.currentDomain.domainMemory;
            }
            catch(e)
            {
            };
            if ((!(result)))
            {
                result = new LEByteArray();
                try
                {
                    result.length = gdomainClass.MIN_DOMAIN_MEMORY_LENGTH;
                    gdomainClass.currentDomain.domainMemory = result;
                }
                catch(e)
                {
                    log(3, "Not using domain memory");
                };
            };
            return (result);
        }


    }
}//package cmodule.decry

