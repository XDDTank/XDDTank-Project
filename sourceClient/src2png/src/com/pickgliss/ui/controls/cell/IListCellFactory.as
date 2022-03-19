// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.cell.IListCellFactory

package com.pickgliss.ui.controls.cell
{
    public interface IListCellFactory 
    {

        function createNewCell():IListCell;
        function getCellHeight():int;
        function getViewWidthNoCount():int;
        function isAllCellHasSameHeight():Boolean;
        function isShareCells():Boolean;

    }
}//package com.pickgliss.ui.controls.cell

