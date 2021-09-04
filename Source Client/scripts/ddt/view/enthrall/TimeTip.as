package ddt.view.enthrall
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   
   public class TimeTip extends Component
   {
       
      
      private var bg:ScaleBitmapImage;
      
      public var info_txt:FilterFrameText;
      
      public function TimeTip()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this.bg = ComponentFactory.Instance.creatComponentByStylename("asset.core.view.enthrall.TipBG");
         addChild(this.bg);
         this.info_txt = ComponentFactory.Instance.creat("core.view.enthrall.TipTimeText");
         addChild(this.info_txt);
      }
   }
}
