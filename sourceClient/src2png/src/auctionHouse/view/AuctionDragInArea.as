// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionDragInArea

package auctionHouse.view
{
    import flash.display.Sprite;
    import ddt.interfaces.IAcceptDrag;
    import __AS3__.vec.Vector;
    import ddt.data.goods.InventoryItemInfo;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.DragManager;

    public class AuctionDragInArea extends Sprite implements IAcceptDrag 
    {

        private var _cells:Vector.<AuctionCellView>;

        public function AuctionDragInArea(_arg_1:Vector.<AuctionCellView>)
        {
            this._cells = _arg_1;
            graphics.beginFill(0, 0);
            graphics.drawRect(-100, -10, 400, 370);
            graphics.endFill();
        }

        public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (((_local_2) && (!(_arg_1.action == DragEffect.SPLIT))))
            {
                _arg_1.action = DragEffect.NONE;
                if (_local_2.getRemainDate() <= 0)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionDragInArea.this"));
                    DragManager.acceptDrag(this);
                }
                else
                {
                    if (_arg_1.target == null)
                    {
                        DragManager.acceptDrag(this);
                    };
                };
            };
        }


    }
}//package auctionHouse.view

