// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.ChangeNumToolTip

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.tip.ITransformableTip;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Sprite;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class ChangeNumToolTip extends BaseTip implements ITransformableTip 
    {

        private var _title:FilterFrameText;
        private var _currentTxt:FilterFrameText;
        private var _totalTxt:FilterFrameText;
        private var _contentTxt:FilterFrameText;
        private var _container:Sprite;
        private var _tempData:Object;
        private var _bg:ScaleBitmapImage;


        override protected function init():void
        {
            this._title = ComponentFactory.Instance.creatComponentByStylename("ChangeNumToolTip.titleTxt");
            this._totalTxt = ComponentFactory.Instance.creatComponentByStylename("ChangeNumToolTip.totalTxt");
            this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("ChangeNumToolTip.contentTxt");
            this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
            this._container = new Sprite();
            this._container.addChild(this._title);
            this._container.addChild(this._totalTxt);
            this._container.addChild(this._contentTxt);
            super.init();
            this.tipbackgound = this._bg;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._container);
            this._container.mouseEnabled = false;
            this._container.mouseChildren = false;
            mouseChildren = false;
            mouseEnabled = false;
        }

        override public function get tipData():Object
        {
            return (this._tempData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            if ((_arg_1 is ChangeNumToolTipInfo))
            {
                this.update(_arg_1.currentTxt, _arg_1.title, _arg_1.current, _arg_1.total, _arg_1.content);
            }
            else
            {
                this.visible = false;
            };
            this._tempData = _arg_1;
        }

        private function update(_arg_1:FilterFrameText, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:String):void
        {
            var _local_6:FilterFrameText = this._currentTxt;
            this._currentTxt = _arg_1;
            this._container.addChild(this._currentTxt);
            this._title.text = _arg_2;
            this._currentTxt.text = String(_arg_3);
            this._totalTxt.text = ("/" + String(_arg_4));
            this._contentTxt.text = _arg_5;
            this.drawBG();
            if ((((!(_local_6 == null)) && (!(_local_6 == this._currentTxt))) && (_local_6.parent)))
            {
                _local_6.parent.removeChild(_local_6);
            };
        }

        private function reset():void
        {
            this._bg.height = 0;
            this._bg.width = 0;
        }

        private function drawBG(_arg_1:int=0):void
        {
            this.reset();
            if (_arg_1 == 0)
            {
                this._bg.width = (this._container.width + 10);
                this._bg.height = (this._container.height + 10);
            }
            else
            {
                this._bg.width = (_arg_1 + 2);
                this._bg.height = (this._container.height + 10);
            };
            _width = this._bg.width;
            _height = this._bg.height;
        }

        public function get tipWidth():int
        {
            return (0);
        }

        public function set tipWidth(_arg_1:int):void
        {
        }

        public function get tipHeight():int
        {
            return (0);
        }

        public function set tipHeight(_arg_1:int):void
        {
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._title)
            {
                ObjectUtils.disposeObject(this._title);
            };
            this._title = null;
            if (this._currentTxt)
            {
                ObjectUtils.disposeObject(this._currentTxt);
            };
            this._currentTxt = null;
            if (this._totalTxt)
            {
                ObjectUtils.disposeObject(this._totalTxt);
            };
            this._totalTxt = null;
            if (this._contentTxt)
            {
                ObjectUtils.disposeObject(this._contentTxt);
            };
            this._contentTxt = null;
            if (this._container)
            {
                ObjectUtils.disposeObject(this._container);
            };
            this._container = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package ddt.view.tips

