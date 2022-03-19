// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.fightPower.PowerUpSystemButtonTips

package bagAndInfo.fightPower
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import __AS3__.vec.*;

    public class PowerUpSystemButtonTips extends BaseTip 
    {

        private var _bg:ScaleBitmapImage;
        private var _tempData:Vector.<String>;
        private var _titleTxt:FilterFrameText;
        private var _recommendEquip:FilterFrameText;
        private var _scoreDesc:FilterFrameText;


        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creat("hall.fightPowerUpButtonTips.bg");
            this._titleTxt = ComponentFactory.Instance.creat("hall.powerUpTipsTitle.text");
            this._recommendEquip = ComponentFactory.Instance.creat("hall.powerUpTipsRecommendEquip.text");
            this._scoreDesc = ComponentFactory.Instance.creat("hall.powerUpTipsScoreDesc.text");
            this.tipbackgound = this._bg;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            mouseChildren = false;
            mouseEnabled = false;
            addChild(this._titleTxt);
            addChild(this._recommendEquip);
            addChild(this._scoreDesc);
        }

        override public function get tipData():Object
        {
            return (this._tempData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            this._tempData = (_arg_1 as Vector.<String>);
            this._titleTxt.text = ((_arg_1[0] == null) ? "" : _arg_1[0]);
            this._recommendEquip.htmlText = ((_arg_1[1] == null) ? "" : _arg_1[1]);
            this._scoreDesc.text = ((_arg_1[2] == null) ? "" : _arg_1[2]);
            this.drawBG();
        }

        private function drawBG():void
        {
            this._bg.height = ((this._scoreDesc.y + this._scoreDesc.textHeight) + 18);
            if (this._bg.width < ((this._recommendEquip.x + this._recommendEquip.textWidth) + 20))
            {
                this._bg.width = ((this._recommendEquip.x + this._recommendEquip.textWidth) + 20);
            };
            _width = this._bg.width;
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package bagAndInfo.fightPower

