// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.WebSpeedTip

package game.view
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import room.model.WebSpeedInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class WebSpeedTip extends BaseTip 
    {

        private var _tempData:Object;
        private var _bg:ScaleBitmapImage;
        private var _stateTxt:FilterFrameText;
        private var _delayTxt:FilterFrameText;
        private var _fpsTxt:FilterFrameText;
        private var _explain1:FilterFrameText;
        private var _explain2:FilterFrameText;
        private var _container:Sprite;


        override protected function init():void
        {
            this._stateTxt = ComponentFactory.Instance.creatComponentByStylename("game.webSpeed.stateTxt");
            this._delayTxt = ComponentFactory.Instance.creatComponentByStylename("game.webSpeed.delayTxt");
            this._fpsTxt = ComponentFactory.Instance.creatComponentByStylename("game.webSpeed.fpsTxt");
            this._explain1 = ComponentFactory.Instance.creatComponentByStylename("game.webSpeed.explain1Txt");
            this._explain2 = ComponentFactory.Instance.creatComponentByStylename("game.webSpeed.explain2Txt");
            this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
            this._container = new Sprite();
            this._container.addChild(this._stateTxt);
            this._container.addChild(this._delayTxt);
            this._container.addChild(this._fpsTxt);
            this._container.addChild(this._explain1);
            this._container.addChild(this._explain2);
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
            this._tempData = _arg_1;
            if (_arg_1.stateTxt == WebSpeedInfo.BEST)
            {
                this._stateTxt.htmlText = (("<font color='#00FF33'>" + _arg_1.stateTxt) + "</font>");
                this._delayTxt.htmlText = (("<font color='#00FF33'>" + _arg_1.delayTxt) + "</font>");
            }
            else
            {
                if (_arg_1.stateTxt == WebSpeedInfo.BETTER)
                {
                    this._stateTxt.htmlText = (("<font color='#cc9900'>" + _arg_1.stateTxt) + "</font>");
                    this._delayTxt.htmlText = (("<font color='#cc9900'>" + _arg_1.delayTxt) + "</font>");
                }
                else
                {
                    if (_arg_1.stateTxt == WebSpeedInfo.WORST)
                    {
                        this._stateTxt.htmlText = (("<font color='#ff0000'>" + _arg_1.stateTxt) + "</font>");
                        this._delayTxt.htmlText = (("<font color='#ff0000'>" + _arg_1.delayTxt) + "</font>");
                    };
                };
            };
            this._fpsTxt.text = _arg_1.fpsTxt;
            this._explain1.text = _arg_1.explain1;
            this._explain2.htmlText = _arg_1.explain2;
            this.drawBG();
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
                this._bg.width = (this._container.width + 20);
                this._bg.height = (this._container.height + 10);
            }
            else
            {
                this._bg.width = (_arg_1 + 2);
                this._bg.height = (this._container.height + 5);
            };
            _width = this._bg.width;
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._stateTxt)
            {
                ObjectUtils.disposeObject(this._stateTxt);
            };
            this._stateTxt = null;
            if (this._delayTxt)
            {
                ObjectUtils.disposeObject(this._delayTxt);
            };
            this._delayTxt = null;
            if (this._fpsTxt)
            {
                ObjectUtils.disposeObject(this._fpsTxt);
            };
            this._fpsTxt = null;
            if (this._explain1)
            {
                ObjectUtils.disposeObject(this._explain1);
            };
            this._explain1 = null;
            if (this._explain2)
            {
                ObjectUtils.disposeObject(this._explain2);
            };
            this._explain2 = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package game.view

