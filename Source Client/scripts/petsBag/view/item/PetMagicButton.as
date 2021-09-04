package petsBag.view.item
{
   import com.pickgliss.ui.controls.BaseButton;
   
   public class PetMagicButton extends BaseButton
   {
       
      
      public function PetMagicButton()
      {
         super();
      }
      
      override public function set enable(param1:Boolean) : void
      {
         if(_enable == param1)
         {
            return;
         }
         _enable = param1;
         if(_enable)
         {
            setFrame(1);
         }
         else
         {
            setFrame(4);
         }
      }
   }
}
