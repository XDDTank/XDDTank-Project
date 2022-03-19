// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.buff.FightBuffBar

package game.view.buff
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import ddt.data.FightBuffInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class FightBuffBar extends Sprite implements Disposeable 
    {

        private var _buffCells:Vector.<BuffCell> = new Vector.<BuffCell>();

        public function FightBuffBar()
        {
            mouseChildren = (mouseEnabled = false);
        }

        private function clearBuff():void
        {
            var _local_1:BuffCell;
            for each (_local_1 in this._buffCells)
            {
                _local_1.clearSelf();
            };
        }

        private function drawBuff():void
        {
        }

        public function update(_arg_1:Vector.<FightBuffInfo>):void
        {
            var _local_3:int;
            var _local_4:BuffCell;
            this.clearBuff();
            var _local_2:int;
            while (_local_3 < _arg_1.length)
            {
                if (_arg_1[_local_3].id == 72)
                {
                    _arg_1.splice(_local_3, 1);
                };
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < _arg_1.length)
            {
                if ((_local_3 + 1) > this._buffCells.length)
                {
                    _local_4 = new BuffCell();
                    this._buffCells.push(_local_4);
                }
                else
                {
                    _local_4 = this._buffCells[_local_3];
                };
                _local_4.setInfo(_arg_1[_local_3]);
                _local_4.x = ((_local_3 & 0x03) * 24);
                _local_4.y = (-(_local_3 >> 2) * 24);
                addChild(_local_4);
                _local_3++;
            };
        }

        public function dispose():void
        {
            var _local_1:BuffCell = this._buffCells.shift();
            while (_local_1)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = this._buffCells.shift();
            };
            this._buffCells = null;
        }


    }
}//package game.view.buff

