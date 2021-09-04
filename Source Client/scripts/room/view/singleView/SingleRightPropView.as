package room.view.singleView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.StripTip;
   import ddt.data.BagInfo;
   import ddt.data.PropInfo;
   import ddt.data.ShopType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.BagEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.ShopManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import room.view.RoomPropCell;
   
   public class SingleRightPropView extends Sprite implements Disposeable
   {
      
      public static const SINGLE_PROP:Array = [3,4,6,7];
      
      public static const UPCELLS_NUMBER:int = 3;
       
      
      private var _upCells:Array;
      
      private var _upCellsContainer:HBox;
      
      private var _downCellsContainer:SimpleTileList;
      
      private var _secBg:MutipleImage;
      
      private var _roomIdVec:Vector.<Bitmap>;
      
      private var _upCellsStripTip:StripTip;
      
      private var _downCellsStripTip:StripTip;
      
      public function SingleRightPropView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var j:int = 0;
         var item:InventoryItemInfo = null;
         var cell:RoomPropCell = null;
         var info:PropInfo = null;
         var cell1:RoomPropCell = null;
         var cell2:RoomPropCell = null;
         this._secBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.RoomList.SingleRoomView.secbg");
         addChild(this._secBg);
         this._upCellsContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.upCellsContainer");
         addChild(this._upCellsContainer);
         this._downCellsContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroomlist.singleRoom.downCellsContainer",[4]);
         addChild(this._downCellsContainer);
         this._upCells = [];
         var i:int = 0;
         while(i < UPCELLS_NUMBER)
         {
            cell = new RoomPropCell(true,i);
            this._upCellsContainer.addChild(cell);
            this._upCells.push(cell);
            i++;
         }
         var proplist:Vector.<ShopItemInfo> = ShopManager.Instance.getGoodsByType(ShopType.ROOM_PROP);
         j = 0;
         while(j < 8)
         {
            if(SINGLE_PROP.some(function(param1:int, param2:int, param3:Array):Boolean
            {
               if(j == param1)
               {
                  return true;
               }
               return false;
            }))
            {
               if(SavePointManager.Instance.savePoints[28])
               {
                  info = new PropInfo(proplist[j].TemplateInfo);
                  cell1 = new RoomPropCell(false,i);
                  this._downCellsContainer.addChild(cell1);
                  cell1.info = info;
               }
               else
               {
                  cell2 = new RoomPropCell(false,i);
                  this._downCellsContainer.addChild(cell2);
               }
            }
            j++;
         }
         for each(item in PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items)
         {
            this._upCells[item.Place].info = new PropInfo(PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[item.Place]);
         }
         this.creatTipShapeTip();
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateGold);
         PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).addEventListener(BagEvent.UPDATE,this.__updateBag);
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateGold);
         PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).removeEventListener(BagEvent.UPDATE,this.__updateBag);
      }
      
      private function creatTipShapeTip() : void
      {
         this._upCellsStripTip = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.upRightPropTip");
         this._downCellsStripTip = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.downRightPropTip");
         this._upCellsStripTip.tipData = LanguageMgr.GetTranslation("room.roomRightPropView.uppropTip");
         this._downCellsStripTip.tipData = LanguageMgr.GetTranslation("room.roomRightPropView.downpropTip");
         addChild(this._upCellsStripTip);
         addChild(this._downCellsStripTip);
      }
      
      private function __updateGold(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[PlayerInfo.GOLD])
         {
         }
      }
      
      private function __updateBag(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         for each(_loc2_ in param1.changedSlots)
         {
            if(PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[_loc2_.Place] == null)
            {
               this._upCells[_loc2_.Place].info = null;
               break;
            }
            this._upCells[_loc2_.Place].info = new PropInfo(PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[_loc2_.Place]);
         }
      }
      
      private function _cellClick(param1:MouseEvent) : void
      {
         var _loc3_:RoomPropCell = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this._upCells)
         {
            if(_loc3_.info != null)
            {
               _loc2_++;
            }
         }
         if(_loc2_ > UPCELLS_NUMBER)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("room.roomRightPropView.bagFull"));
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         this.removeEvents();
         ObjectUtils.disposeObject(this._secBg);
         this._secBg = null;
         if(this._roomIdVec)
         {
            _loc1_ = 0;
            while(_loc1_ < this._roomIdVec.length)
            {
               ObjectUtils.disposeObject(this._roomIdVec[_loc1_]);
               this._roomIdVec[_loc1_] = null;
               _loc1_++;
            }
            this._roomIdVec = null;
         }
         while(this._upCells.length > 0)
         {
            this._upCells.shift().dispose();
         }
         this._upCells = null;
         this._upCellsContainer.dispose();
         this._upCellsContainer = null;
         this._downCellsContainer.dispose();
         this._downCellsContainer = null;
         if(this._upCellsStripTip)
         {
            ObjectUtils.disposeObject(this._upCellsStripTip);
         }
         this._upCellsStripTip = null;
         if(this._downCellsStripTip)
         {
            ObjectUtils.disposeObject(this._downCellsStripTip);
         }
         this._downCellsStripTip = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
