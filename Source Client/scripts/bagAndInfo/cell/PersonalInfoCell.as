package bagAndInfo.cell
{
   import bagAndInfo.info.PlayerViewState;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
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
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class PersonalInfoCell extends BagCell
   {
       
      
      private var _shineObject:MovieClip;
      
      public function PersonalInfoCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true)
      {
         super(param1,param2,param3);
         _bg.visible = false;
         _picPos = new Point(2,1);
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         addEventListener(InteractiveEvent.CLICK,this.onClick);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.onDoubleClick);
         DoubleClickManager.Instance.enableDoubleClick(this);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(InteractiveEvent.CLICK,this.onClick);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.onDoubleClick);
         DoubleClickManager.Instance.disableDoubleClick(this);
      }
      
      override public function dragStart() : void
      {
         if(_info && !locked && stage && allowDrag)
         {
            if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE))
            {
               SoundManager.instance.play("008");
               locked = true;
            }
         }
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
      }
      
      protected function onClick(param1:InteractiveEvent) : void
      {
         dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,this));
      }
      
      protected function onDoubleClick(param1:InteractiveEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(info)
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,this));
         }
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:EquipmentTemplateInfo = null;
         var _loc4_:BaseAlerFrame = null;
         var _loc5_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            param1.action = DragEffect.NONE;
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_)
         {
            _loc3_ = ItemManager.Instance.getEquipTemplateById(_loc2_.TemplateID);
            if(PlayerManager.Instance.Self.bagLocked)
            {
               return;
            }
            if(_loc2_.Place < 29 && _loc2_.BagType != BagInfo.PROPBAG)
            {
               return;
            }
            if(_loc3_)
            {
               if(_loc2_.NeedLevel > PlayerManager.Instance.Self.Grade)
               {
                  DragManager.acceptDrag(this,DragEffect.NONE);
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.need"));
                  return;
               }
            }
            if((_loc2_.BindType == 1 || _loc2_.BindType == 2 || _loc2_.BindType == 3) && _loc2_.IsBinds == false)
            {
               _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc4_.addEventListener(FrameEvent.RESPONSE,this.__onBindResponse);
               temInfo = _loc2_;
               DragManager.acceptDrag(this,DragEffect.NONE);
               return;
            }
            if(PlayerManager.Instance.Self.canEquip(_loc2_))
            {
               if(PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
               {
                  if(this.getCellIndex(_loc2_).indexOf(place) != -1)
                  {
                     _loc5_ = place;
                  }
                  else
                  {
                     _loc5_ = PlayerManager.Instance.getDressEquipPlace(_loc2_);
                  }
               }
               else if(this.getEquipCellIndex(_loc2_).indexOf(place) != -1)
               {
                  _loc5_ = place;
               }
               else
               {
                  _loc5_ = PlayerManager.Instance.getEquipPlace(_loc2_);
               }
               SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc2_.Place,BagInfo.EQUIPBAG,_loc5_,_loc2_.Count);
               DragManager.acceptDrag(this,DragEffect.MOVE);
            }
            else
            {
               DragManager.acceptDrag(this,DragEffect.NONE);
            }
         }
      }
      
      override protected function createLoading() : void
      {
         super.createLoading();
         PositionUtils.setPos(_loadingasset,"ddt.personalInfocell.loadingPos");
      }
      
      override public function checkOverDate() : void
      {
         if(_bgOverDate)
         {
            _bgOverDate.visible = false;
         }
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.sendDefy();
         }
      }
      
      private function __onBindResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.sendBindDefy();
         }
      }
      
      private function sendDefy() : void
      {
         var _loc1_:int = 0;
         if(PlayerManager.Instance.Self.canEquip(temInfo))
         {
            _loc1_ = PlayerManager.Instance.getDressEquipPlace(temInfo);
            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,temInfo.Place,BagInfo.EQUIPBAG,_loc1_);
         }
      }
      
      private function sendBindDefy() : void
      {
         if(PlayerManager.Instance.Self.canEquip(temInfo))
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,temInfo.Place,BagInfo.EQUIPBAG,_place,temInfo.Count);
         }
      }
      
      private function getCellIndex(param1:ItemTemplateInfo) : Array
      {
         if(EquipType.isWeddingRing(param1))
         {
            return [6];
         }
         switch(param1.CategoryID)
         {
            case EquipType.HEAD:
               return [2];
            case EquipType.GLASS:
               return [8];
            case EquipType.HAIR:
               return [4];
            case EquipType.EFF:
               return [3];
            case EquipType.CLOTH:
               return [0];
            case EquipType.FACE:
               return [1];
            case EquipType.SUITS:
               return [5];
            case EquipType.WING:
               return [7];
            case EquipType.CHATBALL:
               return [9];
            default:
               return [-1];
         }
      }
      
      override public function seteuipQualityBg(param1:int) : void
      {
         if(_euipQualityBg == null)
         {
            _euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.View");
            _euipQualityBg.width = 43;
            _euipQualityBg.height = 42;
            _euipQualityBg.x = 1;
            _euipQualityBg.y = 1;
         }
         if(param1 == 0)
         {
            _euipQualityBg.visible = false;
         }
         else if(param1 == 1)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
         else if(param1 == 2)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
         else if(param1 == 3)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
         else if(param1 == 4)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
         else if(param1 == 5)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
      }
      
      private function getEquipCellIndex(param1:ItemTemplateInfo) : Array
      {
         var _loc2_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
         switch(_loc2_.TemplateType)
         {
            case 1:
               return [10];
            case 2:
               return [11];
            case 3:
               return [12];
            case 4:
               return [13];
            case 5:
               return [14];
            case 6:
               return [15];
            case 7:
               return [16];
            case 8:
               return [17];
            case 9:
               return [18];
            case 10:
               return [19];
            case 11:
               return [20];
            case 12:
               return [21];
            case 13:
               return [22];
            case 14:
               return [23];
            default:
               return [-1];
         }
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            param1.action = DragEffect.NONE;
            super.dragStop(param1);
         }
         locked = false;
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
      }
      
      public function shine() : void
      {
         if(this._shineObject == null)
         {
            this._shineObject = ComponentFactory.Instance.creatCustomObject("asset.core.playerInfoCellShine") as MovieClip;
         }
         addChild(this._shineObject);
         this._shineObject.gotoAndPlay(1);
      }
      
      public function stopShine() : void
      {
         if(this._shineObject != null && this.contains(this._shineObject))
         {
            removeChild(this._shineObject);
         }
         if(this._shineObject != null)
         {
            this._shineObject.gotoAndStop(1);
         }
      }
      
      override public function updateCount() : void
      {
         if(_tbxCount)
         {
            if(_info && itemInfo && itemInfo.Count > 1)
            {
               _tbxCount.text = String(itemInfo.Count);
               _tbxCount.visible = true;
               addChild(_tbxCount);
            }
            else
            {
               _tbxCount.visible = false;
            }
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(this._shineObject != null)
         {
            ObjectUtils.disposeObject(this._shineObject);
         }
         this._shineObject = null;
         if(_euipQualityBg)
         {
            ObjectUtils.disposeObject(_euipQualityBg);
         }
         _euipQualityBg = null;
         super.dispose();
      }
   }
}
