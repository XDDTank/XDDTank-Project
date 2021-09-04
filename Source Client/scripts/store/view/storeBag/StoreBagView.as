package store.view.storeBag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.info.MoneyInfoView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.Price;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import store.StoreBagBgWHPoint;
   import store.StoreController;
   import store.StoreMainView;
   import store.data.StoreModel;
   import store.events.StoreIIEvent;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class StoreBagView extends Sprite implements Disposeable
   {
       
      
      private var _controller:StoreBagController;
      
      private var _model:StoreModel;
      
      private var _equipmentView:StoreBagListView;
      
      private var _propView:StoreBagListView;
      
      private var _singleView:StoreSingleBagListView;
      
      private var _bitmapBg:StoreBagbgbmp;
      
      private var _equipmentsColumnBg:Image;
      
      private var _itemsColumnBg:Image;
      
      public var msg_txt:ScaleFrameImage;
      
      private var _bgPoint:StoreBagBgWHPoint;
      
      private var _bgShape:Shape;
      
      private var _equipmentBg:Bitmap;
      
      private var _equipmentTitleText:FilterFrameText;
      
      private var _itemTitleText:FilterFrameText;
      
      private var _equipmentTipText:FilterFrameText;
      
      private var _itemTipText:FilterFrameText;
      
      private var _moneyView:MoneyInfoView;
      
      private var _ddtmoneyView:MoneyInfoView;
      
      private var _goldView:MoneyInfoView;
      
      public function StoreBagView()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.__checkSavePoint);
      }
      
      private function __checkSavePoint(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__checkSavePoint);
         if(SavePointManager.Instance.isInSavePoint(16) && !TaskManager.instance.isNewHandTaskCompleted(12))
         {
            NewHandContainer.Instance.showArrow(ArrowType.STRENG_CHOOSE_WEAPON,180,this._singleView.getWeaponPos(),"","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
      }
      
      public function setup(param1:StoreBagController) : void
      {
         this._controller = param1;
         this._model = this._controller.model;
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this._bitmapBg = new StoreBagbgbmp();
         addChildAt(this._bitmapBg,0);
         this._equipmentBg = ComponentFactory.Instance.creatBitmap("ddtstore.StoreBagView.EquipmentTitleBg");
         this._equipmentTitleText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.EquipmentTitleText");
         this._equipmentTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.EquipmentTitleText");
         this._itemTitleText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.ItemTitleText");
         this._itemTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.ItemTitleText");
         this._equipmentTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.EquipmentTipText");
         this._itemTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.ItemTipText");
         addChild(this._equipmentBg);
         addChild(this._equipmentTitleText);
         addChild(this._itemTitleText);
         addChild(this._equipmentTipText);
         addChild(this._itemTipText);
         this.showStoreBagViewText("store.StoreBagView.EquipmentTip.StrengthText","store.StoreBagView.ItemTip.Text1");
         var _loc1_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.MoneyPanelBg");
         addChild(_loc1_);
         this.initMoneyTexts();
         this._equipmentView = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagListViewEquip");
         this._propView = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagListViewProp");
         this._singleView = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreSingleBagListView");
         this._equipmentView.setup(0,this._controller,StoreBagListView.SMALLGRID);
         this._propView.setup(1,this._controller,StoreBagListView.SMALLGRID);
         this._singleView.setup(0,this._controller,StoreSingleBagListView.SINGLEBAG);
         addChild(this._singleView);
         this.updateMoney();
      }
      
      private function initMoneyTexts() : void
      {
         this._moneyView = new MoneyInfoView(Price.MONEY);
         this._ddtmoneyView = new MoneyInfoView(Price.DDT_MONEY);
         this._goldView = new MoneyInfoView(Price.GOLD);
         addChild(this._moneyView);
         addChild(this._ddtmoneyView);
         addChild(this._goldView);
         PositionUtils.setPos(this._moneyView,"store.MoneyInfoView.pos1");
         PositionUtils.setPos(this._ddtmoneyView,"store.MoneyInfoView.pos2");
         PositionUtils.setPos(this._goldView,"store.MoneyInfoView.pos3");
      }
      
      private function showStoreBagViewText(param1:String, param2:String, param3:Boolean = true) : void
      {
         this._equipmentTipText.text = LanguageMgr.GetTranslation(param1);
         this._equipmentTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.EquipmentTitleText");
         if(param3)
         {
            this._itemTipText.text = LanguageMgr.GetTranslation(param2);
         }
         this._itemTipText.visible = param3;
         this._itemTitleText.visible = param3;
      }
      
      private function initEvents() : void
      {
         this._equipmentView.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._propView.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._singleView.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._model.info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         StoreController.instance.Model.addEventListener(StoreIIEvent.CHANGE_TYPE,this.__updateComposeBag);
         StoreController.instance.Model.addEventListener(StoreIIEvent.STRENGTH_DONE,this.__unlockAllCells);
         this._controller.model.addEventListener(StoreIIEvent.WEAPON_READY,this.__weaponReady);
         this._controller.model.addEventListener(StoreIIEvent.WEAPON_REMOVE,this.__weaponRemove);
      }
      
      private function removeEvents() : void
      {
         this._equipmentView.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._propView.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._model.info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         StoreController.instance.Model.removeEventListener(StoreIIEvent.CHANGE_TYPE,this.__updateComposeBag);
         StoreController.instance.Model.removeEventListener(StoreIIEvent.STRENGTH_DONE,this.__unlockAllCells);
         this._controller.model.removeEventListener(StoreIIEvent.WEAPON_READY,this.__weaponReady);
         this._controller.model.removeEventListener(StoreIIEvent.WEAPON_REMOVE,this.__weaponRemove);
      }
      
      public function setData(param1:StoreModel) : void
      {
         this.visible = true;
         if(this._controller.currentPanel == StoreMainView.STRENGTH)
         {
            this._singleView.setData(this._model.canStrthEqpmtList);
            this._singleView.doubleClickEnable = true;
            this.showStoreBagViewText("store.StoreBagView.EquipmentTip.StrengthText","",false);
            if(SavePointManager.Instance.isInSavePoint(67))
            {
               this._singleView.releaseAllCell();
            }
            if(stage)
            {
               if(SavePointManager.Instance.isInSavePoint(16) && !TaskManager.instance.isNewHandTaskCompleted(12))
               {
                  NewHandContainer.Instance.showArrow(ArrowType.STRENG_CHOOSE_WEAPON,180,this._singleView.getWeaponPos(),"","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
               }
            }
         }
         else if(this._controller.currentPanel == StoreMainView.COMPOSE)
         {
            this.visible = false;
         }
         else if(this._controller.currentPanel == StoreMainView.SPLITE)
         {
            this._singleView.setData(this._model.canSplitEquipList);
            this._singleView.doubleClickEnable = true;
            this.showStoreBagViewText("store.StoreBagView.EquipmentTip.SpliteText","",false);
         }
         else if(this._controller.currentPanel == StoreMainView.EMBED)
         {
            this._singleView.setData(this._model.canEmbedEquipmentList);
            this._singleView.doubleClickEnable = true;
            this.showStoreBagViewText("store.StoreBagView.EquipmentTip.EmbedText","",false);
         }
         else if(this._controller.currentPanel == StoreMainView.REFINING)
         {
            this._singleView.setData(this._model.canRefiningEquipList);
            this._singleView.doubleClickEnable = true;
            this.showStoreBagViewText("store.StoreBagView.EquipmentTip.refiningText","",false);
         }
         else
         {
            this._singleView.setData(this._model.canTransEquipmengtList);
            this._singleView.doubleClickEnable = true;
            this.showStoreBagViewText("store.StoreBagView.EquipmentTip.TransferText","",false);
            if(SavePointManager.Instance.isInSavePoint(67) && !TaskManager.instance.isNewHandTaskCompleted(28))
            {
               NewHandContainer.Instance.showArrow(ArrowType.TRANSFER_CHOOSE_WEAPON,180,this._singleView.getWeaponPos(),"","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            }
         }
         this.changeToSingleBagView();
      }
      
      private function __weaponReady(param1:StoreIIEvent) : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.STRENG_CHOOSE_WEAPON);
         this._singleView.lockAllCell();
      }
      
      private function __weaponRemove(param1:StoreIIEvent) : void
      {
         this._singleView.weaponShowLight();
      }
      
      private function __unlockAllCells(param1:StoreIIEvent) : void
      {
         this._singleView.releaseAllCell();
      }
      
      private function changeToSingleBagView() : void
      {
         this._equipmentView.visible = false;
         this._propView.visible = false;
         this._singleView.visible = true;
      }
      
      private function changeToDoubleBagView() : void
      {
         this._equipmentView.visible = true;
         this._propView.visible = true;
         this._singleView.visible = false;
      }
      
      private function __cellClick(param1:CellEvent) : void
      {
         var _loc3_:InventoryItemInfo = null;
         param1.stopImmediatePropagation();
         var _loc2_:BagCell = param1.data as BagCell;
         if(_loc2_)
         {
            _loc3_ = _loc2_.info as InventoryItemInfo;
         }
         if(_loc3_ == null)
         {
            return;
         }
         if(!_loc2_.locked)
         {
            SoundManager.instance.play("008");
            if(!EquipType.isPackage(_loc3_))
            {
               _loc2_.dragStart();
            }
            if(SavePointManager.Instance.isInSavePoint(67) && !TaskManager.instance.isNewHandTaskCompleted(28) && this._controller.currentPanel == StoreMainView.TRANSF)
            {
               if(!this._model.transWeaponReady)
               {
                  NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON,180,"trainer.storeTransCellArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
               }
            }
         }
      }
      
      public function getPropCell(param1:int) : BagCell
      {
         return this._propView.getCellByPos(param1);
      }
      
      public function getEquipCell(param1:int) : BagCell
      {
         return this._equipmentView.getCellByPos(param1);
      }
      
      public function get EquipList() : StoreBagListView
      {
         return this._equipmentView;
      }
      
      public function get PropList() : StoreBagListView
      {
         return this._propView;
      }
      
      public function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Money"] || param1.changedProperties["Gold"] || param1.changedProperties[PlayerInfo.DDT_MONEY])
         {
            this.updateMoney();
         }
      }
      
      private function updateMoney() : void
      {
         this._moneyView.setInfo(PlayerManager.Instance.Self);
         this._ddtmoneyView.setInfo(PlayerManager.Instance.Self);
         this._goldView.setInfo(PlayerManager.Instance.Self);
      }
      
      private function __updateComposeBag(param1:StoreIIEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.data.x;
         if(_loc2_ == 1)
         {
            this._singleView.setData(this._model.canCpsEquipmentList);
            this._equipmentTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.EquipmentTitleText");
         }
         else if(_loc2_ == 2)
         {
            this._singleView.setData(this._model.canCpsQewelryList);
            this._equipmentTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.JewelryTitleText");
         }
         else if(_loc2_ == 3)
         {
            this._singleView.setData(this._model.canCpsMaterialList);
            this._equipmentTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.MaterialTitleText");
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._bitmapBg)
         {
            ObjectUtils.disposeObject(this._bitmapBg);
         }
         this._bitmapBg = null;
         if(this._equipmentsColumnBg)
         {
            ObjectUtils.disposeObject(this._equipmentsColumnBg);
         }
         this._equipmentsColumnBg = null;
         if(this._itemsColumnBg)
         {
            ObjectUtils.disposeAllChildren(this._itemsColumnBg);
         }
         this._itemsColumnBg = null;
         if(this._equipmentTitleText)
         {
            ObjectUtils.disposeObject(this._equipmentTitleText);
         }
         this._equipmentTitleText = null;
         if(this._equipmentTipText)
         {
            ObjectUtils.disposeObject(this._equipmentTipText);
         }
         this._equipmentTipText = null;
         if(this._itemTitleText)
         {
            ObjectUtils.disposeObject(this._itemTitleText);
         }
         this._itemTitleText = null;
         if(this._itemTipText)
         {
            ObjectUtils.disposeObject(this._itemTipText);
         }
         this._itemTipText = null;
         if(this.msg_txt)
         {
            ObjectUtils.disposeObject(this.msg_txt);
         }
         this.msg_txt = null;
         if(this._equipmentView)
         {
            ObjectUtils.disposeObject(this._equipmentView);
         }
         this._equipmentView = null;
         if(this._propView)
         {
            ObjectUtils.disposeObject(this._propView);
         }
         this._propView = null;
         if(this._singleView)
         {
            ObjectUtils.disposeObject(this._singleView);
         }
         this._singleView = null;
         if(this._goldView)
         {
            ObjectUtils.disposeObject(this._goldView);
            this._goldView = null;
         }
         if(this._moneyView)
         {
            ObjectUtils.disposeObject(this._moneyView);
            this._moneyView = null;
         }
         if(this._ddtmoneyView)
         {
            ObjectUtils.disposeObject(this._ddtmoneyView);
            this._ddtmoneyView = null;
         }
         if(this._bgShape)
         {
            ObjectUtils.disposeObject(this._bgShape);
         }
         this._bgShape = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
