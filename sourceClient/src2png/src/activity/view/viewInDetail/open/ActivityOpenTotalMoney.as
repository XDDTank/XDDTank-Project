// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.viewInDetail.open.ActivityOpenTotalMoney

package activity.view.viewInDetail.open
{
    import activity.view.viewInDetail.ActivityBaseDetailView;
    import flash.display.Shape;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import activity.data.ActivityInfo;
    import com.pickgliss.ui.controls.SelectedTextButton;
    import activity.view.ActivityCell;
    import activity.data.ActivityGiftbagInfo;
    import activity.ActivityController;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.events.Event;
    import activity.ActivityEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class ActivityOpenTotalMoney extends ActivityBaseDetailView 
    {

        public static const SHOW_NUM:int = 6;

        private var _processMask:Shape;
        private var _processBit:Bitmap;
        private var _point:Bitmap;
        private var _pointPos:Point;
        private var _btnGroup:SelectedButtonGroup;
        private var _currentIndex:int = 0;


        public function update():void
        {
            this.info = info;
        }

        override public function set info(_arg_1:ActivityInfo):void
        {
            super.info = _arg_1;
            this.initBtnText();
            this.setData();
        }

        override public function get enable():Boolean
        {
            if (canAcceptByRecieveNum)
            {
                if (((conditions[this._currentIndex] > log) && (nowState >= conditions[this._currentIndex])))
                {
                    return (true);
                };
            };
            return (false);
        }

        private function initBtnText():void
        {
            var _local_1:SelectedTextButton;
            var _local_2:int;
            while (_local_2 < this._btnGroup.itemCount)
            {
                _local_1 = (this._btnGroup.getItemByIndex(_local_2) as SelectedTextButton);
                if (conditions[_local_2])
                {
                    _local_1.text = conditions[_local_2];
                };
                _local_2++;
            };
        }

        override protected function initCells():void
        {
            var _local_1:ActivityCell;
            var _local_2:ActivityGiftbagInfo;
            var _local_3:int;
            for each (_local_2 in _giftBags[this._currentIndex])
            {
                _rewars = ActivityController.instance.getRewardsByGiftbagID(_local_2.GiftbagId);
                _local_3 = 0;
                while (_local_3 < _rewars.length)
                {
                    _local_1 = new ActivityCell(_rewars.list[_local_3]);
                    _local_1.count = _rewars.list[_local_3].Count;
                    _cellList.addChild(_local_1);
                    setCellFilter(_local_1, conditions[this._currentIndex]);
                    _local_3++;
                };
            };
            _panel.vScrollProxy = ((_cellList.numChildren > _cellNumInRow) ? 0 : 2);
        }

        private function setData():void
        {
            var _local_7:Point;
            var _local_1:int = int(ActivityController.instance.model.getState(info.ActivityId));
            var _local_2:int;
            var _local_3:Number = 0;
            var _local_4:int;
            while (_local_4 <= conditions.length)
            {
                if (_local_4 == 0)
                {
                    if (_local_1 < int(conditions[_local_4]))
                    {
                        _local_2 = _local_4;
                        _local_3 = (_local_1 / int(conditions[_local_4]));
                        break;
                    };
                }
                else
                {
                    if (_local_4 < conditions.length)
                    {
                        if (((int(conditions[(_local_4 - 1)]) <= _local_1) && (_local_1 < int(conditions[_local_4]))))
                        {
                            _local_2 = _local_4;
                            _local_3 = ((_local_1 - int(conditions[(_local_4 - 1)])) / (int(conditions[_local_4]) - int(conditions[(_local_4 - 1)])));
                            break;
                        };
                    }
                    else
                    {
                        _local_2 = _local_4;
                    };
                };
                _local_4++;
            };
            var _local_5:Point = new Point();
            var _local_6:Point = ComponentFactory.Instance.creatCustomObject(("ddtactivity.ActivityOpenTotalMoney.pointPos" + _local_2));
            if (_local_2 < conditions.length)
            {
                _local_7 = ComponentFactory.Instance.creatCustomObject(("ddtactivity.ActivityOpenTotalMoney.pointPos" + (_local_2 + 1)));
            }
            else
            {
                _local_7 = _local_6;
            };
            _local_5.y = _local_6.y;
            _local_5.x = (_local_6.x + ((_local_7.x - _local_6.x) * _local_3));
            this._processMask.graphics.beginFill(0xFF0000, 1);
            this._processMask.graphics.drawRect(this._processBit.x, this._processBit.y, (_local_5.x - this._processMask.x), this._processBit.height);
            this._processMask.graphics.endFill();
            this._btnGroup.selectIndex = (_local_2 - 1);
            _local_5.x = (_local_5.x - (this._point.width / 2));
            _local_5.x = (_local_5.x + this._pointPos.x);
            _local_5.y = (_local_5.y + this._pointPos.y);
            PositionUtils.setPos(this._point, _local_5);
        }

        override protected function initView():void
        {
            var _local_2:SelectedTextButton;
            _cellNumInRow = 6;
            this._processBit = ComponentFactory.Instance.creatBitmap("ddtactivity.activitystate.open.moneyProcessBit");
            addChild(this._processBit);
            this._processMask = new Shape();
            this._processMask.graphics.beginFill(0xFF0000, 1);
            this._processMask.graphics.drawRect(this._processBit.x, this._processBit.y, 0, this._processBit.height);
            this._processMask.graphics.endFill();
            addChild(this._processMask);
            this._processBit.mask = this._processMask;
            this._point = ComponentFactory.Instance.creatBitmap("ddtactivity.activitystate.open.moneyProcessPoint");
            this._pointPos = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenTotalMoney.point");
            this._btnGroup = new SelectedButtonGroup();
            var _local_1:int;
            while (_local_1 < SHOW_NUM)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename(("ddtactivity.activitystate.open.ActivityOpenTotalMoney.btn" + (_local_1 + 1)));
                addChild(_local_2);
                this._btnGroup.addSelectItem(_local_2);
                _local_1++;
            };
            this._btnGroup.selectIndex = 0;
            this._btnGroup.addEventListener(Event.CHANGE, this.__selectedChange);
            _cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenTotalMoney.cellList", [_cellNumInRow]);
            addChild(_cellList);
            _panel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityOpenTotalMoney.cellPanel");
            addChild(_panel);
            _panel.setView(_cellList);
            super.initView();
        }

        private function __selectedChange(_arg_1:Event):void
        {
            this._currentIndex = this._btnGroup.selectIndex;
            _cellList.disposeAllChildren();
            this.initCells();
            ActivityController.instance.model.dispatchEvent(new ActivityEvent(ActivityEvent.BUTTON_CHANGE));
        }

        override public function dispose():void
        {
            this._btnGroup.removeEventListener(Event.CHANGE, this.__selectedChange);
            ObjectUtils.disposeObject(this._processBit);
            this._processBit = null;
            ObjectUtils.disposeObject(this._processMask);
            this._processMask = null;
            ObjectUtils.disposeObject(this._point);
            this._point = null;
            ObjectUtils.disposeObject(this._pointPos);
            this._pointPos = null;
            ObjectUtils.disposeObject(this._btnGroup);
            this._btnGroup = null;
            super.dispose();
        }


    }
}//package activity.view.viewInDetail.open

