package petsBag.view.item
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapLoaderProxy;
   import ddt.events.CellEvent;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.PathManager;
   import ddt.manager.PetBagManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import petsBag.event.PetItemEvent;
   import petsBag.event.UpdatePetInfoEvent;
   
   public class PetSmallItem extends PetBaseItem implements IAcceptDrag
   {
       
      
      protected var _bg:DisplayObject;
      
      protected var _stateFlag:Bitmap;
      
      protected var _petIcon:BitmapLoaderProxy;
      
      private var _cellMouseOverBg:Bitmap;
      
      private var _cellMouseOverFormer:Bitmap;
      
      private var _mouseMoveEffect:Boolean;
      
      private var _dragImg:Bitmap;
      
      public function PetSmallItem(param1:DisplayObject = null, param2:PetInfo = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false)
      {
         _info = param2;
         this._bg = param1;
         canDrag = param3;
         this._mouseMoveEffect = param4;
         _showState = param5;
         super();
         tipDirctions = "6,7,4,5";
         tipStyle = "ddt.view.tips.PetInfoTip";
      }
      
      public function get mouseMoveEffect() : Boolean
      {
         return this._mouseMoveEffect;
      }
      
      public function set mouseMoveEffect(param1:Boolean) : void
      {
         this._mouseMoveEffect = param1;
      }
      
      override public function set info(param1:PetInfo) : void
      {
         super.info = param1;
         tipData = _info;
         ObjectUtils.disposeObject(this._stateFlag);
         this._stateFlag = null;
         if(_info)
         {
            if(!_info || !_lastInfo || _info.TemplateID != _lastInfo.TemplateID)
            {
               if(this._petIcon)
               {
                  this._petIcon.removeEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__fixPetIconPostion);
               }
               ObjectUtils.disposeObject(this._petIcon);
               this._petIcon = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagManager.instance().getPicStr(_info)),null,true);
               this._petIcon.addEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__fixPetIconPostion);
               addChildAt(this._petIcon,2);
            }
            if(_showState)
            {
               if(_info.IsEquip)
               {
                  this._stateFlag = ComponentFactory.Instance.creatBitmap("asset.petsBag.petListView.fightFlag");
               }
               else if(_info.IsActive)
               {
                  this._stateFlag = ComponentFactory.Instance.creatBitmap("asset.petsBag.petListView.activeFlag");
               }
               if(this._stateFlag)
               {
                  addChild(this._stateFlag);
               }
            }
         }
         else
         {
            if(this._petIcon)
            {
               this._petIcon.removeEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__fixPetIconPostion);
            }
            ObjectUtils.disposeObject(this._petIcon);
            this._petIcon = null;
         }
         dispatchEvent(new UpdatePetInfoEvent(UpdatePetInfoEvent.UPDATE,_info));
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      override public function set locked(param1:Boolean) : void
      {
         super.locked = param1;
         this.updateLockState();
         dispatchEvent(new CellEvent(CellEvent.LOCK_CHANGED));
      }
      
      override protected function initView() : void
      {
         this._bg = Boolean(this._bg) ? this._bg : this.getDefaultBack();
         this._cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         this._cellMouseOverBg.visible = false;
         addChild(this._cellMouseOverBg);
         if(_info)
         {
            this._petIcon = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagManager.instance().getPicStr(_info)),null,true);
            this._petIcon.addEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__fixPetIconPostion);
            addChild(this._petIcon);
         }
         this._cellMouseOverFormer = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverShareBG");
         this._cellMouseOverFormer.visible = false;
         addChild(this._cellMouseOverFormer);
      }
      
      private function getDefaultBack() : DisplayObject
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(0,0);
         _loc1_.graphics.drawRect(0,0,46,46);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(MouseEvent.ROLL_OVER,this.__rollOverHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.__rollOutHandler);
         addEventListener(PetItemEvent.MOUSE_DOWN,this.__mouseDown);
         addEventListener(PetItemEvent.ITEM_CLICK,this.__itemClick);
         addEventListener(PetItemEvent.DOUBLE_CLICK,this.__doubleClick);
      }
      
      protected function __mouseDown(param1:Event) : void
      {
         if(locked || !canDrag)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      protected function __itemClick(param1:Event) : void
      {
         if(locked || !canDrag)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      protected function __doubleClick(param1:Event) : void
      {
         if(locked || !canDrag)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      private function __fixPetIconPostion(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         param1.stopImmediatePropagation();
         if(this._petIcon)
         {
            _loc2_ = Math.min(this._bg.width * 0.75 / this._petIcon.width,this._bg.height * 0.75 / this._petIcon.height);
            this._petIcon.scaleX = _loc2_;
            this._petIcon.scaleY = _loc2_;
            this._petIcon.x = this._bg.width - this._petIcon.width >> 1;
            this._petIcon.y = this._bg.height - this._petIcon.height >> 1;
         }
      }
      
      private function __rollOverHandler(param1:MouseEvent) : void
      {
         if(this._mouseMoveEffect && this._cellMouseOverBg)
         {
            this.updateBgVisible(true);
         }
      }
      
      private function __rollOutHandler(param1:MouseEvent) : void
      {
         if(this._mouseMoveEffect && this._cellMouseOverBg)
         {
            this.updateBgVisible(false);
         }
      }
      
      protected function updateBgVisible(param1:Boolean) : void
      {
         if(this._cellMouseOverBg)
         {
            this._cellMouseOverBg.visible = param1 || isSelected;
            this._cellMouseOverFormer.visible = param1 || isSelected;
            setChildIndex(this._cellMouseOverFormer,numChildren - 1);
         }
      }
      
      private function changePosition(param1:PetSmallItem, param2:PetSmallItem) : void
      {
         var _loc3_:PetInfo = param1.info;
         param1.info = param2.info;
         param2.info = _loc3_;
      }
      
      private function updateLockState() : void
      {
         if(locked)
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            filters = null;
         }
      }
      
      override protected function createDragImg() : DisplayObject
      {
         ObjectUtils.disposeObject(this._dragImg);
         this._dragImg = null;
         if(this._petIcon && this._petIcon.width > 0 && this._petIcon.height > 0)
         {
            this._dragImg = new Bitmap(new BitmapData(this._petIcon.width / this._petIcon.scaleX,this._petIcon.height / this._petIcon.scaleY,true,0));
            this._dragImg.bitmapData.draw(this._petIcon);
         }
         return this._dragImg;
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         if(this._petIcon)
         {
            this._petIcon.removeEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__fixPetIconPostion);
         }
         removeEventListener(MouseEvent.ROLL_OVER,this.__rollOverHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.__rollOutHandler);
         removeEventListener(PetItemEvent.MOUSE_DOWN,this.__mouseDown);
         removeEventListener(PetItemEvent.ITEM_CLICK,this.__itemClick);
         removeEventListener(PetItemEvent.DOUBLE_CLICK,this.__doubleClick);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._petIcon);
         this._petIcon = null;
         ObjectUtils.disposeObject(this._stateFlag);
         this._stateFlag = null;
         ObjectUtils.disposeObject(this._cellMouseOverBg);
         this._cellMouseOverBg = null;
         ObjectUtils.disposeObject(this._cellMouseOverFormer);
         this._cellMouseOverFormer = null;
         ObjectUtils.disposeObject(this._dragImg);
         this._dragImg = null;
      }
      
      override public function set isSelected(param1:Boolean) : void
      {
         super.isSelected = param1;
         this.updateBgVisible(false);
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         if(locked)
         {
            return;
         }
      }
   }
}
