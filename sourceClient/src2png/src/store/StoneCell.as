// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.StoneCell

package store
{
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.BagInfo;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.SocketManager;
    import ddt.manager.DragManager;

    public class StoneCell extends StoreCell 
    {

        public static const CONTENTSIZE:int = 62;
        public static const PICPOS:int = 17;

        protected var _types:Array;

        public function StoneCell(_arg_1:Array, _arg_2:int)
        {
            var _local_3:Sprite = new Sprite();
            var _local_4:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.BlankCellBG");
            _local_3.addChild(_local_4);
            super(_local_3, _arg_2);
            this._types = _arg_1;
            setContentSize(CONTENTSIZE, CONTENTSIZE);
            PicPos = new Point(PICPOS, PICPOS);
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (((_local_2.BagType == BagInfo.STOREBAG) && (!(info == null))))
            {
                return;
            };
            if (((_local_2) && (!(_arg_1.action == DragEffect.SPLIT))))
            {
                _arg_1.action = DragEffect.NONE;
                if ((((_local_2.CategoryID == 11) && (this._types.indexOf(_local_2.Property1) > -1)) && (_local_2.getRemainDate() > 0)))
                {
                    SocketManager.Instance.out.sendMoveGoods(_local_2.BagType, _local_2.Place, BagInfo.STOREBAG, index, 1, false);
                    _arg_1.action = DragEffect.NONE;
                    DragManager.acceptDrag(this);
                };
            };
        }

        public function get types():Array
        {
            return (this._types);
        }

        override public function dispose():void
        {
            this._types = null;
            super.dispose();
        }


    }
}//package store

