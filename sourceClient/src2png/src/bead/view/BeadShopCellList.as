// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadShopCellList

package bead.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import bead.BeadManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class BeadShopCellList extends Sprite implements Disposeable 
    {

        public static const TotalCount:int = 6;

        private var _beadCellList:Vector.<BeadShopCell>;
        private var _beadScoreShopItemList:Array;
        private var _curPage:int;

        public function BeadShopCellList()
        {
            this.initView();
        }

        private function initView():void
        {
            var _local_2:BeadShopCell;
            this._beadCellList = new Vector.<BeadShopCell>();
            var _local_1:int;
            while (_local_1 < TotalCount)
            {
                _local_2 = new BeadShopCell();
                _local_2.x = ((_local_1 % 2) * (5 + _local_2.width));
                _local_2.y = (int((_local_1 / 2)) * (5 + _local_2.height));
                addChild(_local_2);
                this._beadCellList.push(_local_2);
                _local_1++;
            };
            this._beadScoreShopItemList = BeadManager.instance.scoreShopItemList;
        }

        public function show(_arg_1:int):void
        {
            if (this._curPage == _arg_1)
            {
                return;
            };
            this._curPage = _arg_1;
            var _local_2:int = ((this._curPage - 1) * TotalCount);
            var _local_3:int = ((this._curPage * TotalCount) - 1);
            var _local_4:int = _local_2;
            while (_local_4 <= _local_3)
            {
                this._beadCellList[(_local_4 - _local_2)].show(this._beadScoreShopItemList[_local_4]);
                _local_4++;
            };
        }

        public function dispose():void
        {
            var _local_1:BeadShopCell;
            for each (_local_1 in this._beadCellList)
            {
                if (_local_1)
                {
                    ObjectUtils.disposeObject(_local_1);
                };
            };
            this._beadCellList = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package bead.view

