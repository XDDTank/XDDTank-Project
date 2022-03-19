// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.refining.RefiningItemCell

package store.view.refining
{
    import store.StoreCell;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import ddt.manager.PlayerManager;
    import ddt.data.EquipType;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class RefiningItemCell extends StoreCell 
    {

        public static const CONTENTSIZE:int = 62;
        public static const PICPOS:int = 17;

        private var _text:FilterFrameText;

        public function RefiningItemCell()
        {
            var _local_1:Sprite = new Sprite();
            var _local_2:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.BlankCellBG");
            _local_1.addChild(_local_2);
            super(_local_1, 0);
            setContentSize(CONTENTSIZE, CONTENTSIZE);
            PicPos = new Point(PICPOS, PICPOS);
            this.info = info;
            DoubleClickEnabled = false;
        }

        public function get count():int
        {
            return (int(_tbxCount.text));
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:InventoryItemInfo = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(EquipType.REFINING_STONE)[0];
            super.info = _local_2;
            _tbxCount.text = PlayerManager.Instance.Self.findItemCount(EquipType.REFINING_STONE).toString();
        }

        override public function dragStart():void
        {
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._text);
            this._text = null;
            super.dispose();
        }


    }
}//package store.view.refining

