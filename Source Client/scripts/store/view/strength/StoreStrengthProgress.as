package store.view.strength
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import store.events.StoreIIEvent;
   
   public class StoreStrengthProgress extends Component
   {
       
      
      protected var _background:Bitmap;
      
      protected var _thuck:Component;
      
      protected var _graphics_thuck:Bitmap;
      
      protected var _progressLabel:FilterFrameText;
      
      protected var _star:MovieClip;
      
      protected var _max:Number = 0;
      
      protected var _currentFrame:int;
      
      protected var _strengthenLevel:int;
      
      protected var _strengthenExp:int;
      
      protected var _progressBarMask:Sprite;
      
      protected var _scaleValue:Number;
      
      protected var _taskFrames:Dictionary;
      
      protected var _total:int = 50;
      
      public function StoreStrengthProgress()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         this._background = ComponentFactory.Instance.creatBitmap("asset.ddtstore.StrengthenSpaceProgress");
         PositionUtils.setPos(this._background,"asset.ddtstore.StrengthenSpaceProgressBgPos");
         addChild(this._background);
         this._thuck = ComponentFactory.Instance.creatComponentByStylename("ddtstore.info.thunck");
         addChild(this._thuck);
         this._graphics_thuck = ComponentFactory.Instance.creatBitmap("asset.ddtstore.StrengthenColorStrip");
         addChild(this._graphics_thuck);
         this.initMask();
         this._star = ClassUtils.CreatInstance("asset.strengthen.star");
         this._star.y = this._progressBarMask.y + this._progressBarMask.height / 2;
         addChild(this._star);
         this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.info.StoreStrengthProgressText");
         addChild(this._progressLabel);
         this._scaleValue = this._graphics_thuck.width / this._total;
         this.resetProgress();
      }
      
      protected function startProgress() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.__startFrame);
      }
      
      protected function __startFrame(param1:Event) : void
      {
         this.setMask(this._currentFrame);
         ++this._currentFrame;
         var _loc2_:int = 0;
         if(this._taskFrames.hasOwnProperty(0))
         {
            _loc2_ = this._taskFrames[0];
         }
         if(_loc2_ == 0 && this._taskFrames.hasOwnProperty(1))
         {
            _loc2_ = this._taskFrames[1];
         }
         if(this._currentFrame >= _loc2_)
         {
            if(_loc2_ >= this._total)
            {
               this._currentFrame = 0;
               this._taskFrames[0] = 0;
               this.dispatchEvent(new Event(StoreIIEvent.UPGRADES_PLAY));
            }
            else
            {
               this._taskFrames[1] = 0;
               this.removeEventListener(Event.ENTER_FRAME,this.__startFrame);
               this.setStarVisible(false);
               param1.stopImmediatePropagation();
            }
         }
      }
      
      protected function initMask() : void
      {
         this._progressBarMask = new Sprite();
         this._progressBarMask.graphics.beginFill(16777215,1);
         this._progressBarMask.graphics.drawRect(-6,0,this._graphics_thuck.width,this._graphics_thuck.height);
         this._progressBarMask.graphics.endFill();
         this._progressBarMask.x = -5;
         this._progressBarMask.y = -5;
         this._graphics_thuck.cacheAsBitmap = true;
         this._graphics_thuck.mask = this._progressBarMask;
         addChild(this._progressBarMask);
      }
      
      protected function setStarVisible(param1:Boolean) : void
      {
         this._star.visible = param1;
      }
      
      public function getStarVisible() : Boolean
      {
         return this._star.visible;
      }
      
      public function setMask(param1:Number) : void
      {
         var _loc2_:Number = param1 * this._scaleValue;
         if(isNaN(_loc2_) || _loc2_ == 0)
         {
            this._progressBarMask.width = 0;
         }
         else
         {
            if(_loc2_ >= this._graphics_thuck.width)
            {
               _loc2_ %= this._graphics_thuck.width;
            }
            this._progressBarMask.width = _loc2_;
         }
         this._star.x = this._progressBarMask.x + this._progressBarMask.width;
      }
      
      public function initProgress(param1:InventoryItemInfo) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         this._currentFrame = 0;
         this._strengthenExp = param1.StrengthenExp;
         this._strengthenLevel = param1.StrengthenLevel;
         var _loc2_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
         this._max = ItemManager.Instance.getEquipStrengthInfoByLevel(this._strengthenLevel + 1,_loc2_.QualityID).Exp;
         if(this._max > 0 && this._strengthenExp < this._max)
         {
            _loc3_ = this._strengthenExp / this._max;
            _loc4_ = Math.floor(_loc3_ * this._total);
            if(_loc4_ < 1 && _loc3_ > 0)
            {
               _loc4_ = 1;
            }
            this._currentFrame = _loc4_;
         }
         this.setMask(this._currentFrame);
         this.setExpPercent(param1);
         this._taskFrames = new Dictionary();
         if(this.hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.__startFrame);
         }
         this.setStarVisible(false);
      }
      
      public function setProgress(param1:InventoryItemInfo) : void
      {
         if(this._strengthenLevel != param1.StrengthenLevel)
         {
            this._taskFrames[0] = this._total;
            this._strengthenLevel = param1.StrengthenLevel;
         }
         this._strengthenExp = param1.StrengthenExp;
         var _loc2_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
         if(ItemManager.Instance.getEquipStrengthInfoByLevel(this._strengthenLevel + 1,_loc2_.QualityID))
         {
            this._max = ItemManager.Instance.getEquipStrengthInfoByLevel(this._strengthenLevel + 1,_loc2_.QualityID).Exp;
         }
         else
         {
            this._max = 0;
         }
         var _loc3_:Number = this._strengthenExp / this._max;
         var _loc4_:int = Math.floor(_loc3_ * this._total);
         if(_loc4_ < 1 && _loc3_ > 0)
         {
            _loc4_ = 1;
         }
         if(this._currentFrame == _loc4_)
         {
            if(this._taskFrames[0] && int(this._taskFrames[0]) != 0)
            {
               this.setStarVisible(true);
               this._taskFrames[1] = _loc4_;
               this.startProgress();
            }
         }
         else
         {
            this.setStarVisible(true);
            this._taskFrames[1] = _loc4_;
            this.startProgress();
         }
         this.setExpPercent(param1);
      }
      
      public function setExpPercent(param1:InventoryItemInfo = null) : void
      {
         var _loc2_:Number = NaN;
         if(this._strengthenExp == 0)
         {
            this._progressLabel.text = "0%";
         }
         else
         {
            _loc2_ = Math.floor(this._strengthenExp / this._max * 10000) / 100;
            if(isNaN(_loc2_))
            {
               _loc2_ = 0;
            }
            this._progressLabel.text = _loc2_ + "%";
         }
         if(param1 && this._strengthenLevel >= ItemManager.Instance.getEquipTemplateById(param1.TemplateID).StrengthLimit)
         {
            tipData = "0/0";
         }
         else
         {
            if(isNaN(this._strengthenExp))
            {
               this._strengthenExp = 0;
            }
            if(isNaN(this._max))
            {
               this._max = 0;
            }
            tipData = this._strengthenExp + "/" + this._max;
         }
      }
      
      public function resetProgress() : void
      {
         tipData = "0/0";
         this._progressLabel.text = "0%";
         this._strengthenExp = 0;
         this._max = 0;
         this._currentFrame = 0;
         this._strengthenLevel = -1;
         this.setMask(0);
         this.setStarVisible(false);
         this._taskFrames = new Dictionary();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._graphics_thuck);
         this._graphics_thuck = null;
         ObjectUtils.disposeObject(this._background);
         this._background = null;
         ObjectUtils.disposeObject(this._thuck);
         this._thuck = null;
         ObjectUtils.disposeObject(this._progressLabel);
         this._progressLabel = null;
         if(this._progressBarMask)
         {
            ObjectUtils.disposeObject(this._progressBarMask);
         }
         if(this.hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.__startFrame);
         }
         super.dispose();
      }
   }
}
