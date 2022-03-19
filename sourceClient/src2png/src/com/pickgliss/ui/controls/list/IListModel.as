// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.list.IListModel

package com.pickgliss.ui.controls.list
{
    public interface IListModel 
    {

        function addListDataListener(_arg_1:ListDataListener):void;
        function getElementAt(_arg_1:int):*;
        function getSize():int;
        function removeListDataListener(_arg_1:ListDataListener):void;
        function indexOf(_arg_1:*):int;
        function getCellPosFromIndex(_arg_1:int):Number;
        function getAllCellHeight():Number;
        function getStartIndexByPosY(_arg_1:Number):int;

    }
}//package com.pickgliss.ui.controls.list

