package store.view.strength
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.StoneType;
   import ddt.data.VipConfigInfo;
   import ddt.data.goods.EquipStrengthInfo;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.manager.VipPrivilegeConfigManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.BuyItemButton;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import store.HelpFrame;
   import store.IStoreViewBG;
   import store.ShowSuccessExp;
   import store.StoneCell;
   import store.StoreCell;
   import store.StoreDragInArea;
   import store.data.StoreEquipExperience;
   import store.events.StoreIIEvent;
   import store.view.ConsortiaRateManager;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class StoreIIStrengthBG extends Sprite implements IStoreViewBG
   {
       
      
      private var _area:StoreDragInArea;
      
      private var _items:Array;
      
      private var _strength_btn:BaseButton;
      
      private var _strength_btn_shineEffect:IEffect;
      
      private var _bg:MutipleImage;
      
      private var _pointArray:Vector.<Point>;
      
      private var _strthShine:MovieImage;
      
      private var _startStrthTip:MutipleImage;
      
      private var _consortiaSmith:MySmithLevel;
      
      private var _strengthenEquipmentCellText:FilterFrameText;
      
      private var _isInjectSelect:SelectedCheckButton;
      
      private var _progressLevel:StoreStrengthProgress;
      
      private var _lastStrengthTime:int = 0;
      
      private var _showSuccessExp:ShowSuccessExp;
      
      private var _starMovie:MovieClip;
      
      private var _weaponUpgrades:MovieClip;
      
      private var _weaponUpgradesI:MovieClip;
      
      private var _sBuyStrengthStoneCell:BuyItemButton;
      
      private var _vipDiscountTxt:FilterFrameText;
      
      private var _vipDiscountBg:Image;
      
      private var _vipDiscountIcon:Image;
      
      private var _neededGoldTipText:FilterFrameText;
      
      private var _gold_txt:FilterFrameText;
      
      private var _goldIcon:Image;
      
      private var _strengthLevel:FilterFrameText;
      
      private var _strengthLevelStr:String;
      
      private var _aler:StrengthSelectNumAlertFrame;
      
      private var _goldAlertFrame:BaseAlerFrame;
      
      private var _quickBuyFrame:QuickBuyFrame;
      
      public function StoreIIStrengthBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var _loc7_:StoreCell = null;
         var _loc1_:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(2);
         this._vipDiscountBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.VipDiscountBg");
         this._vipDiscountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.VipDiscountTxt");
         this._vipDiscountTxt.text = LanguageMgr.GetTranslation("store.Strength.VipDiscountDesc");
         this._vipDiscountIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.VipDiscountIcon");
         addChild(this._vipDiscountBg);
         addChild(this._vipDiscountIcon);
         addChild(this._vipDiscountTxt);
         this._strengthenEquipmentCellText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.StrengthenEquipmentCellText");
         this._strengthenEquipmentCellText.text = LanguageMgr.GetTranslation("store.Strength.StrengthenCurrentEquipmentCellText");
         PositionUtils.setPos(this._strengthenEquipmentCellText,"ddtstore.StoreIIStrengthBG.StrengthenEquipmentCellTextPos");
         addChild(this._strengthenEquipmentCellText);
         this._items = new Array();
         this._area = new StoreDragInArea(this._items);
         addChildAt(this._area,0);
         this._neededGoldTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.NeededGoldTipText");
         this._neededGoldTipText.text = LanguageMgr.GetTranslation("store.Transfer.NeededGoldTipText");
         addChild(this._neededGoldTipText);
         this._gold_txt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITarnsferBG.NeedMoneyText");
         addChild(this._gold_txt);
         this._goldIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.GoldIcon");
         addChild(this._goldIcon);
         PositionUtils.setPos(this._neededGoldTipText,"asset.ddtstore.strengthMoneyPos1");
         PositionUtils.setPos(this._gold_txt,"asset.ddtstore.strengthMoneyPos2");
         PositionUtils.setPos(this._goldIcon,"asset.ddtstore.strengthMoneyPos3");
         this._strength_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.StrengthenBtn");
         addChild(this._strength_btn);
         this._strength_btn_shineEffect = EffectManager.Instance.creatEffect(EffectTypes.Linear_SHINER_ANIMATION,this._strength_btn,{"color":EffectColorType.GOLD});
         this._startStrthTip = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.ArrowHeadTip");
         addChild(this._startStrthTip);
         this._isInjectSelect = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrength.isInjectSelect");
         addChild(this._isInjectSelect);
         this._isInjectSelect.selected = true;
         this._strengthLevel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.strengthLevel");
         this._strengthLevelStr = LanguageMgr.GetTranslation("store.StoreIIComposeBG.strengthLevelText");
         this._strengthLevel.visible = false;
         addChild(this._strengthLevel);
         if(!this._weaponUpgradesI)
         {
            this._weaponUpgradesI = ClassUtils.CreatInstance("asset.strength.weaponUpgradesI");
         }
         PositionUtils.setPos(this._weaponUpgradesI,"ddtstore.StoreIIStrengthBG.weaponUpgradesPointI");
         addChild(this._weaponUpgradesI);
         this._weaponUpgradesI.visible = false;
         this._weaponUpgradesI.stop();
         this._progressLevel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreStrengthProgress");
         this._progressLevel.tipStyle = "ddt.view.tips.OneLineTip";
         this._progressLevel.tipDirctions = "3,7,6";
         this._progressLevel.tipGapV = 4;
         addChild(this._progressLevel);
         this._progressLevel.addEventListener(StoreIIEvent.UPGRADES_PLAY,this.weaponUpgradesPlay);
         this.getCellsPoint();
         var _loc2_:int = 0;
         while(_loc2_ < this._pointArray.length)
         {
            switch(_loc2_)
            {
               case 0:
                  _loc7_ = new StrengthStone([StoneType.STRENGTH,StoneType.STRENGTH_1],_loc2_);
                  break;
               case 1:
                  _loc7_ = new StreangthItemCell(_loc2_);
                  break;
            }
            _loc7_.addEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[_loc2_] = _loc7_;
            _loc7_.x = this._pointArray[_loc2_].x;
            _loc7_.y = this._pointArray[_loc2_].y;
            addChild(_loc7_);
            _loc2_++;
         }
         this._sBuyStrengthStoneCell = ComponentFactory.Instance.creat("ddtstore.StoreIIStrengthBG.StoneBuyBtn");
         this._sBuyStrengthStoneCell.setup(EquipType.STRENGTH_STONE_NEW,1,true);
         this._sBuyStrengthStoneCell.tipData = null;
         this._sBuyStrengthStoneCell.tipStyle = null;
         addChild(this._sBuyStrengthStoneCell);
         this.hide();
         this.hideArr();
         this._showSuccessExp = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBG.ShowSuccessExp");
         this._showSuccessExp.showVIPRate();
         var _loc3_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.StrengthenStonStripExp");
         var _loc4_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.ConsortiaAddStripExp");
         var _loc5_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.VIPAddStripExp");
         var _loc6_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.AllNumStrip");
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            _loc4_ = LanguageMgr.GetTranslation("tank.view.store.consortiaRateI");
         }
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            _loc5_ = LanguageMgr.GetTranslation("store.StoreIIComposeBG.NoVIPAddStrip");
         }
         this._showSuccessExp.showAllTips(_loc3_,_loc4_,_loc6_);
         this._showSuccessExp.showVIPTip(_loc5_);
         addChild(this._showSuccessExp);
      }
      
      private function initEvent() : void
      {
         this._isInjectSelect.addEventListener(MouseEvent.CLICK,this.__isInjectSelectClick);
         this._strength_btn.addEventListener(MouseEvent.CLICK,this.__strengthClick);
      }
      
      private function removeEvents() : void
      {
         this._isInjectSelect.removeEventListener(MouseEvent.CLICK,this.__isInjectSelectClick);
         this._strength_btn.removeEventListener(MouseEvent.CLICK,this.__strengthClick);
         this._items[0].removeEventListener(Event.CHANGE,this.__itemInfoChange);
         this._items[1].removeEventListener(Event.CHANGE,this.__itemInfoChange);
         this._progressLevel.removeEventListener(StoreIIEvent.UPGRADES_PLAY,this.weaponUpgradesPlay);
      }
      
      private function userGuide() : void
      {
      }
      
      private function exeStoneTip() : Boolean
      {
         return this._items[0].info;
      }
      
      private function finStoneTip() : void
      {
         this.disposeUserGuide();
      }
      
      private function disposeUserGuide() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
      }
      
      private function getCellsPoint() : void
      {
         this._pointArray = new Vector.<Point>();
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBG.Strengthpoint0");
         this._pointArray.push(_loc1_);
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBG.Strengthpoint1");
         this._pointArray.push(_loc2_);
      }
      
      public function get isAutoStrength() : Boolean
      {
         return this._isInjectSelect.selected;
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      public function get area() : Array
      {
         return this._items;
      }
      
      private function updateProgress(param1:InventoryItemInfo) : void
      {
         if(param1)
         {
            if(StoreEquipExperience.expericence)
            {
               this._progressLevel.setProgress(param1);
            }
         }
      }
      
      private function isAdaptToItem(param1:InventoryItemInfo) : Boolean
      {
         if(this._items[1].info == null)
         {
            return true;
         }
         if(this._items[1].info.RefineryLevel > 0)
         {
            if(param1.Property1 == "35")
            {
               return true;
            }
            return false;
         }
         if(param1.Property1 == "35")
         {
            return false;
         }
         return true;
      }
      
      private function isAdaptToStone(param1:InventoryItemInfo) : Boolean
      {
         if(this._items[0].info != null && this._items[0].info.Property1 != param1.Property1)
         {
            return false;
         }
         return true;
      }
      
      private function itemIsAdaptToStone(param1:InventoryItemInfo) : Boolean
      {
         if(param1.RefineryLevel > 0)
         {
            if(this._items[0].info != null && this._items[0].info.Property1 != "35")
            {
               return false;
            }
            return true;
         }
         if(this._items[0].info != null && this._items[0].info.Property1 == "35")
         {
            return false;
         }
         return true;
      }
      
      private function showNumAlert(param1:InventoryItemInfo, param2:int) : void
      {
         this._aler = ComponentFactory.Instance.creat("ddtstore.StrengthSelectNumAlertFrame");
         this._aler.addExeFunction(this.sellFunction,this.notSellFunction);
         this._aler.goodsinfo = param1;
         this._aler.index = param2;
         this._aler.show(param1.Count);
      }
      
      private function sellFunction(param1:int, param2:InventoryItemInfo, param3:int) : void
      {
         SocketManager.Instance.out.sendMoveGoods(param2.BagType,param2.Place,BagInfo.STOREBAG,param3,param1,true);
         if(this._aler)
         {
            this._aler.dispose();
         }
         if(this._aler && this._aler.parent)
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      private function notSellFunction() : void
      {
         if(this._aler)
         {
            this._aler.dispose();
         }
         if(this._aler && this._aler.parent)
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      public function setCell(param1:BagCell) : void
      {
         var _loc3_:StoreCell = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.info as InventoryItemInfo;
         for each(_loc3_ in this._items)
         {
            if(_loc3_.info == _loc2_)
            {
               _loc3_.info = null;
               param1.locked = false;
               return;
            }
         }
         for each(_loc3_ in this._items)
         {
            if(_loc3_)
            {
               if(_loc3_ is StoneCell)
               {
                  if(_loc3_.info == null)
                  {
                     if((_loc3_ as StoneCell).types.indexOf(_loc2_.Property1) > -1 && _loc2_.CategoryID == 11)
                     {
                        if(this.isAdaptToStone(_loc2_))
                        {
                           if(_loc2_.Count == 1)
                           {
                              SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,1,true);
                           }
                           else
                           {
                              this.showNumAlert(_loc2_,_loc3_.index);
                           }
                           return;
                        }
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
                     }
                  }
               }
               else if(_loc3_ is StreangthItemCell)
               {
                  if(_loc2_.getRemainDate() <= 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                  }
                  else
                  {
                     if(param1.info.CanStrengthen && _loc2_.StrengthenLevel >= ItemManager.Instance.getEquipLimitLevel(_loc2_.TemplateID))
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
                        return;
                     }
                     if(param1.info.CanStrengthen)
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,1);
                        StreangthItemCell(this._items[1]).actionState = true;
                        return;
                     }
                  }
               }
            }
         }
         if(EquipType.isStrengthStone(_loc2_))
         {
            for each(_loc3_ in this._items)
            {
               if(_loc3_ is StoneCell && (_loc3_ as StoneCell).types.indexOf(_loc2_.Property1) > -1 && _loc2_.CategoryID == 11)
               {
                  if(this.isAdaptToStone(_loc2_))
                  {
                     if(_loc2_.Count == 1)
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,1,true);
                     }
                     else
                     {
                        this.showNumAlert(_loc2_,_loc3_.index);
                     }
                     return;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
               }
            }
         }
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function showArr() : void
      {
         this._startStrthTip.visible = true;
         this._strength_btn_shineEffect.play();
      }
      
      private function hideArr() : void
      {
         this._startStrthTip.visible = false;
         this._strength_btn_shineEffect.stop();
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1)
         {
            _loc3_ = int(_loc2_);
            if(this._items.hasOwnProperty(_loc3_))
            {
               this._items[_loc3_].info = PlayerManager.Instance.Self.StoreBag.items[_loc3_];
            }
         }
      }
      
      public function updateData() : void
      {
         if(PlayerManager.Instance.Self.StoreBag.items[1])
         {
            if(this._items[1].info.ItemID != PlayerManager.Instance.Self.StoreBag.items[1].ItemID || this._items[1].info.StrengthenExp != PlayerManager.Instance.Self.StoreBag.items[1].StrengthenExp || this._items[1].info.StrengthenLevel != PlayerManager.Instance.Self.StoreBag.items[1].StrengthenLevel)
            {
               this._items[1].info = PlayerManager.Instance.Self.StoreBag.items[1];
            }
         }
         else
         {
            this._items[1].info = null;
         }
         var _loc1_:InventoryItemInfo = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(EquipType.STRENGTH_STONE_NEW)[0];
         if(_loc1_)
         {
            this._items[0].info = _loc1_;
            this._items[0].setCount(PlayerManager.Instance.Self.findItemCount(EquipType.STRENGTH_STONE_NEW));
         }
         else
         {
            this._items[0].info = null;
         }
      }
      
      public function startShine(param1:int) : void
      {
         if(param1 < 2)
         {
            this._items[param1].startShine();
         }
      }
      
      public function stopShine() : void
      {
         this._items[0].stopShine();
         this._items[1].stopShine();
      }
      
      public function show() : void
      {
         this.visible = true;
         this.updateData();
         this.userGuide();
      }
      
      public function hide() : void
      {
         this.visible = false;
         this.disposeUserGuide();
      }
      
      private function __isInjectSelectClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.updateGoldText();
      }
      
      private function updateGoldText() : void
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:EquipmentTemplateInfo = null;
         var _loc3_:EquipStrengthInfo = null;
         var _loc4_:VipConfigInfo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(StreangthItemCell(this._items[1]).info && StrengthStone(this._items[0]).info)
         {
            _loc1_ = StreangthItemCell(this._items[1]).info as InventoryItemInfo;
            _loc2_ = ItemManager.Instance.getEquipTemplateById(_loc1_.TemplateID);
            if(_loc1_.StrengthenLevel == _loc2_.StrengthLimit)
            {
               this._gold_txt.text = "0";
               return;
            }
            _loc3_ = ItemManager.Instance.getEquipStrengthInfoByLevel(_loc1_.StrengthenLevel + 1,_loc2_.QualityID);
            _loc4_ = VipPrivilegeConfigManager.Instance.getById(2);
            _loc5_ = int(StrengthStone(this._items[0]).info.Property2);
            if(PlayerManager.Instance.Self.IsVIP)
            {
               _loc6_ = _loc5_ * _loc4_["Level" + PlayerManager.Instance.Self.VIPLevel] / 100;
            }
            if(PlayerManager.Instance.Self.IsVIP)
            {
               _loc7_ = _loc5_ + _loc6_;
            }
            else
            {
               _loc7_ = _loc5_;
            }
            _loc8_ = (_loc3_.Exp - _loc1_.StrengthenExp) / _loc7_;
            if((_loc3_.Exp - _loc1_.StrengthenExp) % _loc7_ > 0)
            {
               _loc8_ += 1;
            }
            _loc9_ = 100;
            if(this._isInjectSelect.selected && this._items[0].info)
            {
               if(_loc8_ < StrengthStone(this._items[0]).itemInfo.Count)
               {
                  this._gold_txt.text = (_loc9_ * _loc8_).toString();
               }
               else
               {
                  this._gold_txt.text = (_loc9_ * StrengthStone(this._items[0]).itemInfo.Count).toString();
               }
            }
            else
            {
               this._gold_txt.text = _loc9_.toString();
            }
         }
         else
         {
            this._gold_txt.text = "0";
         }
      }
      
      private function __strengthClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:BaseAlerFrame = null;
         param1.stopImmediatePropagation();
         NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
         SoundManager.instance.play("008");
         if(this._showDontClickTip())
         {
            return;
         }
         if(this._items[1].info != null)
         {
            if(this._items[1].info.StrengthenLevel >= ItemManager.Instance.getEquipLimitLevel(this._items[1].info.TemplateID))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
               return;
            }
         }
         if(this.checkTipBindType())
         {
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIStrengthBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc3_.moveEnable = false;
            _loc3_.info.enableHtml = true;
            _loc3_.info.mutiline = true;
            _loc3_.addEventListener(FrameEvent.RESPONSE,this._bingResponse);
         }
         else if(!this._progressLevel.getStarVisible())
         {
            this.sendSocket();
         }
      }
      
      private function _responseV(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.okFastPurchaseGold();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function okFastPurchaseGold() : void
      {
         var _loc1_:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _loc1_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _loc1_.itemID = EquipType.GOLD_BOX;
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function _bingResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._bingResponse);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendSocket();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function sendSocket() : void
      {
         if(!this.checkLevel())
         {
            return;
         }
         if(PlayerManager.Instance.Self.Gold < int(this._gold_txt.text))
         {
            this._goldAlertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            this._goldAlertFrame.moveEnable = false;
            this._goldAlertFrame.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
            return;
         }
         var _loc1_:Boolean = false;
         var _loc2_:int = ConsortiaRateManager.instance.rate;
         if(PlayerManager.Instance.Self.ConsortiaID != 0 && _loc2_ > 0)
         {
            _loc1_ = true;
         }
         var _loc3_:int = getTimer();
         if(_loc3_ - this._lastStrengthTime > 1200)
         {
            SocketManager.Instance.out.sendItemStrength(_loc1_,this._isInjectSelect.selected);
            this._lastStrengthTime = _loc3_;
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
         }
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
      
      private function checkTipBindType() : Boolean
      {
         if(this._items[1].itemInfo && this._items[1].itemInfo.IsBinds)
         {
            return false;
         }
         if(this._items[0].itemInfo && this._items[0].itemInfo.IsBinds)
         {
            return true;
         }
         return false;
      }
      
      private function checkLevel() : Boolean
      {
         var _loc1_:StreangthItemCell = this._items[1] as StreangthItemCell;
         var _loc2_:InventoryItemInfo = _loc1_.info as InventoryItemInfo;
         if(_loc2_.StrengthenLevel >= ItemManager.Instance.getEquipLimitLevel(_loc2_.TemplateID))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
            return false;
         }
         return true;
      }
      
      private function __itemInfoChange(param1:Event) : void
      {
         var _loc2_:StreangthItemCell = null;
         var _loc3_:InventoryItemInfo = null;
         this.updateGoldText();
         if(param1.currentTarget is StreangthItemCell)
         {
            _loc2_ = param1.currentTarget as StreangthItemCell;
            _loc3_ = _loc2_.info as InventoryItemInfo;
            if(_loc3_)
            {
               if(StreangthItemCell(this._items[1]).actionState)
               {
                  this._progressLevel.initProgress(_loc3_);
                  StreangthItemCell(this._items[1]).actionState = false;
                  if(this._starMovie)
                  {
                     this.removeStarMovie();
                  }
                  if(this._weaponUpgrades)
                  {
                     this.removeWeaponUpgradesMovie();
                  }
               }
               else
               {
                  this.updateProgress(_loc3_);
               }
               this._strengthLevel.visible = true;
               this._strengthLevel.text = this._strengthLevelStr + _loc3_._StrengthenLevel.toString();
               if(SavePointManager.Instance.isInSavePoint(9) && !TaskManager.instance.isNewHandTaskCompleted(7) || SavePointManager.Instance.isInSavePoint(16) && !TaskManager.instance.isNewHandTaskCompleted(12))
               {
                  dispatchEvent(new StoreIIEvent(StoreIIEvent.WEAPON_READY));
               }
               else
               {
                  NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
                  NewHandContainer.Instance.clearArrowByID(ArrowType.STRENG_CHOOSE_WEAPON);
               }
            }
            else
            {
               if(SavePointManager.Instance.isInSavePoint(9) && !TaskManager.instance.isNewHandTaskCompleted(7) || SavePointManager.Instance.isInSavePoint(16) && !TaskManager.instance.isNewHandTaskCompleted(12))
               {
                  dispatchEvent(new StoreIIEvent(StoreIIEvent.WEAPON_REMOVE));
               }
               this._gold_txt.text = "0";
               this._progressLevel.resetProgress();
               this._strengthLevel.visible = false;
            }
            dispatchEvent(new Event(Event.CHANGE));
         }
         this.getCountExpI();
         if(this._items[0].info == null)
         {
            this._items[0].stoneType = this._items[1].stoneType = "";
         }
         if(this._items[1].info == null)
         {
            this._items[0].itemType = -1;
         }
         else
         {
            this._items[0].itemType = this._items[1].info.RefineryLevel;
         }
         if(this._items[1].info == null || this._items[0].info == null || this._items[1].itemInfo.StrengthenLevel >= 9)
         {
            this.hideArr();
            return;
         }
      }
      
      private function _showDontClickTip() : Boolean
      {
         if(this._items[1].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.strength.dontStrengthI"));
            return true;
         }
         if(this._items[0].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.strength.dontStrengthII"));
            return true;
         }
         return false;
      }
      
      private function getCountExpI() : void
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(2);
         if(this._items[0].info != null)
         {
            _loc1_ += this._items[0].info.Property2;
         }
         if(ConsortiaRateManager.instance.rate > 0 && this._items[0].info != null)
         {
            _loc2_ = ConsortiaRateManager.instance.getConsortiaStrengthenEx(PlayerManager.Instance.Self.consortiaInfo.SmithLevel) / 100 * _loc1_;
         }
         if(PlayerManager.Instance.Self.IsVIP && this._items[0].info != null)
         {
            _loc4_ = _loc1_ * _loc5_["Level" + PlayerManager.Instance.Self.VIPLevel] / 100;
         }
         _loc3_ = _loc1_ + _loc4_;
         this._showSuccessExp.showAllNum(_loc1_,_loc2_,_loc4_,_loc3_);
      }
      
      public function getStrengthItemCellInfo() : InventoryItemInfo
      {
         return (this._items[1] as StreangthItemCell).itemInfo;
      }
      
      public function openHelp() : void
      {
         var _loc1_:DisplayObject = ComponentFactory.Instance.creat("ddtstore.StrengthHelpPrompt");
         var _loc2_:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         _loc2_.setView(_loc1_);
         _loc2_.titleText = LanguageMgr.GetTranslation("store.StoreIIStrengthBG.say");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function starMoviePlay() : void
      {
         if(this.isAutoStrength)
         {
            return;
         }
         if(!this._starMovie)
         {
            this._starMovie = ClassUtils.CreatInstance("accet.strength.starMovie");
         }
         this._starMovie.gotoAndPlay(1);
         this._starMovie.addEventListener(Event.ENTER_FRAME,this.__starMovieFrame);
         PositionUtils.setPos(this._starMovie,"ddtstore.StoreIIStrengthBG.starMoviePoint");
         addChild(this._starMovie);
      }
      
      private function __starMovieFrame(param1:Event) : void
      {
         if(this._starMovie)
         {
            if(this._starMovie.currentFrame == this._starMovie.totalFrames)
            {
               this.removeStarMovie();
            }
         }
      }
      
      private function removeStarMovie() : void
      {
         if(this._starMovie.hasEventListener(Event.ENTER_FRAME))
         {
            this._starMovie.removeEventListener(Event.ENTER_FRAME,this.__starMovieFrame);
         }
         if(this.contains(this._starMovie))
         {
            this.removeChild(this._starMovie);
         }
      }
      
      private function weaponUpgradesPlay(param1:Event) : void
      {
         this._weaponUpgradesI.visible = true;
         this._weaponUpgradesI.gotoAndPlay(1);
         this._weaponUpgradesI.addEventListener(Event.ENTER_FRAME,this.__weaponUpgradesFrameI);
         if(!this._weaponUpgrades)
         {
            this._weaponUpgrades = ClassUtils.CreatInstance("asset.strength.weaponUpgrades");
         }
         this._weaponUpgrades.gotoAndPlay(1);
         this._weaponUpgrades.addEventListener(Event.ENTER_FRAME,this.__weaponUpgradesFrame);
         PositionUtils.setPos(this._weaponUpgrades,"ddtstore.StoreIIStrengthBG.weaponUpgradesPoint");
         addChild(this._weaponUpgrades);
         this.dispatchEvent(new Event(StoreIIEvent.UPGRADES_PLAY));
      }
      
      private function __weaponUpgradesFrame(param1:Event) : void
      {
         if(this._weaponUpgrades)
         {
            if(this._weaponUpgrades.currentFrame == this._weaponUpgrades.totalFrames)
            {
               this.removeWeaponUpgradesMovie();
            }
         }
      }
      
      private function __weaponUpgradesFrameI(param1:Event) : void
      {
         if(this._weaponUpgradesI)
         {
            if(this._weaponUpgradesI.currentFrame == this._weaponUpgradesI.totalFrames)
            {
               this.removeWeaponUpgradesMovie();
            }
         }
      }
      
      private function removeWeaponUpgradesMovie() : void
      {
         if(this._weaponUpgrades.hasEventListener(Event.ENTER_FRAME))
         {
            this._weaponUpgrades.removeEventListener(Event.ENTER_FRAME,this.__weaponUpgradesFrame);
         }
         if(this.contains(this._weaponUpgrades))
         {
            this.removeChild(this._weaponUpgrades);
         }
         if(this._weaponUpgrades)
         {
            this._weaponUpgrades.stop();
            ObjectUtils.disposeObject(this._weaponUpgrades);
            this._weaponUpgrades = null;
         }
         this._weaponUpgradesI.visible = false;
         this._weaponUpgradesI.stop();
      }
      
      public function dispose() : void
      {
         var _loc1_:Disposeable = null;
         this.removeEvents();
         this.disposeUserGuide();
         if(this._area)
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         for each(_loc1_ in this._items)
         {
            _loc1_.dispose();
         }
         this._items.length = 0;
         this._items = null;
         EffectManager.Instance.removeEffect(this._strength_btn_shineEffect);
         this._strength_btn_shineEffect = null;
         ObjectUtils.disposeObject(this._strengthenEquipmentCellText);
         this._strengthenEquipmentCellText = null;
         this._pointArray.length = 0;
         this._pointArray = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._strength_btn)
         {
            ObjectUtils.disposeObject(this._strength_btn);
         }
         this._strength_btn = null;
         if(this._strthShine)
         {
            ObjectUtils.disposeObject(this._strthShine);
         }
         this._strthShine = null;
         if(this._startStrthTip)
         {
            ObjectUtils.disposeObject(this._startStrthTip);
         }
         this._startStrthTip = null;
         if(this._showSuccessExp)
         {
            ObjectUtils.disposeObject(this._showSuccessExp);
         }
         this._showSuccessExp = null;
         if(this._consortiaSmith)
         {
            ObjectUtils.disposeObject(this._consortiaSmith);
         }
         this._consortiaSmith = null;
         if(this._gold_txt)
         {
            ObjectUtils.disposeObject(this._gold_txt);
         }
         this._gold_txt = null;
         if(this._progressLevel)
         {
            ObjectUtils.disposeObject(this._progressLevel);
         }
         this._progressLevel = null;
         if(this._isInjectSelect)
         {
            ObjectUtils.disposeObject(this._isInjectSelect);
         }
         this._isInjectSelect = null;
         if(this._aler)
         {
            ObjectUtils.disposeObject(this._aler);
         }
         this._aler = null;
         ObjectUtils.disposeObject(this._vipDiscountBg);
         this._vipDiscountBg = null;
         ObjectUtils.disposeObject(this._vipDiscountIcon);
         this._vipDiscountIcon = null;
         ObjectUtils.disposeObject(this._vipDiscountTxt);
         this._vipDiscountTxt = null;
         if(this._goldIcon)
         {
            ObjectUtils.disposeObject(this._goldIcon);
         }
         this._goldIcon = null;
         if(this._neededGoldTipText)
         {
            ObjectUtils.disposeObject(this._neededGoldTipText);
         }
         this._neededGoldTipText = null;
         if(this._strengthLevel)
         {
            ObjectUtils.disposeObject(this._strengthLevel);
         }
         this._strengthLevel = null;
         if(this._starMovie)
         {
            if(this._starMovie.hasEventListener(Event.ENTER_FRAME))
            {
               this._starMovie.removeEventListener(Event.ENTER_FRAME,this.__starMovieFrame);
            }
            ObjectUtils.disposeObject(this._starMovie);
            this._starMovie = null;
         }
         if(this._weaponUpgrades)
         {
            if(this._weaponUpgrades.hasEventListener(Event.ENTER_FRAME))
            {
               this._weaponUpgrades.removeEventListener(Event.ENTER_FRAME,this.__weaponUpgradesFrame);
            }
            ObjectUtils.disposeObject(this._weaponUpgrades);
            this._weaponUpgrades = null;
         }
         if(this._weaponUpgradesI)
         {
            if(this._weaponUpgradesI.hasEventListener(Event.ENTER_FRAME))
            {
               this._weaponUpgradesI.removeEventListener(Event.ENTER_FRAME,this.__weaponUpgradesFrameI);
            }
            ObjectUtils.disposeObject(this._weaponUpgradesI);
            this._weaponUpgradesI = null;
         }
         if(this._sBuyStrengthStoneCell)
         {
            ObjectUtils.disposeObject(this._sBuyStrengthStoneCell);
         }
         this._sBuyStrengthStoneCell = null;
         if(this._goldAlertFrame)
         {
            ObjectUtils.disposeObject(this._goldAlertFrame);
         }
         this._goldAlertFrame = null;
         if(this._quickBuyFrame)
         {
            ObjectUtils.disposeObject(this._quickBuyFrame);
         }
         this._quickBuyFrame = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}