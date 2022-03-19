// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.cell.BankCell

package bagAndInfo.cell
{
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.DisplayObject;

    public class BankCell extends BagCell 
    {

        public function BankCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true, _arg_4:DisplayObject=null, _arg_5:Boolean=true)
        {
            super(_arg_1, null, true, ComponentFactory.Instance.creatBitmap("asset.consortiaii.bag.bankCellBg"), true);
        }

    }
}//package bagAndInfo.cell

