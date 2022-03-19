// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//calendar.view.DayCell

package calendar.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import calendar.CalendarModel;
    import flash.display.DisplayObject;
    import com.greensock.TweenMax;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.DisplayUtils;
    import flash.events.MouseEvent;
    import flash.display.MovieClip;
    import road7th.utils.MovieClipWrapper;
    import ddt.manager.SoundManager;
    import calendar.CalendarManager;
    import com.pickgliss.utils.ClassUtils;
    import flash.events.Event;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PlayerManager;
    import mainbutton.MainButtnController;

    public class DayCell extends Sprite implements Disposeable 
    {

        private var _dayField:FilterFrameText;
        private var _date:Date;
        private var _model:CalendarModel;
        private var _back:DisplayObject;
        private var _signShape:DisplayObject;
        private var _tweenMax:TweenMax;
        private var _signed:Boolean;

        public function DayCell(_arg_1:Date, _arg_2:CalendarModel)
        {
            this._model = _arg_2;
            this.configUI();
            this.addEvent();
            buttonMode = true;
            mouseChildren = false;
            this.date = _arg_1;
            this.signed = this._model.hasSigned(this._date);
        }

        public function get signed():Boolean
        {
            return (this._signed);
        }

        public function set signed(_arg_1:Boolean):void
        {
            if (this._signed == _arg_1)
            {
                return;
            };
            this._signed = _arg_1;
            if (((this._signed) && (this._signShape == null)))
            {
                this._signShape = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.SignShape");
                addChild(this._signShape);
                if (this._tweenMax)
                {
                    this._tweenMax.pause();
                };
                this._back.filters = null;
            }
            else
            {
                if ((!(this._signed)))
                {
                    if (this._tweenMax)
                    {
                        this._tweenMax.pause();
                    };
                    this._back.filters = null;
                    ObjectUtils.disposeObject(this._signShape);
                    this._signShape = null;
                };
            };
        }

        public function get date():Date
        {
            return (this._date);
        }

        public function set date(_arg_1:Date):void
        {
            if (this._date == _arg_1)
            {
                return;
            };
            this._date = _arg_1;
            this._dayField.text = this._date.date.toString();
            if (this._date.month == this._model.today.month)
            {
                if (((!(this._model.hasSigned(this._date))) && (this._date.date == this._model.today.date)))
                {
                    DisplayUtils.setFrame(this._back, 1);
                }
                else
                {
                    if (((!(this._model.hasSigned(this._date))) && (this._date.date <= this._model.today.date)))
                    {
                        DisplayUtils.setFrame(this._back, 2);
                    }
                    else
                    {
                        DisplayUtils.setFrame(this._back, 1);
                    };
                };
                if (this._date.day == 0)
                {
                    this._dayField.setFrame(3);
                }
                else
                {
                    if (this._date.day == 6)
                    {
                        this._dayField.setFrame(2);
                    }
                    else
                    {
                        this._dayField.setFrame(1);
                    };
                };
            }
            else
            {
                DisplayUtils.setFrame(this._back, 1);
                if (this._date.day == 0)
                {
                    this._dayField.setFrame(6);
                }
                else
                {
                    if (this._date.day == 6)
                    {
                        this._dayField.setFrame(5);
                    }
                    else
                    {
                        this._dayField.setFrame(4);
                    };
                };
            };
            var _local_2:Date = this._model.today;
            if (((((this._date.fullYear == _local_2.fullYear) && (this._date.month == _local_2.month)) && (this._date.date == _local_2.date)) && (!(this._model.hasSigned(this._date)))))
            {
                this._tweenMax = TweenMax.to(this._back, 0.4, {
                    "repeat":-1,
                    "yoyo":true,
                    "glowFilter":{
                        "color":0xD50000,
                        "alpha":1,
                        "blurX":4,
                        "blurY":4,
                        "strength":3
                    }
                });
                this._tweenMax.play();
            }
            else
            {
                if (this._tweenMax)
                {
                    this._tweenMax.pause();
                    this._back.filters = null;
                    ObjectUtils.disposeObject(this._signShape);
                    this._signShape = null;
                };
            };
        }

        private function configUI():void
        {
            this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.Calendar.DayCellBack");
            DisplayUtils.setFrame(this._back, 1);
            addChild(this._back);
            this._dayField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.DayField");
            addChild(this._dayField);
        }

        private function addEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__click);
        }

        private function __click(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip;
            var _local_3:MovieClipWrapper;
            SoundManager.instance.play("008");
            if (CalendarManager.getInstance().sign(this._date))
            {
                if (this._tweenMax)
                {
                    this._tweenMax.pause();
                    this._back.filters = null;
                };
                _local_2 = ClassUtils.CreatInstance("asset.ddtcalendar.Grid.SignAnimation");
                _local_2.x = 2;
                if (_local_2)
                {
                    _local_3 = new MovieClipWrapper(_local_2, true, true);
                    _local_3.addEventListener(Event.COMPLETE, this.__signAnimationComplete);
                    addChild(_local_3.movie);
                };
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.signed"));
                PlayerManager.Instance.Self.Sign = true;
                MainButtnController.instance.dispatchEvent(new Event(MainButtnController.CLOSESIGN));
            };
        }

        private function __signAnimationComplete(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(Event.COMPLETE, this.__signAnimationComplete);
            if (parent)
            {
                this.signed = true;
            };
        }

        public function AutomaticSign():void
        {
            this.__click(null);
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__click);
        }

        public function dispose():void
        {
            this.removeEvent();
            TweenMax.killChildTweensOf(this);
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            ObjectUtils.disposeObject(this._dayField);
            this._dayField = null;
            ObjectUtils.disposeObject(this._signShape);
            this._signShape = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package calendar.view

