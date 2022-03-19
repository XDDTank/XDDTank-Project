// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.bigMapInfoPanel.DropList

package room.view.bigMapInfoPanel
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleUpDownImage;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import bagAndInfo.cell.BaseCell;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.ItemManager;
    import flash.geom.Point;

    public class DropList extends Sprite implements Disposeable 
    {

        public static const LARGE:String = "large";
        public static const SMALL:String = "small";

        private var _bg:ScaleUpDownImage;
        private var _scrollPanel:ScrollPanel;
        private var _list:SimpleTileList;
        private var _cells:Array;
        private var _scrollPanelRect:Rectangle;

        public function DropList()
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dropListBg");
            this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dropListPanel");
            this._scrollPanel.vScrollProxy = ScrollPanel.ON;
            this._scrollPanel.hScrollProxy = ScrollPanel.OFF;
            addChild(this._scrollPanel);
            this._scrollPanelRect = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dropList.scrollPanelRect");
            this._list = new SimpleTileList(4);
            this._list.hSpace = 2;
            this._list.vSpace = 2;
            this._cells = [];
            this._scrollPanel.addEventListener(MouseEvent.ROLL_OVER, this.__overHandler);
            this._scrollPanel.addEventListener(MouseEvent.ROLL_OUT, this.__outHandler);
        }

        public function set info(_arg_1:Array):void
        {
            var _local_3:int;
            var _local_4:BaseCell;
            var _local_5:ItemTemplateInfo;
            var _local_6:BaseCell;
            while (this._cells.length > 0)
            {
                _local_4 = this._cells.shift();
                _local_4.dispose();
            };
            var _local_2:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dropList.cellRect");
            for each (_local_3 in _arg_1)
            {
                _local_5 = ItemManager.Instance.getTemplateById(_local_3);
                _local_6 = new BaseCell(ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dropCellBgAsset"), _local_5);
                _local_6.overBg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.dropCellOverBgAsset");
                _local_6.setContentSize(_local_2.width, _local_2.height);
                _local_6.PicPos = new Point(_local_2.x, _local_2.y);
                this._list.addChild(_local_6);
                this._cells.push(_local_6);
            };
            this._scrollPanel.setView(this._list);
            this._scrollPanel.invalidateViewport();
        }

        private function __overHandler(_arg_1:MouseEvent):void
        {
        }

        private function __outHandler(_arg_1:MouseEvent):void
        {
        }

        public function dispose():void
        {
            this._scrollPanel.removeEventListener(MouseEvent.ROLL_OVER, this.__overHandler);
            this._scrollPanel.removeEventListener(MouseEvent.ROLL_OUT, this.__outHandler);
            this._list.dispose();
            this._list = null;
            this._scrollPanel.dispose();
            this._scrollPanel = null;
            this._bg.dispose();
            this._bg = null;
            this._cells = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view.bigMapInfoPanel

