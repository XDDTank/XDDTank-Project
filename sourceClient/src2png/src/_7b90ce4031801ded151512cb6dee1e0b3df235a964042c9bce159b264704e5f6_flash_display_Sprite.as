// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//_7b90ce4031801ded151512cb6dee1e0b3df235a964042c9bce159b264704e5f6_flash_display_Sprite

package 
{
    import flash.display.Sprite;
    import flash.system.Security;

    [ExcludeClass]
    public class _7b90ce4031801ded151512cb6dee1e0b3df235a964042c9bce159b264704e5f6_flash_display_Sprite extends Sprite 
    {


        public function allowDomainInRSL(... _args):void
        {
            Security.allowDomain.apply(null, _args);
        }

        public function allowInsecureDomainInRSL(... _args):void
        {
            Security.allowInsecureDomain.apply(null, _args);
        }


    }
}//package 

