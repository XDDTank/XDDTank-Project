package ddt.view.bossbox
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PetBlessAddNumView extends Sprite implements Disposeable
   {
       
      
      private var _numMC:MovieClip;
      
      private var _currentNum:Number;
      
      private var _orginNum:int;
      
      private var _dstNum:int;
      
      private var _diff:Number;
      
      private var _frame:int;
      
      public function PetBlessAddNumView()
      {
         super();
         this._numMC = ComponentFactory.Instance.creat("asset.bagAndInfo.petBless.rightNumber");
         addChild(this._numMC);
      }
      
      protected function __onEnterFrame(param1:Event) : void
      {
         this._currentNum += this._diff;
         if((this._currentNum - this._dstNum) * this._diff >= 0)
         {
            this._currentNum = this._dstNum;
            removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
            dispatchEvent(new Event(Event.COMPLETE));
         }
         this.setNum(this._numMC,this._currentNum);
      }
      
      private function setNum(param1:MovieClip, param2:int) : void
      {
         var _loc3_:int = param2 / 100;
         var _loc4_:int = param2 % 100 / 10;
         var _loc5_:int = param2 % 10;
         param1.num_1.gotoAndStop(_loc3_ + 1);
         param1.num_1.visible = _loc3_ > 0;
         param1.num_2.gotoAndStop(_loc4_ + 1);
         param1.num_2.visible = _loc4_ > 0;
         param1.num_3.gotoAndStop(_loc5_ + 1);
      }
      
      public function TweenTo(param1:int, param2:int, param3:Number) : void
      {
         var origin:int = param1;
         var dst:int = param2;
         var frame:Number = param3;
         this._orginNum = this._currentNum = origin;
         this._dstNum = dst;
         this._frame = frame;
         this._diff = (this._dstNum - this._orginNum) / this._frame;
         this._currentNum = origin;
         this.setNum(this._numMC,this._orginNum);
         alpha = 0;
         TweenLite.to(this,0.2,{
            "alpha":1,
            "onComplete":function():void
            {
               addEventListener(Event.ENTER_FRAME,__onEnterFrame);
            }
         });
      }
      
      public function get currentNum() : Number
      {
         return this._currentNum;
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         ObjectUtils.disposeObject(this._numMC);
         this._numMC = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
