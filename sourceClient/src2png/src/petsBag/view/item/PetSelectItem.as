// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetSelectItem

package petsBag.view.item
{
    import com.pickgliss.ui.core.Component;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.text.FilterFrameText;
    import pet.date.PetInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.LanguageMgr;

    public class PetSelectItem extends Component 
    {

        private var _bg:DisplayObject;
        private var _pet:PetSmallItem;
        private var _levelTxt:FilterFrameText;
        private var _nameTxt:FilterFrameText;
        private var _info:PetInfo;
        private var _index:int;
        private var _selected:Boolean;

        public function PetSelectItem(_arg_1:int)
        {
            this._index = _arg_1;
            super();
        }

        override protected function init():void
        {
            super.init();
            this._pet = ComponentFactory.Instance.creat("petsBag.view.petSelectItem.petSmallItem", [ComponentFactory.Instance.creat("petsBag.headScaleBitmap")]);
            this._pet.showTip = false;
            addChild(this._pet);
            this._levelTxt = ComponentFactory.Instance.creat("petsBag.view.petSelectItem.levelTxt");
            addChild(this._levelTxt);
            this._nameTxt = ComponentFactory.Instance.creat("petsBag.view.petSelectItem.nameTxt");
            addChild(this._nameTxt);
            tipDirctions = "6,7,4,5";
            tipStyle = "ddt.view.tips.PetInfoTip";
        }

        override protected function addChildren():void
        {
            var _local_1:String;
            ObjectUtils.disposeObject(this._bg);
            if (this._info)
            {
                if (this._selected)
                {
                    _local_1 = "asset.petsBag.petItem.selectedBg";
                }
                else
                {
                    _local_1 = "asset.petsBag.petItem.unselectedBg";
                };
            }
            else
            {
                _local_1 = "asset.petsBag.petItem.nopetBg";
            };
            this._bg = ComponentFactory.Instance.creat(_local_1);
            addChild(this._bg);
            setChildIndex(this._bg, 0);
            buttonMode = Boolean(this._info);
            _width = this._bg.width;
            _height = this._bg.height;
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
            invalidate();
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
            var _local_2:Boolean = (((this._info) && (!(_arg_1))) || ((!(this._info)) && (Boolean(_arg_1))));
            this._info = _arg_1;
            this._selected = ((this._info) && (this._selected));
            ShowTipManager.Instance.removeTip(this);
            tipData = this._info;
            if (this._info)
            {
                this._pet.info = this._info;
                this._nameTxt.text = this._info.Name;
                this._levelTxt.text = LanguageMgr.GetTranslation("petsBag.view.item.level", this._info.Level);
                this._pet.visible = (this._nameTxt.visible = (this._levelTxt.visible = true));
                ShowTipManager.Instance.addTip(this);
            }
            else
            {
                this._pet.info = null;
                this._pet.visible = (this._nameTxt.visible = (this._levelTxt.visible = false));
            };
            if (_local_2)
            {
                invalidate();
            };
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._pet);
            this._pet = null;
            ObjectUtils.disposeObject(this._levelTxt);
            this._levelTxt = null;
            ObjectUtils.disposeObject(this._nameTxt);
            this._nameTxt = null;
            this._info = null;
            super.dispose();
        }


    }
}//package petsBag.view.item

