package game.view
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Bounce;
   import com.greensock.easing.Quint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import road7th.utils.MovieClipWrapper;
   
   public class DropGoods implements Disposeable
   {
      
      public static var count:int;
      
      public static var isOver:Boolean = true;
       
      
      private var goodBox:MovieClip;
      
      private var bagMc:MovieClipWrapper;
      
      private var goldNumText:FilterFrameText;
      
      private var goods:DisplayObject;
      
      private var container:DisplayObjectContainer;
      
      private var goldNum:int;
      
      private var beginPoint:Point;
      
      private var midPoint:Point;
      
      private var endPoint:Point;
      
      private var headGlow:MovieClip;
      
      private var _type:int;
      
      private var timeId:uint;
      
      private var timeOutId:uint;
      
      public const MONSTER_DROP:int = 1;
      
      public const CHESTS_DROP:int = 2;
      
      private var _goodsId:int;
      
      private var currentCount:int;
      
      private var tweenUp:TweenMax;
      
      private var tweenDown:TweenMax;
      
      private var timeline:TimelineLite;
      
      public function DropGoods(param1:DisplayObjectContainer, param2:DisplayObject, param3:Point, param4:Point, param5:int)
      {
         super();
         this.container = param1;
         this.goods = param2;
         this.beginPoint = param3;
         this.endPoint = param4;
         this.goldNum = param5;
      }
      
      public function start(param1:int = 1) : void
      {
         if(this.goods == null || this.beginPoint == null)
         {
            return;
         }
         this._type = param1;
         this.goods.x = this.beginPoint.x;
         this.goods.y = this.beginPoint.y;
         this.container.addChild(this.goods);
         this.midPoint = this.getLinePoint(this.beginPoint);
         var _loc2_:Point = new Point(this.beginPoint.x - (this.beginPoint.x - this.midPoint.x) / 2,this.beginPoint.y - 200);
         this.goDown(this.midPoint,_loc2_);
         isOver = false;
      }
      
      private function getLinePoint(param1:Point) : Point
      {
         var _loc4_:int = 0;
         var _loc2_:Point = new Point();
         var _loc3_:Number = 45;
         this._goodsId = count;
         if(this._type == this.MONSTER_DROP)
         {
            _loc4_ = 3;
            _loc2_.y = param1.y - 30;
         }
         else if(this._type == this.CHESTS_DROP)
         {
            _loc4_ = 2;
            _loc2_.y = param1.y + Math.random() * 90 + 10;
         }
         if(count % 2 == 0 && param1.x - _loc3_ * count / _loc4_ > param1.x - 350)
         {
            _loc2_.x = param1.x - _loc3_ * count / _loc4_;
         }
         else if(count % 2 == 1 && param1.x + _loc3_ * count / _loc4_ < param1.x + 300)
         {
            _loc2_.x = param1.x + _loc3_ * count / _loc4_;
         }
         else
         {
            _loc2_.x = Boolean(count % 2) ? Number(param1.x + _loc3_ * Math.random() * (count / _loc4_)) : Number(param1.x - _loc3_ * Math.random() * (count / _loc4_));
         }
         if(this.container.localToGlobal(_loc2_).x < 100)
         {
            _loc2_.x = param1.x + _loc3_ * count / _loc4_;
         }
         if(this.container.localToGlobal(_loc2_).x > 900)
         {
            _loc2_.x = param1.x - _loc3_ * count / _loc4_;
         }
         ++count;
         return _loc2_;
      }
      
      private function goDown(param1:Point, param2:Point) : void
      {
         SoundManager.instance.play("170");
         if(this._type == this.MONSTER_DROP)
         {
            this.tweenDown = TweenMax.to(this.goods,1.2 + this._goodsId / 10,{
               "bezier":[{
                  "x":param2.x,
                  "y":param2.y
               },{
                  "x":param1.x,
                  "y":param1.y
               },{
                  "x":param1.x,
                  "y":param1.y
               }],
               "scaleX":1,
               "scaleY":1,
               "ease":Bounce.easeOut,
               "onComplete":this.__onCompleteGodown
            });
         }
         else if(this._type == this.CHESTS_DROP)
         {
            this.tweenDown = TweenMax.to(this.goods,1.2 + this._goodsId / 10,{
               "bezier":[{
                  "x":param2.x,
                  "y":param2.y
               },{
                  "x":param1.x,
                  "y":this.beginPoint.y - 10
               },{
                  "x":param1.x,
                  "y":param1.y
               }],
               "scaleX":1,
               "scaleY":1,
               "ease":Bounce.easeOut,
               "onComplete":this.__onCompleteGodown
            });
         }
      }
      
      private function __onCompleteGodown() : void
      {
         var _loc1_:Point = null;
         this.tweenDown.kill();
         this.tweenDown = null;
         if(this.goods == null)
         {
            return;
         }
         if(this._type == this.MONSTER_DROP)
         {
            _loc1_ = new Point(this.midPoint.x - (this.midPoint.x - this.endPoint.x) / 2,this.midPoint.y - 100);
            this.goodBox = ClassUtils.CreatInstance("asset.game.GoodFlashBox") as MovieClip;
            this.timeOutId = setTimeout(this.goPackUp,500 + this._goodsId * 50,this.endPoint,_loc1_);
         }
         else if(this._type == this.CHESTS_DROP)
         {
            _loc1_ = new Point(this.midPoint.x - (this.midPoint.x - this.endPoint.x) / 2,this.midPoint.y - 100);
            this.goodBox = ClassUtils.CreatInstance("asset.game.FlashLight") as MovieClip;
            this.timeOutId = setTimeout(this.goPackUp,600 + this._goodsId * 100,this.endPoint,_loc1_);
         }
         this.goodBox.x = this.goods.x;
         this.goodBox.y = this.goods.y;
         this.goods.x = 0;
         this.goods.y = 0;
         this.goodBox.gotoAndPlay(int(Math.random() * this.goodBox.totalFrames));
         this.goodBox.box.addChild(this.goods);
         this.container.addChild(this.goodBox);
         SoundManager.instance.play("172");
      }
      
      private function goPackUp(param1:Point, param2:Point) : void
      {
         var p:Point = null;
         var tl:TweenLite = null;
         var p1:Point = param1;
         var p2:Point = param2;
         clearTimeout(this.timeOutId);
         if(this.goods == null)
         {
            return;
         }
         if(this.container.contains(this.goodBox))
         {
            this.container.removeChild(this.goodBox);
         }
         this.goods.x = this.goodBox.x;
         this.goods.y = this.goodBox.y;
         if(this._type == this.MONSTER_DROP)
         {
            this.container.addChild(this.goods);
            this.tweenUp = TweenMax.to(this.goods,0.8,{
               "alpha":0,
               "scaleX":0.5,
               "scaleY":0.5,
               "bezierThrough":[{
                  "x":p2.x,
                  "y":p2.y
               },{
                  "x":p1.x,
                  "y":p1.y
               }],
               "ease":Quint.easeInOut,
               "orientToBezier":true,
               "onComplete":this.onCompletePackUp
            });
         }
         else if(this._type == this.CHESTS_DROP)
         {
            p = this.container.localToGlobal(new Point(this.goods.x,this.goods.y));
            this.goods.x = p.x;
            this.goods.y = p.y;
            this.container.stage.addChild(this.goods);
            p2 = this.container.localToGlobal(p2);
            p1 = new Point(650,550);
            this.tweenUp = TweenMax.to(this.goods,0.8,{
               "alpha":0.5,
               "scaleX":0.5,
               "scaleY":0.5,
               "bezierThrough":[{
                  "x":p2.x,
                  "y":p2.y
               },{
                  "x":p1.x,
                  "y":p1.y
               }],
               "ease":Quint.easeInOut,
               "orientToBezier":true,
               "onComplete":this.onCompletePackUp
            });
         }
         this.goldNumText = ComponentFactory.Instance.creatComponentByStylename("dropGoods.goldNumText");
         if(this.goldNumText)
         {
            this.goldNumText.x = this.midPoint.x;
            this.goldNumText.y = this.midPoint.y;
            this.goldNumText.text = this.goldNum.toString();
            this.container.addChild(this.goldNumText);
            tl = TweenLite.to(this.goldNumText,1,{
               "y":this.midPoint.y - 200,
               "alpha":0,
               "onComplete":function():void
               {
                  tl.kill();
               }
            });
         }
      }
      
      private function onCompletePackUp() : void
      {
         var _loc1_:Sprite = null;
         this.tweenUp.kill();
         this.tweenUp = null;
         if(this.goods == null)
         {
            return;
         }
         if(this.goldNumText && this.container.contains(this.goldNumText))
         {
            this.container.removeChild(this.goldNumText);
         }
         if(this._type == this.MONSTER_DROP)
         {
            this.timeline = new TimelineLite();
            if(this.goods is BaseCell)
            {
               _loc1_ = (this.goods as BaseCell).getContent();
               if(_loc1_)
               {
                  _loc1_.x -= _loc1_.width / 2;
                  _loc1_.y -= _loc1_.height / 2;
               }
            }
            this.headGlow = ClassUtils.CreatInstance("asset.game.HeadGlow") as MovieClip;
            this.headGlow.x = this.endPoint.x;
            this.headGlow.y = this.endPoint.y;
            this.container.addChild(this.headGlow);
            this.goods.rotationX = this.goods.rotationY = this.goods.rotationZ = 0;
            this.timeline.append(TweenLite.to(this.goods,0.2,{
               "alpha":1,
               "scaleX":0.8,
               "scaleY":0.8,
               "x":this.goods.x + 5,
               "y":this.goods.y - 50
            }));
            this.timeline.append(TweenLite.to(this.goods,0.4,{
               "y":this.goods.y - 150,
               "alpha":0.2,
               "rotationY":360 * 5,
               "onComplete":this.completeHead
            }));
         }
         else if(this._type == this.CHESTS_DROP)
         {
            if(this.goods && this.container.stage.contains(this.goods))
            {
               this.container.stage.removeChild(this.goods);
            }
            this.bagMc = this.getBagAniam();
            if(this.bagMc.movie)
            {
               this.container.stage.addChild(this.bagMc.movie);
            }
            this.timeId = setTimeout(this.dispose,500);
            this.currentCount = count;
         }
         SoundManager.instance.play("171");
      }
      
      private function completeHead() : void
      {
         this.timeline.kill();
         this.timeline = null;
         if(this.goods && this.container.contains(this.goods))
         {
            this.container.removeChild(this.goods);
         }
         this.timeId = setTimeout(this.dispose,500);
         this.currentCount = count;
      }
      
      private function getBagAniam() : MovieClipWrapper
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Point = null;
         _loc1_ = ClassUtils.CreatInstance("asset.game.bagAniam") as MovieClip;
         _loc2_ = ComponentFactory.Instance.creatCustomObject("dropGoods.bagPoint");
         _loc1_.x = _loc2_.x;
         _loc1_.y = _loc2_.y;
         return new MovieClipWrapper(_loc1_,true,true);
      }
      
      public function dispose() : void
      {
         clearTimeout(this.timeId);
         clearTimeout(this.timeOutId);
         ObjectUtils.disposeObject(this.goods);
         this.goods = null;
         if(this.goldNumText)
         {
            TweenLite.killTweensOf(this.goldNumText);
            ObjectUtils.disposeObject(this.goldNumText);
            this.goldNumText = null;
         }
         ObjectUtils.disposeObject(this.headGlow);
         this.headGlow = null;
         ObjectUtils.disposeObject(this.goodBox);
         this.goodBox = null;
         if(this.bagMc)
         {
            this.bagMc.dispose();
            this.bagMc = null;
         }
         this.goods = null;
         if(this.currentCount == count)
         {
            isOver = true;
         }
         count = 0;
      }
   }
}
