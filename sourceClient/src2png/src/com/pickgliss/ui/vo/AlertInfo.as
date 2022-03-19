// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.vo.AlertInfo

package com.pickgliss.ui.vo
{
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentSetting;
    import com.pickgliss.events.InteractiveEvent;

    public class AlertInfo extends EventDispatcher 
    {

        public static const CANCEL_LABEL:String = "取 消";
        public static const SUBMIT_LABEL:String = "确 定";

        private var _customPos:Point;
        private var _autoButtonGape:Boolean = true;
        private var _autoDispose:Boolean = false;
        private var _bottomGap:int;
        private var _buttonGape:int = ComponentSetting.ALERT_BUTTON_GAPE;
        private var _cancelLabel:String = "取 消";
        private var _data:Object;
        private var _carryData:Object;
        private var _enableHtml:Boolean;
        private var _enterEnable:Boolean = true;
        private var _escEnable:Boolean = true;
        private var _frameCenter:Boolean = true;
        private var _moveEnable:Boolean = true;
        private var _mutiline:Boolean;
        private var _showCancel:Boolean = true;
        private var _showSubmit:Boolean = true;
        private var _submitEnabled:Boolean = true;
        private var _cancelEnabled:Boolean = true;
        private var _submitLabel:String = "确 定";
        private var _textShowHeight:int;
        private var _textShowWidth:int;
        private var _title:String;
        private var _soundID:*;

        public function AlertInfo(_arg_1:String="", _arg_2:String="确 定", _arg_3:String="取 消", _arg_4:Boolean=true, _arg_5:Boolean=true, _arg_6:Object=null, _arg_7:Boolean=true, _arg_8:Boolean=true, _arg_9:Boolean=true, _arg_10:Boolean=true, _arg_11:int=20, _arg_12:int=30, _arg_13:Boolean=false)
        {
            this.title = _arg_1;
            this.submitLabel = _arg_2;
            this.cancelLabel = _arg_3;
            this.showSubmit = _arg_4;
            this.showCancel = _arg_5;
            this.data = _arg_6;
            this.frameCenter = _arg_7;
            this.moveEnable = _arg_8;
            this.enterEnable = _arg_9;
            this.escEnable = _arg_10;
            this.bottomGap = _arg_11;
            this.buttonGape = _arg_12;
            this.autoDispose = _arg_13;
        }

        public function get autoButtonGape():Boolean
        {
            return (this._autoButtonGape);
        }

        public function set autoButtonGape(_arg_1:Boolean):void
        {
            if (this._autoButtonGape == _arg_1)
            {
                return;
            };
            this._autoButtonGape = _arg_1;
            this.fireChange();
        }

        public function get autoDispose():Boolean
        {
            return (this._autoDispose);
        }

        public function set autoDispose(_arg_1:Boolean):void
        {
            if (this._autoDispose == _arg_1)
            {
                return;
            };
            this._autoDispose = _arg_1;
            this.fireChange();
        }

        public function get bottomGap():int
        {
            return (this._bottomGap);
        }

        public function set bottomGap(_arg_1:int):void
        {
            if (this._bottomGap == _arg_1)
            {
                return;
            };
            this._bottomGap = _arg_1;
            this.fireChange();
        }

        public function get buttonGape():int
        {
            return (this._buttonGape);
        }

        public function set buttonGape(_arg_1:int):void
        {
            if (this._buttonGape == _arg_1)
            {
                return;
            };
            this._buttonGape = _arg_1;
            this.fireChange();
        }

        public function get cancelLabel():String
        {
            return (this._cancelLabel);
        }

        public function set cancelLabel(_arg_1:String):void
        {
            if (this._cancelLabel == _arg_1)
            {
                return;
            };
            this._cancelLabel = _arg_1;
            this.fireChange();
        }

        public function get submitEnabled():Boolean
        {
            return (this._submitEnabled);
        }

        public function set submitEnabled(_arg_1:Boolean):void
        {
            if (this._submitEnabled != _arg_1)
            {
                this._submitEnabled = _arg_1;
                this.fireChange();
            };
        }

        public function get cancelEnabled():Boolean
        {
            return (this._cancelEnabled);
        }

        public function set cancelEnabled(_arg_1:Boolean):void
        {
            if (this._cancelEnabled != _arg_1)
            {
                this._cancelEnabled = _arg_1;
                this.fireChange();
            };
        }

        public function get data():Object
        {
            return (this._data);
        }

        public function set data(_arg_1:Object):void
        {
            if (this._data == _arg_1)
            {
                return;
            };
            this._data = _arg_1;
            this.fireChange();
        }

        public function get enableHtml():Boolean
        {
            return (this._enableHtml);
        }

        public function set enableHtml(_arg_1:Boolean):void
        {
            if (this._enableHtml == _arg_1)
            {
                return;
            };
            this._enableHtml = _arg_1;
            this.fireChange();
        }

        public function get enterEnable():Boolean
        {
            return (this._enterEnable);
        }

        public function set enterEnable(_arg_1:Boolean):void
        {
            if (this._enterEnable == _arg_1)
            {
                return;
            };
            this._enterEnable = _arg_1;
            this.fireChange();
        }

        public function get escEnable():Boolean
        {
            return (this._escEnable);
        }

        public function set escEnable(_arg_1:Boolean):void
        {
            if (this._escEnable == _arg_1)
            {
                return;
            };
            this._escEnable = _arg_1;
            this.fireChange();
        }

        public function get frameCenter():Boolean
        {
            return (this._frameCenter);
        }

        public function set frameCenter(_arg_1:Boolean):void
        {
            if (this._frameCenter == _arg_1)
            {
                return;
            };
            this._frameCenter = _arg_1;
            this.fireChange();
        }

        public function get moveEnable():Boolean
        {
            return (this._moveEnable);
        }

        public function set moveEnable(_arg_1:Boolean):void
        {
            if (this._moveEnable == _arg_1)
            {
                return;
            };
            this._moveEnable = _arg_1;
            this.fireChange();
        }

        public function get mutiline():Boolean
        {
            return (this._mutiline);
        }

        public function set mutiline(_arg_1:Boolean):void
        {
            if (this._mutiline == _arg_1)
            {
                return;
            };
            this._mutiline = _arg_1;
            this.fireChange();
        }

        public function get showCancel():Boolean
        {
            return (this._showCancel);
        }

        public function set showCancel(_arg_1:Boolean):void
        {
            if (this._showCancel == _arg_1)
            {
                return;
            };
            this._showCancel = _arg_1;
            this.fireChange();
        }

        public function get showSubmit():Boolean
        {
            return (this._showSubmit);
        }

        public function set showSubmit(_arg_1:Boolean):void
        {
            if (this._showSubmit == _arg_1)
            {
                return;
            };
            this._showSubmit = _arg_1;
            this.fireChange();
        }

        public function get submitLabel():String
        {
            return (this._submitLabel);
        }

        public function set submitLabel(_arg_1:String):void
        {
            if (this._submitLabel == _arg_1)
            {
                return;
            };
            this._submitLabel = _arg_1;
            this.fireChange();
        }

        public function get textShowHeight():int
        {
            return (this._textShowHeight);
        }

        public function set textShowHeight(_arg_1:int):void
        {
            if (this._textShowHeight == _arg_1)
            {
                return;
            };
            this._textShowHeight = _arg_1;
            this.fireChange();
        }

        public function get textShowWidth():int
        {
            return (this._textShowWidth);
        }

        public function set textShowWidth(_arg_1:int):void
        {
            if (this._textShowWidth == _arg_1)
            {
                return;
            };
            this._textShowWidth = _arg_1;
            this.fireChange();
        }

        public function get title():String
        {
            return (this._title);
        }

        public function set title(_arg_1:String):void
        {
            if (this._title == _arg_1)
            {
                return;
            };
            this._title = _arg_1;
            this.fireChange();
        }

        public function get sound():*
        {
            return (this._soundID);
        }

        public function set sound(_arg_1:*):void
        {
            if (this._soundID == _arg_1)
            {
                return;
            };
            this._soundID = _arg_1;
            this.fireChange();
        }

        private function fireChange():void
        {
            dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
        }

        public function get customPos():Point
        {
            return (this._customPos);
        }

        public function set customPos(_arg_1:Point):void
        {
            this._customPos = _arg_1;
        }

        public function get carryData():Object
        {
            return (this._carryData);
        }

        public function set carryData(_arg_1:Object):void
        {
            this._carryData = _arg_1;
        }


    }
}//package com.pickgliss.ui.vo

