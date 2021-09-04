package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
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
   import ddt.events.RoomEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import hall.FightPowerAndFatigue;
   import room.RoomManager;
   
   public class RoomRightPropView extends Sprite implements Disposeable
   {
      
      public static const UPCELLS_NUMBER:int = 3;
       
      
      private var _bg:Bitmap;
      
      private var _upCells:Array;
      
      private var _upCellsContainer:HBox;
      
      private var _downCellsContainer:SimpleTileList;
      
      private var _roomIdVec:Vector.<Bitmap>;
      
      private var _goldInfoTxt:FilterFrameText;
      
      private var _upCellsStripTip:StripTip;
      
      private var _downCellsStripTip:StripTip;
      
      private var _roomWordAsset:Bitmap;
      
      public function RoomRightPropView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:RoomPropCell = null;
         var _loc6_:PropInfo = null;
         var _loc7_:RoomPropCell = null;
         this._upCellsContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.upCellsContainer");
         this._downCellsContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.downCellsContainer",[4]);
         this._roomWordAsset = ComponentFactory.Instance.creatBitmap("asset.ddtroom.roomWordAsset");
         if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.background.room.leftBg");
            addChild(this._bg);
            addChild(this._upCellsContainer);
            addChild(this._downCellsContainer);
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.background.dungeonroom.leftBg");
            addChild(this._bg);
         }
         addChild(this._roomWordAsset);
         this._upCells = [];
         var _loc1_:int = 0;
         while(_loc1_ < UPCELLS_NUMBER)
         {
            _loc5_ = new RoomPropCell(true,_loc1_);
            this._upCellsContainer.addChild(_loc5_);
            this._upCells.push(_loc5_);
            _loc1_++;
         }
         var _loc2_:Vector.<ShopItemInfo> = ShopManager.Instance.getGoodsByType(ShopType.ROOM_PROP);
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            _loc6_ = new PropInfo(_loc2_[_loc3_].TemplateInfo);
            _loc7_ = new RoomPropCell(false,_loc1_);
            this._downCellsContainer.addChild(_loc7_);
            _loc7_.info = _loc6_;
            _loc3_++;
         }
         for each(_loc4_ in PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items)
         {
            this._upCells[_loc4_.Place].info = new PropInfo(PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[_loc4_.Place]);
         }
         this.roomId = RoomManager.Instance.current.ID;
         this.creatTipShapeTip();
         FightPowerAndFatigue.Instance.show();
      }
      
      private function set roomId(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc2_:String = param1.toString();
         this._roomIdVec = new Vector.<Bitmap>(_loc2_.length);
         var _loc3_:Point = PositionUtils.creatPoint("asset.ddtroom.idPos" + _loc2_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            this._roomIdVec[_loc4_] = ComponentFactory.Instance.creatBitmap("asset.ddtroom.roomNumber" + _loc2_.charAt(_loc4_));
            this._roomIdVec[_loc4_].x = _loc3_.x + (this._roomIdVec[_loc4_].width - 2) * _loc4_;
            this._roomIdVec[_loc4_].y = _loc3_.y;
            addChild(this._roomIdVec[_loc4_]);
            _loc4_++;
         }
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateGold);
         PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).addEventListener(BagEvent.UPDATE,this.__updateBag);
         RoomManager.Instance.current.addEventListener(RoomEvent.ROOM_NAME_CHANGED,this._roomNameChanged);
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateGold);
         PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).removeEventListener(BagEvent.UPDATE,this.__updateBag);
         RoomManager.Instance.current.removeEventListener(RoomEvent.ROOM_NAME_CHANGED,this._roomNameChanged);
      }
      
      private function _roomNameChanged(param1:RoomEvent) : void
      {
      }
      
      private function creatTipShapeTip() : void
      {
         this._upCellsStripTip = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.upRightPropTip");
         this._downCellsStripTip = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.downRightPropTip");
         this._upCellsStripTip.tipData = LanguageMgr.GetTranslation("room.roomRightPropView.uppropTip");
         this._downCellsStripTip.tipData = LanguageMgr.GetTranslation("room.roomRightPropView.downpropTip");
         if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM)
         {
            addChild(this._upCellsStripTip);
            addChild(this._downCellsStripTip);
         }
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
         removeChild(this._bg);
         this._bg = null;
         FightPowerAndFatigue.Instance.hide();
         if(this._roomWordAsset)
         {
            ObjectUtils.disposeObject(this._roomWordAsset);
         }
         this._roomWordAsset = null;
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
