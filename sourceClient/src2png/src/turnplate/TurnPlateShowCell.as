// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//turnplate.TurnPlateShowCell

package turnplate
{
    import bagAndInfo.cell.BaseCell;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.greensock.TweenMax;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.utils.PositionUtils;

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

        public function TurnPlateShowCell(_arg_1:DisplayObject, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true, _arg_4:Boolean=true)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            this.initView();
        }

        private function initView():void
        {
            this._choosenBmp = ComponentFactory.Instance.creatBitmap("asset.turnplate.randomChoose");
            this._itemDisable = ComponentFactory.Instance.creatBitmap("asset.turnplate.itemDisable");
            this._specialGoods = ComponentFactory.Instance.creatBitmap("asset.turnplate.specialGoods");
            addChildAt(this._specialGoods, 2);
            addChildAt(this._choosenBmp, 3);
            addChildAt(this._itemDisable, 4);
            this._choosenBmp.visible = false;
            this._itemDisable.visible = false;
            this._specialGoods.visible = false;
        }

        public function showSpecial():void
        {
            this._specialGoods.visible = true;
        }

        public function choosenAnima():void
        {
            this.killTween();
            this._choosenBmp.visible = true;
            this._choosenBmp.alpha = 0;
            TweenMax.to(this._choosenBmp, 0.2, {
                "autoAlpha":1,
                "onComplete":this.choosenDisappear
            });
        }

        private function choosenDisappear():void
        {
            TweenMax.to(this._choosenBmp, 0.3, {
                "autoAlpha":0,
                "onComplete":this.killTween
            });
        }

        public function shine(_arg_1:int=3):void
        {
            this._choosenBmp.visible = true;
            this._choosenBmp.alpha = 1;
            TweenMax.to(this._choosenBmp, 0.3, {
                "autoAlpha":0,
                "yoyo":true,
                "repeat":_arg_1,
                "onComplete":this.shineComplete
            });
        }

        private function shineComplete():void
        {
            this.killTween();
            dispatchEvent(new Event(SELECT_SHINE_COMPLETE));
        }

        public function showEquipShine():void
        {
            this._specialGoods.visible = false;
            if (this._cellShine)
            {
                ObjectUtils.disposeObject(this._cellShine);
                this._cellShine = null;
            };
            this._cellShine = ComponentFactory.Instance.creat("asset.turnplate.cellShine");
            PositionUtils.setPos(this._cellShine, "turnPlate.cellShine.Pos");
            this._cellShine.addEventListener(Event.COMPLETE, this.__equipShineComplete);
            addChildAt(this._cellShine, 5);
            this._cellShineTop = ComponentFactory.Instance.creat("asset.turnplate.cellShineTop");
            PositionUtils.setPos(this._cellShineTop, "turnPlate.cellShine.Pos");
            addChildAt(this._cellShineTop, (getChildIndex(getContent()) + 1));
        }

        private function __equipShineComplete(_arg_1:Event):void
        {
            this._cellShine.removeEventListener(Event.COMPLETE, this.__equipShineComplete);
            removeChild(this._cellShine);
            this._cellShine = null;
            removeChild(this._cellShineTop);
            this._cellShineTop = null;
            dispatchEvent(new Event(EQUIP_SHINE_COMPLETE));
        }

        private function killTween():void
        {
            TweenMax.killTweensOf(this._choosenBmp);
        }

        public function set enable(_arg_1:Boolean):void
        {
            if (this._enable == _arg_1)
            {
                return;
            };
            this._enable = _arg_1;
            if (this._enable)
            {
                this._itemDisable.visible = false;
            }
            else
            {
                this._itemDisable.visible = true;
            };
        }

        public function get enable():Boolean
        {
            return (this._enable);
        }

        override public function dispose():void
        {
            this.killTween();
            ObjectUtils.disposeObject(this._choosenBmp);
            this._choosenBmp = null;
            ObjectUtils.disposeObject(this._itemDisable);
            this._itemDisable = null;
            if (this._cellShine)
            {
                this._cellShine.removeEventListener(Event.COMPLETE, this.__equipShineComplete);
                ObjectUtils.disposeObject(this._cellShine);
                this._cellShine = null;
            };
            ObjectUtils.disposeObject(this._cellShineTop);
            this._cellShineTop = null;
            super.dispose();
        }

        public function get index():uint
        {
            return (this._index);
        }

        public function set index(_arg_1:uint):void
        {
            this._index = _arg_1;
        }


    }
}//package turnplate

