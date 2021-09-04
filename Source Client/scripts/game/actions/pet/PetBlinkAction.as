package game.actions.pet
{
   import flash.geom.Point;
   import game.actions.BaseAction;
   import game.objects.GamePet;
   
   public class PetBlinkAction extends BaseAction
   {
       
      
      private var _pet:GamePet;
      
      private var _origin:Point;
      
      private var _target:Point;
      
      private var _life:int = 1;
      
      private var _total:int = 20;
      
      public function PetBlinkAction(param1:GamePet, param2:Point)
      {
         this._pet = param1;
         this._origin = this._pet.info.pos;
         this._target = param2;
         super();
      }
      
      public function get target() : Point
      {
         return this._target;
      }
      
      public function get origin() : Point
      {
         return this._origin;
      }
      
      override public function prepare() : void
      {
         this._pet.actionMovie.doAction("call");
      }
      
      override public function connect(param1:BaseAction) : Boolean
      {
         if(param1 is PetBlinkAction)
         {
            this._target = PetBlinkAction(param1).target;
            return true;
         }
         return false;
      }
      
      override public function canReplace(param1:BaseAction) : Boolean
      {
         return false;
      }
      
      private function finish() : void
      {
         if(this._pet && this._pet.info)
         {
            this._pet.info.pos = this._target;
            this._pet.stopMoving();
            this._pet.walkToRandom();
         }
         _isFinished = true;
         this._pet = null;
      }
      
      override public function cancel() : void
      {
         this.finish();
      }
      
      override public function execute() : void
      {
         var _loc1_:Point = null;
         if(!this._pet || !this._pet.actionMovie || !this._origin || !this._target)
         {
            this.finish();
            return;
         }
         this._pet.actionMovie.doAction("call");
         _loc1_ = new Point(this._origin.x + (this._target.x - this._origin.x) * (this._life / this._total),this._origin.y + (this._target.y - this._origin.y) * (this._life / this._total));
         this._pet.x = _loc1_.x;
         this._pet.y = _loc1_.y;
         ++this._life;
         if(!this._pet.info || this._life > this._total || Point.distance(this._target,this._pet.info.pos) < 1)
         {
            this.finish();
         }
      }
      
      override public function executeAtOnce() : void
      {
         this.finish();
      }
   }
}
