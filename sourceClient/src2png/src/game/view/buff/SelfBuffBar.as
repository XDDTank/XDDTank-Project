// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.buff.SelfBuffBar

package game.view.buff
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import game.model.Living;
    import flash.display.DisplayObjectContainer;
    import ddt.events.LivingEvent;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class SelfBuffBar extends Sprite implements Disposeable 
    {

        private var _buffCells:Vector.<BuffCell> = new Vector.<BuffCell>();
        private var _living:Living;
        private var _container:DisplayObjectContainer;

        public function SelfBuffBar(_arg_1:DisplayObjectContainer)
        {
            this._container = _arg_1;
        }

        public function dispose():void
        {
            if (this._living)
            {
                this._living.removeEventListener(LivingEvent.BUFF_CHANGED, this.__updateCell);
            };
            var _local_1:BuffCell = this._buffCells.shift();
            while (_local_1)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = this._buffCells.shift();
            };
            this._buffCells = null;
        }

        private function __updateCell(_arg_1:LivingEvent):void
        {
            var _local_4:BuffCell;
            var _local_5:int;
            var _local_6:int;
            this.clearBuff();
            var _local_2:int = ((this._living == null) ? 0 : this._living.localBuffs.length);
            var _local_3:int = ((this._living == null) ? 0 : this._living.petBuffs.length);
            if ((((_local_2 + _local_3) > 0) && (this._buffCells)))
            {
                _local_5 = 0;
                while (_local_5 < _local_2)
                {
                    if ((_local_5 + 1) > this._buffCells.length)
                    {
                        _local_4 = new BuffCell(null, null, false, true);
                        this._buffCells.push(_local_4);
                    }
                    else
                    {
                        _local_4 = this._buffCells[_local_5];
                    };
                    _local_4.x = (((_local_5 % 10) * 36) + 8);
                    _local_4.y = ((-(Math.floor((_local_5 / 10))) * 36) + 6);
                    _local_4.setInfo(this._living.localBuffs[_local_5]);
                    addChild(_local_4);
                    if (this._living.localBuffs[_local_5].type != 3)
                    {
                        _local_4.width = (_local_4.height = 32);
                    };
                    _local_5++;
                };
                _local_6 = 0;
                while (_local_6 < _local_3)
                {
                    if (((_local_6 + 1) + _local_2) > this._buffCells.length)
                    {
                        _local_4 = new BuffCell(null, null, false, true);
                        this._buffCells.push(_local_4);
                    }
                    else
                    {
                        _local_4 = this._buffCells[(_local_6 + _local_2)];
                    };
                    if (_local_2 > 0)
                    {
                        _local_4.x = ((((((_local_6 + _local_2) > 3) ? (_local_6 + _local_2) : (_local_6 + 3)) % 10) * 36) + 15);
                    }
                    else
                    {
                        _local_4.x = (((_local_6 + _local_2) % 10) * 36);
                    };
                    _local_4.y = ((-(Math.floor(((_local_6 + _local_2) / 10))) * 36) + 6);
                    _local_4.setInfo(this._living.petBuffs[_local_6]);
                    addChild(_local_4);
                    _local_6++;
                };
                if (parent == null)
                {
                    this._container.addChild(this);
                };
            }
            else
            {
                if (parent)
                {
                    parent.removeChild(this);
                };
            };
        }

        public function drawBuff(_arg_1:Living):void
        {
            if (this._living)
            {
                this._living.removeEventListener(LivingEvent.BUFF_CHANGED, this.__updateCell);
            };
            this._living = _arg_1;
            if (this._living)
            {
                this._living.addEventListener(LivingEvent.BUFF_CHANGED, this.__updateCell);
            };
            this.__updateCell(null);
        }

        public function get right():Number
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            if (((this._living == null) || (this._living.localBuffs.length == 0)))
            {
                _local_1 = ((this._living == null) ? 0 : this._living.petBuffs.length);
                _local_2 = ((_local_1 > 8) ? 8 : _local_1);
                return ((x + (_local_2 * 44)) + 40);
            };
            _local_3 = ((this._living == null) ? 0 : this._living.localBuffs.length);
            _local_4 = ((this._living == null) ? 0 : this._living.petBuffs.length);
            _local_5 = (((_local_3 + _local_4) > 8) ? 8 : (_local_3 + _local_4));
            return ((x + (_local_5 * 44)) + 40);
        }

        private function clearBuff():void
        {
            var _local_1:BuffCell;
            for each (_local_1 in this._buffCells)
            {
                _local_1.dispose();
            };
            this._buffCells = new Vector.<BuffCell>();
        }


    }
}//package game.view.buff

