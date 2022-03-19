// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.RoomRightPropView

package room.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.container.HBox;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.command.StripTip;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.PropInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.manager.ShopManager;
    import ddt.data.ShopType;
    import ddt.data.goods.ShopItemInfo;
    import ddt.manager.PlayerManager;
    import ddt.data.BagInfo;
    import room.RoomManager;
    import hall.FightPowerAndFatigue;
    import ddt.utils.PositionUtils;
    import flash.geom.Point;
    import ddt.events.PlayerPropertyEvent;
    import ddt.events.BagEvent;
    import ddt.events.RoomEvent;
    import ddt.manager.LanguageMgr;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.MessageTipManager;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

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
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            var _local_4:InventoryItemInfo;
            var _local_5:RoomPropCell;
            var _local_6:PropInfo;
            var _local_7:RoomPropCell;
            this._upCellsContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.upCellsContainer");
            this._downCellsContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.downCellsContainer", [4]);
            this._roomWordAsset = ComponentFactory.Instance.creatBitmap("asset.ddtroom.roomWordAsset");
            if (((StateManager.currentStateType == StateType.MATCH_ROOM) || (StateManager.currentStateType == StateType.CHALLENGE_ROOM)))
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
            };
            addChild(this._roomWordAsset);
            this._upCells = [];
            var _local_1:int;
            while (_local_1 < UPCELLS_NUMBER)
            {
                _local_5 = new RoomPropCell(true, _local_1);
                this._upCellsContainer.addChild(_local_5);
                this._upCells.push(_local_5);
                _local_1++;
            };
            var _local_2:Vector.<ShopItemInfo> = ShopManager.Instance.getGoodsByType(ShopType.ROOM_PROP);
            var _local_3:int;
            while (_local_3 < 4)
            {
                _local_6 = new PropInfo(_local_2[_local_3].TemplateInfo);
                _local_7 = new RoomPropCell(false, _local_1);
                this._downCellsContainer.addChild(_local_7);
                _local_7.info = _local_6;
                _local_3++;
            };
            for each (_local_4 in PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items)
            {
                this._upCells[_local_4.Place].info = new PropInfo(PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[_local_4.Place]);
            };
            this.roomId = RoomManager.Instance.current.ID;
            this.creatTipShapeTip();
            FightPowerAndFatigue.Instance.show();
        }

        private function set roomId(_arg_1:int):void
        {
            var _local_4:int;
            var _local_2:String = _arg_1.toString();
            this._roomIdVec = new Vector.<Bitmap>(_local_2.length);
            var _local_3:Point = PositionUtils.creatPoint(("asset.ddtroom.idPos" + _local_2.length));
            _local_4 = 0;
            while (_local_4 < _local_2.length)
            {
                this._roomIdVec[_local_4] = ComponentFactory.Instance.creatBitmap(("asset.ddtroom.roomNumber" + _local_2.charAt(_local_4)));
                this._roomIdVec[_local_4].x = (_local_3.x + ((this._roomIdVec[_local_4].width - 2) * _local_4));
                this._roomIdVec[_local_4].y = _local_3.y;
                addChild(this._roomIdVec[_local_4]);
                _local_4++;
            };
        }

        private function initEvents():void
        {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__updateGold);
            PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).addEventListener(BagEvent.UPDATE, this.__updateBag);
            RoomManager.Instance.current.addEventListener(RoomEvent.ROOM_NAME_CHANGED, this._roomNameChanged);
        }

        private function removeEvents():void
        {
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__updateGold);
            PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).removeEventListener(BagEvent.UPDATE, this.__updateBag);
            RoomManager.Instance.current.removeEventListener(RoomEvent.ROOM_NAME_CHANGED, this._roomNameChanged);
        }

        private function _roomNameChanged(_arg_1:RoomEvent):void
        {
        }

        private function creatTipShapeTip():void
        {
            this._upCellsStripTip = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.upRightPropTip");
            this._downCellsStripTip = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.downRightPropTip");
            this._upCellsStripTip.tipData = LanguageMgr.GetTranslation("room.roomRightPropView.uppropTip");
            this._downCellsStripTip.tipData = LanguageMgr.GetTranslation("room.roomRightPropView.downpropTip");
            if (((StateManager.currentStateType == StateType.MATCH_ROOM) || (StateManager.currentStateType == StateType.CHALLENGE_ROOM)))
            {
                addChild(this._upCellsStripTip);
                addChild(this._downCellsStripTip);
            };
        }

        private function __updateGold(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties[PlayerInfo.GOLD])
            {
            };
        }

        private function __updateBag(_arg_1:BagEvent):void
        {
            var _local_2:InventoryItemInfo;
            for each (_local_2 in _arg_1.changedSlots)
            {
                if (PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[_local_2.Place] == null)
                {
                    this._upCells[_local_2.Place].info = null;
                    break;
                };
                this._upCells[_local_2.Place].info = new PropInfo(PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[_local_2.Place]);
            };
        }

        private function _cellClick(_arg_1:MouseEvent):void
        {
            var _local_3:RoomPropCell;
            var _local_2:int;
            for each (_local_3 in this._upCells)
            {
                if (_local_3.info != null)
                {
                    _local_2++;
                };
            };
            if (_local_2 > UPCELLS_NUMBER)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("room.roomRightPropView.bagFull"));
            };
        }

        public function dispose():void
        {
            var _local_1:int;
            this.removeEvents();
            removeChild(this._bg);
            this._bg = null;
            FightPowerAndFatigue.Instance.hide();
            if (this._roomWordAsset)
            {
                ObjectUtils.disposeObject(this._roomWordAsset);
            };
            this._roomWordAsset = null;
            if (this._roomIdVec)
            {
                _local_1 = 0;
                while (_local_1 < this._roomIdVec.length)
                {
                    ObjectUtils.disposeObject(this._roomIdVec[_local_1]);
                    this._roomIdVec[_local_1] = null;
                    _local_1++;
                };
                this._roomIdVec = null;
            };
            this._upCells = null;
            this._upCellsContainer.dispose();
            this._upCellsContainer = null;
            this._downCellsContainer.dispose();
            this._downCellsContainer = null;
            if (this._upCellsStripTip)
            {
                ObjectUtils.disposeObject(this._upCellsStripTip);
            };
            this._upCellsStripTip = null;
            if (this._downCellsStripTip)
            {
                ObjectUtils.disposeObject(this._downCellsStripTip);
            };
            this._downCellsStripTip = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view

