// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.cell.TextButtonListCellAdapter

package com.pickgliss.ui.controls.cell
{
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.list.List;

    public class TextButtonListCellAdapter extends TextButton implements IListCell 
    {


        public function getCellValue():*
        {
            return (_text);
        }

        public function setCellValue(_arg_1:*):void
        {
            text = _arg_1;
        }

        public function setListCellStatus(_arg_1:List, _arg_2:Boolean, _arg_3:int):void
        {
        }


    }
}//package com.pickgliss.ui.controls.cell

