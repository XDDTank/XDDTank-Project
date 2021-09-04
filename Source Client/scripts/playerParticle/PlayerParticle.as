package playerParticle
{
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import game.objects.GamePlayer;
   
   public class PlayerParticle extends Sprite
   {
       
      
      private var _player:GamePlayer;
      
      private var _particleImage:Bitmap;
      
      public function PlayerParticle(param1:GamePlayer)
      {
         super();
         this._player = param1;
         this._particleImage = param1.body.getCloneBody();
         addChild(this._particleImage);
      }
      
      public function get player() : GamePlayer
      {
         return this._player;
      }
      
      public function set direction(param1:int) : void
      {
         this._particleImage.scaleX = param1;
      }
      
      public function get direction() : int
      {
         return this._particleImage.scaleX;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._particleImage);
         this._particleImage = null;
      }
   }
}
