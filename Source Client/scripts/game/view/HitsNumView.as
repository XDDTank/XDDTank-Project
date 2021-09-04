package game.view
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Bounce;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import game.GameManager;
   
   public class HitsNumView extends MovieClip implements Disposeable
   {
       
      
      private var hitsbg:Bitmap;
      
      private var hits11:Bitmap;
      
      private var glassFlake1:Bitmap;
      
      private var glassFlake2:Bitmap;
      
      private var good:Bitmap;
      
      private var cool:Bitmap;
      
      private var great:Bitmap;
      
      private var perfect:Bitmap;
      
      private var pics:Sprite;
      
      private var setTimeoutId:uint;
      
      private var hitsNumArr:Array;
      
      private var rankV:Array;
      
      private var rankS:Array;
      
      private var currentRank:Bitmap;
      
      private var currentGlassFlake:Bitmap;
      
      public function HitsNumView()
      {
         this.hitsNumArr = new Array();
         this.rankV = [3,6,9,12];
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.hitsbg = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.hitsbg");
         this.hits11 = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.hits11");
         this.glassFlake1 = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.glassFlake1");
         this.glassFlake2 = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.glassFlake2");
         this.good = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.good");
         this.cool = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.cool");
         this.great = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.great");
         this.perfect = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.perfect");
         this.rankS = [this.good,this.cool,this.great,this.perfect];
         this.y = 300;
         this.x = -500;
         this.addChild(this.hitsbg);
         this.addChild(this.hits11);
         this.pics = new Sprite();
         this.addChild(this.pics);
      }
      
      public function setHitsNum(param1:int) : void
      {
         if(param1 > 0)
         {
            this.hitsNumArr.push(param1);
         }
      }
      
      public function start() : void
      {
         clearTimeout(this.setTimeoutId);
         if(this.hitsNumArr[0])
         {
            this.hitsNum(this.hitsNumArr.shift());
         }
         if(this.hitsNumArr.length == 0)
         {
            this.setTimeoutId = setTimeout(this.resetView,1200);
         }
      }
      
      public function resetView() : void
      {
         this.hitsNumArr = new Array();
         TweenLite.to(this,1,{"x":-500});
         clearTimeout(this.setTimeoutId);
      }
      
      private function hitsNum(param1:int) : void
      {
         var _loc6_:BitmapData = null;
         var _loc7_:Bitmap = null;
         if(param1 < 2)
         {
            return;
         }
         this.x = 0;
         while(this.pics.numChildren > 0)
         {
            this.pics.removeChildAt(0);
         }
         var _loc2_:String = String(param1);
         var _loc3_:int = _loc2_.length;
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = GameManager.Instance.numCreater.whiteData[int(_loc2_.charAt(_loc5_))];
            _loc7_ = new Bitmap(_loc6_);
            _loc4_.push(_loc7_);
            _loc5_++;
         }
         if(_loc4_.length == 1)
         {
            this.pics.addChild(_loc4_[0]);
            this.pics.x = 30;
         }
         else if(_loc4_.length == 2)
         {
            this.pics.addChild(_loc4_[0]);
            this.pics.addChild(_loc4_[1]);
            _loc4_[1].x = 30;
            this.pics.x = 20;
         }
         else if(_loc4_.length == 3)
         {
            this.pics.addChild(_loc4_[0]);
            this.pics.addChild(_loc4_[1]);
            this.pics.addChild(_loc4_[2]);
            _loc4_[2].x = 50;
            _loc4_[1].x = 20;
            _loc4_[0].x = -10;
            this.pics.x = 10;
         }
         this.pics.y = 111;
         this.pics.alpha = 0.1;
         this.pics.scaleX = 2;
         this.pics.scaleY = 2;
         TweenLite.to(this.pics,0.15,{
            "alpha":1,
            "scaleX":1,
            "scaleY":1
         });
         this.setRankText(param1);
         _loc4_ = null;
      }
      
      private function setRankText(param1:int) : void
      {
         var _loc2_:int = 3;
         while(_loc2_ >= 0)
         {
            if(param1 >= this.rankV[_loc2_])
            {
               if(this.currentRank == this.rankS[_loc2_])
               {
                  break;
               }
               if(this.currentRank && this.contains(this.currentRank))
               {
                  this.removeChild(this.currentRank);
               }
               if(this.currentGlassFlake && this.contains(this.currentGlassFlake))
               {
                  this.removeChild(this.currentGlassFlake);
               }
               if(_loc2_ > 2)
               {
                  this.currentGlassFlake = this.glassFlake2;
               }
               else
               {
                  this.currentGlassFlake = this.glassFlake1;
               }
               this.addChild(this.currentGlassFlake);
               TweenLite.to(this.currentGlassFlake,0.3,{
                  "y":5,
                  "ease":Bounce.easeIn
               });
               this.currentRank = this.rankS[_loc2_];
               this.addChild(this.currentRank);
               this.currentRank.x = 60;
               this.currentRank.y = 53;
               this.currentRank.alpha = 0.2;
               this.currentRank.scaleX = 1.8;
               this.currentRank.scaleY = 1.8;
               TweenLite.to(this.currentRank,0.3,{
                  "alpha":1,
                  "scaleX":1,
                  "scaleY":1
               });
               break;
            }
            if(this.currentRank && this.contains(this.currentRank))
            {
               this.removeChild(this.currentRank);
            }
            if(this.currentGlassFlake && this.contains(this.currentGlassFlake))
            {
               this.removeChild(this.currentGlassFlake);
            }
            _loc2_--;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         GameManager.Instance.hitsNum = 0;
         ObjectUtils.disposeObject(this.pics);
         this.pics = null;
         ObjectUtils.disposeObject(this.hitsbg);
         this.hitsbg = null;
         ObjectUtils.disposeObject(this.hits11);
         this.hits11 = null;
         ObjectUtils.disposeObject(this.currentGlassFlake);
         this.currentGlassFlake = null;
         ObjectUtils.disposeObject(this.glassFlake1);
         this.glassFlake1 = null;
         ObjectUtils.disposeObject(this.glassFlake2);
         this.glassFlake2 = null;
         ObjectUtils.disposeObject(this.currentRank);
         this.currentRank = null;
         if(this.rankS && this.rankS.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.rankS.length)
            {
               this.rankS[_loc1_] = null;
               _loc1_++;
            }
         }
         this.rankS = null;
         clearTimeout(this.setTimeoutId);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
