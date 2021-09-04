package ddt.view
{
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   
   public class SimpleDataAlert extends BaseAlerFrame
   {
       
      
      public var alertData;
      
      public function SimpleDataAlert()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.alertData = null;
      }
   }
}
