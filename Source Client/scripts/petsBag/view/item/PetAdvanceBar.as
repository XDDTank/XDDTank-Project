package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class PetAdvanceBar extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _container:Sprite;
      
      private var _maxBar:ScaleFrameImage;
      
      private var _maxMask:Shape;
      
      private var _currentFlag:Bitmap;
      
      private var _bubleBg:Bitmap;
      
      private var _bubleTxt:FilterFrameText;
      
      private var _level:int = 1;
      
      private var _type:int;
      
      private var _maxValue:int;
      
      public function PetAdvanceBar()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.advanceBar.bg");
         addChild(this._bg);
         this._container = new Sprite();
         addChild(this._container);
         this._maxBar = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.advanceBar.maxBar");
         this._container.addChild(this._maxBar);
         this._maxMask = this.creatMask(this._maxBar);
         this._container.addChild(this._maxMask);
         this._currentFlag = ComponentFactory.Instance.creat("asset.petsBag.petAdvanceFrame.advanceBar.gem");
         this._container.addChild(this._currentFlag);
         this._bubleBg = ComponentFactory.Instance.creat("asset.petsBag.petAdvanceFrame.bublesBg");
         this._container.addChild(this._bubleBg);
         this._bubleTxt = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.advanceBar.txt");
         this._container.addChild(this._bubleTxt);
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
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(param1:int) : void
      {
         var _loc2_:Point = null;
         this._level = param1;
         this._bubleTxt.text = LanguageMgr.GetTranslation("petsBag.view.petAdvanceBar.levelInfo",this._level);
         if(this._type == 0)
         {
            _loc2_ = ComponentFactory.Instance.creat("petsBag.petAdvanceView.level10.pos" + this._level % 10);
         }
         else if(this._level < 60)
         {
            _loc2_ = ComponentFactory.Instance.creat("petsBag.petAdvanceView.level11.pos" + this._level % 10);
         }
         else
         {
            _loc2_ = ComponentFactory.Instance.creat("petsBag.petAdvanceView.level11.pos10");
         }
         var _loc3_:Number = this._level % 10 / this._maxValue;
         this._maxMask.width = _loc2_.x;
         this._currentFlag.x = _loc2_.x - 40;
         this._bubleBg.x = this._maxMask.width - 29;
         this._bubleTxt.x = this._maxMask.width - 13;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._container);
         this._container = null;
         ObjectUtils.disposeObject(this._maxBar);
         this._maxBar = null;
         ObjectUtils.disposeObject(this._maxMask);
         this._maxMask = null;
         ObjectUtils.disposeObject(this._currentFlag);
         this._currentFlag = null;
         ObjectUtils.disposeObject(this._bubleBg);
         this._bubleBg = null;
         ObjectUtils.disposeObject(this._bubleTxt);
         this._bubleTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
         var _loc2_:Boolean = this._type == 0;
         this._maxValue = !!_loc2_ ? int(9) : int(10);
         this._bg.setFrame(!!_loc2_ ? int(1) : int(2));
         this._maxBar.setFrame(!!_loc2_ ? int(1) : int(2));
      }
   }
}
