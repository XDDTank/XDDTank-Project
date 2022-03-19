// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//playerParticle.PlayerParticle

package playerParticle
{
    import flash.display.Sprite;
    import game.objects.GamePlayer;
    import flash.display.Bitmap;
    import com.pickgliss.utils.ObjectUtils;

    public class PlayerParticle extends Sprite 
    {

        private var _player:GamePlayer;
        private var _particleImage:Bitmap;

        public function PlayerParticle(_arg_1:GamePlayer)
        {
            this._player = _arg_1;
            this._particleImage = _arg_1.body.getCloneBody();
            addChild(this._particleImage);
        }

        public function get player():GamePlayer
        {
            return (this._player);
        }

        public function set direction(_arg_1:int):void
        {
            this._particleImage.scaleX = _arg_1;
        }

        public function get direction():int
        {
            return (this._particleImage.scaleX);
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._particleImage);
            this._particleImage = null;
        }


    }
}//package playerParticle

