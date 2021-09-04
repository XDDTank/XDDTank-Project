package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   public class PetExpProgress extends Component
   {
       
      
      private var _backGround:ScaleBitmapImage;
      
      private var _maxGpItem:ScaleBitmapImage;
      
      private var _maxGpMask:Shape;
      
      private var _gp:Number = 0;
      
      private var _maxGp:Number = 100;
      
      private var _progressLabel:FilterFrameText;
      
      public function PetExpProgress()
      {
         super();
         this.initView();
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      private function initView() : void
      {
         this._backGround = ComponentFactory.Instance.creat("petsBag.view.infoView.expBg");
         addChild(this._backGround);
         this._maxGpItem = ComponentFactory.Instance.creat("petsBag.view.infoView.expBar");
         this._maxGpItem.cacheAsBitmap = true;
         addChild(this._maxGpItem);
         this._maxGpMask = this.creatMask(this._maxGpItem);
         addChild(this._maxGpMask);
         this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.infoView.expTxt");
         addChild(this._progressLabel);
         _width = this._backGround.width;
         _height = this._backGround.height;
         tipStyle = "ddt.view.tips.OneLineTip";
         tipDirctions = "3";
         ShowTipManager.Instance.addTip(this);
      }
      
      private function creatMask(param1:DisplayObject) : Shape
      {
         var _loc2_:Shape = null;
         _loc2_ = new Shape();
         _loc2_.graphics.beginFill(16711680,1);
         _loc2_.graphics.drawRect(0,0,param1.width,param1.height);
         _loc2_.graphics.endFill();
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         param1.mask = _loc2_;
         return _loc2_;
      }
      
      public function setProgress(param1:Number, param2:Number) : void
      {
         this._gp = param1;
         this._maxGp = param2;
         this._maxGpItem.visible = true;
         this._progressLabel.visible = true;
         this.drawProgress();
         tipData = [param1,param2].join("/");
      }
      
      public function noPet() : void
      {
         this._maxGpItem.visible = false;
         this._progressLabel.visible = false;
      }
      
      private function drawProgress() : void
      {
         var _loc1_:Number = this._maxGp > 0 ? Number(this._gp / this._maxGp) : Number(0);
         this._maxGpMask.width = this._maxGpItem.width * _loc1_;
         _tipData = [this._gp,this._maxGp].join("/") + LanguageMgr.GetTranslation("ddt.petbag.petExpProgressTip",this._gp);
         var _loc2_:Number = _loc1_ * 100;
         this._progressLabel.text = _loc2_.toFixed(2) + "%";
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._backGround);
         this._backGround = null;
         ObjectUtils.disposeObject(this._progressLabel);
         this._progressLabel = null;
         ObjectUtils.disposeObject(this._maxGpItem);
         this._maxGpItem = null;
         ObjectUtils.disposeObject(this._maxGpMask);
         this._maxGpMask = null;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}
