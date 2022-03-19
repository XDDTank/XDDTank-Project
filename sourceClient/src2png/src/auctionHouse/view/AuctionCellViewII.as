// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionCellViewII

package auctionHouse.view
{
    import bagAndInfo.cell.LinkedBagCell;
    import flash.display.Sprite;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import bagAndInfo.cell.DragEffect;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class AuctionCellViewII extends LinkedBagCell 
    {

        public static const SELECT_BID_GOOD:String = "selectBidGood";
        public static const SELECT_GOOD:String = "selectGood";

        public function AuctionCellViewII()
        {
            var _local_1:Sprite;
            var _local_2:Scale9CornerImage;
            _local_1 = new Sprite();
            _local_2 = ComponentFactory.Instance.creatComponentByStylename("core.newScale9CornerImage.scale9CornerImage3");
            _local_2.width = 48;
            _local_2.height = 48;
            _local_1.addChild(_local_2);
            super(_local_1);
            tipDirctions = "7,5,2,6,4,1";
            PicPos = new Point(2, 1);
        }

        override protected function createChildren():void
        {
            super.createChildren();
            _tbxCount = null;
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
        }

        override protected function onMouseClick(_arg_1:MouseEvent):void
        {
        }

        override protected function onMouseOver(_arg_1:MouseEvent):void
        {
        }

        override protected function onMouseOut(_arg_1:MouseEvent):void
        {
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


    }
}//package auctionHouse.view

