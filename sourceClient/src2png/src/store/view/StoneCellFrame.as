// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.StoneCellFrame

package store.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;

    public class StoneCellFrame extends Sprite implements Disposeable 
    {

        private var _textField:FilterFrameText;
        private var _textFieldX:Number;
        private var _textFieldY:Number;
        private var _text:String;
        private var _textStyle:String;
        private var _backStyle:String;


        public function set label(_arg_1:String):void
        {
            if (this._textField == null)
            {
                return;
            };
            this._text = _arg_1;
            this._textField.text = this._text;
            this._textField.x = this.textFieldX;
            this._textField.y = this.textFieldY;
        }

        private function init():void
        {
            addChild(this._textField);
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._textField);
            this._textField = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get textStyle():String
        {
            return (this._textStyle);
        }

        public function set textStyle(_arg_1:String):void
        {
            if (((_arg_1 == null) || (_arg_1.length == 0)))
            {
                return;
            };
            this._textStyle = _arg_1;
            this._textField = ComponentFactory.Instance.creatComponentByStylename(this._textStyle);
            addChild(this._textField);
        }

        public function get backStyle():String
        {
            return (this._backStyle);
        }

        public function set backStyle(_arg_1:String):void
        {
            if (((_arg_1 == null) || (_arg_1.length == 0)))
            {
                return;
            };
            this._backStyle = _arg_1;
        }

        public function get textFieldX():Number
        {
            return (this._textFieldX);
        }

        public function set textFieldX(_arg_1:Number):void
        {
            this._textFieldX = _arg_1;
        }

        public function get textFieldY():Number
        {
            return (this._textFieldY);
        }

        public function set textFieldY(_arg_1:Number):void
        {
            this._textFieldY = _arg_1;
        }


    }
}//package store.view

