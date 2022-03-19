// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.EquipTipEmbedItem

package ddt.view.tips
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;

    public class EquipTipEmbedItem extends Component 
    {

        private var _index:int;
        private var _embedHole:ScaleFrameImage;
        private var _embedTypeImage:ScaleFrameImage;
        private var _embedText:FilterFrameText;
        private var _unembedText:FilterFrameText;
        private var _holeID:int;

        public function EquipTipEmbedItem(_arg_1:int)
        {
            this._index = _arg_1;
            super();
        }

        override protected function init():void
        {
            super.init();
            this._embedHole = ComponentFactory.Instance.creat("EquipsTipPanel.embedBg");
            addChild(this._embedHole);
            this._embedTypeImage = ComponentFactory.Instance.creat("EquipsTipPanel.embedIcon");
            addChild(this._embedTypeImage);
            this._embedText = ComponentFactory.Instance.creat("EquipsTipPanel.embedTxt");
            addChild(this._embedText);
            this._unembedText = ComponentFactory.Instance.creat("EquipsTipPanel.unembedTxt");
            addChild(this._unembedText);
            _height = this._embedHole.height;
        }

        private function setData():void
        {
            var _local_1:ItemTemplateInfo;
            var _local_2:EquipmentTemplateInfo;
            var _local_3:EquipmentTemplateInfo;
            if (this._holeID > 1)
            {
                _local_1 = ItemManager.Instance.getTemplateById(this._holeID);
                _local_2 = ItemManager.Instance.getEquipTemplateById(this._holeID);
                if (_local_2)
                {
                    _local_3 = ItemManager.Instance.getEquipPropertyListById(_local_2.MainProperty1ID);
                    this._embedText.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.embedStoneTip.embedInfo", _local_1.Property1, _local_3.PropertyName, _local_2.MainProperty1Value);
                }
                else
                {
                    this._embedText.htmlText = "error";
                };
                this._embedTypeImage.setFrame(this.getFrameIndexByProperID(_local_2.MainProperty1ID));
                this._embedTypeImage.visible = true;
                this._embedText.visible = true;
                this._unembedText.visible = false;
            }
            else
            {
                if (this._holeID == 1)
                {
                    this._embedHole.setFrame(2);
                    this._unembedText.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.embedStoneTip.unEmbed");
                    this._embedTypeImage.visible = false;
                    this._embedText.visible = false;
                    this._unembedText.visible = true;
                }
                else
                {
                    if (this._holeID == -1)
                    {
                        this._embedHole.setFrame(1);
                        this._unembedText.text = LanguageMgr.GetTranslation("ddt.view.tips.embedStoneTip.unOpened");
                        this._embedTypeImage.visible = false;
                        this._embedText.visible = false;
                        this._unembedText.visible = true;
                    };
                };
            };
        }

        private function getFrameIndexByProperID(_arg_1:int):int
        {
            switch (_arg_1)
            {
                case 1:
                    return (1);
                case 2:
                    return (2);
                case 3:
                    return (3);
                case 4:
                    return (4);
                case 7:
                    return (5);
            };
            return (-1);
        }

        public function get holeID():int
        {
            return (this._holeID);
        }

        public function set holeID(_arg_1:int):void
        {
            this._holeID = _arg_1;
            this.setData();
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeObject(this._embedHole);
            this._embedHole = null;
            ObjectUtils.disposeObject(this._embedTypeImage);
            this._embedTypeImage = null;
            ObjectUtils.disposeObject(this._embedText);
            this._embedText = null;
            ObjectUtils.disposeObject(this._unembedText);
            this._unembedText = null;
        }


    }
}//package ddt.view.tips

