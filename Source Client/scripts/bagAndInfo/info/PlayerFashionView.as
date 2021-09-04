package bagAndInfo.info
{
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.PersonalInfoCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
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
   
   public class PlayerFashionView extends Sprite implements Disposeable
   {
       
      
      private var _info:PlayerInfo;
      
      private var _bagInfo:BagInfo;
      
      private var _cellPos:Array;
      
      private var _bg:Bitmap;
      
      private var _cellContent:Sprite;
      
      private var _cells:Vector.<PersonalInfoCell>;
      
      private var _cellNames:Vector.<FilterFrameText>;
      
      private var _showSelfOperation:Boolean;
      
      public function PlayerFashionView()
      {
         super();
         this.initView();
         this.initPos();
         this.creatCells();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("bagAndInfo.Fashionview.bg");
         addChild(this._bg);
         this._cellContent = new Sprite();
         addChild(this._cellContent);
         this._cellNames = new Vector.<FilterFrameText>();
         this.initName();
      }
      
      private function initName() : void
      {
         var _loc2_:Point = null;
         var _loc3_:FilterFrameText = null;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.FashionCellName.pos" + _loc1_.toString());
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.FashionName.text");
            _loc3_.text = LanguageMgr.GetTranslation("ddtbagAndInfo.FashionName.txt" + _loc1_.toString());
            _loc3_.x = _loc2_.x;
            _loc3_.y = _loc2_.y;
            addChild(_loc3_);
            this._cellNames.push(_loc3_);
            _loc1_++;
         }
      }
      
      private function initPos() : void
      {
         this._cellPos = [ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos1"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos2"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos3"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos4"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos5"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos6"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos7"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos8"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos9"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.Fashion.pos10")];
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
         this._info = param1;
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
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
         if(this._bagInfo)
         {
            this._bagInfo.addEventListener(BagEvent.UPDATE,this.__updateCells);
         }
         this.updateCells();
      }
      
      public function get bagInfo() : BagInfo
      {
         return this._bagInfo;
      }
      
      private function creatCells() : void
      {
         var _loc1_:int = 0;
         var _loc2_:PersonalInfoCell = null;
         this._cells = new Vector.<PersonalInfoCell>();
         _loc1_ = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = CellFactory.instance.createPersonalInfoCell(_loc1_) as PersonalInfoCell;
            _loc2_.addEventListener(CellEvent.ITEM_CLICK,this.__cellClickHandler);
            _loc2_.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClickHandler);
            _loc2_.x = this._cellPos[_loc1_].x;
            _loc2_.y = this._cellPos[_loc1_].y;
            this._cellContent.addChild(_loc2_);
            this._cells.push(_loc2_);
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
         for(_loc2_ in param1.changedSlots)
         {
            _loc3_ = int(_loc2_);
            if(_loc3_ <= BagInfo.PERSONAL_EQUIP_COUNT)
            {
               if(_loc3_ >= 10)
               {
                  return;
               }
               this._cells[_loc3_].info = this._bagInfo.getItemAt(_loc3_);
               if(this._cells[_loc3_].info == null)
               {
                  this._cellNames[_loc3_].visible = true;
               }
               else
               {
                  this._cellNames[_loc3_].visible = false;
               }
               if(SavePointManager.Instance.isInSavePoint(64))
               {
                  if(this._cells[_loc3_].info)
                  {
                     SavePointManager.Instance.setSavePoint(64);
                     NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TO_EQUIP);
                     NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_FASHION_BTN);
                     dispatchEvent(new BagEvent(BagEvent.FASHION_READY,new Dictionary()));
                  }
                  else
                  {
                     dispatchEvent(new BagEvent(BagEvent.FASHION_REMOVE,new Dictionary()));
                  }
               }
            }
         }
      }
      
      private function updateCells() : void
      {
         var _loc1_:PersonalInfoCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.info = this._info == null ? null : this._bagInfo.getItemAt(_loc1_.place);
            if(_loc1_.info == null)
            {
               this._cellNames[_loc1_.place].visible = true;
            }
            else
            {
               this._cellNames[_loc1_.place].visible = false;
            }
         }
      }
      
      private function clearCells() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._cells.length)
         {
            if(this._cells[_loc1_])
            {
               this._cells[_loc1_].removeEventListener(CellEvent.ITEM_CLICK,this.__cellClickHandler);
               this._cells[_loc1_].removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClickHandler);
               if(this._cells[_loc1_].parent)
               {
                  this._cells[_loc1_].parent.removeChild(this._cells[_loc1_] as PersonalInfoCell);
               }
               this._cells[_loc1_].dispose();
               this._cells[_loc1_] = null;
            }
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._cellNames.length)
         {
            if(this._cellNames[_loc2_])
            {
               this._cellNames[_loc2_].dispose();
               this._cellNames[_loc2_] = null;
            }
            _loc2_++;
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
      
      public function startShine(param1:ItemTemplateInfo) : void
      {
         var _loc2_:Array = this.getCellIndex(param1).split(",");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(int(_loc2_[_loc3_]) >= 0)
            {
               (this._cells[int(_loc2_[_loc3_])] as PersonalInfoCell).shine();
            }
            _loc3_++;
         }
      }
      
      public function stopShine() : void
      {
         var _loc1_:PersonalInfoCell = null;
         for each(_loc1_ in this._cells)
         {
            (_loc1_ as PersonalInfoCell).stopShine();
         }
      }
      
      private function getCellIndex(param1:ItemTemplateInfo) : String
      {
         if(EquipType.isRingEquipment(param1))
         {
            return "6";
         }
         switch(param1.CategoryID)
         {
            case EquipType.HEAD:
               return "2";
            case EquipType.GLASS:
               return "8";
            case EquipType.HAIR:
               return "4";
            case EquipType.EFF:
               return "3";
            case EquipType.CLOTH:
               return "0";
            case EquipType.FACE:
               return "1";
            case EquipType.SUITS:
               return "5";
            case EquipType.WING:
               return "7";
            case EquipType.CHATBALL:
               return "9";
            default:
               return "-1";
         }
      }
      
      public function dispose() : void
      {
         this.clearCells();
         this.removeEvent();
         if(parent)
         {
            parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeAllChildren(this._cellContent);
         this._cellContent = null;
         this._cells = null;
         this._info = null;
         this._bagInfo = null;
      }
   }
}
