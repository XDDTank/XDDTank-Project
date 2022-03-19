// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.space.PetSpaceBagCell

package petsBag.view.space
{
    import bagAndInfo.cell.BagCell;
    import flash.display.Shape;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class PetSpaceBagCell extends BagCell 
    {

        private var _selected:Boolean;
        private var _mask:Shape;

        public function PetSpaceBagCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true, _arg_4:DisplayObject=null, _arg_5:Boolean=true)
        {
            super(_arg_1, _arg_2, _showLoading, _arg_4, _arg_5);
            this._mask = new Shape();
            this._mask.graphics.beginFill(0, 0.3);
            this._mask.graphics.drawRect(0, 0, (width - 3), (height - 3));
        }

        override public function dragStart():void
        {
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._mask);
            this._mask = null;
            super.dispose();
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
                addChild(this._mask);
            }
            else
            {
                if (this._mask.parent)
                {
                    this._mask.parent.removeChild(this._mask);
                };
            };
            updateBgVisible(((_cellMouseOverFormer) && (_cellMouseOverFormer.visible)));
        }


    }
}//package petsBag.view.space

