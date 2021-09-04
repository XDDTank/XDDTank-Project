package platformapi.tencent.view
{
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import platformapi.tencent.interfaces.IDiamondIcon;
   
   public class MemberDiamondIcon extends Component implements IDiamondIcon
   {
       
      
      private var _diamond:ScaleFrameImage;
      
      private var _level:int;
      
      public function MemberDiamondIcon()
      {
         super();
         this._diamond = UICreatShortcut.creatAndAdd("platformapi.tencent.memberDiamondIcon",this);
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
         if(this._level < 1)
         {
            this._level = 1;
         }
         else if(this._level > 7)
         {
            this._level = 7;
         }
         this._diamond.setFrame(this._level);
      }
      
      override public function get width() : Number
      {
         return Boolean(this._diamond) ? Number(this._diamond.width) : Number(0);
      }
      
      override public function get height() : Number
      {
         return Boolean(this._diamond) ? Number(this._diamond.height) : Number(0);
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._diamond);
         this._diamond = null;
      }
   }
}
