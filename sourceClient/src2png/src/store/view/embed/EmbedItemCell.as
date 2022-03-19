// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.embed.EmbedItemCell

package store.view.embed
{
    import store.StoreCell;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.SoundManager;
    import ddt.data.goods.InventoryItemInfo;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.DragManager;
    import store.events.EmbedEvent;
    import flash.geom.Point;

    public class EmbedItemCell extends StoreCell 
    {

        public function EmbedItemCell(_arg_1:int)
        {
            var _local_2:Sprite = new Sprite();
            var _local_3:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG");
            _local_2.addChild(_local_3);
            super(_local_2, _arg_1);
            setContentSize(68, 68);
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            super.info = _arg_1;
        }

        override public function seteuipQualityBg(_arg_1:int):void
        {
            super.seteuipQualityBg(_arg_1);
            _euipQualityBg.x = -3;
            _euipQualityBg.y = -3;
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            SoundManager.instance.playButtonSound();
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            _arg_1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
            dispatchEvent(new EmbedEvent(EmbedEvent.MOVE, _local_2));
        }

        override public function get shinerPos():Point
        {
            return (_shinerPos);
        }

        override public function set shinerPos(_arg_1:Point):void
        {
            _shinerPos = _arg_1;
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package store.view.embed

