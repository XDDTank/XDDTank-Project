package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import ddt.data.player.PlayerInfo;
   import flash.display.Bitmap;
   
   public class RuneIcon extends Component
   {
       
      
      private var _icon:Bitmap;
      
      public function RuneIcon()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._icon = ComponentFactory.Instance.creat("asset.ddtbagAndInfo.EmbedIcon");
         addChild(this._icon);
         tipStyle = "core.EmbedTips";
         tipGapH = 5;
         tipGapV = 5;
         tipDirctions = "2";
      }
      
      public function setInfo(param1:PlayerInfo) : void
      {
         tipData = param1;
         if(param1.runeLevel <= 0)
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            filters = null;
         }
      }
   }
}
