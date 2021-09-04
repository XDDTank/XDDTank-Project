package store
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import store.events.ChoosePanelEvnet;
   import store.events.StoreIIEvent;
   import store.view.Compose.StoreIIComposeBG;
   import store.view.embed.StoreEmbedBG;
   import store.view.refining.StoreRefiningBG;
   import store.view.strength.StoreIIStrengthBG;
   import store.view.transfer.StoreIITransferBG;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class StoreMainView extends Sprite implements Disposeable
   {
      
      public static const STRENGTH:int = 0;
      
      public static const COMPOSE:int = 1;
      
      public static const TRANSF:int = 2;
      
      public static const EMBED:int = 3;
      
      public static const REFINING:int = 4;
      
      public static const SPLITE:int = 5;
      
      public static const LIANGHUA:int = 6;
       
      
      private var _tabLine:ScaleBitmapImage;
      
      private var _composePanel:StoreIIComposeBG;
      
      private var _strengthPanel:StoreIIStrengthBG;
      
      private var _embedPanel:StoreEmbedBG;
      
      private var _transferPanel:StoreIITransferBG;
      
      private var _refiningPanel:StoreRefiningBG;
      
      private var _currentPanelIndex:int;
      
      private var _tabSelectedButtonContainer:HBox;
      
      private var _tabSelectedButtonGroup:SelectedButtonGroup;
      
      private var strength_btn:SelectedButton;
      
      private var compose_btn:SelectedButton;
      
      private var split_btn:SelectedButton;
      
      private var embed_btn:SelectedButton;
      
      private var transf_Btn:SelectedButton;
      
      private var refining_btn:SelectedButton;
      
      private var bg:ScaleFrameImage;
      
      private var _disEnabledFilters:Array;
      
      public function StoreMainView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._tabLine = ComponentFactory.Instance.creatComponentByStylename("core.ddtStore.tabLine");
         addChild(this._tabLine);
         this._tabSelectedButtonGroup = new SelectedButtonGroup();
         this._tabSelectedButtonContainer = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.TabSelectedBtnContainer");
         this.bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.MainViewBg");
         addChild(this.bg);
         this.strength_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.StrengthenTabBtn");
         this._tabSelectedButtonContainer.addChild(this.strength_btn);
         this._tabSelectedButtonGroup.addSelectItem(this.strength_btn);
         this.split_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.SplitTabBtn");
         this.compose_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.ComposeTabBtn");
         this._tabSelectedButtonContainer.addChild(this.compose_btn);
         this._tabSelectedButtonGroup.addSelectItem(this.compose_btn);
         this.transf_Btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.TransferTabBtn");
         this._tabSelectedButtonContainer.addChild(this.transf_Btn);
         this._tabSelectedButtonGroup.addSelectItem(this.transf_Btn);
         if(!this._disEnabledFilters)
         {
            this._disEnabledFilters = [ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ButtonDisenable")];
         }
         this.embed_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.EmbedTabBtn");
         this.embed_btn.enable = true;
         if(!SavePointManager.Instance.savePoints[54])
         {
            this.compose_btn.enable = false;
            this.compose_btn.filters = this._disEnabledFilters;
         }
         if(!SavePointManager.Instance.savePoints[26])
         {
            this.transf_Btn.enable = false;
            this.transf_Btn.filters = this._disEnabledFilters;
         }
         if(PlayerManager.Instance.Self.Grade < int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.RUNE_OPEN_LEVEL).Value))
         {
            this.embed_btn.enable = false;
            this.embed_btn.filters = this._disEnabledFilters;
         }
         this._tabSelectedButtonContainer.addChild(this.embed_btn);
         this._tabSelectedButtonGroup.addSelectItem(this.embed_btn);
         this.refining_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame.RefiningTabBtn");
         this._tabSelectedButtonContainer.addChild(this.refining_btn);
         this._tabSelectedButtonGroup.addSelectItem(this.refining_btn);
         if(PlayerManager.Instance.Self.Grade < 25)
         {
            this.refining_btn.enable = false;
            this.refining_btn.filters = this._disEnabledFilters;
         }
         this._tabSelectedButtonGroup.selectIndex = 0;
         addChild(this._tabSelectedButtonContainer);
         this._strengthPanel = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBGView");
         this._composePanel = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIICompose");
         this._transferPanel = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIITransfer");
         this._embedPanel = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIEmbedBGView");
         this._refiningPanel = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIRefiningBGView");
         addChild(this._strengthPanel);
         this._strengthPanel.show();
         this._currentPanelIndex = STRENGTH;
         addChild(this._composePanel);
         addChild(this._transferPanel);
         addChild(this._embedPanel);
         addChild(this._refiningPanel);
         this.bg.setFrame(1);
         this._tabSelectedButtonContainer.arrange();
         this.showGuilde();
      }
      
      public function changeToConsortiaState() : void
      {
      }
      
      public function changeToBaseState() : void
      {
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         this._tabSelectedButtonGroup.addEventListener(Event.CHANGE,this.__groupChangeHandler);
         this.strength_btn.addEventListener(MouseEvent.CLICK,this.__strengthClick);
         this.compose_btn.addEventListener(MouseEvent.CLICK,this.__composeClick);
         this.split_btn.addEventListener(MouseEvent.CLICK,this.__splitClick);
         this.embed_btn.addEventListener(MouseEvent.CLICK,this.__embedBtnClick);
         this.transf_Btn.addEventListener(MouseEvent.CLICK,this.__transferClick);
         this.refining_btn.addEventListener(MouseEvent.CLICK,this.__refiningClick);
         this._strengthPanel.addEventListener(StoreIIEvent.WEAPON_READY,this.__weaponReady);
         this._strengthPanel.addEventListener(StoreIIEvent.WEAPON_REMOVE,this.__weaponRemove);
      }
      
      protected function __groupChangeHandler(param1:Event) : void
      {
         this._tabSelectedButtonContainer.arrange();
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         this.strength_btn.removeEventListener(MouseEvent.CLICK,this.__strengthClick);
         this.compose_btn.removeEventListener(MouseEvent.CLICK,this.__composeClick);
         this.split_btn.removeEventListener(MouseEvent.CLICK,this.__splitClick);
         this.embed_btn.removeEventListener(MouseEvent.CLICK,this.__embedBtnClick);
         this.transf_Btn.addEventListener(MouseEvent.CLICK,this.__transferClick);
         this._strengthPanel.removeEventListener(StoreIIEvent.WEAPON_READY,this.__weaponReady);
         this._strengthPanel.removeEventListener(StoreIIEvent.WEAPON_REMOVE,this.__weaponRemove);
      }
      
      private function showGuilde() : void
      {
         if(SavePointManager.Instance.isInSavePoint(26) && !TaskManager.instance.isNewHandTaskCompleted(23))
         {
            NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON,180,"trainer.composeArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
         if(SavePointManager.Instance.isInSavePoint(67) && !TaskManager.instance.isNewHandTaskCompleted(28))
         {
            NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON,180,"trainer.transArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
      }
      
      private function __weaponReady(param1:StoreIIEvent) : void
      {
         StoreController.instance.Model.weaponReady = true;
         this.checkStrengthReady();
      }
      
      private function __weaponRemove(param1:StoreIIEvent) : void
      {
         StoreController.instance.Model.weaponReady = false;
         this.checkStrengthReady();
      }
      
      private function checkStrengthReady() : void
      {
         if(SavePointManager.Instance.isInSavePoint(9) && !TaskManager.instance.isNewHandTaskCompleted(7) || SavePointManager.Instance.isInSavePoint(16) && !TaskManager.instance.isNewHandTaskCompleted(12))
         {
            if(StoreController.instance.Model.weaponReady)
            {
               dispatchEvent(new StoreIIEvent(StoreIIEvent.WEAPON_READY));
               NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON,0,"trainer.strengSureArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            }
            else
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
               NewHandContainer.Instance.clearArrowByID(ArrowType.STRENG_CHOOSE_WEAPON);
               dispatchEvent(new StoreIIEvent(StoreIIEvent.WEAPON_REMOVE));
            }
         }
      }
      
      private function __updateStoreBag(param1:BagEvent) : void
      {
         this.currentPanel.refreshData(param1.changedSlots);
      }
      
      public function set currentPanelIndex(param1:int) : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.STRENG_CHOOSE_WEAPON);
         NewHandContainer.Instance.clearArrowByID(ArrowType.TRANSFER_CHOOSE_WEAPON);
         this._currentPanelIndex = param1;
         dispatchEvent(new ChoosePanelEvnet(this._currentPanelIndex));
      }
      
      public function get currentPanelIndex() : int
      {
         return this._currentPanelIndex;
      }
      
      public function get currentPanel() : IStoreViewBG
      {
         switch(this.currentPanelIndex)
         {
            case STRENGTH:
               return this._strengthPanel;
            case COMPOSE:
               return this._composePanel;
            case TRANSF:
               return this._transferPanel;
            case EMBED:
               return this._embedPanel;
            case REFINING:
               return this._refiningPanel;
            default:
               return null;
         }
      }
      
      public function openHelp() : void
      {
         this.currentPanel.openHelp();
      }
      
      public function get StrengthPanel() : StoreIIStrengthBG
      {
         return this._strengthPanel;
      }
      
      private function __strengthClick(param1:MouseEvent) : void
      {
         if(this.currentPanelIndex == STRENGTH)
         {
            return;
         }
         this.currentPanelIndex = STRENGTH;
         if(param1 == null)
         {
            this.changeToTab(this.currentPanelIndex,false);
         }
         else
         {
            this.changeToTab(this.currentPanelIndex);
         }
      }
      
      private function __composeClick(param1:MouseEvent) : void
      {
         if(this.currentPanelIndex == COMPOSE)
         {
            return;
         }
         this.currentPanelIndex = COMPOSE;
         SocketManager.Instance.out.sendToGetComposeSkill();
         this.changeToTab(this.currentPanelIndex);
         if(SavePointManager.Instance.isInSavePoint(26) && !TaskManager.instance.isNewHandTaskCompleted(23))
         {
            NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON,180,"trainer.composeChooseWeaponArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
      }
      
      private function __splitClick(param1:MouseEvent) : void
      {
         if(this.currentPanelIndex == SPLITE)
         {
            return;
         }
         this.currentPanelIndex = SPLITE;
         this.changeToTab(this.currentPanelIndex);
      }
      
      private function __lianhuaClick(param1:MouseEvent) : void
      {
      }
      
      private function __embedBtnClick(param1:MouseEvent) : void
      {
         if(this.currentPanelIndex == EMBED)
         {
            return;
         }
         this.currentPanelIndex = EMBED;
         this.changeToTab(this.currentPanelIndex);
         dispatchEvent(new StoreIIEvent(StoreIIEvent.EMBED_CLICK));
      }
      
      private function __transferClick(param1:MouseEvent) : void
      {
         if(this.currentPanelIndex == TRANSF)
         {
            return;
         }
         this.currentPanelIndex = TRANSF;
         this.changeToTab(this.currentPanelIndex);
      }
      
      private function __refiningClick(param1:MouseEvent) : void
      {
         if(this.currentPanelIndex == REFINING)
         {
            return;
         }
         this.currentPanelIndex = REFINING;
         this.changeToTab(this.currentPanelIndex);
      }
      
      private function changeToTab(param1:int, param2:Boolean = true) : void
      {
         SocketManager.Instance.out.sendClearStoreBag();
         SoundManager.instance.play("008");
         this._composePanel.hide();
         this._strengthPanel.hide();
         this._transferPanel.hide();
         this._embedPanel.hide();
         this._refiningPanel.hide();
         if(this.currentPanel)
         {
            this.currentPanel.show();
         }
         this.bg.setFrame(param1 + 1);
      }
      
      private function sortBtn() : void
      {
         addChild(this.transf_Btn);
         addChild(this.compose_btn);
         addChild(this.embed_btn);
         addChild(this.strength_btn);
      }
      
      private function embedInfoChangeHandler(param1:StoreIIEvent) : void
      {
         dispatchEvent(new StoreIIEvent(StoreIIEvent.EMBED_INFORCHANGE));
      }
      
      public function changeTabByIndex(param1:int) : void
      {
         var _loc2_:MouseEvent = new MouseEvent(MouseEvent.CLICK);
         switch(param1)
         {
            case STRENGTH:
               this.__strengthClick(_loc2_);
               break;
            case COMPOSE:
               this.__composeClick(_loc2_);
               break;
            case TRANSF:
               this.__transferClick(_loc2_);
               break;
            case EMBED:
               this.__embedBtnClick(_loc2_);
               break;
            case REFINING:
               this.__refiningClick(_loc2_);
         }
         this._tabSelectedButtonGroup.selectIndex = param1;
      }
      
      public function dispose() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
         NewHandContainer.Instance.clearArrowByID(ArrowType.TRANSFER_CHOOSE_WEAPON);
         NewHandContainer.Instance.clearArrowByID(ArrowType.STRENG_CHOOSE_WEAPON);
         this.removeEvents();
         if(this._tabLine)
         {
            ObjectUtils.disposeObject(this._tabLine);
         }
         this._tabLine = null;
         if(this._composePanel)
         {
            ObjectUtils.disposeObject(this._composePanel);
         }
         this._composePanel = null;
         if(this._strengthPanel)
         {
            ObjectUtils.disposeObject(this._strengthPanel);
         }
         this._strengthPanel = null;
         if(this._transferPanel)
         {
            ObjectUtils.disposeObject(this._transferPanel);
         }
         this._transferPanel = null;
         if(this._embedPanel)
         {
            ObjectUtils.disposeObject(this._embedPanel);
         }
         this._embedPanel = null;
         if(this._refiningPanel)
         {
            ObjectUtils.disposeObject(this._refiningPanel);
         }
         this._refiningPanel = null;
         if(this.bg)
         {
            ObjectUtils.disposeObject(this.bg);
         }
         this.bg = null;
         if(this._tabSelectedButtonContainer)
         {
            this._tabSelectedButtonContainer.dispose();
            this._tabSelectedButtonContainer = null;
         }
         if(this._tabSelectedButtonGroup)
         {
            ObjectUtils.disposeObject(this._tabSelectedButtonGroup);
         }
         this._tabSelectedButtonGroup = null;
         if(this.strength_btn)
         {
            ObjectUtils.disposeObject(this.strength_btn);
         }
         this.strength_btn = null;
         if(this.transf_Btn)
         {
            ObjectUtils.disposeObject(this.transf_Btn);
         }
         this.transf_Btn = null;
         if(this.compose_btn)
         {
            ObjectUtils.disposeObject(this.compose_btn);
         }
         this.compose_btn = null;
         if(this.embed_btn)
         {
            ObjectUtils.disposeObject(this.embed_btn);
         }
         this.embed_btn = null;
         if(this.split_btn)
         {
            ObjectUtils.disposeObject(this.split_btn);
         }
         this.split_btn = null;
         SocketManager.Instance.out.sendClearStoreBag();
         SocketManager.Instance.out.sendSaveDB();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
