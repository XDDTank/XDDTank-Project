package totem.view
{
   import com.pickgliss.ui.core.Component;
   
   public class TitleComponent extends Component
   {
       
      
      public function TitleComponent()
      {
         super();
      }
      
      override public function get tipStyle() : String
      {
         return "ddt.view.tips.OneLineTip";
      }
      
      override public function get tipDirctions() : String
      {
         return "0";
      }
   }
}
