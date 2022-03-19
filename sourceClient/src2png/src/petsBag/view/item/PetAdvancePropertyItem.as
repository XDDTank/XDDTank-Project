// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetAdvancePropertyItem

package petsBag.view.item
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class PetAdvancePropertyItem extends Component 
    {

        private var _valueTxt:FilterFrameText;
        private var _upflag:Bitmap;
        private var _upTxt:FilterFrameText;
        private var _type:int;
        private var _value:int;
        private var _addValue:int;

        public function PetAdvancePropertyItem(_arg_1:int)
        {
            this._type = _arg_1;
            super();
        }

        override protected function init():void
        {
            super.init();
            this._valueTxt = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.propertyItem.value");
            addChild(this._valueTxt);
            this._upflag = ComponentFactory.Instance.creat("asset.petsBag.petAdvanceFrame.increaseArrow");
            addChild(this._upflag);
            this._upTxt = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.propertyItem.uptxt");
            addChild(this._upTxt);
            _height = 22;
        }

        public function get type():int
        {
            return (this._type);
        }

        public function get value():int
        {
            return (this._value);
        }

        public function set value(_arg_1:int):void
        {
            this._value = _arg_1;
            this._valueTxt.text = String(this._value);
        }

        public function get addValue():int
        {
            return (this._addValue);
        }

        public function set addValue(_arg_1:int):void
        {
            this._addValue = _arg_1;
            this._upflag.visible = (this._addValue > 0);
            this._upTxt.text = String(this._addValue);
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._valueTxt);
            this._valueTxt = null;
            ObjectUtils.disposeObject(this._upflag);
            this._upflag = null;
            ObjectUtils.disposeObject(this._upTxt);
            this._upTxt = null;
            super.dispose();
        }


    }
}//package petsBag.view.item

