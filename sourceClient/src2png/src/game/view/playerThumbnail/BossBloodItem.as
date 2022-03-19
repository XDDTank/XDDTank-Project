// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.playerThumbnail.BossBloodItem

package game.view.playerThumbnail
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Shape;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class BossBloodItem extends Sprite implements Disposeable 
    {

        private var _totalBlood:Number;
        private var _bloodNum:Number;
        private var _maskShape:Shape;
        private var _HPTxt:FilterFrameText;
        private var _bg:Bitmap;
        private var _rateTxt:FilterFrameText;

        public function BossBloodItem(_arg_1:Number)
        {
            this._totalBlood = _arg_1;
            this._bloodNum = _arg_1;
            this._bg = ComponentFactory.Instance.creatBitmap("asset.game.bossHpStripAsset");
            addChild(this._bg);
            this._maskShape = new Shape();
            this._maskShape.x = 13;
            this._maskShape.y = 7;
            this._maskShape.graphics.beginFill(0, 1);
            this._maskShape.graphics.drawRect(0, 0, 120, 25);
            this._maskShape.graphics.endFill();
            this._bg.mask = this._maskShape;
            addChild(this._maskShape);
            this._rateTxt = ComponentFactory.Instance.creatComponentByStylename("asset.bossHPStripRateTxt");
            addChild(this._rateTxt);
            this._rateTxt.text = "100%";
        }

        public function set bloodNum(_arg_1:Number):void
        {
            if (_arg_1 < 0)
            {
                _arg_1 = 0;
            }
            else
            {
                if (_arg_1 > this._totalBlood)
                {
                    _arg_1 = this._totalBlood;
                };
            };
            this._bloodNum = _arg_1;
            this.updateView();
        }

        public function updateBlood(_arg_1:Number, _arg_2:Number):void
        {
            this._bloodNum = _arg_1;
            if (this._bloodNum < 0)
            {
                this._bloodNum = 0;
            };
            this._totalBlood = _arg_2;
            if (this._totalBlood < this._bloodNum)
            {
                this._totalBlood = this._bloodNum;
            };
            this.updateView();
        }

        private function updateView():void
        {
            var _local_1:int = this.getRate(this._bloodNum, this._totalBlood);
            this._rateTxt.text = (_local_1.toString() + "%");
            this._maskShape.width = (120 * (_local_1 / 100));
            this._bg.mask = this._maskShape;
        }

        private function getRate(_arg_1:Number, _arg_2:Number):int
        {
            var _local_3:Number = ((_arg_1 / _arg_2) * 100);
            if (((_local_3 > 0) && (_local_3 < 1)))
            {
                _local_3 = 1;
            };
            return (int(_local_3));
        }

        public function dispose():void
        {
            removeChild(this._bg);
            this._bg.bitmapData.dispose();
            this._bg = null;
            removeChild(this._maskShape);
            this._maskShape = null;
            if (this._HPTxt)
            {
                this._HPTxt.dispose();
                this._HPTxt = null;
            };
            ObjectUtils.disposeObject(this._rateTxt);
            this._rateTxt = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.playerThumbnail

