// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.info.PropButton

package bagAndInfo.info
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.Directions;
    import bagAndInfo.tips.CharacterPropTxtTipInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class PropButton extends Sprite implements Disposeable, ITipedDisplay 
    {

        protected var _back:DisplayObject;
        protected var _tipGapH:int = 0;
        protected var _tipGapV:int = 0;
        protected var _tipDirection:String = ((((((Directions.DIRECTION_BR + ",") + Directions.DIRECTION_TR) + ",") + Directions.DIRECTION_BL) + ",") + Directions.DIRECTION_TL);
        protected var _tipStyle:String = "core.PropTxtTips";
        protected var _tipData:CharacterPropTxtTipInfo = new CharacterPropTxtTipInfo();

        public function PropButton()
        {
            mouseChildren = false;
            this.addChildren();
        }

        protected function addChildren():void
        {
            if ((!(this._back)))
            {
                this._back = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.background_propbutton");
                addChild(this._back);
            };
        }

        public function dispose():void
        {
            if (this._back)
            {
                ObjectUtils.disposeObject(this._back);
                this._back = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get color():int
        {
            return (this._tipData.color);
        }

        public function set color(_arg_1:int):void
        {
            this._tipData.color = _arg_1;
        }

        public function get property():String
        {
            return (this._tipData.property);
        }

        public function set property(_arg_1:String):void
        {
            this._tipData.property = (("[" + _arg_1) + "]");
        }

        public function get detail():String
        {
            return (this._tipData.detail);
        }

        public function set detail(_arg_1:String):void
        {
            this._tipData.detail = _arg_1;
        }

        public function get propertySource():String
        {
            return (this._tipData.propertySource);
        }

        public function set propertySource(_arg_1:String):void
        {
            this._tipData.propertySource = _arg_1;
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipData = (_arg_1 as CharacterPropTxtTipInfo);
        }

        public function get tipDirctions():String
        {
            return (this._tipDirection);
        }

        public function set tipDirctions(_arg_1:String):void
        {
            this._tipDirection = _arg_1;
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function set tipGapH(_arg_1:int):void
        {
            this._tipGapH = _arg_1;
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function set tipGapV(_arg_1:int):void
        {
            this._tipGapV = _arg_1;
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function set tipStyle(_arg_1:String):void
        {
            this._tipStyle = _arg_1;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }


    }
}//package bagAndInfo.info

