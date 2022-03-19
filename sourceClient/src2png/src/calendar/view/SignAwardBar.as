// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//calendar.view.SignAwardBar

package calendar.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import calendar.CalendarModel;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import calendar.CalendarEvent;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class SignAwardBar extends Sprite implements Disposeable 
    {

        private var _items:Vector.<NavigItem> = new Vector.<NavigItem>();
        private var _current:NavigItem;
        private var _model:CalendarModel;
        private var _back:DisplayObject;
        private var _title:DisplayObject;
        private var _awardHolder:SignedAwardHolder;
        private var _signCoundField:FilterFrameText;
        private var _selectedItem:NavigItem;
        private var _signedTimesPanel:Image;

        public function SignAwardBar(_arg_1:CalendarModel)
        {
            this._model = _arg_1;
            this.configUI();
            this.addEvent();
        }

        private function configUI():void
        {
            this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.SignedAwardBack");
            addChild(this._back);
            this._title = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.SignAwardBarTitle");
            addChild(this._title);
            this._signedTimesPanel = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.SingedAward.SignedTimesPanel");
            addChild(this._signedTimesPanel);
            this._signCoundField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.SignCountField");
            this._signCoundField.text = this._model.signCount.toString();
            addChild(this._signCoundField);
            this._awardHolder = ComponentFactory.Instance.creatCustomObject("ddtcalendar.SignedAwardHolder", [this._model]);
            addChild(this._awardHolder);
            this.drawCells();
        }

        private function drawCells():void
        {
            var _local_3:Point;
            var _local_4:int;
            var _local_5:NavigItem;
            var _local_1:int = this._model.awardCounts.length;
            var _local_2:int;
            _local_3 = ComponentFactory.Instance.creatCustomObject("ddtcalendar.Award.TopLeft");
            _local_4 = 0;
            while (_local_4 < _local_1)
            {
                _local_5 = new NavigItem(this._model.awardCounts[_local_4]);
                _local_5.x = (_local_3.x + (_local_4 * 100));
                _local_5.y = _local_3.y;
                _local_5.addEventListener(MouseEvent.CLICK, this.__itemClick);
                this._items.push(_local_5);
                addChild(_local_5);
                if (this._model.hasReceived(this._model.awardCounts[_local_4]))
                {
                    _local_5.received = true;
                    _local_2++;
                };
                _local_4++;
            };
            if (_local_2 < this._items.length)
            {
                this._items[_local_2].selected = true;
                this._selectedItem = this._items[_local_2];
                this._awardHolder.setAwardsByCount(this._selectedItem.count);
            };
        }

        private function __itemClick(_arg_1:MouseEvent):void
        {
            var _local_2:NavigItem = (_arg_1.currentTarget as NavigItem);
            if (this._selectedItem != _local_2)
            {
                this._selectedItem.selected = false;
                this._selectedItem = _local_2;
                this._selectedItem.selected = true;
                this._awardHolder.setAwardsByCount(this._selectedItem.count);
                SoundManager.instance.play("008");
            };
        }

        private function reset():void
        {
            var _local_1:int = this._model.awardCounts.length;
            var _local_2:int;
            var _local_3:int;
            while (_local_3 < _local_1)
            {
                this._items[_local_3].selected = (this._items[_local_3].received = false);
                _local_3++;
            };
            this._selectedItem = this._items[0];
            this._selectedItem.selected = true;
            this._awardHolder.setAwardsByCount(this._selectedItem.count);
        }

        private function __signCountChanged(_arg_1:Event):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            this._signCoundField.text = this._model.signCount.toString();
            if (this._model.signCount == 0)
            {
                this.reset();
            }
            else
            {
                _local_2 = this._model.awardCounts.length;
                _local_3 = 0;
                _local_4 = 0;
                while (_local_4 < _local_2)
                {
                    if (this._model.hasReceived(this._model.awardCounts[_local_4]))
                    {
                        this._items[_local_4].received = true;
                        if (this._items[_local_4] == this._selectedItem)
                        {
                            this._selectedItem = null;
                        };
                        _local_3++;
                    };
                    _local_4++;
                };
                if (((_local_3 < this._items.length) && (this._selectedItem == null)))
                {
                    this._items[_local_3].selected = true;
                    this._selectedItem = this._items[_local_3];
                    this._awardHolder.setAwardsByCount(this._selectedItem.count);
                }
                else
                {
                    if (this._selectedItem == null)
                    {
                        this._awardHolder.clean();
                    };
                };
            };
        }

        private function addEvent():void
        {
            this._model.addEventListener(CalendarEvent.SignCountChanged, this.__signCountChanged);
        }

        private function removeEvent():void
        {
            this._model.removeEventListener(CalendarEvent.SignCountChanged, this.__signCountChanged);
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            ObjectUtils.disposeObject(this._title);
            this._title = null;
            ObjectUtils.disposeObject(this._signCoundField);
            this._signCoundField = null;
            ObjectUtils.disposeObject(this._awardHolder);
            this._awardHolder = null;
            var _local_1:NavigItem = this._items.shift();
            while (_local_1 != null)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = this._items.shift();
            };
            this._current = (this._selectedItem = null);
            this._model = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package calendar.view

