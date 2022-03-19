// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionCellView

package auctionHouse.view
{
    import bagAndInfo.cell.LinkedBagCell;
    import flash.geom.Rectangle;
    import ddt.data.goods.InventoryItemInfo;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import bagAndInfo.cell.LockBagCell;
    import auctionHouse.event.AuctionSellEvent;
    import ddt.manager.DragManager;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class AuctionCellView extends LinkedBagCell 
    {

        public static const SELECT_BID_GOOD:String = "selectBidGood";
        public static const SELECT_GOOD:String = "selectGood";
        public static const CELL_MOUSEOVER:String = "Cell_mouseOver";
        public static const CELL_MOUSEOUT:String = "Cell_mouseOut";

        private var _picRect:Rectangle;
        private var _temporaryInfo:InventoryItemInfo;
        private var _temporaryCount:int;
        private var _goodsCount:int = 1;

        public function AuctionCellView()
        {
            var _local_1:Sprite = new Sprite();
            _local_1.addChild(ComponentFactory.Instance.creatBitmap("asset.auctionHouse.CellBgIIAsset"));
            super(_local_1);
            tipDirctions = "7";
            (_bg as Sprite).graphics.beginFill(0, 0);
            (_bg as Sprite).graphics.drawRect(-5, -5, 203, 55);
            (_bg as Sprite).graphics.endFill();
            this._picRect = ComponentFactory.Instance.creatCustomObject("auctionHouse.sell.cell.PicRect");
            PicPos = this._picRect.topLeft;
        }

        override protected function createChildren():void
        {
            super.createChildren();
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_3:AuctionSellLeftAler;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                _arg_1.action = DragEffect.NONE;
                if (_arg_1.action == DragEffect.NONE)
                {
                    locked = false;
                };
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (((_local_2) && (!(_arg_1.action == DragEffect.SPLIT))))
            {
                _arg_1.action = DragEffect.NONE;
                if (_local_2.getRemainDate() <= 0)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionCellView.Object"));
                }
                else
                {
                    if (_local_2.IsBinds)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionCellView.Sale"));
                    }
                    else
                    {
                        this._goodsCount = 1;
                        lockBagCell = (_arg_1.source as LockBagCell);
                        this._temporaryCount = lockBagCell.itemInfo.Count;
                        this._temporaryInfo = lockBagCell.itemInfo;
                        if (lockBagCell.itemInfo.Count > 1)
                        {
                            _local_3 = ComponentFactory.Instance.creat("auctionHouse.AuctionSellLeftAler");
                            _local_3.show(this._temporaryInfo.Count);
                            _local_3.addEventListener(AuctionSellEvent.SELL, this._alerSell);
                            _local_3.addEventListener(AuctionSellEvent.NOTSELL, this._alerNotSell);
                        };
                        DragManager.acceptDrag(lockBagCell, DragEffect.LINK);
                    };
                };
            };
        }

        private function _alerSell(_arg_1:AuctionSellEvent):void
        {
            var _local_2:AuctionSellLeftAler = (_arg_1.currentTarget as AuctionSellLeftAler);
            this._goodsCount = _arg_1.sellCount;
            this._temporaryInfo.Count = _arg_1.sellCount;
            info = this._temporaryInfo;
            if (lockBagCell)
            {
                lockBagCell.itemInfo.Count = this._temporaryCount;
            };
            _local_2.dispose();
            if (((_local_2) && (_local_2.parent)))
            {
                removeChild(_local_2);
            };
            _local_2 = null;
        }

        private function _alerNotSell(_arg_1:AuctionSellEvent):void
        {
            var _local_2:AuctionSellLeftAler = (_arg_1.currentTarget as AuctionSellLeftAler);
            info = null;
            lockBagCell.locked = false;
            lockBagCell = null;
            _local_2.dispose();
            if (((_local_2) && (_local_2.parent)))
            {
                removeChild(_local_2);
            };
            _local_2 = null;
        }

        public function get goodsCount():int
        {
            return (this._goodsCount);
        }

        override public function dragStop(_arg_1:DragEffect):void
        {
            super.dragStop(_arg_1);
        }

        override protected function onMouseClick(_arg_1:MouseEvent):void
        {
            super.onMouseClick(_arg_1);
            dispatchEvent(new Event(AuctionCellView.SELECT_BID_GOOD));
        }

        override protected function onMouseOver(_arg_1:MouseEvent):void
        {
            dispatchEvent(new Event(CELL_MOUSEOVER));
        }

        override protected function onMouseOut(_arg_1:MouseEvent):void
        {
            dispatchEvent(new Event(CELL_MOUSEOUT));
        }

        public function onObjectClicked():void
        {
            super.dragStart();
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        override public function updateCount():void
        {
            if (_tbxCount == null)
            {
                return;
            };
            if ((((_info) && (itemInfo)) && (itemInfo.MaxCount > 1)))
            {
                _tbxCount.visible = true;
                _tbxCount.text = String(itemInfo.Count);
                _tbxCount.x = (this._picRect.right - _tbxCount.width);
                _tbxCount.y = (this._picRect.bottom - _tbxCount.height);
                addChild(_tbxCount);
            }
            else
            {
                _tbxCount.visible = false;
            };
        }


    }
}//package auctionHouse.view

