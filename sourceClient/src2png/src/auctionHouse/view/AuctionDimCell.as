// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionDimCell

package auctionHouse.view
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.controls.cell.IDropListCell;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class AuctionDimCell extends Component implements IDropListCell 
    {

        private var _bg:ScaleFrameImage;
        private var _textField:FilterFrameText;
        private var _selected:Boolean;
        private var _name:String;


        public function set NickName(_arg_1:String):void
        {
            this._name = _arg_1;
        }

        public function get NickName():String
        {
            return (this._name);
        }

        override protected function init():void
        {
            super.init();
            this._bg = ComponentFactory.Instance.creatComponentByStylename("droplist.CellBg");
            this._textField = ComponentFactory.Instance.creatComponentByStylename("droplist.CellText");
            this._bg.setFrame(1);
            width = this._bg.width;
            height = this._bg.height;
            addChild(this._bg);
            addChild(this._textField);
        }

        override protected function addChildren():void
        {
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            this._selected = _arg_1;
            if (this._selected)
            {
                this._bg.setFrame(2);
            }
            else
            {
                this._bg.setFrame(1);
            };
        }

        public function getCellValue():*
        {
            return ("");
        }

        public function setCellValue(_arg_1:*):void
        {
            if (_arg_1)
            {
                this._textField.text = _arg_1;
            };
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            if (this._textField)
            {
                ObjectUtils.disposeObject(this._textField);
            };
            this._bg = null;
            this._textField = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package auctionHouse.view

