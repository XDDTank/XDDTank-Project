package farm.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   
   public class FieldOpenFlag extends Component
   {
       
      
      private var _bg:Bitmap;
      
      private var _grade:Bitmap;
      
      private var _num1:ScaleFrameImage;
      
      private var _num2:ScaleFrameImage;
      
      private var _level:int;
      
      public function FieldOpenFlag()
      {
         super();
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
         this._num1.setFrame(this._level / 10 + 1);
         this._num2.setFrame(this._level % 10 + 1);
         tipData = LanguageMgr.GetTranslation("ddt.farms.openFlagTip",this._level);
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.field.openTip");
         addChild(this._bg);
         this._grade = ComponentFactory.Instance.creatBitmap("asset.field.level.grade");
         addChild(this._grade);
         this._num1 = ComponentFactory.Instance.creat("farm.field.openNum1");
         addChild(this._num1);
         this._num2 = ComponentFactory.Instance.creat("farm.field.openNum2");
         addChild(this._num2);
         tipStyle = "ddt.view.tips.OneLineTip";
         tipDirctions = "2";
         ShowTipManager.Instance.addTip(this);
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._grade);
         this._grade = null;
         ObjectUtils.disposeObject(this._num1);
         this._num1 = null;
         ObjectUtils.disposeObject(this._num2);
         this._num2 = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
