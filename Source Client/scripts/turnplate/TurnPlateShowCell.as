package turnplate
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class TurnPlateShowCell extends BaseCell
   {
      
      public static const SELECT_SHINE_COMPLETE:String = "selectShineComplete";
      
      public static const EQUIP_SHINE_COMPLETE:String = "itemShineComplete";
       
      
      private var _choosenBmp:Bitmap;
      
      private var _itemDisable:Bitmap;
      
      private var _cellShine:MovieClip;
      
      private var _cellShineTop:MovieClip;
      
      private var _enable:Boolean = true;
      
      private var _index:uint;
      
      private var _specialGoods:Bitmap;
      
      public function TurnPlateShowCell(param1:DisplayObject, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:Boolean = true)
      {
         super(param1,param2,param3,param4);
         this.initView();
      }
      
      private function initView() : void
      {
         this._choosenBmp = ComponentFactory.Instance.creatBitmap("asset.turnplate.randomChoose");
         this._itemDisable = ComponentFactory.Instance.creatBitmap("asset.turnplate.itemDisable");
         this._specialGoods = ComponentFactory.Instance.creatBitmap("asset.turnplate.specialGoods");
         addChildAt(this._specialGoods,2);
         addChildAt(this._choosenBmp,3);
         addChildAt(this._itemDisable,4);
         this._choosenBmp.visible = false;
         this._itemDisable.visible = false;
         this._specialGoods.visible = false;
      }
      
      public function showSpecial() : void
      {
         this._specialGoods.visible = true;
      }
      
      public function choosenAnima() : void
      {
         this.killTween();
         this._choosenBmp.visible = true;
         this._choosenBmp.alpha = 0;
         TweenMax.to(this._choosenBmp,0.2,{
            "autoAlpha":1,
            "onComplete":this.choosenDisappear
         });
      }
      
      private function choosenDisappear() : void
      {
         TweenMax.to(this._choosenBmp,0.3,{
            "autoAlpha":0,
            "onComplete":this.killTween
         });
      }
      
      public function shine(param1:int = 3) : void
      {
         this._choosenBmp.visible = true;
         this._choosenBmp.alpha = 1;
         TweenMax.to(this._choosenBmp,0.3,{
            "autoAlpha":0,
            "yoyo":true,
            "repeat":param1,
            "onComplete":this.shineComplete
         });
      }
      
      private function shineComplete() : void
      {
         this.killTween();
         dispatchEvent(new Event(SELECT_SHINE_COMPLETE));
      }
      
      public function showEquipShine() : void
      {
         this._specialGoods.visible = false;
         if(this._cellShine)
         {
            ObjectUtils.disposeObject(this._cellShine);
            this._cellShine = null;
         }
         this._cellShine = ComponentFactory.Instance.creat("asset.turnplate.cellShine");
         PositionUtils.setPos(this._cellShine,"turnPlate.cellShine.Pos");
         this._cellShine.addEventListener(Event.COMPLETE,this.__equipShineComplete);
         addChildAt(this._cellShine,5);
         this._cellShineTop = ComponentFactory.Instance.creat("asset.turnplate.cellShineTop");
         PositionUtils.setPos(this._cellShineTop,"turnPlate.cellShine.Pos");
         addChildAt(this._cellShineTop,getChildIndex(getContent()) + 1);
      }
      
      private function __equipShineComplete(param1:Event) : void
      {
         this._cellShine.removeEventListener(Event.COMPLETE,this.__equipShineComplete);
         removeChild(this._cellShine);
         this._cellShine = null;
         removeChild(this._cellShineTop);
         this._cellShineTop = null;
         dispatchEvent(new Event(EQUIP_SHINE_COMPLETE));
      }
      
      private function killTween() : void
      {
         TweenMax.killTweensOf(this._choosenBmp);
      }
      
      public function set enable(param1:Boolean) : void
      {
         if(this._enable == param1)
         {
            return;
         }
         this._enable = param1;
         if(this._enable)
         {
            this._itemDisable.visible = false;
         }
         else
         {
            this._itemDisable.visible = true;
         }
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      override public function dispose() : void
      {
         this.killTween();
         ObjectUtils.disposeObject(this._choosenBmp);
         this._choosenBmp = null;
         ObjectUtils.disposeObject(this._itemDisable);
         this._itemDisable = null;
         if(this._cellShine)
         {
            this._cellShine.removeEventListener(Event.COMPLETE,this.__equipShineComplete);
            ObjectUtils.disposeObject(this._cellShine);
            this._cellShine = null;
         }
         ObjectUtils.disposeObject(this._cellShineTop);
         this._cellShineTop = null;
         super.dispose();
      }
      
      public function get index() : uint
      {
         return this._index;
      }
      
      public function set index(param1:uint) : void
      {
         this._index = param1;
      }
   }
}
