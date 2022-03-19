// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetBloodProgress

package petsBag.view.item
{
    import com.pickgliss.ui.core.Component;
    import flash.display.Bitmap;
    import flash.display.Shape;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class PetBloodProgress extends Component 
    {

        private var _backGround:Bitmap;
        private var _maxGpItem:Bitmap;
        private var _maxGpMask:Shape;
        private var _gp:int = 0;
        private var _maxGp:int = 100;
        private var _progressLabel:FilterFrameText;

        public function PetBloodProgress()
        {
            this.initView();
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        private function initView():void
        {
            this._backGround = ComponentFactory.Instance.creat("asset.petsBag.bloodBar.bg");
            addChild(this._backGround);
            this._maxGpItem = ComponentFactory.Instance.creat("asset.petsBag.bloodBar.bar");
            this._maxGpItem.cacheAsBitmap = true;
            addChild(this._maxGpItem);
            this._maxGpMask = this.creatMask(this._maxGpItem);
            addChild(this._maxGpMask);
            this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.bloodBarTxt");
            addChild(this._progressLabel);
            _width = this._backGround.width;
            _height = this._backGround.height;
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

        public function setBlood(_arg_1:int, _arg_2:int):void
        {
            this._gp = _arg_1;
            this._maxGp = _arg_2;
            this._maxGpItem.visible = true;
            this._progressLabel.visible = true;
            this.drawProgress();
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
            this._progressLabel.text = String(this._gp);
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

