package activity.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ActivityContentHolder extends Sprite implements Disposeable
   {
       
      
      private var _back:Bitmap;
      
      public function ActivityContentHolder()
      {
         super();
         this.configUI();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityContentBg");
      }
      
      override public function get height() : Number
      {
         return this._back.height;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
