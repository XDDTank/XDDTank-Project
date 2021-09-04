package game.animations
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import game.objects.GamePlayer;
   import game.view.GameViewBase;
   import game.view.map.MapView;
   import road7th.math.interpolateNumber;
   
   public class MultiSpellSkillAnimation extends EventDispatcher implements IAnimate
   {
      
      private static const SKILL_TYPE:int = 2;
      
      private static const OFF_X:int = -68;
       
      
      private var _typeList:Vector.<int>;
      
      private var _begin:Point;
      
      private var _end:Point;
      
      private var _scale:Number;
      
      private var _life:int;
      
      private var _backlist:Array;
      
      private var _finished:Boolean;
      
      private var _playerList:Vector.<GamePlayer>;
      
      private var _characterCopyList:Vector.<Bitmap>;
      
      private var _gameView:GameViewBase;
      
      private var map:MapView;
      
      private var _skillList:Vector.<Sprite>;
      
      private var _effectList:Vector.<ScaleEffect>;
      
      private var _skillTypeList:Vector.<int>;
      
      private var _container:Sprite;
      
      public function MultiSpellSkillAnimation(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Vector.<GamePlayer>, param8:GameViewBase)
      {
         var _loc13_:int = 0;
         this._typeList = Vector.<int>([1,2,3,4]);
         super();
         this._scale = 1.5;
         var _loc9_:Number = -param5 * this._scale + param3;
         var _loc10_:Number = -param6 * this._scale + param4;
         var _loc11_:Matrix = new Matrix(this._scale,0,0,this._scale);
         this._end = new Point(param1,param2);
         this._end = _loc11_.transformPoint(this._end);
         this._end.x = param3 / 2 - this._end.x;
         this._end.y = param4 / 4 * 3 - this._end.y;
         this._end.x = this._end.x > 0 ? Number(0) : (this._end.x < _loc9_ ? Number(_loc9_) : Number(this._end.x));
         this._end.y = this._end.y > 0 ? Number(0) : (this._end.y < _loc10_ ? Number(_loc10_) : Number(this._end.y));
         this._playerList = param7;
         this._gameView = param8;
         this._container = new Sprite();
         this._container.x = OFF_X;
         this._gameView.addChildAt(this._container,1);
         this._life = 0;
         this._backlist = new Array();
         this._finished = false;
         this._skillList = new Vector.<Sprite>(this._playerList.length);
         this._effectList = new Vector.<ScaleEffect>(this._playerList.length);
         this._skillTypeList = new Vector.<int>(this._playerList.length);
         var _loc12_:int = 0;
         while(_loc12_ < this._playerList.length)
         {
            _loc13_ = this._typeList.splice(int(Math.random() * this._typeList.length),1)[0];
            this._skillTypeList[_loc12_] = _loc13_;
            _loc12_++;
         }
      }
      
      public function get level() : int
      {
         return AnimationLevel.HIGHEST;
      }
      
      public function canAct() : Boolean
      {
         return !this._finished;
      }
      
      public function prepare(param1:AnimationSet) : void
      {
      }
      
      public function canReplace(param1:IAnimate) : Boolean
      {
         return false;
      }
      
      public function cancel() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._skillList.length)
         {
            if(this._skillList[_loc1_] && this._skillList[_loc1_].parent)
            {
               this._skillList[_loc1_].parent.removeChild(this._skillList[_loc1_]);
            }
            if(this._effectList[_loc1_])
            {
               this._effectList[_loc1_].dispose();
            }
            _loc1_++;
         }
         if(this.map)
         {
            this.map.lockPositon = false;
            this.map.restoreStageTopLiving();
            while(this._backlist.length > 0)
            {
               this.map.setMatrx(this._backlist.pop());
            }
            if(this.map.ground)
            {
               this.map.ground.alpha = 1;
            }
            if(this.map.stone)
            {
               this.map.stone.alpha = 1;
            }
            if(this.map.sky)
            {
               this.map.sky.alpha = 1;
            }
            this.map.showPhysical();
         }
         ObjectUtils.disposeObject(this._container);
         this._container = null;
         this.map = null;
         this._playerList = null;
         this._gameView = null;
         this._skillList.length = 0;
         this._skillList = null;
         this._effectList.length = 0;
         this._effectList = null;
         this._skillTypeList.length = 0;
         this._skillTypeList = null;
      }
      
      public function update(param1:MapView) : Boolean
      {
         var count:int = 0;
         var a:Number = NaN;
         var i:int = 0;
         var tp:Point = null;
         var s:Number = NaN;
         var m:Matrix = null;
         var bmd:BitmapData = null;
         var width:Number = NaN;
         var movie:MapView = param1;
         try
         {
            count = this._playerList.length;
            this.map = movie;
            ++this._life;
            i = 0;
            for(; i < count; i++)
            {
               if(this._skillList[i] && this._effectList[i])
               {
                  this._skillList[i].addChild(this._effectList[i]);
               }
               if(this._life == 1)
               {
                  this.map.lockPositon = true;
                  this.map.sky.alpha = 1 - this._life / 20;
               }
               else if(this._life < 6)
               {
                  if(this._backlist.length == 0)
                  {
                     this._begin = new Point(this.map.x,this.map.y);
                     this._backlist.push(this.map.transform.matrix.clone());
                  }
                  this.map.sky.alpha = 1 - this._life / 15;
                  tp = Point.interpolate(this._end,this._begin,(this._life - 1) / 5);
                  s = interpolateNumber(0,1,1,this._scale,(this._life - 1) / 5);
                  m = new Matrix();
                  m.scale(s,s);
                  m.translate(tp.x,tp.y);
                  this.map.setMatrx(m);
                  this._backlist.push(m);
               }
               else if(this._life < 15)
               {
                  this.map.sky.alpha = 1 - this._life / 15;
               }
               else if(this._life == 15)
               {
                  this.map.sky.alpha = 1 - this._life / 15;
                  this._skillList[i] = this.createSkillCartoon(this._skillTypeList[i]);
                  this._skillList[i].mouseChildren = this._skillList[i].mouseEnabled = false;
                  bmd = Math.random() > 0.3 ? this._playerList[i].character.charaterWithoutWeapon : this._playerList[i].character.winCharater;
                  this._effectList[i] = new ScaleEffect(i % 2 == 0 ? int(2) : int(5),bmd);
                  this._skillList[i].addChild(this._effectList[i]);
                  width = StageReferance.stageWidth / 3;
                  this._skillList[i].x = StageReferance.stageWidth / 2 - width * count / 2 + width * i;
                  this._container.addChild(this._skillList[i]);
               }
               else if(this._life == 52)
               {
                  this.map.showPhysical();
               }
               else if(this._life > 47)
               {
                  if(this._backlist.length <= 0)
                  {
                     this.cancel();
                     this._finished = true;
                  }
                  this.map.setMatrx(this._backlist.pop());
                  this.map.sky.alpha = (this._life - 47) / 5;
                  continue;
                  dispatchEvent(new Event(Event.COMPLETE));
                  break;
               }
            }
         }
         catch(e:Error)
         {
            cancel();
         }
         return true;
      }
      
      private function createSkillCartoon(param1:int) : Sprite
      {
         var _loc2_:String = "";
         _loc2_ = "asset.game.specialSkillA" + param1;
         return MovieClip(ClassUtils.CreatInstance(_loc2_));
      }
      
      public function get finish() : Boolean
      {
         return this._finished;
      }
      
      public function get ownerID() : int
      {
         return AnimationSet.PUBLIC_OWNER;
      }
   }
}
