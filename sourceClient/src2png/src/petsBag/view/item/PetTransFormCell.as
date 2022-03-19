// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetTransFormCell

package petsBag.view.item
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import pet.date.PetInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class PetTransFormCell extends Sprite implements Disposeable 
    {

        private var _bg:ScaleFrameImage;
        private var _pet:PetSmallItem;
        private var _levelTxt:FilterFrameText;
        private var _nameTxt:FilterFrameText;
        private var _info:PetInfo;
        private var _index:int;
        private var _selected:Boolean;

        public function PetTransFormCell()
        {
            buttonMode = true;
            this.initView();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("petsBag.petTransformFrame.cellBg");
            this._bg.setFrame(1);
            addChild(this._bg);
            this._pet = ComponentFactory.Instance.creat("petsBag.view.petSelectItem.petSmallItem2", [ComponentFactory.Instance.creat("petsBag.headScaleBitmap")]);
            this._pet.showTip = false;
            addChild(this._pet);
            this._levelTxt = ComponentFactory.Instance.creat("petsBag.petTransformFrame.levelTxt");
            addChild(this._levelTxt);
            this._nameTxt = ComponentFactory.Instance.creat("petsBag.petTransformFrame.nameTxt");
            addChild(this._nameTxt);
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (this._selected == _arg_1)
            {
                return;
            };
            this._selected = ((this._info) && (_arg_1));
            this._bg.setFrame(((this._selected) ? 2 : 1));
        }

        public function get index():int
        {
            return (this._index);
        }

        public function set index(_arg_1:int):void
        {
            this._index = _arg_1;
        }

        public function get info():PetInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:PetInfo):void
        {
            this._info = _arg_1;
            this._selected = ((this._info) && (this._selected));
            if (this._info)
            {
                this._pet.info = this._info;
                this._levelTxt.text = ("Lv:" + this._info.Level.toString());
                this._nameTxt.text = this._info.Name;
            }
            else
            {
                this._pet.info = null;
            };
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._pet);
            this._pet = null;
            ObjectUtils.disposeObject(this._levelTxt);
            this._levelTxt = null;
            ObjectUtils.disposeObject(this._nameTxt);
            this._nameTxt = null;
        }


    }
}//package petsBag.view.item

