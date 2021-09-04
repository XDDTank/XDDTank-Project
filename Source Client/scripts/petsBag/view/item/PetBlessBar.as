package petsBag.view.item
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class PetBlessBar extends PetBaseBar
   {
       
      
      private var _blessShine:MovieClip;
      
      public function PetBlessBar()
      {
         super();
         tipStyle = "petsBag.view.tip.PetBlessTip";
         tipDirctions = "0";
      }
      
      override public function set value(param1:Number) : void
      {
         super.value = param1;
      }
      
      public function shine() : void
      {
         if(!this._blessShine)
         {
            this._blessShine = ComponentFactory.Instance.creat("asset.petsBag.petAdvanceFrame.blessShine");
            this._blessShine.y = _maxBar.y + _maxBar.height / 2;
            this._blessShine.addEventListener(Event.COMPLETE,this.__onComplete);
         }
         addChildAt(this._blessShine,numChildren - 2);
         this._blessShine.gotoAndPlay(1);
         TweenLite.killTweensOf(this._blessShine);
         if(value == 0)
         {
            this.__onComplete(null);
            this._blessShine.x = _maxBar.x;
         }
         else
         {
            this._blessShine.x = _maxBar.x + _maxMask.width - _maxBar.width / 100;
            TweenLite.to(this._blessShine,0.5,{"x":_maxBar.x + _maxMask.width});
         }
      }
      
      protected function __onComplete(param1:Event) : void
      {
         this._blessShine.stop();
         if(this._blessShine.parent)
         {
            this._blessShine.parent.removeChild(this._blessShine);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._blessShine)
         {
            this._blessShine.removeEventListener(Event.COMPLETE,this.__onComplete);
         }
         ObjectUtils.disposeObject(this._blessShine);
         this._blessShine = null;
      }
   }
}
