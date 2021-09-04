package store.view.strength
{
   import bagAndInfo.cell.CellContentCreator;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.StoneType;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import store.StoreCell;
   
   public class StreangthItemCell extends StoreCell
   {
       
      
      private var _stoneType:String = "";
      
      private var _actionState:Boolean;
      
      public function StreangthItemCell(param1:int)
      {
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG");
         _loc2_.addChild(_loc3_);
         super(_loc2_,param1);
         setContentSize(68,68);
         this.PicPos = new Point(15,27);
      }
      
      public function set stoneType(param1:String) : void
      {
         this._stoneType = param1;
      }
      
      public function set actionState(param1:Boolean) : void
      {
         this._actionState = param1;
      }
      
      public function get actionState() : Boolean
      {
         return this._actionState;
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_ && param1.action != DragEffect.SPLIT)
         {
            param1.action = DragEffect.NONE;
            if(_loc2_.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
            }
            else if(_loc2_.CanStrengthen && this.isAdaptToStone(_loc2_))
            {
               if(_loc2_.StrengthenLevel >= ItemManager.Instance.getEquipLimitLevel(_loc2_.TemplateID))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
                  return;
               }
               SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,index,1);
               this._actionState = true;
               param1.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
               this.reset();
            }
            else if(this.isAdaptToStone(_loc2_))
            {
            }
         }
      }
      
      private function isAdaptToStone(param1:InventoryItemInfo) : Boolean
      {
         if(this._stoneType == "")
         {
            return true;
         }
         if(this._stoneType == StoneType.STRENGTH && param1.RefineryLevel <= 0)
         {
            return true;
         }
         if(this._stoneType == StoneType.STRENGTH_1 && param1.RefineryLevel > 0)
         {
            return true;
         }
         return false;
      }
      
      private function reset() : void
      {
         this._stoneType = "";
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         var _loc2_:EquipmentTemplateInfo = null;
         if(_info == param1 && !_info)
         {
            return;
         }
         if(_info)
         {
            clearCreatingContent();
            ObjectUtils.disposeObject(_pic);
            _pic = null;
            clearLoading();
            _tipData = null;
            locked = false;
         }
         _info = param1;
         if(_info)
         {
            if(_showLoading)
            {
               createLoading();
            }
            _pic = new CellContentCreator();
            _pic.info = _info;
            _pic.loadSync(createContentComplete);
            addChild(_pic);
            tipStyle = "ddtstore.StrengthTips";
            _tipData = new ItemTemplateInfo();
            _tipData = info;
         }
         updateCount();
         checkOverDate();
         if(_info is InventoryItemInfo)
         {
            this.locked = this._info["lock"];
         }
         if(_info == null)
         {
            _loc2_ = null;
            this.seteuipQualityBg(0);
         }
         if(_info != null)
         {
            _loc2_ = ItemManager.Instance.getEquipTemplateById(_info.TemplateID);
         }
         if(_loc2_ != null && _info.Property8 == "0")
         {
            this.seteuipQualityBg(_loc2_.QualityID);
         }
         else
         {
            this.seteuipQualityBg(0);
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      override public function seteuipQualityBg(param1:int) : void
      {
         if(_euipQualityBg == null)
         {
            _euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
         }
         _euipQualityBg.width = 68;
         _euipQualityBg.height = 68;
         _euipQualityBg.x = 13;
         _euipQualityBg.y = 25;
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
      
      override public function dispose() : void
      {
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
