package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _7b90ce4031801ded151512cb6dee1e0b3df235a964042c9bce159b264704e5f6_flash_display_Sprite extends Sprite
   {
       
      
      public function _7b90ce4031801ded151512cb6dee1e0b3df235a964042c9bce159b264704e5f6_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain.apply(null,rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain.apply(null,rest);
      }
   }
}
