package platformapi.tencent.view
{
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import platformapi.tencent.interfaces.IDiamondIcon;
   
   public class YellowDiamondIcon extends Component implements IDiamondIcon
   {
       
      
      private var _diamond:Bitmap;
      
      private var _levelTxt:FilterFrameText;
      
      private var _level:int;
      
      public function YellowDiamondIcon()
      {
         super();
         this._diamond = UICreatShortcut.creatAndAdd("asset.MemberDiamondGift.IMDiamond",this);
         this._levelTxt = UICreatShortcut.creatAndAdd("IM.view.memberIconText",this);
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
         this._levelTxt.text = param1.toString();
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      override public function get width() : Number
      {
         return Boolean(this._diamond) ? Number(this._diamond.width) : Number(0);
      }
      
      override public function get height() : Number
      {
         return Boolean(this._diamond) ? Number(this._diamond.height) : Number(0);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._diamond);
         this._diamond = null;
         ObjectUtils.disposeObject(this._levelTxt);
         this._levelTxt = null;
      }
   }
}
