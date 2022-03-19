// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.singleView.SingleRightPropView

package room.view.singleView
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.container.HBox;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.image.MutipleImage;
    import __AS3__.vec.Vector;
    import flash.display.Bitmap;
    import ddt.command.StripTip;
    import ddt.data.goods.InventoryItemInfo;
    import room.view.RoomPropCell;
    import ddt.data.PropInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.ShopItemInfo;
    import ddt.manager.ShopManager;
    import ddt.data.ShopType;
    import ddt.manager.SavePointManager;
    import ddt.manager.PlayerManager;
    import ddt.data.BagInfo;
    import ddt.events.PlayerPropertyEvent;
    import ddt.events.BagEvent;
    import ddt.manager.LanguageMgr;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.MessageTipManager;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class SingleRightPropView extends Sprite implements Disposeable 
    {

        public static const SINGLE_PROP:Array = [3, 4, 6, 7];
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
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            var j:int;
            var item:InventoryItemInfo;
            var cell:RoomPropCell;
            var info:PropInfo;
            var cell1:RoomPropCell;
            var cell2:RoomPropCell;
            this._secBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.RoomList.SingleRoomView.secbg");
            addChild(this._secBg);
            this._upCellsContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.upCellsContainer");
            addChild(this._upCellsContainer);
            this._downCellsContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroomlist.singleRoom.downCellsContainer", [4]);
            addChild(this._downCellsContainer);
            this._upCells = [];
            var i:int;
            while (i < UPCELLS_NUMBER)
            {
                cell = new RoomPropCell(true, i);
                this._upCellsContainer.addChild(cell);
                this._upCells.push(cell);
                i = (i + 1);
            };
            var proplist:Vector.<ShopItemInfo> = ShopManager.Instance.getGoodsByType(ShopType.ROOM_PROP);
            j = 0;
            while (j < 8)
            {
                if (SINGLE_PROP.some(function (_arg_1:int, _arg_2:int, _arg_3:Array):Boolean
                {
                    if (j == _arg_1)
                    {
                        return (true);
                    };
                    return (false);
                }))
                {
                    if (SavePointManager.Instance.savePoints[28])
                    {
                        info = new PropInfo(proplist[j].TemplateInfo);
                        cell1 = new RoomPropCell(false, i);
                        this._downCellsContainer.addChild(cell1);
                        cell1.info = info;
                    }
                    else
                    {
                        cell2 = new RoomPropCell(false, i);
                        this._downCellsContainer.addChild(cell2);
                    };
                };
                j = (j + 1);
            };
            for each (item in PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items)
            {
                this._upCells[item.Place].info = new PropInfo(PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[item.Place]);
            };
            this.creatTipShapeTip();
        }

        private function initEvents():void
        {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__updateGold);
            PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).addEventListener(BagEvent.UPDATE, this.__updateBag);
        }

        private function removeEvents():void
        {
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__updateGold);
            PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).removeEventListener(BagEvent.UPDATE, this.__updateBag);
        }

        private function creatTipShapeTip():void
        {
            this._upCellsStripTip = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.upRightPropTip");
            this._downCellsStripTip = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.downRightPropTip");
            this._upCellsStripTip.tipData = LanguageMgr.GetTranslation("room.roomRightPropView.uppropTip");
            this._downCellsStripTip.tipData = LanguageMgr.GetTranslation("room.roomRightPropView.downpropTip");
            addChild(this._upCellsStripTip);
            addChild(this._downCellsStripTip);
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
            ObjectUtils.disposeObject(this._secBg);
            this._secBg = null;
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
            while (this._upCells.length > 0)
            {
                this._upCells.shift().dispose();
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
}//package room.view.singleView

