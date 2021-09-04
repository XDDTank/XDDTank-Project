package petsBag.view
{
   import pet.date.PetInfo;
   
   public class PetRightBaseFrame extends PetBaseFrame
   {
       
      
      protected var _info:PetInfo;
      
      public function PetRightBaseFrame()
      {
         super();
      }
      
      public function get info() : PetInfo
      {
         return this._info;
      }
      
      public function set info(param1:PetInfo) : void
      {
         this._info = param1;
      }
      
      public function reset() : void
      {
      }
      
      override public function dispose() : void
      {
         this._info = null;
         super.dispose();
      }
   }
}
