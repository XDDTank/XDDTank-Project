// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.PropTxtTip

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import flash.text.TextFormat;

    public class PropTxtTip extends BaseTip 
    {

        protected var property_txt:FilterFrameText;
        protected var detail_txt:FilterFrameText;
        protected var _bg:ScaleBitmapImage;
        private var _tempData:Object;
        private var _oriW:int;
        private var _oriH:int;


        override protected function init():void
        {
            mouseChildren = false;
            mouseEnabled = false;
            super.init();
            this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
            this.property_txt = ComponentFactory.Instance.creat("core.PerpertyTxt");
            this.detail_txt = ComponentFactory.Instance.creat("core.DetailTxt");
            var _local_1:int = this.detail_txt.width;
            this.detail_txt.multiline = true;
            this.detail_txt.wordWrap = true;
            this.detail_txt.width = _local_1;
            this.detail_txt.selectable = false;
            this.property_txt.selectable = false;
            this.tipbackgound = this._bg;
            this._oriW = 184;
            this._oriH = 90;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this.property_txt)
            {
                addChild(this.property_txt);
            };
            if (this.detail_txt)
            {
                addChild(this.detail_txt);
                this.updateWH();
            };
        }

        override public function get tipData():Object
        {
            return (this._tempData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            if ((_arg_1 is PropTxtTipInfo))
            {
                this._tempData = _arg_1;
                this.visible = true;
                this.propertyText(_arg_1.property);
                this.detailText(_arg_1.detail);
                this.propertyTextColor(_arg_1.color);
            }
            else
            {
                this.visible = false;
            };
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this.property_txt);
            this.property_txt = null;
            ObjectUtils.disposeObject(this.detail_txt);
            this.detail_txt = null;
            super.dispose();
        }

        private function propertyTextColor(_arg_1:uint):void
        {
            var _local_2:TextFormat = this.property_txt.getTextFormat();
            _local_2.color = _arg_1;
            this.property_txt.setTextFormat(_local_2);
        }

        private function propertyText(_arg_1:String):void
        {
            this.property_txt.text = _arg_1;
        }

        private function detailText(_arg_1:String):void
        {
            this.detail_txt.text = _arg_1;
            this.updateWH();
        }

        protected function updateWH():void
        {
            if ((this.detail_txt.y + this.detail_txt.height) >= this._oriH)
            {
                this._bg.height = ((this.detail_txt.y + this.detail_txt.height) + 2);
            }
            else
            {
                this._bg.height = this._oriH;
            };
            this._bg.width = this._oriW;
            _width = this._bg.width;
            _height = this._bg.height;
        }


    }
}//package ddt.view.tips

