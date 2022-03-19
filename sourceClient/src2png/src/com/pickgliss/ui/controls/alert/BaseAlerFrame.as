// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.alert.BaseAlerFrame

package com.pickgliss.ui.controls.alert
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.toplevel.StageReferance;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.KeyboardEvent;
    import com.pickgliss.events.InteractiveEvent;
    import com.pickgliss.ui.ComponentSetting;
    import com.pickgliss.events.FrameEvent;
    import flash.ui.Keyboard;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.core.Component;

    public class BaseAlerFrame extends Frame 
    {

        public static const P_buttonToBottom:String = "buttonToBottom";
        public static const P_cancelButton:String = "submitButton";
        public static const P_info:String = "info";
        public static const P_submitButton:String = "submitButton";

        protected var _buttonToBottom:int;
        protected var _cancelButton:BaseButton;
        protected var _cancelButtonStyle:String;
        protected var _info:AlertInfo;
        protected var _sound:*;
        protected var _submitButton:BaseButton;
        protected var _submitButtonStyle:String;


        public function set buttonToBottom(_arg_1:int):void
        {
            if (this._buttonToBottom == _arg_1)
            {
                return;
            };
            this._buttonToBottom = _arg_1;
            onPropertiesChanged(P_buttonToBottom);
        }

        public function set cancelButtonEnable(_arg_1:Boolean):void
        {
            this._cancelButton.enable = _arg_1;
        }

        public function set cancelButtonStyle(_arg_1:String):void
        {
            if (this._cancelButtonStyle == _arg_1)
            {
                return;
            };
            this._cancelButtonStyle = _arg_1;
            this._cancelButton = ComponentFactory.Instance.creat(this._cancelButtonStyle);
            onPropertiesChanged(P_cancelButton);
        }

        override public function dispose():void
        {
            var _local_1:DisplayObject = (StageReferance.stage.focus as DisplayObject);
            if (((_local_1) && (contains(_local_1))))
            {
                StageReferance.stage.focus = null;
            };
            if (this._submitButton)
            {
                this._submitButton.removeEventListener(MouseEvent.CLICK, this.__onSubmitClick);
                ObjectUtils.disposeObject(this._submitButton);
                this._submitButton = null;
            };
            if (this._cancelButton)
            {
                this._cancelButton.removeEventListener(MouseEvent.CLICK, this.__onCancelClick);
                ObjectUtils.disposeObject(this._cancelButton);
                this._cancelButton = null;
            };
            removeEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
            this._info = null;
            super.dispose();
        }

        public function get info():AlertInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:AlertInfo):void
        {
            if (this._info == _arg_1)
            {
                return;
            };
            if (this._info)
            {
                this._info.removeEventListener(InteractiveEvent.STATE_CHANGED, this.__onInfoChanged);
            };
            this._info = _arg_1;
            this._info.addEventListener(InteractiveEvent.STATE_CHANGED, this.__onInfoChanged);
            onPropertiesChanged(P_info);
        }

        public function set submitButtonEnable(_arg_1:Boolean):void
        {
            this._submitButton.enable = _arg_1;
        }

        public function set submitButtonStyle(_arg_1:String):void
        {
            if (this._submitButtonStyle == _arg_1)
            {
                return;
            };
            this._submitButtonStyle = _arg_1;
            this._submitButton = ComponentFactory.Instance.creat(this._submitButtonStyle);
            onPropertiesChanged(P_submitButton);
        }

        protected function __onCancelClick(_arg_1:MouseEvent):void
        {
            if (this._sound != null)
            {
                ComponentSetting.PLAY_SOUND_FUNC(this._sound);
            };
            this.onResponse(FrameEvent.CANCEL_CLICK);
        }

        override protected function __onCloseClick(_arg_1:MouseEvent):void
        {
            if (this._sound != null)
            {
                ComponentSetting.PLAY_SOUND_FUNC(this._sound);
            };
            super.__onCloseClick(_arg_1);
        }

        override protected function __onKeyDown(_arg_1:KeyboardEvent):void
        {
            if ((((_arg_1.keyCode == Keyboard.ENTER) && (enterEnable)) || ((_arg_1.keyCode == Keyboard.ESCAPE) && (escEnable))))
            {
                if (this._sound != null)
                {
                    ComponentSetting.PLAY_SOUND_FUNC(this._sound);
                };
            };
            super.__onKeyDown(_arg_1);
        }

        protected function __onSubmitClick(_arg_1:MouseEvent):void
        {
            if (this._sound != null)
            {
                ComponentSetting.PLAY_SOUND_FUNC(this._sound);
            };
            this.onResponse(FrameEvent.SUBMIT_CLICK);
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._submitButton)
            {
                addChild(this._submitButton);
            };
            if (this._cancelButton)
            {
                addChild(this._cancelButton);
            };
        }

        override protected function onProppertiesUpdate():void
        {
            if (_changedPropeties[P_info])
            {
                this._sound = this._info.sound;
                _escEnable = this._info.escEnable;
                _enterEnable = this.info.enterEnable;
                _titleText = this._info.title;
                _changedPropeties[Frame.P_titleText] = true;
                _moveEnable = this._info.moveEnable;
                _changedPropeties[Frame.P_moveEnable] = true;
            };
            super.onProppertiesUpdate();
            if ((((_changedPropeties[P_info]) || (_changedPropeties[P_submitButton])) || (_changedPropeties[P_cancelButton])))
            {
                if (((this._cancelButton) && (this._info)))
                {
                    this._cancelButton.visible = this._info.showCancel;
                    this._cancelButton.enable = this._info.cancelEnabled;
                    if ((this._cancelButton is TextButton))
                    {
                        TextButton(this._cancelButton).text = this._info.cancelLabel;
                    };
                    if (this._cancelButton.visible)
                    {
                        this._cancelButton.addEventListener(MouseEvent.CLICK, this.__onCancelClick);
                    };
                };
                if (((this._submitButton) && (this._info)))
                {
                    this._submitButton.visible = this._info.showSubmit;
                    this._submitButton.enable = this._info.submitEnabled;
                    if ((this._submitButton is TextButton))
                    {
                        TextButton(this._submitButton).text = this._info.submitLabel;
                    };
                    if (this._submitButton.visible)
                    {
                        this._submitButton.addEventListener(MouseEvent.CLICK, this.__onSubmitClick);
                    };
                };
            };
            if (((((_changedPropeties[P_info]) || (_changedPropeties[Component.P_height])) || (_changedPropeties[Component.P_width])) || (_changedPropeties[P_buttonToBottom])))
            {
                this.updatePos();
            };
        }

        override protected function onResponse(_arg_1:int):void
        {
            if (((this._info) && (this._info.autoDispose)))
            {
                this.dispose();
            };
            super.onResponse(_arg_1);
        }

        protected function updatePos():void
        {
            if (this._info == null)
            {
                return;
            };
            if (this._info.bottomGap)
            {
                this._buttonToBottom = int(this._info.bottomGap);
            };
            if (this._submitButton)
            {
                this._submitButton.y = ((_height - this._submitButton.height) - this._buttonToBottom);
            };
            if (this._cancelButton)
            {
                this._cancelButton.y = ((_height - this._cancelButton.height) - this._buttonToBottom);
            };
            if (((this._info.showCancel) || (this._info.showSubmit)))
            {
                if (this._info.customPos)
                {
                    if (this._submitButton)
                    {
                        this._submitButton.x = this._info.customPos.x;
                        this._submitButton.y = this._info.customPos.y;
                        if (this._cancelButton)
                        {
                            this._cancelButton.x = ((this._info.customPos.x + this._cancelButton.width) + this._info.buttonGape);
                            this._cancelButton.y = this._info.customPos.y;
                        };
                    }
                    else
                    {
                        if (this._cancelButton)
                        {
                            this._cancelButton.x = this._info.customPos.x;
                            this._cancelButton.y = this._info.customPos.y;
                        };
                    };
                }
                else
                {
                    if (this._info.autoButtonGape)
                    {
                        if (((!(this._submitButton == null)) && (!(this._cancelButton == null))))
                        {
                            this._info.buttonGape = (((_width - this._submitButton.width) - this._cancelButton.width) / 2);
                        };
                    };
                    if (((!(this._info.showCancel)) && (this._submitButton)))
                    {
                        this._submitButton.x = ((_width - this._submitButton.width) / 2);
                    }
                    else
                    {
                        if (((!(this._info.showSubmit)) && (this._cancelButton)))
                        {
                            this._cancelButton.x = ((_width - this._cancelButton.width) / 2);
                        }
                        else
                        {
                            if (((!(this._cancelButton == null)) && (!(this._submitButton == null))))
                            {
                                this._submitButton.x = ((((_width - this._submitButton.width) - this._cancelButton.width) - this._info.buttonGape) / 2);
                                this._cancelButton.x = ((this._submitButton.x + this._submitButton.width) + this._info.buttonGape);
                            };
                        };
                    };
                };
            };
        }

        private function __onInfoChanged(_arg_1:InteractiveEvent):void
        {
            onPropertiesChanged(P_info);
        }


    }
}//package com.pickgliss.ui.controls.alert

