// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetAdvanceBar

package petsBag.view.item
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.Shape;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;

    public class PetAdvanceBar extends Sprite implements Disposeable 
    {

        private var _bg:ScaleFrameImage;
        private var _container:Sprite;
        private var _maxBar:ScaleFrameImage;
        private var _maxMask:Shape;
        private var _currentFlag:Bitmap;
        private var _bubleBg:Bitmap;
        private var _bubleTxt:FilterFrameText;
        private var _level:int = 1;
        private var _type:int;
        private var _maxValue:int;

        public function PetAdvanceBar()
        {
            this.init();
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.advanceBar.bg");
            addChild(this._bg);
            this._container = new Sprite();
            addChild(this._container);
            this._maxBar = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.advanceBar.maxBar");
            this._container.addChild(this._maxBar);
            this._maxMask = this.creatMask(this._maxBar);
            this._container.addChild(this._maxMask);
            this._currentFlag = ComponentFactory.Instance.creat("asset.petsBag.petAdvanceFrame.advanceBar.gem");
            this._container.addChild(this._currentFlag);
            this._bubleBg = ComponentFactory.Instance.creat("asset.petsBag.petAdvanceFrame.bublesBg");
            this._container.addChild(this._bubleBg);
            this._bubleTxt = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.advanceBar.txt");
            this._container.addChild(this._bubleTxt);
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

        public function get level():int
        {
            return (this._level);
        }

        public function set level(_arg_1:int):void
        {
            var _local_2:Point;
            this._level = _arg_1;
            this._bubleTxt.text = LanguageMgr.GetTranslation("petsBag.view.petAdvanceBar.levelInfo", this._level);
            if (this._type == 0)
            {
                _local_2 = ComponentFactory.Instance.creat(("petsBag.petAdvanceView.level10.pos" + (this._level % 10)));
            }
            else
            {
                if (this._level < 60)
                {
                    _local_2 = ComponentFactory.Instance.creat(("petsBag.petAdvanceView.level11.pos" + (this._level % 10)));
                }
                else
                {
                    _local_2 = ComponentFactory.Instance.creat("petsBag.petAdvanceView.level11.pos10");
                };
            };
            var _local_3:Number = ((this._level % 10) / this._maxValue);
            this._maxMask.width = _local_2.x;
            this._currentFlag.x = (_local_2.x - 40);
            this._bubleBg.x = (this._maxMask.width - 29);
            this._bubleTxt.x = (this._maxMask.width - 13);
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._container);
            this._container = null;
            ObjectUtils.disposeObject(this._maxBar);
            this._maxBar = null;
            ObjectUtils.disposeObject(this._maxMask);
            this._maxMask = null;
            ObjectUtils.disposeObject(this._currentFlag);
            this._currentFlag = null;
            ObjectUtils.disposeObject(this._bubleBg);
            this._bubleBg = null;
            ObjectUtils.disposeObject(this._bubleTxt);
            this._bubleTxt = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get type():int
        {
            return (this._type);
        }

        public function set type(_arg_1:int):void
        {
            this._type = _arg_1;
            var _local_2:Boolean = (this._type == 0);
            this._maxValue = ((_local_2) ? 9 : 10);
            this._bg.setFrame(((_local_2) ? 1 : 2));
            this._maxBar.setFrame(((_local_2) ? 1 : 2));
        }


    }
}//package petsBag.view.item

