package farm.view
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import farm.FarmModelController;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class SeedSelectedView extends Sprite implements Disposeable
   {
      
      public static const SEED:int = 1;
       
      
      private var _seedSelectViewBg:ScaleBitmapImage;
      
      private var _title:ScaleFrameImage;
      
      private var _preBtn:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _hBox:HBox;
      
      private var _cells:Vector.<FarmCell>;
      
      private var _type:int;
      
      private var _cellInfos:Vector.<InventoryItemInfo>;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      private var _isShow:Boolean;
      
      public function SeedSelectedView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set viewType(param1:int) : void
      {
         this._type = param1;
         this.cellInfos();
         this.upCells(0);
         this._title.setFrame(this._type);
      }
      
      public function set isShow(param1:Boolean) : void
      {
         if(param1 && this._cellInfos.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.seedView.noSeedTip"));
            return;
         }
         TweenLite.killTweensOf(this);
         this._isShow = param1;
         if(this._isShow)
         {
            visible = true;
            this.alpha = 0;
            TweenLite.to(this,0.5,{
               "alpha":1,
               "mouseEnabled":1,
               "mouseChildren":1
            });
            if(SavePointManager.Instance.isInSavePoint(48) && !TaskManager.instance.isNewHandTaskCompleted(21))
            {
               NewHandContainer.Instance.showArrow(ArrowType.FARM_GUILDE,0,"trainer.farmSeedArrowPos","","");
            }
         }
         else
         {
            mouseEnabled = false;
            mouseChildren = false;
            TweenLite.to(this,0.5,{
               "alpha":0,
               "visible":0
            });
         }
      }
      
      private function initEvent() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__onClose);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__bagUpdate);
         addEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      private function removeEvent() : void
      {
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__onClose);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.__bagUpdate);
         addEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      protected function __onClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      private function initView() : void
      {
         this._seedSelectViewBg = ComponentFactory.Instance.creatComponentByStylename("farm.seedselectViewBg");
         this._title = ComponentFactory.Instance.creatComponentByStylename("farm.selectedView.title");
         this._title.setFrame(this._type);
         this._preBtn = ComponentFactory.Instance.creat("farm.btnPrePage1");
         this._nextBtn = ComponentFactory.Instance.creat("farm.btnNextPage1");
         this._closeBtn = ComponentFactory.Instance.creat("farm.seedselectcloseBtn");
         this._hBox = ComponentFactory.Instance.creat("farm.cropBox");
         addChild(this._seedSelectViewBg);
         addChild(this._title);
         addChild(this._preBtn);
         addChild(this._nextBtn);
         addChild(this._closeBtn);
         addChild(this._hBox);
         this._cells = new Vector.<FarmCell>(4);
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this._cells[_loc1_] = new FarmCell();
            this._cells[_loc1_].addEventListener(MouseEvent.CLICK,this.__clickHandler);
            this._hBox.addChild(this._cells[_loc1_]);
            _loc1_++;
         }
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this.visible = false;
         FarmModelController.instance._cell = param1.currentTarget as FarmCell;
         FarmModelController.instance._cell.dragStart();
         if(SavePointManager.Instance.isInSavePoint(48) && !TaskManager.instance.isNewHandTaskCompleted(21))
         {
            NewHandContainer.Instance.showArrow(ArrowType.FARM_GUILDE,135,"trainer.farmSowArrowPos","","");
         }
      }
      
      private function __bagUpdate(param1:BagEvent) : void
      {
         this.cellInfos();
         this.upCells(this._currentPage);
      }
      
      private function __onClose(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(SavePointManager.Instance.isInSavePoint(48) && !TaskManager.instance.isNewHandTaskCompleted(21))
         {
            NewHandContainer.Instance.showArrow(ArrowType.FARM_GUILDE,0,"trainer.farmFieldArrowPos","","");
         }
         this.isShow = false;
      }
      
      private function __onPageBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._preBtn:
               this._currentPage = this._currentPage - 1 < 0 ? int(0) : int(this._currentPage - 1);
               break;
            case this._nextBtn:
               this._currentPage = this._currentPage + 1 > this._totlePage ? int(this._totlePage) : int(this._currentPage + 1);
         }
         this.upCells(this._currentPage);
      }
      
      private function cellInfos() : void
      {
         var _loc1_:Array = PlayerManager.Instance.Self.Bag.findItems(EquipType.SEED);
         _loc1_.sortOn("TemplateID",Array.NUMERIC);
         this._cellInfos = this.combineSeed(_loc1_);
         this._totlePage = this._cellInfos.length % 4 == 0 ? int(this._cellInfos.length / 4 - 1) : int(this._cellInfos.length / 4);
      }
      
      private function combineSeed(param1:Array) : Vector.<InventoryItemInfo>
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:InventoryItemInfo = null;
         var _loc2_:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         var _loc3_:int = 0;
         for each(_loc4_ in param1)
         {
            if(_loc4_.TemplateID == _loc3_)
            {
               _loc2_[_loc2_.length - 1].Count += _loc4_.Count;
            }
            else
            {
               _loc5_ = new InventoryItemInfo();
               _loc5_.TemplateID = _loc4_.TemplateID;
               ItemManager.fill(_loc5_);
               _loc5_.IsBinds = _loc4_.IsBinds;
               _loc5_.Count = _loc4_.Count;
               _loc2_.push(_loc5_);
            }
            _loc3_ = _loc4_.TemplateID;
         }
         return _loc2_;
      }
      
      private function upCells(param1:int = 0) : void
      {
         this._currentPage = param1;
         var _loc2_:int = param1 * 4;
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            if(this._cellInfos.length > _loc3_ + _loc2_)
            {
               this._cells[_loc3_].itemInfo = this._cellInfos[_loc3_ + _loc2_];
               if(this._cells[_loc3_].itemInfo.Count > 0)
               {
                  this._cells[_loc3_].visible = true;
               }
               else
               {
                  this._cells[_loc3_].visible = false;
               }
            }
            else
            {
               this._cells[_loc3_].visible = false;
            }
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:FarmCell = null;
         TweenLite.killTweensOf(this);
         this.removeEvent();
         while(this._cells.length > 0)
         {
            _loc1_ = this._cells.shift();
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
            _loc1_.dispose();
         }
         this._cells = null;
         this._cellInfos = null;
         if(this._seedSelectViewBg)
         {
            ObjectUtils.disposeObject(this._seedSelectViewBg);
         }
         this._seedSelectViewBg = null;
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(this._preBtn)
         {
            ObjectUtils.disposeObject(this._preBtn);
         }
         this._preBtn = null;
         if(this._nextBtn)
         {
            ObjectUtils.disposeObject(this._nextBtn);
         }
         this._nextBtn = null;
         if(this._closeBtn)
         {
            ObjectUtils.disposeObject(this._closeBtn);
         }
         this._closeBtn = null;
         if(this._hBox)
         {
            ObjectUtils.disposeObject(this._hBox);
         }
         this._hBox = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
