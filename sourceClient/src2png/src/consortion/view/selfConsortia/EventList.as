// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.EventList

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Rectangle;
    import ddt.utils.PositionUtils;
    import consortion.ConsortionModelControl;
    import consortion.event.ConsortionEvent;
    import __AS3__.vec.Vector;
    import ddt.data.ConsortiaEventInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class EventList extends Sprite implements Disposeable 
    {

        private var _bg:MutipleImage;
        private var _titleTxt:FilterFrameText;
        private var _timeTxt:FilterFrameText;
        private var _vbox:VBox;
        private var _list:ScrollPanel;
        private var _line:MutipleImage;

        public function EventList()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            var _local_1:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.ddtconsortion.eventbgRect");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("memberlist.Bg");
            this._bg.imageRectString = "0|590|0|436|13,0|588|0|35|13";
            this._bg.height = _local_1.height;
            this._line = ComponentFactory.Instance.creatComponentByStylename("consortion.EventItemVLine");
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("memberList.nameText");
            this._titleTxt.text = "公会日志";
            this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("memberList.nameText");
            this._timeTxt.text = "时间";
            PositionUtils.setPos(this._line, "asset.ddtconsortion.eventTilteLine");
            PositionUtils.setPos(this._titleTxt, "asset.ddtconsortion.eventListTitleTxt");
            PositionUtils.setPos(this._timeTxt, "asset.ddtconsortion.eventListTimeTxt");
            this._vbox = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.eventVbox");
            this._list = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.eventPanel");
            this._list.setView(this._vbox);
            addChild(this._bg);
            addChild(this._line);
            addChild(this._titleTxt);
            addChild(this._timeTxt);
            addChild(this._list);
        }

        private function initEvent():void
        {
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.EVENT_LIST_CHANGE, this.__eventChangeHandler);
        }

        private function removeEvent():void
        {
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.EVENT_LIST_CHANGE, this.__eventChangeHandler);
        }

        private function __eventChangeHandler(_arg_1:ConsortionEvent):void
        {
            var _local_5:EventListItem;
            this._vbox.disposeAllChildren();
            var _local_2:Vector.<ConsortiaEventInfo> = ConsortionModelControl.Instance.model.eventList;
            var _local_3:int = _local_2.length;
            var _local_4:int;
            if (_local_3 == 0)
            {
                while (_local_4 < 11)
                {
                    _local_5 = new EventListItem();
                    _local_5.updateBaceGroud(_local_4);
                    this._vbox.addChild(_local_5);
                    _local_4++;
                };
            }
            else
            {
                if (_local_3 >= 11)
                {
                    while (_local_4 < _local_3)
                    {
                        _local_5 = new EventListItem();
                        _local_5.updateBaceGroud(_local_4);
                        _local_5.info = _local_2[_local_4];
                        this._vbox.addChild(_local_5);
                        _local_4++;
                    };
                }
                else
                {
                    while (_local_4 < 11)
                    {
                        if (_local_4 < _local_3)
                        {
                            _local_5 = new EventListItem();
                            _local_5.updateBaceGroud(_local_4);
                            _local_5.info = _local_2[_local_4];
                            this._vbox.addChild(_local_5);
                        }
                        else
                        {
                            _local_5 = new EventListItem();
                            _local_5.updateBaceGroud(_local_4);
                            this._vbox.addChild(_local_5);
                        };
                        _local_4++;
                    };
                };
            };
            this._list.invalidateViewport();
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._vbox)
            {
                this._vbox.disposeAllChildren();
                ObjectUtils.disposeObject(this._vbox);
            };
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._line)
            {
                ObjectUtils.disposeObject(this._line);
            };
            this._line = null;
            if (this._titleTxt)
            {
                ObjectUtils.disposeObject(this._titleTxt);
            };
            this._titleTxt = null;
            if (this._timeTxt)
            {
                ObjectUtils.disposeObject(this._timeTxt);
            };
            this._timeTxt = null;
            if (this._list)
            {
                ObjectUtils.disposeObject(this._list);
            };
            this._list = null;
            ObjectUtils.disposeAllChildren(this);
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

