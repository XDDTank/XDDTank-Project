// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//playerParticle.PlayerParticleModel

package playerParticle
{
    public class PlayerParticleModel 
    {

        private var _posArray:Array;
        private var _direction:int = 1;
        private var _length:int = 0;

        public function PlayerParticleModel()
        {
            this._posArray = new Array();
        }

        public function reset():void
        {
            this._length = 0;
            this._posArray = new Array();
        }

        public function get posArray():Array
        {
            return (this._posArray);
        }

        public function set posArray(_arg_1:Array):void
        {
            this._posArray = _arg_1;
        }

        public function get direction():int
        {
            return (this._direction);
        }

        public function set direction(_arg_1:int):void
        {
            this._direction = _arg_1;
        }


    }
}//package playerParticle

