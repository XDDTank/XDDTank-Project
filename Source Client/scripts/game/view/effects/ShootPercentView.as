package game.view.effects
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.TweenVars;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.model.Living;
   
   public class ShootPercentView extends Sprite implements Disposeable
   {
       
      
      private var _type:int;
      
      private var _isAdd:Boolean;
      
      private var _isSelf:Boolean;
      
      private var _picBmp:Bitmap;
      
      private var _leftBlood:MovieClip;
      
      private var _rightBlood:MovieClip;
      
      private var _leftCritBlood:MovieClip;
      
      private var _rightCritBlood:MovieClip;
      
      private var _redBg:MovieClip;
      
      private var _setTimeoutId:uint;
      
      private var tween:TweenLite;
      
      public function ShootPercentView(param1:int, param2:int = 1, param3:Boolean = false, param4:Boolean = false)
      {
         super();
         this._type = param2;
         this._isAdd = param3;
         this._isSelf = param4;
         this._picBmp = this.getPercent(Math.abs(param1));
      }
      
      public function play(param1:int = 0) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:Bitmap = null;
         var _loc5_:Sprite = null;
         var _loc6_:Bitmap = null;
         var _loc7_:TweenVars = null;
         var _loc8_:TweenVars = null;
         if(this._picBmp != null)
         {
            _loc2_ = param1 == 0 ? int(int(Math.random() * 2)) : int(param1);
            if(this._type == 2)
            {
               _loc3_ = ComponentFactory.Instance.creatBitmap("asset.game.CritAsset") as Bitmap;
               if(_loc2_ == 1)
               {
                  this._leftCritBlood = ClassUtils.CreatInstance("asset.game.LeftCritBlood") as MovieClip;
                  this._leftCritBlood.cons.consPic.addChild(_loc3_);
                  this._leftCritBlood.cons.consNum.addChild(this._picBmp);
                  this.addChild(this._leftCritBlood);
               }
               else
               {
                  this._rightCritBlood = ClassUtils.CreatInstance("asset.game.RightCritBlood") as MovieClip;
                  this._rightCritBlood.cons.consPic.addChild(_loc3_);
                  this._rightCritBlood.cons.consNum.addChild(this._picBmp);
                  this.addChild(this._rightCritBlood);
               }
               if(GameManager.Instance.isRed)
               {
                  this._redBg = ClassUtils.CreatInstance("asset.game.CritRedBg") as MovieClip;
                  StageReferance.stage.addChild(this._redBg);
                  GameManager.Instance.isRed = false;
               }
            }
            else if(this._type == 20)
            {
               _loc4_ = ComponentFactory.Instance.creatBitmap("asset.game.CritHeadAsset") as Bitmap;
               if(_loc2_ == 1)
               {
                  this._leftCritBlood = ClassUtils.CreatInstance("asset.game.LeftCritBlood") as MovieClip;
                  this._leftCritBlood.cons.consPic.addChild(_loc4_);
                  this._leftCritBlood.cons.consNum.addChild(this._picBmp);
                  this.addChild(this._leftCritBlood);
               }
               else
               {
                  this._rightCritBlood = ClassUtils.CreatInstance("asset.game.RightCritBlood") as MovieClip;
                  this._rightCritBlood.cons.consPic.addChild(_loc4_);
                  this._rightCritBlood.cons.consNum.addChild(this._picBmp);
                  this.addChild(this._rightCritBlood);
               }
               if(GameManager.Instance.isRed)
               {
                  this._redBg = ClassUtils.CreatInstance("asset.game.CritRedBg") as MovieClip;
                  StageReferance.stage.addChild(this._redBg);
                  GameManager.Instance.isRed = false;
               }
            }
            else if(this._type == Living.PET_REDUCE)
            {
               _loc5_ = new Sprite();
               _loc6_ = ComponentFactory.Instance.creatBitmap("asset.game.petReduceAsset") as Bitmap;
               _loc6_.scaleX = _loc6_.scaleY = 0.6;
               _loc6_.y += 6;
               _loc5_.addChild(_loc6_);
               _loc5_.addChild(this._picBmp);
               this._picBmp.x += _loc6_.width;
               this.addChild(_loc5_);
               _loc7_ = ComponentFactory.Instance.creatCustomObject("settlement.tweenVars") as TweenVars;
               this.tween = TweenLite.to(_loc5_,_loc7_.duration,{
                  "x":_loc5_.x + _loc7_.x,
                  "y":_loc5_.y + _loc7_.y,
                  "scaleX":_loc7_.scaleX,
                  "scaleY":_loc7_.scaleY,
                  "alpha":_loc7_.alpha,
                  "ease":Sine.easeOut,
                  "onComplete":this.__onCompleteTween,
                  "onCompleteParams":[_loc5_]
               });
            }
            else if(this._isAdd)
            {
               this.addChild(this._picBmp);
               _loc8_ = ComponentFactory.Instance.creatCustomObject("settlement.tweenVars") as TweenVars;
               this.tween = TweenLite.to(this._picBmp,_loc8_.duration,{
                  "x":this._picBmp.x + _loc8_.x,
                  "y":this._picBmp.y + _loc8_.y,
                  "scaleX":_loc8_.scaleX,
                  "scaleY":_loc8_.scaleY,
                  "alpha":_loc8_.alpha,
                  "ease":Sine.easeOut,
                  "onComplete":this.__onCompleteTween,
                  "onCompleteParams":[this._picBmp]
               });
            }
            else if(_loc2_ == 1)
            {
               this._leftBlood = ClassUtils.CreatInstance("asset.game.LeftLoseBlood") as MovieClip;
               this._leftBlood.cons.addChild(this._picBmp);
               this.addChild(this._leftBlood);
            }
            else
            {
               this._rightBlood = ClassUtils.CreatInstance("asset.game.RightLoseBlood") as MovieClip;
               this._rightBlood.cons.addChild(this._picBmp);
               this.addChild(this._rightBlood);
            }
         }
         this._setTimeoutId = setTimeout(this.dispose,2000);
      }
      
      private function __onCompleteTween(param1:DisplayObject) : void
      {
         var tl:TweenLite = null;
         var dis:DisplayObject = param1;
         this.tween.kill();
         this.tween = null;
         tl = TweenLite.to(dis,0.4,{
            "alpha":0,
            "onComplete":function():void
            {
               tl.kill();
            }
         });
      }
      
      public function getPercent(param1:int) : Bitmap
      {
         var _loc2_:Array = null;
         var _loc8_:BitmapData = null;
         var _loc9_:BitmapData = null;
         if(param1 > 99999999)
         {
            return null;
         }
         _loc2_ = new Array();
         _loc2_ = [0,0,0,0];
         var _loc3_:Array = new Array();
         var _loc4_:String = String(param1);
         var _loc5_:int = _loc4_.length;
         if(this._isAdd)
         {
            _loc4_ = " " + _loc4_;
            _loc5_ += 1;
            _loc8_ = GameManager.Instance.numCreater.addIconData;
            _loc3_.push(0);
            _loc2_.push(_loc8_);
         }
         var _loc6_:int = !!this._isAdd ? int(1) : int(0);
         while(_loc6_ < _loc5_)
         {
            if(this._isAdd)
            {
               _loc9_ = GameManager.Instance.numCreater.greenData[int(_loc4_.charAt(_loc6_))];
            }
            else if(this._isSelf)
            {
               _loc9_ = GameManager.Instance.numCreater.redYellowData[int(_loc4_.charAt(_loc6_))];
            }
            else if(this._type == 21)
            {
               _loc9_ = GameManager.Instance.numCreater.blueData[int(_loc4_.charAt(_loc6_))];
            }
            else
            {
               _loc9_ = GameManager.Instance.numCreater.redData[int(_loc4_.charAt(_loc6_))];
            }
            _loc3_.push(_loc6_ * 20);
            _loc2_.push(_loc9_);
            _loc6_++;
         }
         _loc2_ = this.returnNum(_loc2_,_loc3_);
         var _loc7_:BitmapData = new BitmapData(_loc2_[2],_loc2_[3],true,0);
         this._picBmp = new Bitmap(_loc7_,"auto",true);
         _loc6_ = 4;
         while(_loc6_ < _loc2_.length)
         {
            _loc7_.copyPixels(_loc2_[_loc6_],new Rectangle(0,0,_loc2_[_loc6_].width,_loc2_[_loc6_].height),new Point(_loc3_[_loc6_ - 4] - _loc2_[0],_loc2_[_loc6_].rect.y - _loc2_[1]),null,null,true);
            _loc6_++;
         }
         this._picBmp.x = _loc2_[0];
         this._picBmp.y = _loc2_[1];
         _loc2_ = null;
         this._picBmp.smoothing = true;
         return this._picBmp;
      }
      
      private function returnNum(param1:Array, param2:Array) : Array
      {
         var _loc3_:int = 4;
         while(_loc3_ < param1.length)
         {
            param1[0] = param1[0] > param2[_loc3_ - 4] ? param2[_loc3_ - 4] : param1[0];
            param1[1] = param1[1] > param1[_loc3_].rect.y ? param1[_loc3_].rect.y : param1[1];
            param1[2] = param1[2] > param1[_loc3_].width + param2[_loc3_ - 4] ? param1[2] : param1[_loc3_].width + param2[_loc3_ - 4];
            param1[3] = param1[3] > param1[_loc3_].height + param1[_loc3_].rect.y ? param1[3] : param1[_loc3_].height + param1[_loc3_].rect.y;
            _loc3_++;
         }
         param1[2] -= param1[0];
         param1[3] -= param1[1];
         return param1;
      }
      
      public function dispose() : void
      {
         clearTimeout(this._setTimeoutId);
         if(this._redBg)
         {
            this._redBg.stop();
            StageReferance.stage.removeChild(this._redBg);
            this._redBg = null;
         }
         if(this._picBmp)
         {
            TweenLite.killTweensOf(this._picBmp);
            ObjectUtils.disposeObject(this._picBmp);
            this._picBmp = null;
         }
         if(this._leftBlood)
         {
            this._leftBlood.stop();
            ObjectUtils.disposeObject(this._leftBlood);
            this._leftBlood = null;
         }
         if(this._rightBlood)
         {
            this._rightBlood.stop();
            ObjectUtils.disposeObject(this._rightBlood);
            this._rightBlood = null;
         }
         if(this._leftCritBlood)
         {
            this._leftCritBlood.stop();
            ObjectUtils.disposeObject(this._leftCritBlood);
            this._leftCritBlood = null;
         }
         if(this._rightCritBlood)
         {
            this._rightCritBlood.stop();
            ObjectUtils.disposeObject(this._leftCritBlood);
            this._rightCritBlood = null;
         }
         if(this.tween)
         {
            this.tween.kill();
            this.tween = null;
         }
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
