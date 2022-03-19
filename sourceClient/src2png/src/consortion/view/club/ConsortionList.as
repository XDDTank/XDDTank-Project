// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.club.ConsortionList

package consortion.view.club
{
    import com.pickgliss.ui.controls.container.VBox;
    import __AS3__.vec.Vector;
    import consortion.data.ConsortiaApplyInfo;
    import consortion.ConsortionModelControl;
    import consortion.event.ConsortionEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.data.ConsortiaInfo;
    import __AS3__.vec.*;

    public class ConsortionList extends VBox 
    {

        private var _currentItem:ConsortionListItem;
        private var items:Vector.<ConsortionListItem>;
        private var _selfApplyList:Vector.<ConsortiaApplyInfo>;

        public function ConsortionList()
        {
            _spacing = 2;
            this.__applyListChange(null);
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE, this.__applyListChange);
        }

        private function __applyListChange(_arg_1:ConsortionEvent):void
        {
            this._selfApplyList = ConsortionModelControl.Instance.model.myApplyList;
        }

        override protected function init():void
        {
            super.init();
            this.initItems();
        }

        private function initItems():void
        {
            var _local_1:int;
            this.items = new Vector.<ConsortionListItem>(9);
            _local_1 = 0;
            while (_local_1 < 9)
            {
                this.items[_local_1] = new ConsortionListItem(_local_1);
                this.items[_local_1].buttonMode = true;
                addChild(this.items[_local_1]);
                this.items[_local_1].addEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
                this.items[_local_1].addEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
                _local_1++;
            };
        }

        private function removeItem():void
        {
            var _local_1:int;
            while (_local_1 < 9)
            {
                this.items[_local_1].dispose();
                this.items[_local_1].removeEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
                this.items[_local_1].removeEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
                this.items[_local_1] = null;
                _local_1++;
            };
        }

        private function __clickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:int;
            while (_local_2 < 9)
            {
                if (this.items[_local_2] == (_arg_1.currentTarget as ConsortionListItem))
                {
                    this.items[_local_2].selected = true;
                    this._currentItem = this.items[_local_2];
                }
                else
                {
                    this.items[_local_2].selected = false;
                };
                _local_2++;
            };
            dispatchEvent(new ConsortionEvent(ConsortionEvent.CLUB_ITEM_SELECTED));
        }

        public function get currentItem():ConsortionListItem
        {
            return (this._currentItem);
        }

        private function __overHandler(_arg_1:MouseEvent):void
        {
            (_arg_1.currentTarget as ConsortionListItem).light = true;
        }

        private function __outHandler(_arg_1:MouseEvent):void
        {
            (_arg_1.currentTarget as ConsortionListItem).light = false;
        }

        public function setListData(_arg_1:Vector.<ConsortiaInfo>):void
        {
            var _local_2:int;
            var _local_3:int;
            this.removeItem();
            this.initItems();
            if (_arg_1 != null)
            {
                _local_2 = _arg_1.length;
                _local_3 = 0;
                while (_local_3 < 9)
                {
                    if (_local_3 < _local_2)
                    {
                        this.items[_local_3].info = _arg_1[_local_3];
                        this.items[_local_3].visible = true;
                        this.items[_local_3].isApply = false;
                    }
                    else
                    {
                        this.items[_local_3].visible = true;
                    };
                    _local_3++;
                };
                this.setStatus();
                if (this._currentItem)
                {
                    this._currentItem.selected = false;
                };
            };
        }

        private function setStatus():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            if (this._selfApplyList != null)
            {
                _local_1 = 0;
                while (_local_1 < 9)
                {
                    _local_2 = this._selfApplyList.length;
                    if (this.items[_local_1].info)
                    {
                        _local_3 = 0;
                        while (_local_3 < _local_2)
                        {
                            if (this.items[_local_1].info.ConsortiaID == this._selfApplyList[_local_3].ConsortiaID)
                            {
                                this.items[_local_1].isApply = true;
                                this.items[_local_1].ID = this._selfApplyList[_local_3].ID;
                            };
                            _local_3++;
                        };
                    };
                    _local_1++;
                };
            };
        }

        override public function dispose():void
        {
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE, this.__applyListChange);
            var _local_1:int;
            while (_local_1 < 9)
            {
                this.items[_local_1].dispose();
                this.items[_local_1].removeEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
                this.items[_local_1].removeEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
                this.items[_local_1] = null;
                _local_1++;
            };
            this._currentItem = null;
            super.dispose();
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.club

