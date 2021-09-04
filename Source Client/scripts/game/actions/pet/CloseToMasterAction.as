package game.actions.pet
{
   import flash.geom.Point;
   import game.actions.BaseAction;
   import game.objects.GamePet;
   import game.view.map.MapView;
   
   public class CloseToMasterAction extends BaseAction
   {
       
      
      private var _pet:GamePet;
      
      private var _target:Point;
      
      private var _map:MapView;
      
      private var _path:Array;
      
      private var _canWalk:Boolean = false;
      
      private var _count:int = 0;
      
      private var _walkAction:String;
      
      private var _standAtion:String;
      
      public function CloseToMasterAction(param1:GamePet, param2:Point)
      {
         super();
         this._pet = param1;
         this._target = param2;
         this._map = this._pet.map;
         _isFinished = false;
         this._walkAction = Math.random() > 0.5 ? "walkA" : "walkB";
         this._standAtion = Math.random() > 0.5 ? "standA" : "standB";
      }
      
      public function get target() : Point
      {
         return this._target;
      }
      
      override public function connect(param1:BaseAction) : Boolean
      {
         if(_isFinished)
         {
            return false;
         }
         if(param1 is CloseToMasterAction)
         {
            this._target = CloseToMasterAction(param1).target;
            this.findPath();
            return true;
         }
         return false;
      }
      
      override public function prepare() : void
      {
         this.findPath();
      }
      
      override public function canReplace(param1:BaseAction) : Boolean
      {
         if(param1 is PetBlinkAction || param1 is PetBeatAction)
         {
            return true;
         }
         return false;
      }
      
      private function findPath() : void
      {
         this._count = 0;
         this._path = [];
         if(Point.distance(this._pet.pos,this._target) > 400)
         {
            this._canWalk = false;
            return;
         }
         var _loc1_:int = this._pet.x;
         var _loc2_:int = this._pet.y;
         var _loc3_:int = this._target.x > _loc1_ ? int(1) : int(-1);
         this._pet.info.direction = _loc3_;
         var _loc4_:Point = new Point(_loc1_,_loc2_);
         while((this._target.x - _loc1_) * _loc3_ > 0)
         {
            _loc4_ = this._map.findNextWalkPoint(_loc1_,_loc2_,_loc3_,this._pet.stepX,this._pet.stepY);
            if(!_loc4_)
            {
               break;
            }
            this._path.push(_loc4_);
            _loc1_ = _loc4_.x;
            _loc2_ = _loc4_.y;
         }
         var _loc5_:Point = this._path[this._path.length - 1];
         this._canWalk = _loc5_ && Point.distance(_loc5_,this._target) <= new Point(this._pet.stepX,this._pet.stepY).length;
      }
      
      override public function execute() : void
      {
         if(Point.distance(this._pet.pos,this._target) > 50)
         {
            if(this._canWalk && this._path[this._count])
            {
               this._pet.doAction(this._walkAction);
               if(this._pet.info)
               {
                  this._pet.info.pos = this._path[this._count++];
               }
            }
            else
            {
               this._pet.blinkTo(this._target);
            }
         }
         else
         {
            this.finish();
         }
      }
      
      override public function executeAtOnce() : void
      {
         if(_isFinished)
         {
            return;
         }
         this._pet.info.pos = this._target;
         this.finish();
      }
      
      private function finish() : void
      {
         this._pet.doAction(this._standAtion);
         _isFinished = true;
         this._pet = null;
      }
   }
}
