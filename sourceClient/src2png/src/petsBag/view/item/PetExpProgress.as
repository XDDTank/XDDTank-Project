// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetExpProgress

package petsBag.view.item
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.Shape;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.ShowTipManager;
    import flash.display.DisplayObject;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;

    public class PetExpProgress extends Component 
    {

        private var _backGround:ScaleBitmapImage;
        private var _maxGpItem:ScaleBitmapImage;
        private var _maxGpMask:Shape;
        private var _gp:Number = 0;
        private var _maxGp:Number = 100;
        private var _progressLabel:FilterFrameText;

        public function PetExpProgress()
        {
            this.initView();
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        private function initView():void
        {
            this._backGround = ComponentFactory.Instance.creat("petsBag.view.infoView.expBg");
            addChild(this._backGround);
            this._maxGpItem = ComponentFactory.Instance.creat("petsBag.view.infoView.expBar");
            this._maxGpItem.cacheAsBitmap = true;
            addChild(this._maxGpItem);
            this._maxGpMask = this.creatMask(this._maxGpItem);
            addChild(this._maxGpMask);
            this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.infoView.expTxt");
            addChild(this._progressLabel);
            _width = this._backGround.width;
            _height = this._backGround.height;
            tipStyle = "ddt.view.tips.OneLineTip";
            tipDirctions = "3";
            ShowTipManager.Instance.addTip(this);
        }

        private function creatMask(_arg_1:DisplayObject):Shape
        {
            var _local_2:Shape;
            _local_2 = new Shape();
            _local_2.graphics.beginFill(0xFF0000, 1);
            _local_2.graphics.drawRect(0, 0, _arg_1.width, _arg_1.height);
            _local_2.graphics.endFill();
            _local_2.x = _arg_1.x;
            _local_2.y = _arg_1.y;
            _arg_1.mask = _local_2;
            return (_local_2);
        }

        public function setProgress(_arg_1:Number, _arg_2:Number):void
        {
            this._gp = _arg_1;
            this._maxGp = _arg_2;
            this._maxGpItem.visible = true;
            this._progressLabel.visible = true;
            this.drawProgress();
            tipData = [_arg_1, _arg_2].join("/");
        }

        public function noPet():void
        {
            this._maxGpItem.visible = false;
            this._progressLabel.visible = false;
        }

        private function drawProgress():void
        {
            var _local_1:Number = ((this._maxGp > 0) ? (this._gp / this._maxGp) : 0);
            this._maxGpMask.width = (this._maxGpItem.width * _local_1);
            _tipData = ([this._gp, this._maxGp].join("/") + LanguageMgr.GetTranslation("ddt.petbag.petExpProgressTip", this._gp));
            var _local_2:Number = (_local_1 * 100);
            this._progressLabel.text = (_local_2.toFixed(2) + "%");
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._backGround);
            this._backGround = null;
            ObjectUtils.disposeObject(this._progressLabel);
            this._progressLabel = null;
            ObjectUtils.disposeObject(this._maxGpItem);
            this._maxGpItem = null;
            ObjectUtils.disposeObject(this._maxGpMask);
            this._maxGpMask = null;
            ObjectUtils.disposeAllChildren(this);
            super.dispose();
        }


    }
}//package petsBag.view.item

