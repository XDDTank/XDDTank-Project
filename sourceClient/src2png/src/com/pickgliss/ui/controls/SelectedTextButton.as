// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.SelectedTextButton

package com.pickgliss.ui.controls
{
    import flash.text.TextField;
    import com.pickgliss.geom.InnerRectangle;
    import com.pickgliss.geom.OuterRectPos;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    public class SelectedTextButton extends SelectedButton 
    {

        public static const P_backgoundInnerRect:String = "backgoundInnerRect";
        public static const P_text:String = "text";
        public static const P_selectedTextField:String = "selectedtextField";
        public static const P_unSelectedTextField:String = "unselectedtextField";
        public static const P_selected:String = "selected";
        public static const P_unSelectedButtonOuterRectPos:String = "unSelectedButtonOuterRectPos";
        public static const P_SelectedButtonOuterRectPos:String = "selectedButtonOuterRectPos";

        protected var _selectedTextField:TextField;
        protected var _unSelectedTextField:TextField;
        protected var _text:String = "";
        protected var _textStyle:String;
        protected var _selectedBackgoundInnerRect:InnerRectangle = new InnerRectangle(0, 0, 0, 0, -1);
        protected var _unselectedBackgoundInnerRect:InnerRectangle = new InnerRectangle(0, 0, 0, 0, -1);
        protected var _backgoundInnerRectString:String;
        protected var _unSelectedButtonOuterRectPosString:String;
        protected var _selectedButtonOuterRectPosString:String;
        protected var _selectedButtonOuterRectPos:OuterRectPos;
        protected var _unSelectedButtonOuterRectPos:OuterRectPos;


        public function set unSelectedButtonOuterRectPosString(_arg_1:String):void
        {
            if (this._unSelectedButtonOuterRectPosString == _arg_1)
            {
                return;
            };
            this._unSelectedButtonOuterRectPosString = _arg_1;
            this._unSelectedButtonOuterRectPos = ClassUtils.CreatInstance(ClassUtils.OUTTERRECPOS, ComponentFactory.parasArgs(this._unSelectedButtonOuterRectPosString));
            onPropertiesChanged(P_unSelectedButtonOuterRectPos);
        }

        public function set selectedButtonOuterRectPosString(_arg_1:String):void
        {
            if (this._selectedButtonOuterRectPosString == _arg_1)
            {
                return;
            };
            this._selectedButtonOuterRectPosString = _arg_1;
            this._selectedButtonOuterRectPos = ClassUtils.CreatInstance(ClassUtils.OUTTERRECPOS, ComponentFactory.parasArgs(this._selectedButtonOuterRectPosString));
            onPropertiesChanged(P_SelectedButtonOuterRectPos);
        }

        public function set backgoundInnerRectString(_arg_1:String):void
        {
            if (this._backgoundInnerRectString == _arg_1)
            {
                return;
            };
            this._backgoundInnerRectString = _arg_1;
            var _local_2:Array = ComponentFactory.parasArgs(this._backgoundInnerRectString);
            if (((_local_2.length > 0) && (!(_local_2[0] == ""))))
            {
                this._selectedBackgoundInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, String(_local_2[0]).split("|"));
            };
            if (((_local_2.length > 1) && (!(_local_2[1] == ""))))
            {
                this._unselectedBackgoundInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, String(_local_2[1]).split("|"));
            };
            onPropertiesChanged(P_backgoundInnerRect);
        }

        override public function dispose():void
        {
            if (this._selectedTextField)
            {
                ObjectUtils.disposeObject(this._selectedTextField);
            };
            this._selectedTextField = null;
            if (this._unSelectedTextField)
            {
                ObjectUtils.disposeObject(this._unSelectedTextField);
            };
            this._unSelectedTextField = null;
            super.dispose();
        }

        public function set text(_arg_1:String):void
        {
            if (this._text == _arg_1)
            {
                return;
            };
            this._text = _arg_1;
            onPropertiesChanged(P_text);
        }

        public function set selectedTextField(_arg_1:TextField):void
        {
            if (this._selectedTextField == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._selectedTextField);
            this._selectedTextField = _arg_1;
            onPropertiesChanged(P_selectedTextField);
        }

        public function set unSelectedTextField(_arg_1:TextField):void
        {
            if (this._unSelectedTextField == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._unSelectedTextField);
            this._unSelectedTextField = _arg_1;
            onPropertiesChanged(P_unSelectedTextField);
        }

        public function set textStyle(_arg_1:String):void
        {
            if (this._textStyle == _arg_1)
            {
                return;
            };
            this._textStyle = _arg_1;
            var _local_2:Array = ComponentFactory.parasArgs(_arg_1);
            if (((_local_2.length > 0) && (!(_local_2[0] == ""))))
            {
                this.selectedTextField = ComponentFactory.Instance.creatComponentByStylename(_local_2[0]);
            };
            if (((_local_2.length > 1) && (!(_local_2[1] == ""))))
            {
                this.unSelectedTextField = ComponentFactory.Instance.creatComponentByStylename(_local_2[1]);
            };
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._selectedTextField)
            {
                addChild(this._selectedTextField);
            };
            if (this._unSelectedTextField)
            {
                addChild(this._unSelectedTextField);
            };
        }

        override public function set selected(_arg_1:Boolean):void
        {
            super.selected = _arg_1;
            if (this._selectedTextField)
            {
                this._selectedTextField.visible = _arg_1;
            };
            if (this._unSelectedTextField)
            {
                this._unSelectedTextField.visible = (!(_arg_1));
            };
            onPropertiesChanged(P_selected);
        }

        override protected function onProppertiesUpdate():void
        {
            var _local_1:Rectangle;
            var _local_2:Rectangle;
            super.onProppertiesUpdate();
            if (((_selected) && (this._selectedTextField)))
            {
                this._selectedTextField.text = this._text;
            }
            else
            {
                if (((!(_selected)) && (this._unSelectedTextField)))
                {
                    this._unSelectedTextField.text = this._text;
                };
            };
            if (_autoSizeAble)
            {
                if (((_selected) && (this._selectedTextField)))
                {
                    this.upSelecetdButtonPos();
                    _local_1 = this._selectedBackgoundInnerRect.getInnerRect(this._selectedTextField.textWidth, this._selectedTextField.textHeight);
                    _width = (_selectedButton.width = _local_1.width);
                    _height = (_selectedButton.height = _local_1.height);
                    this._selectedTextField.x = this._selectedBackgoundInnerRect.para1;
                    this._selectedTextField.y = this._selectedBackgoundInnerRect.para3;
                }
                else
                {
                    if (((!(_selected)) && (this._unSelectedTextField)))
                    {
                        this.upUnselectedButtonPos();
                        _local_2 = this._unselectedBackgoundInnerRect.getInnerRect(this._unSelectedTextField.textWidth, this._unSelectedTextField.textHeight);
                        _width = (_unSelectedButton.width = _local_2.width);
                        _height = (_unSelectedButton.height = _local_2.height);
                        this._unSelectedTextField.x = (this._unselectedBackgoundInnerRect.para1 + _unSelectedButton.x);
                        this._unSelectedTextField.y = (this._unselectedBackgoundInnerRect.para3 + _unSelectedButton.y);
                    }
                    else
                    {
                        if (_selected)
                        {
                            this.upSelecetdButtonPos();
                            _width = _selectedButton.width;
                            _height = _selectedButton.height;
                        }
                        else
                        {
                            this.upUnselectedButtonPos();
                            _width = _unSelectedButton.width;
                            _height = _unSelectedButton.height;
                        };
                    };
                };
            }
            else
            {
                this.upSelecetdButtonPos();
                this.upUnselectedButtonPos();
                _selectedButton.width = (_unSelectedButton.width = _width);
                _selectedButton.height = (_unSelectedButton.height = _height);
                if (this._selectedTextField)
                {
                    this._selectedTextField.x = ((_width - this._selectedTextField.textWidth) / 2);
                    this._selectedTextField.y = ((_height - this._selectedTextField.textHeight) / 2);
                };
                if (this._unSelectedTextField)
                {
                    this._unSelectedTextField.x = ((_width - this._unSelectedTextField.textWidth) / 2);
                    this._unSelectedTextField.y = ((_height - this._unSelectedTextField.textHeight) / 2);
                };
            };
        }

        private function upUnselectedButtonPos():void
        {
            if (((_unSelectedButton == null) || (_selectedButton == null)))
            {
                return;
            };
            if (this._unSelectedButtonOuterRectPos == null)
            {
                return;
            };
            var _local_1:Point = this._unSelectedButtonOuterRectPos.getPos(_unSelectedButton.width, _unSelectedButton.height, _selectedButton.width, _selectedButton.height);
            _unSelectedButton.x = _local_1.x;
            _unSelectedButton.y = _local_1.y;
        }

        private function upSelecetdButtonPos():void
        {
            if (((_selectedButton == null) || (_selectedButton == null)))
            {
                return;
            };
            if (this._selectedButtonOuterRectPos == null)
            {
                return;
            };
            var _local_1:Point = this._selectedButtonOuterRectPos.getPos(_selectedButton.width, _selectedButton.height, _selectedButton.width, _selectedButton.height);
            _selectedButton.x = _local_1.x;
            _selectedButton.y = _local_1.y;
        }


    }
}//package com.pickgliss.ui.controls

