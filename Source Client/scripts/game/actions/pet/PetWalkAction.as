package game.actions.pet
{
   import flash.geom.Point;
   import game.actions.BaseAction;
   import game.objects.GamePet;
   
   public class PetWalkAction extends BaseAction
   {
       
      
      private var _pet:GamePet;
      
      private var _target:Point;
      
      private var _walkAction:String;
      
      private var _standAction:String;
      
      public function PetWalkAction(param1:GamePet, param2:Point)
      {
         super();
         this._pet = param1;
         this._target = param2;
      }
      
      override public function canReplace(param1:BaseAction) : Boolean
      {
         return true;
      }
      
      override public function prepare() : void
      {
         if(this._pet.pos.x < this._target.x)
         {
            this._pet.info.direction = 1;
         }
         else
         {
            this._pet.info.direction = -1;
         }
         this._walkAction = Math.random() > 0.5 ? "walkA" : "walkB";
         this._standAction = Math.random() > 0.5 ? "standA" : "standB";
      }
      
      public function get target() : Point
      {
         return this._target;
      }
      
      override public function connect(param1:BaseAction) : Boolean
      {
         if(isFinished)
         {
            return false;
         }
         if(param1 is PetWalkAction)
         {
            this._target = PetWalkAction(param1).target;
            return true;
         }
         return false;
      }
      
      override public function execute() : void
      {
         var _loc1_:Point = null;
         if(Math.abs(this._pet.pos.x - this._target.x) > this._pet.stepX)
         {
            if(this._pet.pos.x < this._target.x)
            {
               this._pet.info.direction = 1;
            }
            else
            {
               this._pet.info.direction = -1;
            }
            _loc1_ = this._pet.getNextWalkPoint(this._pet.info.direction);
            if(_loc1_)
            {
               this._pet.info.pos = _loc1_;
               this._pet.doAction(this._walkAction);
            }
            else
            {
               this.finish();
            }
         }
         else
         {
            this.finish();
         }
      }
      
      override public function executeAtOnce() : void
      {
         this.finish();
      }
      
      private function finish() : void
      {
         if(this._pet)
         {
            this._pet.doAction(this._standAction);
         }
         _isFinished = true;
         this._pet = null;
      }
   }
}
