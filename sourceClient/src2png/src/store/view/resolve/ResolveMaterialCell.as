// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.resolve.ResolveMaterialCell

package store.view.resolve
{
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class ResolveMaterialCell extends BaseCell 
    {

        public function ResolveMaterialCell(_arg_1:ItemTemplateInfo)
        {
            super(ComponentFactory.Instance.creatBitmap("asset.ddtstore.ComposeView.itemCellBg"), _arg_1);
            _info = _arg_1;
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.resolve

