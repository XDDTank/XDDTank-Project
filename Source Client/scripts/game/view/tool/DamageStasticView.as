package game.view.tool
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class DamageStasticView extends Sprite implements Disposeable
   {
       
      
      private var _resultList:Vector.<DamageStrip>;
      
      private var _infoList:Array;
      
      private var _delay:int;
      
      private var _isShowed:Boolean;
      
      private var _currentIndex:int;
      
      public function DamageStasticView()
      {
         super();
         this._resultList = new Vector.<DamageStrip>();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function setInfoList(param1:Array) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:DamageStrip = null;
         this.reset();
         this._infoList = param1;
         if(this._infoList.length == 0)
         {
            return;
         }
         this._isShowed = false;
         _loc4_ = 0;
         while(_loc4_ < this._infoList.length)
         {
            _loc5_ = new DamageStrip();
            _loc5_.y = this._resultList.length * _loc5_.height;
            _loc5_.info = this._infoList[_loc4_];
            this._resultList.push(_loc5_);
            if(this._resultList[_loc3_].width < _loc5_.width)
            {
               _loc3_ = _loc4_;
            }
            _loc4_++;
         }
         _loc2_ = this._resultList[_loc3_].width;
         _loc4_ = 0;
         while(_loc4_ < this._infoList.length)
         {
            this._resultList[_loc4_].width = _loc2_;
            _loc4_++;
         }
         this._currentIndex = 0;
      }
      
      public function start() : void
      {
         if(this._isShowed)
         {
            return;
         }
         this._isShowed = true;
         if(this._infoList && this._infoList.length > 0)
         {
            addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         }
      }
      
      protected function __onEnterFrame(param1:Event) : void
      {
         if(this._delay <= 0)
         {
            if(this._currentIndex < this._resultList.length)
            {
               this._resultList[this._currentIndex].show();
               addChild(this._resultList[this._currentIndex]);
               if(this._currentIndex < this._resultList.length - 1)
               {
                  this._delay = 10;
               }
               else
               {
                  this._delay = 50;
               }
               ++this._currentIndex;
            }
            else
            {
               removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
               TweenLite.to(this,0.2,{
                  "alpha":0,
                  "onComplete":this.reset
               });
            }
         }
         --this._delay;
      }
      
      public function reset() : void
      {
         TweenLite.killTweensOf(this);
         while(this._resultList.length > 0)
         {
            this._resultList.shift().dispose();
         }
         this._resultList.length = 0;
         this._delay = 0;
         alpha = 1;
      }
      
      public function dispose() : void
      {
         this.reset();
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         this._resultList = null;
         this._infoList = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
