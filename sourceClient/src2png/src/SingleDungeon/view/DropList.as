// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.view.DropList

package SingleDungeon.view
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.MapManager;
    import ddt.data.map.DungeonInfo;
    import bagAndInfo.cell.BaseCell;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.ItemManager;
    import flash.geom.Point;
    import com.pickgliss.utils.ObjectUtils;

    public class DropList extends Component 
    {

        private var _bg:ScaleBitmapImage;
        private var _scrollPanel:ScrollPanel;
        private var _list:SimpleTileList;
        private var _cells:Array;
        private var _scrollPanelRect:Rectangle;

        public function DropList()
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("singledungeon.dropListBg");
            addChild(this._bg);
            this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("singledungeon.dropListPanel");
            this._scrollPanel.vScrollProxy = ScrollPanel.ON;
            this._scrollPanel.hScrollProxy = ScrollPanel.OFF;
            addChild(this._scrollPanel);
            this._scrollPanelRect = ComponentFactory.Instance.creatCustomObject("singledungeon.dropList.scrollPanelRect");
            this._list = new SimpleTileList(6);
            this._list.hSpace = 3;
            this._list.vSpace = 3;
            this._cells = [];
        }

        public function updateList(_arg_1:int):void
        {
            var _local_2:DungeonInfo = MapManager.getDungeonInfo(_arg_1);
            if (_local_2)
            {
                this.info = _local_2.NormalTemplateIds.split(",");
            }
            else
            {
                this.removeChild(this._scrollPanel);
            };
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
            var _local_2:Rectangle = ComponentFactory.Instance.creatCustomObject("singledungeon.dropList.cellRect");
            for each (_local_3 in _arg_1)
            {
                _local_5 = ItemManager.Instance.getTemplateById(_local_3);
                _local_6 = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.singleDungeon.dropCellBgAsset"), _local_5);
                _local_6.overBg = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.dropCellOverBgAsset");
                _local_6.setContentSize(_local_2.width, _local_2.height);
                _local_6.PicPos = new Point(_local_2.x, _local_2.y);
                this._list.addChild(_local_6);
                this._cells.push(_local_6);
            };
            this._scrollPanel.setView(this._list);
            this._scrollPanel.height = this._scrollPanelRect.height;
            this._scrollPanel.width = this._scrollPanelRect.width;
        }

        override public function dispose():void
        {
            super.dispose();
            while (((this._cells) && (this._cells.length > 0)))
            {
                ObjectUtils.disposeObject(this._cells.pop());
            };
            this._cells = null;
            ObjectUtils.disposeObject(this._list);
            this._list = null;
            ObjectUtils.disposeObject(this._scrollPanel);
            this._scrollPanel = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package SingleDungeon.view

