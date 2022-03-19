// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.cell.SimpleListCellFactory

package com.pickgliss.ui.controls.cell
{
    import com.pickgliss.utils.StringUtils;
    import com.pickgliss.ui.ComponentFactory;

    public class SimpleListCellFactory implements IListCellFactory 
    {

        private var _ViewWidthNoCount:int;
        private var _allCellHasSameHeight:Boolean;
        private var _cellHeight:int;
        private var _cellStyle:String;
        private var _shareCells:Boolean;

        public function SimpleListCellFactory(_arg_1:String, _arg_2:int, _arg_3:int=-1, _arg_4:String="true", _arg_5:String="true")
        {
            this._cellStyle = _arg_1;
            this._allCellHasSameHeight = StringUtils.converBoolean(_arg_4);
            this._shareCells = StringUtils.converBoolean(_arg_5);
            this._cellHeight = _arg_2;
            this._ViewWidthNoCount = _arg_3;
        }

        public function createNewCell():IListCell
        {
            return (ComponentFactory.Instance.creat(this._cellStyle));
        }

        public function getCellHeight():int
        {
            return (this._cellHeight);
        }

        public function getViewWidthNoCount():int
        {
            return (this._ViewWidthNoCount);
        }

        public function isAllCellHasSameHeight():Boolean
        {
            return (this._allCellHasSameHeight);
        }

        public function isShareCells():Boolean
        {
            return (this._shareCells);
        }


    }
}//package com.pickgliss.ui.controls.cell

