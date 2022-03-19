// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//liveness.LivenessModel

package liveness
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class LivenessModel extends EventDispatcher 
    {

        public static const NOT_THE_TIME:uint = 0;
        public static const DAY_PASS:uint = 1;
        public static const NOT_GET_AWARD:uint = 2;
        public static const HAS_GET_AWARD:uint = 3;
        public static const BOX_HAS_GET:uint = 0;
        public static const BOX_CAN_GET:uint = 1;
        public static const BOX_CANNOT_GET:uint = 2;
        public static const CONSORTION_TASK:uint = 68;
        public static const WORLD_BOSS:uint = 14;
        public static const CONSORTION_CONVOY:int = 67;
        public static const MONSTER_REFLASH:int = 17;
        public static const SINGLE_DUNGEON:int = 65;
        public static const RANDOM_PVE:int = 64;
        public static const ARENA:int = 19;
        public static const RUNE:int = 26001;
        public static const NORMAL:int = 6;

        private var _statusList:Vector.<uint>;
        private var _livenessValue:uint = 0;
        private var _saveLivenessValue:uint = 0;
        private var _pointMovieHasPlay:Vector.<Boolean>;

        public function LivenessModel()
        {
            this._pointMovieHasPlay = new Vector.<Boolean>();
            var _local_1:uint;
            while (_local_1 < 5)
            {
                this._pointMovieHasPlay.push(false);
                _local_1++;
            };
        }

        public function get statusList():Vector.<uint>
        {
            return (this._statusList);
        }

        public function set statusList(_arg_1:Vector.<uint>):void
        {
            this._statusList = _arg_1;
        }

        public function get livenessValue():uint
        {
            return (this._livenessValue);
        }

        public function set livenessValue(_arg_1:uint):void
        {
            this._livenessValue = _arg_1;
        }

        public function get saveLivenessValue():uint
        {
            return (this._saveLivenessValue);
        }

        public function set saveLivenessValue(_arg_1:uint):void
        {
            this._saveLivenessValue = _arg_1;
        }

        public function get pointMovieHasPlay():Vector.<Boolean>
        {
            return (this._pointMovieHasPlay);
        }

        public function set pointMovieHasPlay(_arg_1:Vector.<Boolean>):void
        {
            this._pointMovieHasPlay = _arg_1;
        }


    }
}//package liveness

