// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.StoreDragInArea

package store
{
    import flash.display.Sprite;
    import ddt.interfaces.IAcceptDrag;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.BagInfo;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.DragManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;

    public class StoreDragInArea extends Sprite implements IAcceptDrag 
    {

        public static const RECTWIDTH:int = 340;
        public static const RECTHEIGHT:int = 360;

        protected var _cells:Array;

        public function StoreDragInArea(_arg_1:Array)
        {
            this._cells = _arg_1;
            this.init();
        }

        private function init():void
        {
            graphics.beginFill(0xFF, 0);
            graphics.drawRect(0, 0, RECTWIDTH, RECTHEIGHT);
            graphics.endFill();
        }

        public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_3:Boolean;
            var _local_4:int;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (_local_2.BagType == BagInfo.STOREBAG)
            {
                _arg_1.action = DragEffect.NONE;
                DragManager.acceptDrag(this);
                return;
            };
            if (((_local_2) && (!(_arg_1.action == DragEffect.SPLIT))))
            {
                _arg_1.action = DragEffect.NONE;
                if (_local_2.getRemainDate() <= 0)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                    DragManager.acceptDrag(this);
                }
                else
                {
                    _local_3 = false;
                    _local_4 = 0;
                    while (_local_4 < this._cells.length)
                    {
                        this._cells[_local_4].dragDrop(_arg_1);
                        _local_4++;
                    };
                };
            };
        }

        public function dispose():void
        {
            this._cells = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store

