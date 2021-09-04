package bagAndInfo.cell
{
   import bagAndInfo.bag.BreakGoodsBtn;
   import bagAndInfo.bag.ContinueGoodsBtn;
   import bagAndInfo.bag.SellGoodsBtn;
   import bagAndInfo.bag.SellGoodsFrame;
   import baglocked.BagLockedController;
   import baglocked.BaglockedManager;
   import baglocked.SetPassEvent;
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.BagCellInfo;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import farm.view.FarmFieldBlock;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.utils.Timer;
   import petsBag.view.item.SkillItem;
   
   public class LockBagCell extends BaseCell
   {
      
      private static var NEXT_FRAM:int = 33;
      
      private static var OVER_FRAM:int = 58;
      
      private static var STRAT_FRAM:int = 1;
       
      
      protected var _place:int;
      
      protected var _bgOverDate:Bitmap;
      
      protected var _cellMouseOverBg:Bitmap;
      
      protected var _cellMouseOverFormer:Bitmap;
      
      private var _mouseOverEffBoolean:Boolean;
      
      protected var _bagType:int;
      
      private var _bagIndex:int;
      
      private var _lastTime:Date;
      
      private var time:int = 20;
      
      private var _oneFrame:Number;
      
      private var _currentFrame:int = 0;
      
      private var _timer:Timer;
      
      private var bagCellinfo:BagCellInfo;
      
      private var _euipQualityBg:ScaleFrameImage;
      
      private var _isLighting:Boolean;
      
      protected var temInfo:InventoryItemInfo;
      
      private var _sellFrame:SellGoodsFrame;
      
      public function LockBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null, param5:Boolean = true)
      {
         this._mouseOverEffBoolean = param5;
         this._place = param1;
         super(Boolean(param4) ? param4 : ComponentFactory.Instance.creatComponentByStylename("core.bagAndInfo.bagCellBgAsset"),param2,param3);
      }
      
      public function set mouseOverEffBoolean(param1:Boolean) : void
      {
         this._mouseOverEffBoolean = param1;
      }
      
      public function get bagType() : int
      {
         return this._bagType;
      }
      
      public function set bagType(param1:int) : void
      {
         this._bagType = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         locked = false;
         this._bgOverDate = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.overDateBgAsset");
         if(this._mouseOverEffBoolean == true)
         {
            this._cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
            this._cellMouseOverFormer = ComponentFactory.Instance.creatBitmap("core.bagAndInfo.bagCellOverBgAsset");
            this._cellMouseOverFormer.x = -10;
            this._cellMouseOverFormer.y = -10;
            addChild(this._cellMouseOverFormer);
         }
         addChild(this._bgOverDate);
         _tbxCount = ComponentFactory.Instance.creatComponentByStylename("BagCellCountText");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
         this.updateCount();
         this.checkOverDate();
         this.updateBgVisible(false);
      }
      
      public function initeuipQualityBg(param1:int) : void
      {
         if(this._euipQualityBg == null)
         {
            this._euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
            this._euipQualityBg.width = 43;
            this._euipQualityBg.height = 43;
         }
         if(param1 == 0)
         {
            this._euipQualityBg.visible = false;
         }
         else if(param1 == 1)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
         else if(param1 == 2)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
         else if(param1 == 3)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
         else if(param1 == 4)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
         else if(param1 == 5)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         var _loc2_:EquipmentTemplateInfo = null;
         super.info = param1;
         this.updateCount();
         this.checkOverDate();
         if(info is InventoryItemInfo)
         {
            this.locked = this.info["lock"];
         }
         if(info == null)
         {
            _loc2_ = null;
            this.initeuipQualityBg(0);
         }
         if(info != null)
         {
            _loc2_ = ItemManager.Instance.getEquipTemplateById(info.TemplateID);
         }
         if(_loc2_ != null && info.Property8 == "0")
         {
            this.initeuipQualityBg(_loc2_.QualityID);
         }
         else
         {
            this.initeuipQualityBg(0);
         }
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         super.onMouseOver(param1);
         this.updateBgVisible(true);
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         super.onMouseOut(param1);
         this.updateBgVisible(false);
      }
      
      public function onParentMouseOver(param1:Bitmap) : void
      {
         if(!this._cellMouseOverBg)
         {
            this._cellMouseOverBg = param1;
            addChild(this._cellMouseOverBg);
            super.setChildIndex(this._cellMouseOverBg,0);
            this.updateBgVisible(true);
         }
      }
      
      public function onParentMouseOut() : void
      {
         if(this._cellMouseOverBg)
         {
            this.updateBgVisible(false);
            this._cellMouseOverBg = null;
         }
      }
      
      protected function updateBgVisible(param1:Boolean) : void
      {
         if(this._cellMouseOverBg)
         {
            this._cellMouseOverBg.visible = param1;
            this._cellMouseOverFormer.visible = param1;
            setChildIndex(this._cellMouseOverFormer,numChildren - 1);
         }
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:EquipmentTemplateInfo = null;
         var _loc6_:BaseAlerFrame = null;
         if(param1.source is SkillItem)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            param1.action = DragEffect.NONE;
            super.dragStop(param1);
            return;
         }
         var _loc2_:int = PlayerManager.Instance.Self.bagVibleType;
         if(param1.data as InventoryItemInfo)
         {
            _loc3_ = param1.data as InventoryItemInfo;
            if((_loc2_ == 1 || _loc2_ == 2 || _loc2_ == 3 || _loc2_ == 4) && _loc3_.Place > 30)
            {
               param1.action = DragEffect.NONE;
               return;
            }
         }
         if(param1.data is InventoryItemInfo)
         {
            _loc4_ = param1.data as InventoryItemInfo;
            if(locked)
            {
               if(_loc4_ == this.info)
               {
                  this.locked = false;
                  DragManager.acceptDrag(this);
               }
               else
               {
                  DragManager.acceptDrag(this,DragEffect.NONE);
               }
            }
            else
            {
               if(this._bagType == 11 || _loc4_.BagType == 11)
               {
                  if(param1.action == DragEffect.SPLIT)
                  {
                     param1.action = DragEffect.NONE;
                  }
                  else if(this._bagType != 11)
                  {
                     SocketManager.Instance.out.sendMoveGoods(BagInfo.CONSORTIA,_loc4_.Place,this._bagType,this.place,_loc4_.Count);
                     param1.action = DragEffect.NONE;
                  }
                  else if(this._bagType == _loc4_.BagType)
                  {
                     if(this.place >= PlayerManager.Instance.Self.consortiaInfo.StoreLevel * 10)
                     {
                        param1.action = DragEffect.NONE;
                     }
                     else
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc4_.BagType,_loc4_.Place,_loc4_.BagType,this.place,_loc4_.Count);
                     }
                  }
                  else if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel < 1)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.cellDoubleClick"));
                     param1.action = DragEffect.NONE;
                  }
                  else
                  {
                     SocketManager.Instance.out.sendMoveGoods(_loc4_.BagType,_loc4_.Place,this._bagType,this.place,_loc4_.Count);
                     param1.action = DragEffect.NONE;
                  }
               }
               else if(_loc4_.BagType == this._bagType)
               {
                  if(!this.itemInfo)
                  {
                     if(_loc4_.isMoveSpace)
                     {
                        PlayerManager.Instance.Self.bagVibleType = 0;
                        SocketManager.Instance.out.sendMoveGoods(_loc4_.BagType,_loc4_.Place,_loc4_.BagType,this.place,_loc4_.Count);
                     }
                     param1.action = DragEffect.NONE;
                     return;
                  }
                  _loc5_ = ItemManager.Instance.getEquipTemplateById(this.itemInfo.TemplateID);
                  if(_loc5_ && _loc4_.Place <= 30)
                  {
                     if(_loc4_.NeedLevel > PlayerManager.Instance.Self.Grade)
                     {
                        return MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.need"));
                     }
                  }
                  if(_loc4_.CategoryID == this.itemInfo.CategoryID && _loc4_.Place <= 30 && (_loc4_.BindType == 1 || _loc4_.BindType == 2 || _loc4_.BindType == 3) && this.itemInfo.IsBinds == false && EquipType.canEquip(_loc4_))
                  {
                     _loc6_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
                     _loc6_.addEventListener(FrameEvent.RESPONSE,this.__onCellResponse);
                     this.temInfo = _loc4_;
                  }
                  else if(EquipType.isHealStone(_loc4_))
                  {
                     if(PlayerManager.Instance.Self.Grade >= int(_loc4_.Property1))
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc4_.BagType,_loc4_.Place,_loc4_.BagType,this.place,_loc4_.Count);
                        param1.action = DragEffect.NONE;
                     }
                     else if(param1.action == DragEffect.MOVE)
                     {
                        if(param1.source is BagCell)
                        {
                           BagCell(param1.source).locked = false;
                        }
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade",_loc4_.Property1));
                     }
                  }
                  else
                  {
                     SocketManager.Instance.out.sendMoveGoods(_loc4_.BagType,_loc4_.Place,_loc4_.BagType,this.place,_loc4_.Count);
                     param1.action = DragEffect.NONE;
                  }
               }
               else if(_loc4_.BagType == BagInfo.STOREBAG)
               {
                  if(_loc4_.CategoryID == EquipType.TEXP || _loc4_.CategoryID == EquipType.FOOD)
                  {
                     SocketManager.Instance.out.sendMoveGoods(_loc4_.BagType,_loc4_.Place,this._bagType,-1,_loc4_.Count);
                  }
                  param1.action = DragEffect.NONE;
               }
               else
               {
                  param1.action = DragEffect.NONE;
               }
               DragManager.acceptDrag(this);
            }
         }
         else if(param1.data is SellGoodsBtn)
         {
            if(!locked && _info && this._bagType != 11)
            {
               locked = true;
               DragManager.acceptDrag(this);
            }
         }
         else if(param1.data is ContinueGoodsBtn)
         {
            if(!locked && _info && this._bagType != 11)
            {
               locked = true;
               DragManager.acceptDrag(this,DragEffect.NONE);
            }
         }
         else if(param1.data is BreakGoodsBtn)
         {
            if(!locked && _info)
            {
               DragManager.acceptDrag(this);
            }
         }
      }
      
      private function sendDefy() : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.canEquip(this.temInfo))
         {
            SocketManager.Instance.out.sendMoveGoods(this.temInfo.BagType,this.temInfo.Place,this.temInfo.BagType,this.place,this.temInfo.Count);
         }
      }
      
      override public function dragStart() : void
      {
         super.dragStart();
         if(_info && _pic.numChildren > 0)
         {
            dispatchEvent(new CellEvent(CellEvent.DRAGSTART,this.info,true));
         }
      }
      
      public function getStagePos() : Point
      {
         return this.localToGlobal(new Point(0,0));
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(param1.action == DragEffect.MOVE && param1.target == null)
         {
            if(_loc2_ && _loc2_.BagType == 11)
            {
               param1.action = DragEffect.NONE;
               super.dragStop(param1);
            }
            else if(_loc2_ && _loc2_.BagType == 12)
            {
               locked = false;
            }
            else if(_loc2_ && _loc2_.BagType == 21)
            {
               locked = false;
            }
            else
            {
               locked = false;
               this.sellItem();
            }
         }
         else if(param1.action == DragEffect.SPLIT && param1.target == null)
         {
            locked = false;
         }
         else if(param1.target is FarmFieldBlock)
         {
            locked = false;
            if(_loc2_.Property1 != "31")
            {
               this.sellItem();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.beadCanntDestory"));
            }
         }
         else
         {
            super.dragStop(param1);
         }
      }
      
      public function dragCountStart(param1:int) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:String = null;
         if(_info && !locked && stage && param1 != 0)
         {
            _loc2_ = this.itemInfo;
            _loc3_ = DragEffect.MOVE;
            if(param1 != this.itemInfo.Count)
            {
               _loc2_ = new InventoryItemInfo();
               _loc2_.ItemID = this.itemInfo.ItemID;
               _loc2_.BagType = this.itemInfo.BagType;
               _loc2_.Place = this.itemInfo.Place;
               _loc2_.IsBinds = this.itemInfo.IsBinds;
               _loc2_.BeginDate = this.itemInfo.BeginDate;
               _loc2_.ValidDate = this.itemInfo.ValidDate;
               _loc2_.Count = param1;
               _loc2_.NeedSex = this.itemInfo.NeedSex;
               _loc3_ = DragEffect.SPLIT;
            }
            if(DragManager.startDrag(this,_loc2_,createDragImg(),stage.mouseX,stage.mouseY,_loc3_))
            {
               locked = true;
            }
         }
      }
      
      public function sellItem() : void
      {
         if(EquipType.isValuableEquip(info))
         {
            if(!PlayerManager.Instance.Self.bagPwdState)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip1"));
               return;
            }
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               BagLockedController.Instance.addEventListener(SetPassEvent.CANCELBTN,this.__cancelBtn);
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip1"));
         }
         else if(EquipType.isEmbed(info))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip2"));
         }
         else if(EquipType.isPetSpeciallFood(info))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
         }
         else if(!info.CanDelete)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
         }
         else
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this.showSellFrame();
         }
      }
      
      private function showSellFrame() : void
      {
         if(this._sellFrame == null)
         {
            this._sellFrame = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame");
            this._sellFrame.addEventListener(SellGoodsFrame.CANCEL,this.disposeSellFrame);
            this._sellFrame.addEventListener(SellGoodsFrame.OK,this.disposeSellFrame);
            this._sellFrame.itemInfo = InventoryItemInfo(info);
         }
         LayerManager.Instance.addToLayer(this._sellFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function disposeSellFrame(param1:Event) : void
      {
         if(this._sellFrame)
         {
            this._sellFrame.dispose();
         }
         this._sellFrame = null;
      }
      
      protected function __onCellResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(EquipType.isHealStone(info))
            {
               if(PlayerManager.Instance.Self.Grade >= int(info.Property1))
               {
                  this.sendDefy();
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade",info.Property1));
               }
            }
            else
            {
               this.sendDefy();
            }
         }
      }
      
      private function getAlertInfo() : AlertInfo
      {
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.autoDispose = true;
         _loc1_.showCancel = _loc1_.showSubmit = true;
         _loc1_.enterEnable = true;
         _loc1_.escEnable = true;
         _loc1_.moveEnable = false;
         _loc1_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc1_.data = LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.sure").replace("{0}",InventoryItemInfo(_info).Count * _info.ReclaimValue + (_info.ReclaimType == 1 ? LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.gold") : (_info.ReclaimType == 2 ? LanguageMgr.GetTranslation("tank.gameover.takecard.gifttoken") : "")));
         return _loc1_;
      }
      
      private function confirmCancel() : void
      {
         locked = false;
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      public function get bagIndex() : int
      {
         return this._bagIndex;
      }
      
      public function get lastTime() : Date
      {
         return this._lastTime;
      }
      
      override public function get itemInfo() : InventoryItemInfo
      {
         return _info as InventoryItemInfo;
      }
      
      public function replaceBg(param1:Sprite) : void
      {
         _bg = param1;
      }
      
      public function updateCount() : void
      {
         if(_tbxCount)
         {
            if(_info && this.itemInfo && this.itemInfo.MaxCount > 1)
            {
               _tbxCount.text = String(this.itemInfo.Count);
               _tbxCount.visible = true;
               addChild(_tbxCount);
            }
            else
            {
               _tbxCount.visible = false;
            }
         }
      }
      
      public function checkOverDate() : void
      {
         if(this._bgOverDate)
         {
            if(this.itemInfo && this.itemInfo.getRemainDate() <= 0)
            {
               this._bgOverDate.visible = true;
               addChild(this._bgOverDate);
               _pic.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
            }
            else
            {
               this._bgOverDate.visible = false;
               if(_pic)
               {
                  _pic.filters = [];
               }
            }
         }
      }
      
      public function set BGVisible(param1:Boolean) : void
      {
         _bg.visible = param1;
      }
      
      private function __cancelBtn(param1:SetPassEvent) : void
      {
         BagLockedController.Instance.removeEventListener(SetPassEvent.CANCELBTN,this.__cancelBtn);
         this.disposeSellFrame(null);
      }
      
      public function set light(param1:Boolean) : void
      {
         this._isLighting = param1;
         if(param1)
         {
            this.showEffect();
         }
         else
         {
            this.hideEffect();
         }
      }
      
      private function showEffect() : void
      {
         TweenMax.to(this,0.5,{
            "repeat":-1,
            "yoyo":true,
            "glowFilter":{
               "color":16777011,
               "alpha":1,
               "blurX":8,
               "blurY":8,
               "strength":3,
               "inner":true
            }
         });
      }
      
      private function hideEffect() : void
      {
         TweenMax.killChildTweensOf(this.parent,false);
         this.filters = null;
      }
      
      public function get isLighting() : Boolean
      {
         return this._isLighting;
      }
      
      override public function dispose() : void
      {
         if(_tbxCount)
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = null;
         if(this._bgOverDate)
         {
            ObjectUtils.disposeObject(this._bgOverDate);
         }
         this._bgOverDate = null;
         if(this._cellMouseOverBg)
         {
            ObjectUtils.disposeObject(this._cellMouseOverBg);
         }
         this._cellMouseOverBg = null;
         if(this._cellMouseOverFormer)
         {
            ObjectUtils.disposeObject(this._cellMouseOverFormer);
         }
         this._cellMouseOverFormer = null;
         if(this._euipQualityBg)
         {
            ObjectUtils.disposeObject(this._euipQualityBg);
         }
         this._euipQualityBg = null;
         TweenMax.killChildTweensOf(this.parent,false);
         super.dispose();
      }
   }
}
