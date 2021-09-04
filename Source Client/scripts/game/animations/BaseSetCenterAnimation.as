package game.animations
{
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import game.view.map.MapView;
   
   public class BaseSetCenterAnimation extends BaseAnimate
   {
       
      
      protected var _target:Point;
      
      protected var _life:int;
      
      protected var _directed:Boolean;
      
      protected var _speed:int;
      
      protected var _moveSpeed:int = 4;
      
      protected var _tween:BaseStageTween;
      
      public function BaseSetCenterAnimation(param1:Number, param2:Number, param3:int = 0, param4:Boolean = false, param5:int = 0, param6:int = -1, param7:int = 4, param8:Object = null)
      {
         var _loc9_:TweenObject = null;
         super();
         _loc9_ = new TweenObject(param8);
         this._target = new Point(param1,param2);
         _loc9_.target = this._target;
         var _loc10_:String = StageTweenStrategys.getTweenClassNameByShortName(_loc9_.strategy);
         _finished = false;
         this._life = param3;
         _level = param5;
         _ownerID = param6;
         if(param8 && param8.priority != null)
         {
            _level = param8.priority;
         }
         if(param8 && param8.duration != null)
         {
            this._life = param8.duration;
         }
         this._directed = param4;
         this._speed = param7;
         var _loc11_:Class = getDefinitionByName(_loc10_) as Class;
         this._tween = new _loc11_(_loc9_);
      }
      
      override public function canAct() : Boolean
      {
         if(_finished)
         {
            return false;
         }
         if(this._life <= 0)
         {
            return false;
         }
         return true;
      }
      
      override public function prepare(param1:AnimationSet) : void
      {
         this._target.x = param1.stageWidth / 2 - this._target.x;
         this._target.y = param1.stageHeight / 2 - this._target.y;
         this._target.x = this._target.x < param1.minX ? Number(param1.minX) : (this._target.x > 0 ? Number(0) : Number(this._target.x));
         this._target.y = this._target.y < param1.minY ? Number(param1.minY) : (this._target.y > 0 ? Number(0) : Number(this._target.y));
      }
      
      override public function update(param1:MapView) : Boolean
      {
         var _loc2_:Point = null;
         --this._life;
         if(this._life <= 0)
         {
            this.finished();
         }
         if(!_finished && this._life > 0)
         {
            if(!this._directed)
            {
               this._tween.target = this._target;
               _loc2_ = this._tween.update(param1);
               param1.x = _loc2_.x;
               param1.y = _loc2_.y;
               if(this._tween.isFinished)
               {
                  this.finished();
               }
            }
            else
            {
               param1.x = this._target.x;
               param1.y = this._target.y;
               this.finished();
            }
            param1.setExpressionLoction();
            return true;
         }
         return false;
      }
      
      protected function finished() : void
      {
         _finished = true;
      }
   }
}
