// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.shortcutBuy.ShortcutBuyCell

package store.view.shortcutBuy
{
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import ddt.manager.LanguageMgr;
    import ddt.command.ShineObject;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.EquipType;
    import com.pickgliss.utils.ObjectUtils;

    public class ShortcutBuyCell extends BaseCell 
    {

        private var _selected:Boolean = false;
        private var _mcBg:ScaleFrameImage;
        private var _lightEffect:Scale9CornerImage;
        private var _nameArr:Array = [ddt.manager.LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.lingju"), ddt.manager.LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.jiezi"), ddt.manager.LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.shouzhuo"), ddt.manager.LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.baozhu"), ddt.manager.LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.zhuque"), ddt.manager.LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.xuanwu"), ddt.manager.LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.qinglong"), ddt.manager.LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.baihu")];
        private var _shiner:ShineObject;
        private var _itemInfo:ItemTemplateInfo;
        private var _shortcutText:FilterFrameText;
        private var _shortcutTextBg:ScaleBitmapImage;

        public function ShortcutBuyCell(_arg_1:ItemTemplateInfo)
        {
            var _local_2:Sprite = new Sprite();
            _local_2.addChild(ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG"));
            super(_local_2);
            tipDirctions = "7,0";
            this._itemInfo = _arg_1;
            this.initII();
        }

        private function initII():void
        {
            var _local_1:String;
            var _local_2:int;
            this._mcBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortcutBuyFrame.ShortcutCellBg");
            this._lightEffect = ComponentFactory.Instance.creatComponentByStylename("asset.ddtstore.CellBgSelectEffect");
            this._lightEffect.visible = false;
            this._mcBg.setFrame(1);
            addChildAt(this._mcBg, 0);
            this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.ddtstore.cellShine"));
            this._shiner.mouseChildren = (this._shiner.mouseEnabled = (this._shiner.visible = false));
            addChildAt(this._shiner, 1);
            this._shortcutTextBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortcutBuyFrame.ShortcutTextBg");
            addChild(this._shortcutTextBg);
            this._shortcutText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortcutBuyFrame.ShortcutText");
            this._shortcutText.mouseEnabled = false;
            if (EquipType.isBeadNeedOpen(this._itemInfo))
            {
                this._shortcutText.text = this._itemInfo.Name;
                this._shortcutText.x = 4;
                this._shortcutText.y = 69;
                this._shortcutTextBg.width = 70;
            }
            else
            {
                _local_1 = "";
                _local_2 = 0;
                while (_local_2 < this._nameArr.length)
                {
                    if (this._itemInfo.Name.indexOf(this._nameArr[_local_2]) > 0)
                    {
                        _local_1 = this._nameArr[_local_2];
                        break;
                    };
                    _local_2++;
                };
                this._shortcutText.text = _local_1;
            };
            this._shortcutTextBg.x = (this._shortcutText.x - 9);
            addChild(this._shortcutText);
            if (this._shortcutText.text == "")
            {
                this._lightEffect.x = (this._mcBg.x = -3);
                this._lightEffect.y = (this._mcBg.y = -3);
            };
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            super.info = _arg_1;
            if (this._lightEffect)
            {
                addChild(this._lightEffect);
            };
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
            this._selected = _arg_1;
            this._lightEffect.visible = this._selected;
        }

        public function startShine():void
        {
            this._shiner.visible = true;
            this._shiner.shine();
        }

        public function stopShine():void
        {
            this._shiner.stopShine();
            this._shiner.visible = false;
        }

        public function showBg():void
        {
            this._mcBg.visible = true;
        }

        public function hideBg():void
        {
            this._mcBg.visible = false;
            this._lightEffect.visible = false;
        }

        override public function dispose():void
        {
            if (this._shortcutText)
            {
                ObjectUtils.disposeObject(this._shortcutText);
            };
            this._shortcutText = null;
            if (this._shiner)
            {
                ObjectUtils.disposeObject(this._shiner);
            };
            this._shiner = null;
            if (this._mcBg)
            {
                ObjectUtils.disposeObject(this._mcBg);
            };
            this._mcBg = null;
            if (this._lightEffect)
            {
                ObjectUtils.disposeObject(this._lightEffect);
            };
            this._lightEffect = null;
            this._itemInfo = null;
            this._nameArr = null;
            ObjectUtils.disposeAllChildren(this);
            super.dispose();
        }


    }
}//package store.view.shortcutBuy

