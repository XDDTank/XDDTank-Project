// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.LaterStrengthItemCell

package store.view.strength
{
    import store.StoreCell;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import com.pickgliss.events.InteractiveEvent;

    public class LaterStrengthItemCell extends StoreCell 
    {

        public function LaterStrengthItemCell(_arg_1:int)
        {
            var _local_2:Sprite = new Sprite();
            var _local_3:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG");
            _local_2.addChild(_local_3);
            super(_local_2, _arg_1);
            setContentSize(68, 68);
            this.PicPos = new Point(-4, -2);
        }

        override protected function __clickHandler(_arg_1:InteractiveEvent):void
        {
        }

        override protected function __doubleClickHandler(_arg_1:InteractiveEvent):void
        {
        }

        override public function dispose():void
        {
            super.dispose();
            removeEventListener(InteractiveEvent.CLICK, this.__clickHandler);
            removeEventListener(InteractiveEvent.DOUBLE_CLICK, this.__doubleClickHandler);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.strength

