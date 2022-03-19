// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.embed.EmbedStoneTip

package store.view.embed
{
    import ddt.view.tips.GoodTip;
    import com.pickgliss.geom.InnerRectangle;
    import flash.text.TextField;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import ddt.view.tips.GoodTipInfo;

    public class EmbedStoneTip extends GoodTip 
    {

        public static const P_backgoundInnerRect:String = "backOutterRect";
        public static const P_tipTextField:String = "tipTextField";

        protected var _backInnerRect:InnerRectangle;
        protected var _backgoundInnerRectString:String;
        protected var _tipTextField:TextField;
        protected var _tipTextStyle:String;
        private var _currentData:Object;


        public function set backgoundInnerRectString(_arg_1:String):void
        {
            if (this._backgoundInnerRectString == _arg_1)
            {
                return;
            };
            this._backgoundInnerRectString = _arg_1;
            this._backInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._backgoundInnerRectString));
            onPropertiesChanged(P_backgoundInnerRect);
        }

        override public function dispose():void
        {
            if (this._tipTextField)
            {
                ObjectUtils.disposeObject(this._tipTextField);
            };
            this._tipTextField = null;
            super.dispose();
        }

        public function set tipTextField(_arg_1:TextField):void
        {
            if (this._tipTextField == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._tipTextField);
            this._tipTextField = _arg_1;
            onPropertiesChanged(P_tipTextField);
        }

        public function set tipTextStyle(_arg_1:String):void
        {
            if (this._tipTextStyle == _arg_1)
            {
                return;
            };
            this._tipTextStyle = _arg_1;
            this.tipTextField = ComponentFactory.Instance.creat(this._tipTextStyle);
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._tipTextField)
            {
                addChild(this._tipTextField);
            };
            if ((_tipData is DisplayObject))
            {
                addChild((_tipData as DisplayObject));
            };
        }

        override public function get tipData():Object
        {
            return (this._currentData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            var _local_2:Rectangle;
            var _local_3:GoodTipInfo;
            if ((_arg_1 as String))
            {
                if ((_arg_1 is String))
                {
                    this._tipTextField.wordWrap = false;
                    this._tipTextField.text = String(_arg_1);
                    _local_2 = this._backInnerRect.getInnerRect(this._tipTextField.width, this._tipTextField.height);
                    _width = (_tipbackgound.width = _local_2.width);
                    _height = (_tipbackgound.height = _local_2.height);
                }
                else
                {
                    if ((_arg_1 is Array))
                    {
                        this._tipTextField.wordWrap = true;
                        this._tipTextField.width = int(_arg_1[1]);
                        this._tipTextField.text = String(_arg_1[0]);
                        _local_2 = this._backInnerRect.getInnerRect(this._tipTextField.width, this._tipTextField.height);
                        _width = (_tipbackgound.width = _local_2.width);
                        _height = (_tipbackgound.height = _local_2.height);
                    };
                };
                visible = true;
                this._tipTextField.x = this._backInnerRect.para1;
                this._tipTextField.y = this._backInnerRect.para3;
                this._currentData = _arg_1;
            }
            else
            {
                if ((_arg_1 as GoodTipInfo))
                {
                    _local_3 = (_arg_1 as GoodTipInfo);
                    this._currentData = _local_3;
                    showTip(_local_3.itemInfo, _local_3.typeIsSecond);
                    visible = true;
                }
                else
                {
                    visible = false;
                    this._currentData = null;
                };
            };
        }


    }
}//package store.view.embed

