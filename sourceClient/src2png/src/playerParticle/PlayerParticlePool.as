// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//playerParticle.PlayerParticlePool

package playerParticle
{
    import __AS3__.vec.Vector;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PlayerParticlePool 
    {

        private var _creat:Function;
        private var _clean:Function;
        private var _mix:int;
        private var _max:int;
        private var _list:Vector.<PlayerParticle>;
        private var _length:int = 0;
        private var _size:int = 0;

        public function PlayerParticlePool()
        {
            this._list = new Vector.<PlayerParticle>();
        }

        public function creatPlayerParticle(_arg_1:Function, _arg_2:Function, _arg_3:int=5):void
        {
            this._creat = _arg_1;
            this._clean = _arg_2;
            this._max = _arg_3;
            var _local_4:int;
            while (_local_4 < this._max)
            {
                this.addParticle();
                _local_4++;
            };
        }

        public function addParticle():void
        {
            var _local_1:* = this._length++;
            this._list[_local_1] = this._creat();
        }

        public function checkOut():PlayerParticle
        {
            if (this._length <= 0)
            {
            };
            return (this._list[--this._length]);
        }

        public function checkIn():void
        {
            this._clean(this._list[this._length]);
        }

        public function clear():void
        {
            var _local_1:PlayerParticle;
            for each (_local_1 in this._list)
            {
                this._clean(_local_1);
            };
            this._length = this._max;
        }

        public function dispose():void
        {
            var _local_1:PlayerParticle;
            this._clean = null;
            this._creat = null;
            for each (_local_1 in this._list)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = null;
            };
            this._list = new Vector.<PlayerParticle>();
            this._length = 0;
            this._size = 0;
        }


    }
}//package playerParticle

