// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetInfoExpBar

package petsBag.view.item
{
    import com.pickgliss.ui.core.Component;
    import flash.display.Bitmap;
    import flash.display.Shape;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.ShowTipManager;
    import com.pickgliss.utils.PNGHitAreaFactory;
    import flash.display.DisplayObject;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;

    public class PetInfoExpBar extends Component 
    {

        private var _maxGpItem:Bitmap;
        private var _maxGpMask:Shape;
        private var _gp:Number = 0;
        private var _maxGp:Number = 100;
        private var _progressLabel:FilterFrameText;
        private var _mouseArea:Sprite;

        public function PetInfoExpBar()
        {
            _width = (_height = 10);
            this.initView();
        }

        private function initView():void
        {
            this._maxGpItem = ComponentFactory.Instance.creat("asset.petsBag.petInfoFrame.petExpBar");
            this._maxGpItem.cacheAsBitmap = true;
            addChild(this._maxGpItem);
            this._maxGpMask = this.creatMask(this._maxGpItem);
            addChild(this._maxGpMask);
            this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("pet.item.infoexpBarTxt");
            addChild(this._progressLabel);
            tipStyle = "ddt.view.tips.OneLineTip";
            tipDirctions = "3";
            ShowTipManager.Instance.addTip(this);
            this._mouseArea = PNGHitAreaFactory.drawHitArea(this._maxGpItem.bitmapData);
            this._mouseArea.alpha = 0;
            addChild(this._mouseArea);
        }

        private function getMaxExpStyle(_arg_1:int):String
        {
            if (_arg_1 == 0)
            {
                return ("asset.petsBag.exerciseItem.normal.expBar");
            };
            return ("asset.petsBag.exerciseItem.vip.expBar");
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

        override public function get width():Number
        {
            return (this._maxGpItem.width);
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
            this._progressLabel.text = (_local_2.toString().substr(0, 4) + "%");
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._progressLabel);
            this._progressLabel = null;
            ObjectUtils.disposeObject(this._maxGpItem);
            this._maxGpItem = null;
            ObjectUtils.disposeObject(this._maxGpMask);
            this._maxGpMask = null;
            ObjectUtils.disposeObject(this._mouseArea);
            this._mouseArea = null;
            ObjectUtils.disposeAllChildren(this);
            super.dispose();
        }


    }
}//package petsBag.view.item

