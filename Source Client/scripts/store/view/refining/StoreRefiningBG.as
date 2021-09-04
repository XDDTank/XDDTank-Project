package store.view.refining
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.interfaces.IDragable;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.BuyItemButton;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import store.HelpFrame;
   import store.IStoreViewBG;
   import store.StoreController;
   import store.StoreDragInArea;
   import store.events.StoreIIEvent;
   
   public class StoreRefiningBG extends Sprite implements IStoreViewBG, IDragable, IAcceptDrag
   {
       
      
      private var _area:StoreDragInArea;
      
      private var _isInJectSelect:SelectedCheckButton;
      
      private var _refining_btn:BaseButton;
      
      private var _refining_cancelBtn:BaseButton;
      
      private var _equipCell:RefiningEquipCell;
      
      private var _itemCell:RefiningItemCell;
      
      private var _progress:RefiningProgress;
      
      private var _goldFilterFrame:FilterFrameText;
      
      private var _goldTxt:FilterFrameText;
      
      private var _goldIcon:Image;
      
      private var _sendTimer:Timer;
      
      private var _numberMC_exp:String;
      
      private var _numberMC_Crit:String;
      
      private var _numberMCI:MovieClip;
      
      private var _numberMCITxt:FilterFrameText;
      
      private var _numberMCII:MovieClip;
      
      private var _numberMCIITxt:FilterFrameText;
      
      private var _lastLevel:int;
      
      private var _buyItemButton:BuyItemButton;
      
      private var _addExpMC:MovieClip;
      
      private var _upgradeMC:MovieClip;
      
      private var _goldAlertFrame:BaseAlerFrame;
      
      private var _refiningLevel:FilterFrameText;
      
      private var _refiningLevelStr:String;
      
      private var _refiningNeedCount:FilterFrameText;
      
      private var _refiningNeedCountStr:String;
      
      private var _quickBuyFrame:QuickBuyFrame;
      
      public function StoreRefiningBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      public function set info(param1:InventoryItemInfo) : void
      {
         this._equipCell.info = param1;
      }
      
      public function startShine() : void
      {
         this._equipCell.startShine();
      }
      
      public function stopShine() : void
      {
         this._equipCell.stopShine();
      }
      
      private function init() : void
      {
         this._isInJectSelect = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIRefining.isInjectSelect");
         this._isInJectSelect.tipStyle = "ddt.view.tips.OneLineTip";
         this._isInJectSelect.tipDirctions = "3,7,6";
         this._isInJectSelect.tipGapV = 4;
         this._isInJectSelect.tipData = LanguageMgr.GetTranslation("store.storeRefiningBG.checkBtnTips");
         this._refining_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIRefiningBG.refiningBtn");
         this._refining_cancelBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIRefiningBG.refiningCancelBtn");
         addChild(this._isInJectSelect);
         addChild(this._refining_btn);
         addChild(this._refining_cancelBtn);
         this._refining_cancelBtn.visible = false;
         this._equipCell = new RefiningEquipCell();
         PositionUtils.setPos(this._equipCell,"ddtstore.refining.equipcell.pos");
         addChild(this._equipCell);
         this._itemCell = new RefiningItemCell();
         PositionUtils.setPos(this._itemCell,"ddtstore.refining.itemcell.pos");
         addChild(this._itemCell);
         var _loc1_:Array = new Array();
         _loc1_.push(this._equipCell);
         this._area = new StoreDragInArea(_loc1_);
         PositionUtils.setPos(this._area,"ddtstore.refining.dragAreaPos");
         addChildAt(this._area,0);
         this._progress = ComponentFactory.Instance.creatComponentByStylename("ddtstore.RefiningProgress");
         this._progress.tipStyle = "ddt.view.tips.OneLineTip";
         this._progress.tipDirctions = "3,7,6";
         this._progress.tipGapV = 4;
         addChild(this._progress);
         this._refiningLevel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreRefiningBG.refiningLevel");
         this._refiningLevelStr = LanguageMgr.GetTranslation("store.storeRefiningBG.refiningLevelText");
         this._refiningLevel.visible = false;
         addChild(this._refiningLevel);
         this._refiningNeedCount = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreRefiningBG.needCount");
         this._refiningNeedCountStr = LanguageMgr.GetTranslation("store.storeRefiningBG.needCount");
         this._refiningNeedCount.visible = false;
         addChild(this._refiningNeedCount);
         this._numberMC_exp = LanguageMgr.GetTranslation("store.storeRefiningBG.numberMCexp");
         this._numberMC_Crit = LanguageMgr.GetTranslation("store.storeRefiningBG.numberMCCrit");
         this._numberMCI = ComponentFactory.Instance.creat("ddtstore.Refining.textUpI") as MovieClip;
         PositionUtils.setPos(this._numberMCI,"ddtstore.refining.textUpI.pos");
         this._numberMCI.addFrameScript(this._numberMCI.totalFrames - 1,this.textIUpComplete);
         this._numberMCI.visible = false;
         this._numberMCI.stop();
         addChild(this._numberMCI);
         this._numberMCITxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.Refining.numberMCI.txt");
         this._numberMCI.text.addChild(this._numberMCITxt);
         this._numberMCII = ComponentFactory.Instance.creat("ddtstore.Refining.textUpII") as MovieClip;
         PositionUtils.setPos(this._numberMCII,"ddtstore.refining.textUpII.pos");
         this._numberMCII.addFrameScript(this._numberMCII.totalFrames - 1,this.textIIUpComplete);
         this._numberMCII.visible = false;
         this._numberMCII.stop();
         addChild(this._numberMCII);
         this._numberMCIITxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.Refining.numberMCII.txt");
         this._numberMCII.text.addChild(this._numberMCIITxt);
         this._goldFilterFrame = ComponentFactory.Instance.creatComponentByStylename("ddtstore.Refining.goldFilterFrame");
         this._goldFilterFrame.text = LanguageMgr.GetTranslation("store.storeRefiningBG.goldTxt");
         addChild(this._goldFilterFrame);
         this._goldTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.Refining.goldTxt");
         this._goldTxt.text = "0";
         addChild(this._goldTxt);
         this._goldIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.GoldIcon");
         PositionUtils.setPos(this._goldIcon,"asset.ddtstore.refiningGoldIconPos");
         addChild(this._goldIcon);
         this._buyItemButton = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreRefiningBG.StoneBuyBtn");
         this._buyItemButton.setup(EquipType.REFINING_STONE,1,true);
         this._buyItemButton.tipData = null;
         this._buyItemButton.tipStyle = null;
         addChild(this._buyItemButton);
         this._addExpMC = ComponentFactory.Instance.creat("ddtstore.StoreRefiningBg.addExpMC") as MovieClip;
         this._addExpMC.mouseEnabled = false;
         this._addExpMC.mouseChildren = false;
         PositionUtils.setPos(this._addExpMC,"ddtstore.refining.addExpMCPos");
         this.addExpMCComplete();
         addChild(this._addExpMC);
         this._upgradeMC = ComponentFactory.Instance.creat("ddtstore.StoreRefiningBg.upgradeMC") as MovieClip;
         this._upgradeMC.mouseEnabled = false;
         this._upgradeMC.mouseChildren = false;
         PositionUtils.setPos(this._upgradeMC,"ddtstore.refining.upgradeMCPos");
         this.upgradeMCComplete();
         addChild(this._upgradeMC);
      }
      
      private function initEvent() : void
      {
         this._equipCell.addEventListener(RefiningEvent.MOVE,this.__moveEquip);
         this._progress.addEventListener(StoreIIEvent.UPGRADES_PLAY,this.__upgradesPlay);
         this._equipCell.addEventListener(Event.CHANGE,this.__itemInfoChange);
         this._itemCell.addEventListener(Event.CHANGE,this.__itemInfoChange);
         this._refining_btn.addEventListener(MouseEvent.CLICK,this.___refiningClick);
         this._refining_cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelClick);
         StoreController.instance.Model.addEventListener(StoreIIEvent.REFINING_REBACK,this.__refiningReback);
         this._isInJectSelect.addEventListener(MouseEvent.CLICK,this.__selectBtnClick);
         this._addExpMC.addFrameScript(this._addExpMC.totalFrames - 1,this.addExpMCComplete);
         this._upgradeMC.addFrameScript(this._upgradeMC.totalFrames - 1,this.upgradeMCComplete);
      }
      
      private function updateProgress(param1:InventoryItemInfo) : void
      {
         if(param1)
         {
            this._progress.setProgress(param1);
         }
      }
      
      private function __moveEquip(param1:RefiningEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.info;
         this.sendMoveItem(_loc2_);
      }
      
      private function __upgradesPlay(param1:Event) : void
      {
      }
      
      private function textIUpComplete() : void
      {
         this._numberMCI.stop();
         this._numberMCI.visible = false;
      }
      
      private function textIIUpComplete() : void
      {
         this._numberMCII.stop();
         this._numberMCII.visible = false;
      }
      
      private function __itemInfoChange(param1:Event) : void
      {
         var _loc2_:InventoryItemInfo = null;
         if(param1.currentTarget is RefiningEquipCell)
         {
            _loc2_ = this._equipCell.info as InventoryItemInfo;
            if(_loc2_ && _loc2_.StrengthenLevel < ItemManager.Instance.getEquipLimitLevel(_loc2_.TemplateID))
            {
               if(this._equipCell.actionState)
               {
                  this._progress.initProgress(_loc2_);
                  this._equipCell.actionState = false;
                  this.addExpMCComplete();
                  this.upgradeMCComplete();
               }
               else
               {
                  this.updateProgress(_loc2_);
                  if(this._lastLevel < this._equipCell.info["StrengthenLevel"])
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.storeRefiningBG.upgrade"));
                     this._upgradeMC.gotoAndPlay(1);
                     this._upgradeMC.visible = true;
                     this._lastLevel = this._equipCell.info["StrengthenLevel"];
                  }
                  else
                  {
                     this._addExpMC.gotoAndPlay(1);
                     this._addExpMC.visible = true;
                  }
               }
               this._goldTxt.text = StoreController.instance.Model.getRefiningConfigByLevel(_loc2_.StrengthenLevel + 1).NeedMoney.toString();
               this._refiningLevel.visible = true;
               this._refiningNeedCount.visible = true;
               this._refiningLevel.text = this._refiningLevelStr + StoreController.instance.Model.getRefiningConfigByLevel(_loc2_.StrengthenLevel).Desc.toString();
               this._refiningNeedCount.text = this._refiningNeedCountStr + StoreController.instance.Model.getRefiningConfigByLevel(_loc2_.StrengthenLevel + 1).NeedSoulCount.toString();
            }
            else
            {
               this._progress.resetProgress();
               this._goldTxt.text = "0";
               this._refiningLevel.visible = false;
               this._refiningNeedCount.visible = false;
            }
         }
      }
      
      private function ___refiningClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this.checkEnable())
         {
            return;
         }
         this._lastLevel = this._equipCell.info["StrengthenLevel"];
         StoreController.instance.sendRefining();
         if(!this._sendTimer && this._isInJectSelect.selected)
         {
            this._sendTimer = new Timer(500);
            this._sendTimer.addEventListener(TimerEvent.TIMER,this.__sendTimerHandle);
            this._sendTimer.start();
            this._isInJectSelect.enable = false;
            this._refining_cancelBtn.visible = true;
            this._refining_btn.visible = false;
         }
      }
      
      private function checkEnable() : Boolean
      {
         var _loc1_:String = "";
         if(this._equipCell.info)
         {
            if(this._itemCell.info)
            {
               if(PlayerManager.Instance.Self.Gold < int(this._goldTxt.text))
               {
                  this._goldAlertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  this._goldAlertFrame.moveEnable = false;
                  this._goldAlertFrame.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
                  return false;
               }
               if(this._equipCell.info["StrengthenLevel"] >= ItemManager.Instance.getEquipLimitLevel(this._equipCell.info.TemplateID))
               {
                  _loc1_ = LanguageMgr.GetTranslation("store.storeRefiningBG.levelLimit");
               }
               else if(this._itemCell.count < StoreController.instance.Model.getRefiningConfigByLevel(InventoryItemInfo(this._equipCell.info).StrengthenLevel + 1).NeedSoulCount)
               {
                  _loc1_ = LanguageMgr.GetTranslation("store.storeRefiningBG.itemNOEnough");
               }
            }
            else
            {
               _loc1_ = LanguageMgr.GetTranslation("store.storeRefiningBG.noitem");
            }
         }
         else
         {
            _loc1_ = LanguageMgr.GetTranslation("store.storeRefiningBG.noequip");
         }
         if(_loc1_ != "")
         {
            MessageTipManager.getInstance().show(_loc1_);
            return false;
         }
         return true;
      }
      
      private function __quickBuyResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._goldAlertFrame.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         this._goldAlertFrame.dispose();
         this._goldAlertFrame = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this._quickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            this._quickBuyFrame.itemID = EquipType.GOLD_BOX;
            this._quickBuyFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(this._quickBuyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __cancelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.stopTimer();
      }
      
      private function __sendTimerHandle(param1:TimerEvent) : void
      {
         if(this._isInJectSelect.selected && this.checkEnable())
         {
            StoreController.instance.sendRefining();
         }
         else
         {
            this.stopTimer();
         }
      }
      
      private function stopTimer() : void
      {
         if(this._sendTimer)
         {
            this._sendTimer.stop();
            this._sendTimer.removeEventListener(TimerEvent.TIMER,this.__sendTimerHandle);
            this._sendTimer = null;
            this._isInJectSelect.enable = true;
            this._refining_cancelBtn.visible = false;
            this._refining_btn.visible = true;
         }
      }
      
      private function __refiningReback(param1:StoreIIEvent) : void
      {
         var _loc2_:Object = param1.data;
         if(_loc2_["isCrit"])
         {
            this._numberMCII.visible = true;
            this._numberMCIITxt.htmlText = this._numberMC_Crit + _loc2_["exp"];
            this._numberMCII.gotoAndPlay(1);
         }
         else
         {
            this._numberMCI.visible = true;
            this._numberMCITxt.text = this._numberMC_exp + _loc2_["exp"];
            this._numberMCI.gotoAndPlay(1);
         }
      }
      
      private function addExpMCComplete() : void
      {
         this._addExpMC.gotoAndStop(1);
         this._addExpMC.visible = false;
      }
      
      private function upgradeMCComplete() : void
      {
         this._upgradeMC.gotoAndStop(1);
         this._upgradeMC.visible = false;
      }
      
      private function __selectBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
      }
      
      private function sendMoveItem(param1:InventoryItemInfo) : void
      {
         if(!param1)
         {
            return;
         }
         if(ItemManager.Instance.judgeJewelry(param1))
         {
            if(param1.getRemainDate() < 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
            }
            else if(this._sendTimer && this._sendTimer.running)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.storeRefiningBG.doing"));
            }
            else if(param1.StrengthenLevel >= ItemManager.Instance.getEquipLimitLevel(param1.TemplateID))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.storeRefiningBG.levelLimit"));
            }
            else if(param1.CanEquip)
            {
               SocketManager.Instance.out.sendMoveGoods(param1.BagType,param1.Place,BagInfo.STOREBAG,1,1);
               this._equipCell.actionState = true;
            }
         }
      }
      
      public function hide() : void
      {
         this.visible = false;
         this.stopTimer();
         this.textIUpComplete();
      }
      
      public function setCell(param1:BagCell) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!param1)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.info as InventoryItemInfo;
         if(_loc2_.StrengthenLevel >= ItemManager.Instance.getEquipLimitLevel(_loc2_.TemplateID))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.storeRefiningBG.levelLimit"));
            return;
         }
         this.sendMoveItem(_loc2_);
      }
      
      public function show() : void
      {
         this.visible = true;
         this.refreshData(null);
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1)
         {
            _loc3_ = int(_loc2_);
            if(_loc3_ == 1)
            {
               this.info = PlayerManager.Instance.Self.StoreBag.items[_loc3_];
            }
         }
         if(!param1)
         {
            this.info = null;
         }
         this._itemCell.info = this._itemCell.info;
      }
      
      public function updateData() : void
      {
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
      }
      
      public function dragStop(param1:DragEffect) : void
      {
      }
      
      public function openHelp() : void
      {
         var _loc1_:DisplayObject = ComponentFactory.Instance.creat("ddtstore.RefiningHelpPrompt");
         var _loc2_:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         _loc2_.setView(_loc1_);
         _loc2_.titleText = LanguageMgr.GetTranslation("store.StoreRefiningBG.say");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      private function removeEvent() : void
      {
         this._equipCell.removeEventListener(RefiningEvent.MOVE,this.__moveEquip);
         this._progress.removeEventListener(StoreIIEvent.UPGRADES_PLAY,this.__upgradesPlay);
         this._equipCell.removeEventListener(Event.CHANGE,this.__itemInfoChange);
         this._itemCell.removeEventListener(Event.CHANGE,this.__itemInfoChange);
         this._refining_btn.removeEventListener(MouseEvent.CLICK,this.___refiningClick);
         this._refining_cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelClick);
         StoreController.instance.Model.removeEventListener(StoreIIEvent.REFINING_REBACK,this.__refiningReback);
         this._isInJectSelect.removeEventListener(MouseEvent.CLICK,this.__selectBtnClick);
         this._addExpMC.addFrameScript(this._addExpMC.totalFrames - 1,null);
         this._upgradeMC.addFrameScript(this._upgradeMC.totalFrames - 1,null);
         this._numberMCI.addFrameScript(this._numberMCI.totalFrames - 1,null);
         this._numberMCII.addFrameScript(this._numberMCII.totalFrames - 1,null);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.stopTimer();
         ObjectUtils.disposeObject(this._refiningLevel);
         this._refiningLevel = null;
         ObjectUtils.disposeObject(this._refiningNeedCount);
         this._refiningNeedCount = null;
         ObjectUtils.disposeObject(this._isInJectSelect);
         this._isInJectSelect = null;
         ObjectUtils.disposeObject(this._refining_btn);
         this._refining_btn = null;
         ObjectUtils.disposeObject(this._refining_cancelBtn);
         this._refining_cancelBtn = null;
         ObjectUtils.disposeObject(this._equipCell);
         this._equipCell = null;
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         ObjectUtils.disposeObject(this._numberMCI);
         this._numberMCI = null;
         ObjectUtils.disposeObject(this._numberMCII);
         this._numberMCII = null;
         ObjectUtils.disposeObject(this._numberMCIITxt);
         this._numberMCIITxt = null;
         ObjectUtils.disposeObject(this._numberMCITxt);
         this._numberMCITxt = null;
         ObjectUtils.disposeObject(this._buyItemButton);
         this._buyItemButton = null;
         ObjectUtils.disposeObject(this._addExpMC);
         this._addExpMC = null;
         ObjectUtils.disposeObject(this._upgradeMC);
         this._upgradeMC = null;
         ObjectUtils.disposeObject(this._area);
         this._area = null;
         ObjectUtils.disposeObject(this._goldFilterFrame);
         this._goldFilterFrame = null;
         ObjectUtils.disposeObject(this._goldTxt);
         this._goldTxt = null;
         ObjectUtils.disposeObject(this._goldIcon);
         this._goldIcon = null;
         ObjectUtils.disposeObject(this._goldAlertFrame);
         this._goldAlertFrame = null;
         ObjectUtils.disposeObject(this._quickBuyFrame);
         this._quickBuyFrame = null;
      }
   }
}
