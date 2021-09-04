package store.view.Compose.view
{
   import bead.BeadManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import store.data.ComposeItemInfo;
   import store.view.Compose.ComposeController;
   import store.view.Compose.ComposeEvents;
   import store.view.StoneCellFrame;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class ComposeMaterialShow extends Sprite implements Disposeable
   {
      
      private static var CELL_COUNT:int = 4;
       
      
      private var _count:int;
      
      private var _items:Array;
      
      private var _mainCell:ComposeItemCell;
      
      private var _equipmentCell:StoneCellFrame;
      
      private var _pointArray:Vector.<Point>;
      
      private var _mainCellPos:Point;
      
      private var _composeCountTextBg:ScaleLeftRightImage;
      
      private var _composeCountText:TextInput;
      
      private var _reduceBtn:BaseButton;
      
      private var _addBtn:BaseButton;
      
      private var _compose_btn:BaseButton;
      
      private var _neededGoldTipText:FilterFrameText;
      
      private var _gold_txt:FilterFrameText;
      
      private var _goldIcon:Image;
      
      private var _composeCount:int;
      
      private var _goldNeed:int;
      
      public function ComposeMaterialShow()
      {
         super();
         this.intView();
         this.initEvent();
      }
      
      private function intView() : void
      {
         var _loc2_:ComposeMaterialCell = null;
         this._items = new Array();
         this.getCellsPoint();
         this._equipmentCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.EquipmentCell");
         this._equipmentCell.label = LanguageMgr.GetTranslation("store.Strength.StrengthenEquipmentCellText");
         addChild(this._equipmentCell);
         this._mainCell = new ComposeItemCell(0);
         this._mainCellPos = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.ComposepointMain");
         PositionUtils.setPos(this._mainCell,this._mainCellPos);
         addChild(this._mainCell);
         this._composeCountTextBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.composeView.composeCountTextBg");
         addChild(this._composeCountTextBg);
         this._composeCountText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.composeView.composeCountText");
         this._composeCountText.text = "1";
         addChild(this._composeCountText);
         this._composeCountText.textField.restrict = "0-9";
         this._reduceBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.composeView.reduceBtn");
         this._reduceBtn.enable = false;
         addChild(this._reduceBtn);
         this._addBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.composeView.addBtn");
         this._addBtn.enable = false;
         addChild(this._addBtn);
         this._neededGoldTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.NeededGoldTipText");
         this._neededGoldTipText.text = LanguageMgr.GetTranslation("store.Transfer.NeededGoldTipText");
         addChild(this._neededGoldTipText);
         this._gold_txt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.NeedMoneyText");
         addChild(this._gold_txt);
         this._goldIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.GoldIcon");
         addChild(this._goldIcon);
         PositionUtils.setPos(this._neededGoldTipText,"asset.ddtstore.composeMoneyPos1");
         PositionUtils.setPos(this._gold_txt,"asset.ddtstore.composeMoneyPos2");
         PositionUtils.setPos(this._goldIcon,"asset.ddtstore.composeMoneyPos3");
         this._compose_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.ComposeBtn");
         addChild(this._compose_btn);
         var _loc1_:int = 0;
         while(_loc1_ < CELL_COUNT)
         {
            _loc2_ = new ComposeMaterialCell();
            _loc2_.x = this._pointArray[_loc1_].x;
            _loc2_.y = this._pointArray[_loc1_].y;
            addChild(_loc2_);
            this._items.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function set info(param1:ItemTemplateInfo) : void
      {
         this._mainCell.info = param1;
         this.updateData();
         this.composeCount = 1;
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._mainCell.info;
      }
      
      private function getCellsPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 0;
         while(_loc1_ < CELL_COUNT)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.Composepoint" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function getLargeCount() : int
      {
         var _loc2_:ComposeMaterialCell = null;
         var _loc3_:int = 0;
         var _loc1_:int = this.getEquipComposeMaxCount();
         for each(_loc2_ in this._items)
         {
            _loc3_ = _loc2_.LargestTime;
            if(_loc2_.info)
            {
               if(_loc3_ == 0)
               {
                  return int(0);
               }
               if(_loc1_ > _loc3_)
               {
                  _loc1_ = _loc3_;
               }
            }
         }
         return _loc1_;
      }
      
      private function getEquipComposeMaxCount() : int
      {
         return ComposeController.instance.model.composeItemInfoDic[this.info.TemplateID].MaxCount;
      }
      
      private function getEnough() : int
      {
         var _loc1_:ComposeMaterialCell = null;
         for each(_loc1_ in this._items)
         {
            if(!_loc1_.enough)
            {
               if(_loc1_.haveCount > _loc1_.canUseCount)
               {
                  return -1;
               }
            }
            continue;
            return 0;
         }
         return 1;
      }
      
      public function getBind() : Boolean
      {
         var _loc1_:ComposeMaterialCell = null;
         for each(_loc1_ in this._items)
         {
            if(_loc1_.info && _loc1_.isNotBind)
            {
               return true;
            }
         }
         return false;
      }
      
      public function updateData() : void
      {
         var _loc2_:int = 0;
         var _loc1_:ComposeItemInfo = new ComposeItemInfo();
         if(this._mainCell.info)
         {
            _loc2_ = this._mainCell.info.TemplateID;
            _loc1_ = ComposeController.instance.model.composeItemInfoDic[_loc2_];
         }
         if(_loc1_ && _loc1_.Material1ID)
         {
            this._items[0].info = ItemManager.Instance.getTemplateById(_loc1_.Material1ID);
            this._items[0].count = _loc1_.NeedCount1;
         }
         else
         {
            this._items[0].info = null;
            this._items[0].count = 0;
         }
         if(_loc1_ && _loc1_.Material2ID)
         {
            this._items[1].info = ItemManager.Instance.getTemplateById(_loc1_.Material2ID);
            this._items[1].count = _loc1_.NeedCount2;
         }
         else
         {
            this._items[1].info = null;
            this._items[1].count = 0;
         }
         if(_loc1_ && _loc1_.Material3ID)
         {
            this._items[2].info = ItemManager.Instance.getTemplateById(_loc1_.Material3ID);
            this._items[2].count = _loc1_.NeedCount3;
         }
         else
         {
            this._items[2].info = null;
            this._items[2].count = 0;
         }
         if(_loc1_ && _loc1_.Material4ID)
         {
            this._items[3].info = ItemManager.Instance.getTemplateById(_loc1_.Material4ID);
            this._items[3].count = _loc1_.NeedCount4;
         }
         else
         {
            this._items[3].info = null;
            this._items[3].count = 0;
         }
      }
      
      public function get composeCount() : int
      {
         return this._composeCount;
      }
      
      public function set composeCount(param1:int) : void
      {
         var _loc2_:ComposeMaterialCell = null;
         var _loc3_:ComposeItemInfo = null;
         if(param1 <= 1)
         {
            param1 = 1;
         }
         this._composeCount = param1;
         this._composeCountText.text = this._composeCount.toString();
         for each(_loc2_ in this._items)
         {
            _loc2_.setTime(param1);
         }
         if(this.info)
         {
            this._addBtn.enable = this._composeCount < this.getLargeCount();
            this._reduceBtn.enable = this._composeCount > 1;
            _loc3_ = ComposeController.instance.model.composeItemInfoDic[this.info.TemplateID];
            this._goldNeed = _loc3_.NeedGold * this.composeCount;
            this._gold_txt.text = this._goldNeed.toString();
         }
         else
         {
            this._addBtn.enable = this._reduceBtn.enable = false;
            this._gold_txt.text = "0";
         }
      }
      
      private function initEvent() : void
      {
         ComposeController.instance.model.addEventListener(ComposeEvents.CLICK_SMALL_ITEM,this.__clickHandle);
         this._compose_btn.addEventListener(MouseEvent.CLICK,this.__sendCompose);
         this._addBtn.addEventListener(MouseEvent.CLICK,this.__addCount);
         this._reduceBtn.addEventListener(MouseEvent.CLICK,this.__reduceCount);
         this._composeCountText.addEventListener(Event.CHANGE,this.__countChange);
      }
      
      private function __countChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.composeCount = int(this._composeCountText.text);
         if(this.composeCount <= 0 || !this.haveItem())
         {
            this.composeCount = 1;
            if(!this.haveItem())
            {
               return;
            }
         }
         var _loc2_:int = this.getLargeCount();
         if(_loc2_ == 0)
         {
            this.composeCount = 1;
            return;
         }
         if(this.composeCount > _loc2_)
         {
            this.composeCount = _loc2_;
         }
      }
      
      private function haveItem() : Boolean
      {
         if(this.info)
         {
            return true;
         }
         return false;
      }
      
      private function __sendCompose(param1:MouseEvent) : void
      {
         var _loc3_:EquipmentTemplateInfo = null;
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.Gold < this._goldNeed)
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
            BeadManager.instance.buyGoldFrame();
            return;
         }
         var _loc2_:int = this.getEnough();
         if(_loc2_ == 1)
         {
            dispatchEvent(new ComposeEvents(ComposeEvents.START_COMPOSE));
         }
         else if(_loc2_ == 0)
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
            _loc3_ = ItemManager.Instance.getEquipTemplateById(this.info.TemplateID);
            if(_loc3_ && _loc3_.TemplateType == 12)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.noEnoughRune"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.noEnoughMaterial"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.noEnoughMaterial1"));
         }
      }
      
      private function __clickHandle(param1:ComposeEvents) : void
      {
         this.info = ComposeController.instance.model.currentItem;
         if(SavePointManager.Instance.isInSavePoint(26) && !TaskManager.instance.isNewHandTaskCompleted(23) && !ComposeController.instance.model.composeSuccess)
         {
            NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON,0,"trainer.composeSureArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
      }
      
      private function __addCount(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.haveItem())
         {
            ++this.composeCount;
            this.__countChange(null);
         }
      }
      
      private function __reduceCount(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.haveItem())
         {
            --this.composeCount;
            this.__countChange(null);
         }
      }
      
      private function removeEvent() : void
      {
         ComposeController.instance.model.removeEventListener(ComposeEvents.CLICK_SMALL_ITEM,this.__clickHandle);
         this._compose_btn.removeEventListener(MouseEvent.CLICK,this.__sendCompose);
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.__addCount);
         this._reduceBtn.removeEventListener(MouseEvent.CLICK,this.__reduceCount);
         this._composeCountText.removeEventListener(Event.CHANGE,this.__countChange);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(this._items.length > 0)
         {
            ObjectUtils.disposeObject(this._items.shift());
         }
         this._items = null;
         ObjectUtils.disposeObject(this._mainCell);
         this._mainCell = null;
         ObjectUtils.disposeObject(this._equipmentCell);
         this._equipmentCell = null;
         this._pointArray.length = 0;
         this._pointArray = null;
         this._mainCellPos = null;
         ObjectUtils.disposeObject(this._composeCountTextBg);
         this._composeCountTextBg = null;
         ObjectUtils.disposeObject(this._composeCountText);
         this._composeCountText = null;
         ObjectUtils.disposeObject(this._reduceBtn);
         this._reduceBtn = null;
         ObjectUtils.disposeObject(this._addBtn);
         this._addBtn = null;
         ObjectUtils.disposeObject(this._compose_btn);
         this._compose_btn = null;
         ObjectUtils.disposeObject(this._neededGoldTipText);
         this._neededGoldTipText = null;
         ObjectUtils.disposeObject(this._gold_txt);
         this._gold_txt = null;
         ObjectUtils.disposeObject(this._goldIcon);
         this._goldIcon = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
