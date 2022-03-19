// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.ConsortiaListView

package im
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.ListPanel;
    import ddt.data.player.ConsortiaPlayerInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.events.ListItemEvent;
    import consortion.ConsortionModelControl;
    import consortion.event.ConsortionEvent;
    import com.pickgliss.geom.IntPoint;

    public class ConsortiaListView extends Sprite implements Disposeable 
    {

        private var _list:ListPanel;
        private var _consortiaPlayerArray:Array;
        private var _currentItem:ConsortiaPlayerInfo;
        private var _pos:int;

        public function ConsortiaListView()
        {
            this.init();
        }

        private function init():void
        {
            this._list = ComponentFactory.Instance.creat("IM.ConsortiaListPanel");
            this._list.vScrollProxy = ScrollPanel.AUTO;
            addChild(this._list);
            this._list.list.updateListView();
            this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
            this.update();
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_ADD, this.__updateList);
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_REMOVE, this.__updateList);
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_UPDATA, this.__updateList);
        }

        private function __updateList(_arg_1:ConsortionEvent):void
        {
            this._pos = this._list.list.viewPosition.y;
            this.update();
            var _local_2:IntPoint = new IntPoint(0, this._pos);
            this._list.list.viewPosition = _local_2;
        }

        private function __itemClick(_arg_1:ListItemEvent):void
        {
            if ((!(this._currentItem)))
            {
                this._currentItem = (_arg_1.cellValue as ConsortiaPlayerInfo);
                this._currentItem.isSelected = true;
            }
            else
            {
                if (this._currentItem != (_arg_1.cellValue as ConsortiaPlayerInfo))
                {
                    this._currentItem.isSelected = false;
                    this._currentItem = (_arg_1.cellValue as ConsortiaPlayerInfo);
                    this._currentItem.isSelected = true;
                };
            };
            this._list.list.updateListView();
        }

        private function update():void
        {
            var _local_5:ConsortiaPlayerInfo;
            this._consortiaPlayerArray = [];
            this._consortiaPlayerArray = ConsortionModelControl.Instance.model.onlineConsortiaMemberList;
            var _local_1:Array = [];
            var _local_2:Array = [];
            var _local_3:int;
            while (_local_3 < this._consortiaPlayerArray.length)
            {
                _local_5 = (this._consortiaPlayerArray[_local_3] as ConsortiaPlayerInfo);
                if (_local_5.IsVIP)
                {
                    _local_1.push(_local_5);
                }
                else
                {
                    _local_2.push(_local_5);
                };
                _local_3++;
            };
            _local_1 = _local_1.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING));
            _local_2 = _local_2.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING));
            this._consortiaPlayerArray = _local_1.concat(_local_2);
            var _local_4:Array = ConsortionModelControl.Instance.model.offlineConsortiaMemberList;
            _local_4 = _local_4.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING));
            this._consortiaPlayerArray = this._consortiaPlayerArray.concat(_local_4);
            this._list.vectorListModel.clear();
            this._list.vectorListModel.appendAll(this._consortiaPlayerArray);
            this._list.list.updateListView();
        }

        public function dispose():void
        {
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_ADD, this.__updateList);
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_REMOVE, this.__updateList);
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_UPDATA, this.__updateList);
            if (((this._list) && (this._list.parent)))
            {
                this._list.parent.removeChild(this._list);
                this._list.dispose();
                this._list = null;
            };
            if (this._currentItem)
            {
                this._currentItem.isSelected = false;
            };
        }


    }
}//package im

