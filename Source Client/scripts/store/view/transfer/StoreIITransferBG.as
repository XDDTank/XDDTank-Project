package store.view.transfer
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
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DropGoodsManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import store.HelpFrame;
   import store.HelpPrompt;
   import store.IStoreViewBG;
   import store.StoreController;
   import store.view.StoneCellFrame;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class StoreIITransferBG extends Sprite implements IStoreViewBG
   {
       
      
      private var _bg:MutipleImage;
      
      private var _area:TransferDragInArea;
      
      private var _items:Vector.<TransferItemCell>;
      
      private var _transferBtnAsset:BaseButton;
      
      private var transShine:MovieImage;
      
      private var transArr:MutipleImage;
      
      private var _pointArray:Vector.<Point>;
      
      private var gold_txt:FilterFrameText;
      
      private var _goldIcon:Image;
      
      private var _transferBefore:Boolean = false;
      
      private var _transferAfter:Boolean = false;
      
      private var _equipmentCell1:StoneCellFrame;
      
      private var _equipmentCell2:StoneCellFrame;
      
      private var _neededGoldTipText:FilterFrameText;
      
      private var _transferBtnAsset_shineEffect:IEffect;
      
      private var _preExpText:FilterFrameText;
      
      private var _preExp:FilterFrameText;
      
      private var _preSaveExpText:FilterFrameText;
      
      private var _preSaveExp:FilterFrameText;
      
      private var _turnExpText:FilterFrameText;
      
      private var _turnExp:FilterFrameText;
      
      private var _turnSaveExpText:FilterFrameText;
      
      private var _turnSaveExp:FilterFrameText;
      
      private var _memoryExpBg1:Bitmap;
      
      private var _memoryExpBg2:Bitmap;
      
      private var _sprite1:Sprite;
      
      private var _sprite2:Sprite;
      
      private var _expTips:OneLineTip;
      
      private var _transferSuccessMc:MovieClip;
      
      private var _transferSuccessMcI:MovieClip;
      
      public function StoreIITransferBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TransferItemCell = null;
         this._memoryExpBg1 = ComponentFactory.Instance.creatBitmap("asset.ddtstore.Transfer.memoryExp.bg");
         PositionUtils.setPos(this._memoryExpBg1,"asset.ddtstore.Transfer.memoryExp.bg.pos1");
         addChild(this._memoryExpBg1);
         this._sprite1 = new Sprite();
         this._sprite1.graphics.beginFill(0,0);
         this._sprite1.graphics.drawRect(0,0,this._memoryExpBg1.width,this._memoryExpBg1.height);
         this._sprite1.graphics.endFill();
         this._sprite1.x = this._memoryExpBg1.x;
         this._sprite1.y = this._memoryExpBg1.y;
         addChild(this._sprite1);
         this._memoryExpBg2 = ComponentFactory.Instance.creatBitmap("asset.ddtstore.Transfer.memoryExp.bg");
         PositionUtils.setPos(this._memoryExpBg2,"asset.ddtstore.Transfer.memoryExp.bg.pos2");
         addChild(this._memoryExpBg2);
         this._sprite2 = new Sprite();
         this._sprite2.graphics.beginFill(0,0);
         this._sprite2.graphics.drawRect(0,0,this._memoryExpBg2.width,this._memoryExpBg2.height);
         this._sprite2.graphics.endFill();
         this._sprite2.x = this._memoryExpBg2.x;
         this._sprite2.y = this._memoryExpBg2.y;
         addChild(this._sprite2);
         this._equipmentCell1 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIITransferBG.EquipmentCell1");
         this._equipmentCell2 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIITransferBG.EquipmentCell2");
         this._equipmentCell1.label = this._equipmentCell2.label = LanguageMgr.GetTranslation("store.Strength.StrengthenEquipmentCellText");
         addChild(this._equipmentCell1);
         addChild(this._equipmentCell2);
         this._preExpText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.preExpText");
         this._preExpText.text = LanguageMgr.GetTranslation("store.Transfer.strengthExp");
         addChild(this._preExpText);
         this._preExp = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.preExp");
         this._preExp.text = "0";
         addChild(this._preExp);
         this._preSaveExpText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.preSaveExpText");
         this._preSaveExpText.text = LanguageMgr.GetTranslation("store.Transfer.saveExp");
         addChild(this._preSaveExpText);
         this._preSaveExp = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.preSaveExp");
         this._preSaveExp.text = "0";
         addChild(this._preSaveExp);
         this._turnExpText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.turnExpText");
         this._turnExpText.text = LanguageMgr.GetTranslation("store.Transfer.strengthExp");
         addChild(this._turnExpText);
         this._turnExp = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.turnExp");
         this._turnExp.text = "0";
         this._turnExp.visible = false;
         addChild(this._turnExp);
         this._turnSaveExpText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.turnSaveExpText");
         this._turnSaveExpText.text = LanguageMgr.GetTranslation("store.Transfer.saveExp");
         addChild(this._turnSaveExpText);
         this._turnSaveExp = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.turnSaveExp");
         this._turnSaveExp.text = "0";
         this._turnSaveExp.visible = false;
         addChild(this._turnSaveExp);
         this._transferBtnAsset = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.TransferBtn");
         addChild(this._transferBtnAsset);
         this._transferBtnAsset_shineEffect = EffectManager.Instance.creatEffect(EffectTypes.Linear_SHINER_ANIMATION,this._transferBtnAsset,{"color":EffectColorType.BLUE});
         this._neededGoldTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.NeededGoldTipText");
         this._neededGoldTipText.text = LanguageMgr.GetTranslation("store.Transfer.NeededGoldTipText");
         addChild(this._neededGoldTipText);
         this.gold_txt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITarnsferBG.NeedMoneyText");
         addChild(this.gold_txt);
         this._goldIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.GoldIcon");
         addChild(this._goldIcon);
         this._expTips = new OneLineTip();
         this._expTips.tipData = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.expTips");
         this._expTips.visible = false;
         addChild(this._expTips);
         if(!this._transferSuccessMcI)
         {
            this._transferSuccessMcI = ClassUtils.CreatInstance("asset.ddtstore.transferSuccessI");
         }
         PositionUtils.setPos(this._transferSuccessMcI,"ddtstore.StoreIITransferBG.weaponUpgradesPointI");
         addChild(this._transferSuccessMcI);
         this._transferSuccessMcI.visible = false;
         this._transferSuccessMcI.stop();
         this.getCellsPoint();
         this._items = new Vector.<TransferItemCell>();
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            _loc2_ = new TransferItemCell(_loc1_);
            _loc2_.addEventListener(Event.CHANGE,this.__itemInfoChange);
            _loc2_.x = this._pointArray[_loc1_].x;
            _loc2_.y = this._pointArray[_loc1_].y;
            addChild(_loc2_);
            this._items.push(_loc2_);
            _loc1_++;
         }
         this._area = new TransferDragInArea(this._items);
         addChildAt(this._area,0);
         if(!this._transferSuccessMc)
         {
            this._transferSuccessMc = ClassUtils.CreatInstance("asset.ddtstore.transferSuccess");
         }
         PositionUtils.setPos(this._transferSuccessMc,"ddtstore.StoreIITransferBG.weaponUpgradesPoint");
         addChild(this._transferSuccessMc);
         this._transferSuccessMc.visible = false;
         this._transferSuccessMc.stop();
         this.showExpPre(false);
         this.showExpTurn(false);
         this.hideArr();
         this.hide();
      }
      
      private function getCellsPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIITransferBG.Transferpoint" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         this._transferBtnAsset.addEventListener(MouseEvent.CLICK,this.__transferHandler);
         this._sprite1.addEventListener(MouseEvent.MOUSE_OVER,this.__showExpTips);
         this._sprite2.addEventListener(MouseEvent.MOUSE_OVER,this.__showExpTips);
         this._sprite1.addEventListener(MouseEvent.MOUSE_OUT,this.__hideExpTips);
         this._sprite2.addEventListener(MouseEvent.MOUSE_OUT,this.__hideExpTips);
         StoreController.instance.addEventListener(StoreController.TRANSFER_SUCCESS,this.__playMc);
      }
      
      private function removeEvent() : void
      {
         this._transferBtnAsset.removeEventListener(MouseEvent.CLICK,this.__transferHandler);
         this._sprite1.removeEventListener(MouseEvent.MOUSE_OVER,this.__showExpTips);
         this._sprite2.removeEventListener(MouseEvent.MOUSE_OVER,this.__showExpTips);
         this._sprite1.removeEventListener(MouseEvent.MOUSE_OUT,this.__hideExpTips);
         this._sprite2.removeEventListener(MouseEvent.MOUSE_OUT,this.__hideExpTips);
         StoreController.instance.removeEventListener(StoreController.TRANSFER_SUCCESS,this.__playMc);
      }
      
      private function __playMc(param1:Event) : void
      {
         this._transferSuccessMc.visible = true;
         this._transferSuccessMcI.visible = true;
         this._transferSuccessMc.gotoAndPlay(1);
         this._transferSuccessMcI.gotoAndPlay(1);
         this._transferSuccessMc.addEventListener(Event.ENTER_FRAME,this.__transferFrame);
         this._transferSuccessMcI.addEventListener(Event.ENTER_FRAME,this.__transferFrameI);
      }
      
      private function __transferFrame(param1:Event) : void
      {
         if(this._transferSuccessMc)
         {
            if(this._transferSuccessMc.currentFrame == this._transferSuccessMc.totalFrames)
            {
               this._transferSuccessMc.removeEventListener(Event.ENTER_FRAME,this.__transferFrame);
               this.removeMovie();
            }
         }
      }
      
      private function __transferFrameI(param1:Event) : void
      {
         if(this._transferSuccessMcI)
         {
            if(this._transferSuccessMcI.currentFrame == this._transferSuccessMcI.totalFrames)
            {
               this._transferSuccessMcI.removeEventListener(Event.ENTER_FRAME,this.__transferFrameI);
               this.removeMovie();
            }
         }
      }
      
      private function removeMovie() : void
      {
         this._transferSuccessMc.visible = false;
         this._transferSuccessMcI.visible = false;
         this._transferSuccessMc.stop();
         this._transferSuccessMcI.stop();
         this.clearTransferItemCell();
      }
      
      public function startShine(param1:int) : void
      {
         this._items[param1].startShine();
      }
      
      public function stopShine() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            this._items[_loc1_].stopShine();
            _loc1_++;
         }
      }
      
      private function showArr() : void
      {
         if(SavePointManager.Instance.isInSavePoint(67) && !TaskManager.instance.isNewHandTaskCompleted(28))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.TRANSFER_CHOOSE_WEAPON);
            NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON,0,"trainer.storeTranSureArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
         this._transferBtnAsset_shineEffect.play();
      }
      
      private function hideArr() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
         this._transferBtnAsset_shineEffect.stop();
      }
      
      public function get area() : Vector.<TransferItemCell>
      {
         return this._items;
      }
      
      public function setCell(param1:BagCell) : void
      {
         var _loc4_:TransferItemCell = null;
         var _loc5_:EquipmentTemplateInfo = null;
         var _loc6_:EquipmentTemplateInfo = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.info as InventoryItemInfo;
         var _loc3_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_loc2_.TemplateID);
         for each(_loc4_ in this._items)
         {
            if(_loc4_.info == null)
            {
               if(this._items[0].info)
               {
                  _loc5_ = ItemManager.Instance.getEquipTemplateById(this._items[0].info.TemplateID);
                  if(_loc5_.TemplateType != _loc3_.TemplateType)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
                     return;
                  }
               }
               else if(this._items[1].info)
               {
                  _loc6_ = ItemManager.Instance.getEquipTemplateById(this._items[1].info.TemplateID);
                  if(_loc6_.TemplateType != _loc3_.TemplateType)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
                     return;
                  }
               }
               SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc4_.index,1);
               return;
            }
         }
      }
      
      private function getMaxExpByLevel(param1:int, param2:int) : Number
      {
         var _loc3_:Number = 0;
         var _loc4_:int = 1;
         while(_loc4_ <= param1)
         {
            _loc3_ += ItemManager.Instance.getEquipStrengthInfoByLevel(_loc4_,param2).Exp;
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function __transferHandler(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:BaseAlerFrame = null;
         var _loc6_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:TransferItemCell = this._items[0] as TransferItemCell;
         var _loc3_:TransferItemCell = this._items[1] as TransferItemCell;
         if(this._showDontClickTip())
         {
            return;
         }
         if(_loc2_.info && _loc3_.info)
         {
            if(PlayerManager.Instance.Self.Gold < Number(this.gold_txt.text))
            {
               _loc6_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc6_.moveEnable = false;
               _loc6_.addEventListener(FrameEvent.RESPONSE,this._responseV);
               return;
            }
            this.hideArr();
            this._transferBefore = this._transferAfter = false;
            _loc4_ = "";
            if(EquipType.isArm(_loc2_.info) || EquipType.isCloth(_loc2_.info) || EquipType.isHead(_loc2_.info) || EquipType.isArm(_loc3_.info) || EquipType.isCloth(_loc3_.info) || EquipType.isHead(_loc3_.info))
            {
               _loc4_ = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.sure2");
            }
            else
            {
               _loc4_ = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.sure");
            }
            _loc5_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc4_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            _loc5_.addEventListener(FrameEvent.RESPONSE,this._responseII);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.EmptyItem"));
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
      
      private function _response(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.depositAction();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this._transferBefore = this._transferAfter = true;
            StoreController.instance.Model.transWeaponReady = false;
            this.sendSocket();
         }
         else
         {
            this.cannel();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function cannel() : void
      {
         this.showArr();
      }
      
      private function depositAction() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("setFlashCall");
         }
         navigateToURL(new URLRequest(PathManager.solveFillPage()),"_blank");
      }
      
      private function isComposeStrengthen(param1:BagCell) : Boolean
      {
         if(param1.itemInfo.StrengthenExp > 0 || param1.itemInfo.StrengthenLevel > 0)
         {
            return true;
         }
         return false;
      }
      
      private function sendSocket() : void
      {
         SocketManager.Instance.out.sendItemTransfer(this._transferBefore,this._transferAfter);
      }
      
      private function __itemInfoChange(param1:Event) : void
      {
         var _loc4_:EquipmentTemplateInfo = null;
         var _loc5_:EquipmentTemplateInfo = null;
         NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
         this.gold_txt.text = "0";
         var _loc2_:TransferItemCell = this._items[0];
         var _loc3_:TransferItemCell = this._items[1];
         if(_loc2_.info)
         {
            this.showExpPre(true);
            _loc4_ = ItemManager.Instance.getEquipTemplateById(_loc2_.info.TemplateID);
            if(_loc2_.info["StrengthenLevel"] == _loc4_.StrengthLimit && _loc2_.info["StrengthenExp"] > 0)
            {
               this._preExp.text = this.getMaxExpByLevel(_loc4_.StrengthLimit,_loc4_.QualityID).toString();
               this._preSaveExp.text = _loc2_.info["StrengthenExp"].toString();
            }
            else
            {
               this._preExp.text = (this.getMaxExpByLevel(_loc2_.info["StrengthenLevel"],_loc4_.QualityID) + _loc2_.info["StrengthenExp"]).toString();
               this._preSaveExp.text = "0";
            }
            _loc2_.TemplateType = -1;
            if(_loc3_.info)
            {
               _loc2_.TemplateType = _loc4_.TemplateType;
            }
            _loc3_.TemplateType = _loc4_.TemplateType;
            NewHandContainer.Instance.clearArrowByID(ArrowType.TRANSFER_CHOOSE_WEAPON);
         }
         else
         {
            this.showExpPre(false);
            _loc3_.TemplateType = -1;
            if(_loc3_.info)
            {
               _loc2_.TemplateType = ItemManager.Instance.getEquipTemplateById(_loc3_.info.TemplateID).TemplateType;
            }
            else
            {
               _loc2_.TemplateType = -1;
            }
         }
         if(_loc3_.info)
         {
            this.showExpTurn(true);
            _loc5_ = ItemManager.Instance.getEquipTemplateById(_loc3_.info.TemplateID);
            if(_loc3_.info["StrengthenLevel"] == _loc5_.StrengthLimit && _loc3_.info["StrengthenExp"] > 0)
            {
               this._turnExp.text = this.getMaxExpByLevel(_loc5_.StrengthLimit,_loc5_.QualityID).toString();
               this._turnSaveExp.text = _loc3_.info["StrengthenExp"].toString();
            }
            else
            {
               this._turnExp.text = (this.getMaxExpByLevel(_loc3_.info["StrengthenLevel"],_loc5_.QualityID) + _loc3_.info["StrengthenExp"]).toString();
               this._turnSaveExp.text = "0";
            }
            NewHandContainer.Instance.clearArrowByID(ArrowType.TRANSFER_CHOOSE_WEAPON);
         }
         else
         {
            this.showExpTurn(false);
         }
         if(_loc2_.info)
         {
            _loc2_.Refinery = _loc3_.Refinery = _loc2_.info.RefineryLevel;
         }
         else if(_loc3_.info)
         {
            _loc2_.Refinery = _loc3_.Refinery = _loc3_.info.RefineryLevel;
         }
         else
         {
            _loc2_.Refinery = _loc3_.Refinery = -1;
         }
         if(_loc2_.info && _loc3_.info)
         {
            if(_loc4_.TemplateType != _loc5_.TemplateType)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.put"));
               return;
            }
            if(this.isComposeStrengthen(_loc2_) || this.isComposeStrengthen(_loc3_))
            {
               this.goldMoney();
               this.showArr();
            }
            else
            {
               this.hideArr();
            }
         }
         else
         {
            this.hideArr();
         }
         if(_loc2_.info && !_loc3_.info)
         {
            StoreController.instance.Model.transWeaponReady = true;
            StoreController.instance.sendTransferShowLightEvent(_loc2_.info,true);
         }
         else if(_loc3_.info && !_loc2_.info)
         {
            StoreController.instance.Model.transWeaponReady = true;
            StoreController.instance.sendTransferShowLightEvent(_loc3_.info,true);
         }
         else
         {
            StoreController.instance.Model.transWeaponReady = false;
            StoreController.instance.sendTransferShowLightEvent(null,false);
         }
      }
      
      private function showExpPre(param1:Boolean) : void
      {
         this._preExp.visible = param1;
         this._preExpText.visible = param1;
         this._preSaveExpText.visible = param1;
         this._preSaveExp.visible = param1;
         this._memoryExpBg1.visible = param1;
         this._sprite1.visible = param1;
      }
      
      private function showExpTurn(param1:Boolean) : void
      {
         this._turnExp.visible = param1;
         this._turnExpText.visible = param1;
         this._turnSaveExp.visible = param1;
         this._turnSaveExpText.visible = param1;
         this._memoryExpBg2.visible = param1;
         this._sprite2.visible = param1;
      }
      
      private function _showDontClickTip() : Boolean
      {
         var _loc1_:TransferItemCell = this._items[0];
         var _loc2_:TransferItemCell = this._items[1];
         if(_loc1_.info == null && _loc2_.info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.NoItem"));
            return true;
         }
         if(_loc1_.info == null || _loc2_.info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.EmptyItem"));
            return true;
         }
         if(!this.isComposeStrengthen(_loc1_) && !this.isComposeStrengthen(_loc2_))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.transfer.dontTransferII"));
            return true;
         }
         return false;
      }
      
      private function goldMoney() : void
      {
         this.gold_txt.text = "10000";
      }
      
      public function show() : void
      {
         this.initEvent();
         this.visible = true;
         this.updateData();
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1)
         {
            _loc3_ = int(_loc2_);
            if(_loc3_ < this._items.length)
            {
               this._items[_loc3_].info = PlayerManager.Instance.Self.StoreBag.items[_loc3_];
            }
         }
      }
      
      public function updateData() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            this._items[_loc1_].info = PlayerManager.Instance.Self.StoreBag.items[_loc1_];
            _loc1_++;
         }
      }
      
      public function hide() : void
      {
         this.removeEvent();
         if(this._items[0].info || this._items[1].info)
         {
            StoreController.instance.sendTransferShowLightEvent(null,false);
         }
         this.visible = false;
      }
      
      public function openHelp() : void
      {
         var _loc1_:HelpPrompt = ComponentFactory.Instance.creat("ddtstore.TransferHelpPrompt");
         var _loc2_:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         _loc2_.setView(_loc1_);
         _loc2_.titleText = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.move");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function clearTransferItemCell() : void
      {
         var _loc1_:TransferItemCell = this._items[0];
         var _loc2_:TransferItemCell = this._items[1];
         if(SavePointManager.Instance.isInSavePoint(67))
         {
            if(_loc1_.info.TemplateID == 400218 || _loc2_.info.TemplateID == 400218)
            {
               setTimeout(this.dropGoods,1000,400218);
            }
            else if(_loc1_.info.TemplateID == 400219 || _loc2_.info.TemplateID == 400219)
            {
               setTimeout(this.dropGoods,1000,400219);
            }
         }
         if(_loc1_.info != null)
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,_loc1_.index,_loc1_.itemBagType,-1);
         }
         if(_loc2_.info != null)
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,_loc2_.index,_loc2_.itemBagType,-1);
         }
      }
      
      private function dropGoods(param1:int) : void
      {
         DropGoodsManager.showTipByTemplateID(param1);
      }
      
      private function __showExpTips(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         var _loc2_:Object = param1.target;
         this._expTips.visible = true;
         this._expTips.x = _loc2_.x - this._expTips.width - 5;
         this._expTips.y = _loc2_.y - 3;
      }
      
      private function __hideExpTips(param1:MouseEvent) : void
      {
         this._expTips.visible = false;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].removeEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[_loc1_].dispose();
            _loc1_++;
         }
         this._items = null;
         EffectManager.Instance.removeEffect(this._transferBtnAsset_shineEffect);
         this._pointArray = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._neededGoldTipText)
         {
            ObjectUtils.disposeObject(this._neededGoldTipText);
         }
         this._neededGoldTipText = null;
         if(this._goldIcon)
         {
            ObjectUtils.disposeObject(this._goldIcon);
         }
         this._goldIcon = null;
         if(this._equipmentCell1)
         {
            ObjectUtils.disposeObject(this._equipmentCell1);
         }
         this._equipmentCell1 = null;
         if(this._equipmentCell2)
         {
            ObjectUtils.disposeObject(this._equipmentCell2);
         }
         this._equipmentCell2 = null;
         if(this._area)
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         if(this._transferBtnAsset)
         {
            ObjectUtils.disposeObject(this._transferBtnAsset);
         }
         this._transferBtnAsset = null;
         if(this.transShine)
         {
            ObjectUtils.disposeObject(this.transShine);
         }
         this.transShine = null;
         if(this.transArr)
         {
            ObjectUtils.disposeObject(this.transArr);
         }
         this.transArr = null;
         if(this.gold_txt)
         {
            ObjectUtils.disposeObject(this.gold_txt);
         }
         this.gold_txt = null;
         if(this._transferSuccessMc)
         {
            if(this._transferSuccessMc.hasEventListener(Event.ENTER_FRAME))
            {
               this._transferSuccessMc.removeEventListener(Event.ENTER_FRAME,this.__transferFrame);
            }
            ObjectUtils.disposeObject(this._transferSuccessMc);
            this._transferSuccessMc = null;
         }
         if(this._transferSuccessMcI)
         {
            if(this._transferSuccessMcI.hasEventListener(Event.ENTER_FRAME))
            {
               this._transferSuccessMcI.removeEventListener(Event.ENTER_FRAME,this.__transferFrameI);
            }
            ObjectUtils.disposeObject(this._transferSuccessMcI);
            this._transferSuccessMcI = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._memoryExpBg1);
         this._memoryExpBg1 = null;
         ObjectUtils.disposeObject(this._memoryExpBg2);
         this._memoryExpBg2 = null;
         ObjectUtils.disposeObject(this._turnExp);
         this._turnExp = null;
         ObjectUtils.disposeObject(this._turnSaveExp);
         this._turnSaveExp = null;
         ObjectUtils.disposeObject(this._turnExpText);
         this._turnExpText = null;
         ObjectUtils.disposeObject(this._turnSaveExpText);
         this._turnSaveExpText = null;
         ObjectUtils.disposeObject(this._preExp);
         this._preExp = null;
         ObjectUtils.disposeObject(this._preSaveExp);
         this._preSaveExp = null;
         ObjectUtils.disposeObject(this._preExpText);
         this._preExpText = null;
         ObjectUtils.disposeObject(this._preSaveExpText);
         this._preSaveExpText = null;
         ObjectUtils.disposeObject(this._sprite1);
         this._sprite1 = null;
         ObjectUtils.disposeObject(this._sprite2);
         this._sprite2 = null;
         ObjectUtils.disposeObject(this._expTips);
         this._expTips = null;
      }
   }
}
