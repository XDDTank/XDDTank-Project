// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.view.EmaillBagCell

package email.view
{
    import bagAndInfo.cell.LinkedBagCell;
    import ddt.data.goods.InventoryItemInfo;
    import auctionHouse.view.AuctionSellLeftAler;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import bagAndInfo.cell.BagCell;
    import com.pickgliss.ui.ComponentFactory;
    import auctionHouse.event.AuctionSellEvent;
    import ddt.manager.DragManager;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ShowTipManager;

    public class EmaillBagCell extends LinkedBagCell 
    {

        private var _temporaryCount:int;
        private var _temporaryInfo:InventoryItemInfo;
        private var _goodsCount:int;

        public function EmaillBagCell()
        {
            super(null);
            this._goodsCount = 1;
            _bg.alpha = 0;
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_3:AuctionSellLeftAler;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (((_local_2) && (_arg_1.action == DragEffect.MOVE)))
            {
                _arg_1.action = DragEffect.NONE;
                if (_local_2.IsBinds)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.EmaillIIBagCell.isBinds"));
                }
                else
                {
                    if (_local_2.getRemainDate() <= 0)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.EmaillIIBagCell.RemainDate"));
                    }
                    else
                    {
                        this._goodsCount = 1;
                        bagCell = (_arg_1.source as BagCell);
                        _arg_1.action = DragEffect.LINK;
                        this._temporaryCount = bagCell.itemInfo.Count;
                        this._temporaryInfo = bagCell.itemInfo;
                        if (bagCell.locked == false)
                        {
                            bagCell.locked = true;
                            return;
                        };
                        if (bagCell.itemInfo.Count > 1)
                        {
                            _local_3 = ComponentFactory.Instance.creat("auctionHouse.AuctionSellLeftAler");
                            _local_3.titleText = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagBreak");
                            _local_3.show(this._temporaryInfo.Count);
                            _local_3.addEventListener(AuctionSellEvent.SELL, this._alerSell);
                            _local_3.addEventListener(AuctionSellEvent.NOTSELL, this._alerNotSell);
                        };
                    };
                };
                DragManager.acceptDrag(this);
            };
        }

        private function _alerSell(_arg_1:AuctionSellEvent):void
        {
            var _local_2:AuctionSellLeftAler = (_arg_1.currentTarget as AuctionSellLeftAler);
            this._temporaryInfo.Count = _arg_1.sellCount;
            this._goodsCount = _arg_1.sellCount;
            this.info = this._temporaryInfo;
            if (bagCell)
            {
                bagCell.itemInfo.Count = this._temporaryCount;
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
            this.info = null;
            bagCell.locked = false;
            bagCell = null;
            _local_2.dispose();
            if (((_local_2) && (_local_2.parent)))
            {
                removeChild(_local_2);
            };
            _local_2 = null;
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            super.info = _arg_1;
            this.updateCount();
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
                addChild(_tbxCount);
            }
            else
            {
                _tbxCount.visible = false;
            };
        }

        override protected function onMouseOver(_arg_1:MouseEvent):void
        {
            buttonMode = true;
        }

        override public function dispose():void
        {
            super.dispose();
            ShowTipManager.Instance.removeAllTip();
        }

        public function get goodsCount():int
        {
            return (this._goodsCount);
        }


    }
}//package email.view

