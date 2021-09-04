package platformapi.tencent.view
{
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import platformapi.tencent.interfaces.IDiamondIcon;
   
   public class BunIcon extends Component implements IDiamondIcon
   {
       
      
      private var _diamond:ScaleFrameImage;
      
      private var _level:int;
      
      public function BunIcon()
      {
         super();
         this._diamond = UICreatShortcut.creatAndAdd("platformapi.tencent.bunDiamondIcon",this);
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
         if(param1 > 0 && param1 < 7)
         {
            this._diamond.setFrame(this._level);
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._diamond);
         this._diamond = null;
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
   }
}
