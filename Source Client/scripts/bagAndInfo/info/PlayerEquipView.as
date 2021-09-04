package bagAndInfo.info
{
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.EquipLock;
   import bagAndInfo.cell.PersonalInfoCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class PlayerEquipView extends Sprite implements Disposeable
   {
       
      
      private var _info:PlayerInfo;
      
      private var _bagInfo:BagInfo;
      
      private var _cellPos:Array;
      
      private var _bg:Bitmap;
      
      private var _cellContent:Sprite;
      
      private var _cells:Vector.<PersonalInfoCell>;
      
      private var _showSelfOperation:Boolean;
      
      private var _lockCell:Vector.<EquipLock>;
      
      private var _lockPos:Array;
      
      public function PlayerEquipView()
      {
         super();
         this.initView();
         this.initPos();
         this.initLockPos();
         this.creatCells();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("bagAndInfo.Equipview.bg");
         addChild(this._bg);
         this._cellContent = new Sprite();
         addChild(this._cellContent);
      }
      
      private function initPos() : void
      {
         this._cellPos = ["","","","","","","","","","",ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos1"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos2"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos5"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos6"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos8"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos7"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos9"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos10"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos11"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos12"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos13"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos14")];
      }
      
      private function initLockPos() : void
      {
         this._lockPos = [ComponentFactory.Instance.creatCustomObject("bagAndInfo.lockCell.pos0"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.lockCell.pos1"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.lockCell.pos2"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.lockCell.pos3")];
      }
      
      private function removeEvent() : void
      {
         if(this._bagInfo)
         {
            this._bagInfo.removeEventListener(BagEvent.UPDATE,this.__updateCells);
         }
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         if(this._info == param1)
         {
            return;
         }
         if(this.info)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__proertyChange);
            this._info = null;
         }
         this._info = param1;
         if(this._info && PlayerManager.Instance.playerstate == PlayerViewState.EQUIP)
         {
            if(this._info.ID == PlayerManager.Instance.Self.ID)
            {
               this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__proertyChange);
            }
         }
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
            this.creatLockCells();
         }
      }
      
      public function set bagInfo(param1:BagInfo) : void
      {
         if(this._bagInfo == param1)
         {
            return;
         }
         if(this._bagInfo)
         {
            this._bagInfo.removeEventListener(BagEvent.UPDATE,this.__updateCells);
            this._bagInfo = null;
         }
         this._bagInfo = param1;
         if(this._info && PlayerManager.Instance.playerstate == PlayerViewState.EQUIP)
         {
            this._bagInfo.addEventListener(BagEvent.UPDATE,this.__updateCells);
         }
         this.updateCells();
      }
      
      public function get bagInfo() : BagInfo
      {
         return this._bagInfo;
      }
      
      private function __proertyChange(param1:PlayerPropertyEvent) : void
      {
         this.updateLockCells();
      }
      
      private function creatCells() : void
      {
         var _loc1_:PersonalInfoCell = null;
         var _loc2_:int = 0;
         this._cells = new Vector.<PersonalInfoCell>();
         _loc2_ = 0;
         while(_loc2_ < 22)
         {
            if(_loc2_ >= 10)
            {
               _loc1_ = CellFactory.instance.createPersonalInfoCell(_loc2_) as PersonalInfoCell;
               _loc1_.addEventListener(CellEvent.ITEM_CLICK,this.__cellClickHandler);
               _loc1_.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClickHandler);
               _loc1_.x = this._cellPos[_loc2_].x;
               _loc1_.y = this._cellPos[_loc2_].y;
               this._cellContent.addChild(_loc1_);
               this._cells.push(_loc1_);
            }
            else
            {
               _loc1_ = CellFactory.instance.createPersonalInfoCell(0) as PersonalInfoCell;
               this._cells.push(_loc1_);
            }
            _loc2_++;
         }
      }
      
      private function creatLockCells() : void
      {
         var _loc1_:int = 0;
         var _loc2_:EquipLock = null;
         this._lockCell = new Vector.<EquipLock>(4);
         _loc1_ = 0;
         while(_loc1_ < this._lockCell.length)
         {
            _loc2_ = new EquipLock();
            if(_loc1_ == 0 && PlayerManager.Instance.Self.Grade < 25)
            {
               addChild(_loc2_);
               this._lockCell[_loc1_] = _loc2_;
            }
            else if(_loc1_ == 1 && PlayerManager.Instance.Self.Grade < 30)
            {
               addChild(_loc2_);
               this._lockCell[_loc1_] = _loc2_;
            }
            else if(_loc1_ == 2 && PlayerManager.Instance.Self.Grade < 35)
            {
               addChild(_loc2_);
               this._lockCell[_loc1_] = _loc2_;
            }
            else if(_loc1_ == 3 && PlayerManager.Instance.Self.Grade < 40)
            {
               addChild(_loc2_);
               this._lockCell[_loc1_] = _loc2_;
            }
            _loc2_.x = this._lockPos[_loc1_].x;
            _loc2_.y = this._lockPos[_loc1_].y;
            _loc2_.tipStyle = "ddt.view.tips.OneLineTip";
            _loc2_.tipData = _loc2_.gettipData(_loc1_);
            _loc2_.tipDirctions = "0,3,7";
            _loc1_++;
         }
      }
      
      public function get showSelfOperation() : Boolean
      {
         return this._showSelfOperation;
      }
      
      public function set showSelfOperation(param1:Boolean) : void
      {
         this._showSelfOperation = param1;
      }
      
      private function clearCells() : void
      {
         var _loc1_:PersonalInfoCell = null;
         while(this._cells.length > 0)
         {
            _loc1_ = this._cells.shift();
            _loc1_.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClickHandler);
            _loc1_.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClickHandler);
            _loc1_.dispose();
            _loc1_ = null;
         }
      }
      
      private function updateLockCells() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._lockCell.length)
         {
            if(this._lockCell[_loc1_])
            {
               if(_loc1_ == 0 && PlayerManager.Instance.Self.Grade >= 25)
               {
                  if(this._lockCell[_loc1_].parent)
                  {
                     this._lockCell[_loc1_].parent.removeChild(this._lockCell[_loc1_] as EquipLock);
                     this._lockCell[_loc1_].dispose();
                     this._lockCell[_loc1_] = null;
                  }
               }
               else if(_loc1_ == 1 && PlayerManager.Instance.Self.Grade >= 30)
               {
                  if(this._lockCell[_loc1_].parent)
                  {
                     this._lockCell[_loc1_].parent.removeChild(this._lockCell[_loc1_] as EquipLock);
                     this._lockCell[_loc1_].dispose();
                     this._lockCell[_loc1_] = null;
                  }
               }
               else if(_loc1_ == 2 && PlayerManager.Instance.Self.Grade >= 35)
               {
                  if(this._lockCell[_loc1_].parent)
                  {
                     this._lockCell[_loc1_].parent.removeChild(this._lockCell[_loc1_] as EquipLock);
                     this._lockCell[_loc1_].dispose();
                     this._lockCell[_loc1_] = null;
                  }
               }
               else if(_loc1_ == 3 && PlayerManager.Instance.Self.Grade >= 40)
               {
                  if(this._lockCell[_loc1_].parent)
                  {
                     this._lockCell[_loc1_].parent.removeChild(this._lockCell[_loc1_] as EquipLock);
                     this._lockCell[_loc1_].dispose();
                     this._lockCell[_loc1_] = null;
                  }
               }
            }
            _loc1_++;
         }
      }
      
      private function clearLockCells() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._lockCell.length)
         {
            if(this._lockCell[_loc1_])
            {
               this._lockCell[_loc1_].parent.removeChild(this._lockCell[_loc1_] as EquipLock);
               this._lockCell[_loc1_].dispose();
               this._lockCell[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      private function __cellClickHandler(param1:CellEvent) : void
      {
         var _loc2_:PersonalInfoCell = null;
         if(this._showSelfOperation)
         {
            _loc2_ = param1.data as PersonalInfoCell;
            _loc2_.dragStart();
         }
      }
      
      private function __cellDoubleClickHandler(param1:CellEvent) : void
      {
         var _loc2_:PersonalInfoCell = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:int = 0;
         if(this._showSelfOperation)
         {
            _loc2_ = param1.data as PersonalInfoCell;
            if(_loc2_ && _loc2_.info)
            {
               _loc3_ = _loc2_.info as InventoryItemInfo;
               _loc4_ = this._info.Bag.itemBagNumber;
               if(PlayerManager.Instance.Self.Bag.itemBagFull())
               {
                  return MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.moveGooDtips"));
               }
               PlayerManager.Instance.Self.bagVibleType = 0;
               SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc3_.Place,BagInfo.EQUIPBAG,-1,_loc3_.Count);
            }
         }
      }
      
      private function __updateCells(param1:BagEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:EquipmentTemplateInfo = null;
         for(_loc2_ in param1.changedSlots)
         {
            _loc3_ = int(_loc2_);
            if(_loc3_ <= BagInfo.PERSONAL_EQUIP_COUNT)
            {
               this._cells[_loc3_].info = this._bagInfo.getItemAt(_loc3_);
               if(this._cells[_loc3_].info == null)
               {
                  this._cells[_loc3_].seteuipQualityBg(0);
               }
               else if(this._cells[_loc3_].info != null)
               {
                  _loc4_ = ItemManager.Instance.getEquipTemplateById(this._cells[_loc3_].info.TemplateID);
                  if(_loc4_ != null && this._cells[_loc3_].info.Property8 == "0")
                  {
                     this._cells[_loc3_].seteuipQualityBg(_loc4_.QualityID);
                  }
                  else
                  {
                     this._cells[_loc3_].seteuipQualityBg(0);
                  }
               }
               if(SavePointManager.Instance.isInSavePoint(33))
               {
                  if(this._cells[_loc3_].info != null)
                  {
                     if(this._cells[_loc3_].info.CategoryID == EquipType.EQUIP)
                     {
                        NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TO_EQUIP);
                        NewHandContainer.Instance.showArrow(ArrowType.CLICK_FASHION_BTN,45,"trainer.clickFashionTipPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                        dispatchEvent(new BagEvent(BagEvent.WEAPON_READY,new Dictionary()));
                     }
                  }
                  else
                  {
                     NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_FASHION_BTN);
                     dispatchEvent(new BagEvent(BagEvent.WEAPON_REMOVE,new Dictionary()));
                  }
               }
            }
         }
      }
      
      private function updateCells() : void
      {
         var _loc1_:PersonalInfoCell = null;
         var _loc2_:EquipmentTemplateInfo = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.info = this._info == null ? null : this._bagInfo.getItemAt(_loc1_.place);
            if(_loc1_.info == null)
            {
               _loc2_ = null;
            }
            if(_loc1_.info != null)
            {
               _loc2_ = ItemManager.Instance.getEquipTemplateById(_loc1_.info.TemplateID);
            }
            if(_loc2_ != null && _loc1_.info.Property8 == "0")
            {
               _loc1_.seteuipQualityBg(_loc2_.QualityID);
            }
            else
            {
               _loc1_.seteuipQualityBg(0);
            }
            if(SavePointManager.Instance.isInSavePoint(64))
            {
               if(_loc1_.place == 14)
               {
                  if(_loc1_.info)
                  {
                     NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_FASHION_BTN);
                     dispatchEvent(new BagEvent(BagEvent.WEAPON_READY,new Dictionary()));
                     NewHandContainer.Instance.showArrow(ArrowType.CLICK_FASHION_BTN,45,"trainer.clickFashionTipPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                  }
               }
            }
         }
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      public function startShine(param1:ItemTemplateInfo) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
         if(_loc2_ == null && !EquipType.isWeddingRing(param1))
         {
            return;
         }
         if(_loc2_.TemplateType == 8 && PlayerManager.Instance.Self.Grade < 30)
         {
            return;
         }
         if(_loc2_.TemplateType == 9 && PlayerManager.Instance.Self.Grade < 35)
         {
            return;
         }
         if(_loc2_.TemplateType == 10 && PlayerManager.Instance.Self.Grade < 40)
         {
            return;
         }
         if(EquipType.isWeddingRing(param1))
         {
            _loc3_ = this.getWeddingRingIndex().split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(int(_loc3_[_loc6_]) >= 0)
               {
                  (this._cells[int(_loc3_[_loc6_])] as PersonalInfoCell).shine();
               }
               _loc4_++;
            }
         }
         if((param1.NeedSex == 0 || param1.NeedSex == (!!PlayerManager.Instance.Self.Sex ? 1 : 2)) && !EquipType.isWeddingRing(param1))
         {
            _loc5_ = this.getCellIndex(_loc2_).split(",");
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               if(int(_loc5_[_loc6_]) >= 0)
               {
                  (this._cells[int(_loc5_[_loc6_])] as PersonalInfoCell).shine();
               }
               _loc6_++;
            }
         }
      }
      
      private function getWeddingRingIndex() : String
      {
         return "16";
      }
      
      public function stopShine() : void
      {
         var _loc1_:PersonalInfoCell = null;
         for each(_loc1_ in this._cells)
         {
            (_loc1_ as PersonalInfoCell).stopShine();
         }
      }
      
      private function getCellIndex(param1:EquipmentTemplateInfo) : String
      {
         switch(param1.TemplateType)
         {
            case 1:
               return "10";
            case 2:
               return "11";
            case 3:
               return "12";
            case 4:
               return "13";
            case 6:
               return "15";
            case 5:
               return "14";
            case 7:
               return "16";
            case 8:
               return "17";
            case 9:
               return "18";
            case 10:
               return "19";
            case 11:
               return "20";
            case 13:
               return "22";
            case 14:
               return "21";
            default:
               return "-1";
         }
      }
      
      public function getCellPos(param1:int) : Point
      {
         return localToGlobal(new Point(this._cellPos[param1].x,this._cellPos[param1].y));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearCells();
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
            this.clearLockCells();
         }
         this._cells = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._cellContent);
         this._cellContent = null;
         this._info = null;
         this._bagInfo = null;
      }
   }
}
