// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.KeySetItem

package bagAndInfo.bag
{
    import ddt.interfaces.IAcceptDrag;
    import com.pickgliss.ui.core.ITipedDisplay;
    import flash.display.Bitmap;
    import flash.filters.ColorMatrixFilter;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ShowTipManager;
    import flash.display.DisplayObject;
    import ddt.manager.DragManager;
    import bagAndInfo.cell.DragEffect;
    import ddt.data.PropInfo;
    import ddt.manager.ItemManager;
    import ddt.view.tips.ToolPropInfo;

    public class KeySetItem extends ItemCellView implements IAcceptDrag, ITipedDisplay 
    {

        private const CONST1:int = 40;
        private const CONST2:int = 35;

        private var _propIndex:int;
        private var _propID:int;
        private var _isGlow:Boolean = false;
        private var glow_mc:Bitmap;
        private var lightingFilter:ColorMatrixFilter;

        public function KeySetItem(_arg_1:uint=0, _arg_2:int=0, _arg_3:int=0, _arg_4:DisplayObject=null, _arg_5:Boolean=false)
        {
            super(_arg_1, _arg_4, _arg_5);
            this._propIndex = _arg_2;
            this._propID = _arg_3;
            this.glow_mc = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.keySetGlowAsset");
            addChild(this.glow_mc);
            this.glow_mc.visible = false;
            addEventListener(MouseEvent.ROLL_OVER, this.__over);
            addEventListener(MouseEvent.ROLL_OUT, this.__out);
            ShowTipManager.Instance.addTip(this);
        }

        override protected function initItemBg():void
        {
            _asset = ComponentFactory.Instance.creatBitmap("asset.bagAndInfo.quickKeyItemBg");
            _asset.width = (_asset.height = this.CONST1);
        }

        override protected function setItemWidthAndHeight():void
        {
            _item.width = (_item.height = this.CONST2);
            _item.x = 2;
            _item.y = 3;
        }

        public function dragDrop(_arg_1:DragEffect):void
        {
            DragManager.acceptDrag(this, DragEffect.NONE);
        }

        private function __over(_arg_1:MouseEvent):void
        {
            filters = ComponentFactory.Instance.creatFilters("lightFilter");
        }

        private function __out(_arg_1:MouseEvent):void
        {
            filters = null;
        }

        public function set glow(_arg_1:Boolean):void
        {
            this._isGlow = _arg_1;
            this.glow_mc.visible = this._isGlow;
        }

        public function get glow():Boolean
        {
            return (this._isGlow);
        }

        public function set propID(_arg_1:int):void
        {
            this._propID = _arg_1;
        }

        public function get tipData():Object
        {
            var _local_1:PropInfo = new PropInfo(ItemManager.Instance.getTemplateById(this._propID));
            var _local_2:ToolPropInfo = new ToolPropInfo();
            _local_2.showThew = true;
            _local_2.info = _local_1.Template;
            if (this._propIndex)
            {
                _local_2.shortcutKey = this._propIndex.toString();
            };
            return (_local_2);
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function set tipData(_arg_1:Object):void
        {
        }

        public function get tipDirctions():String
        {
            return ("5,2,7,1,6,4");
        }

        public function set tipDirctions(_arg_1:String):void
        {
        }

        public function get tipGapH():int
        {
            return (-15);
        }

        public function set tipGapH(_arg_1:int):void
        {
        }

        public function get tipGapV():int
        {
            return (5);
        }

        public function set tipGapV(_arg_1:int):void
        {
        }

        public function get tipStyle():String
        {
            return ("core.ToolPropTips");
        }

        public function set tipStyle(_arg_1:String):void
        {
        }

        override public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            removeEventListener(MouseEvent.ROLL_OVER, this.__over);
            removeEventListener(MouseEvent.ROLL_OUT, this.__out);
            if (((this.glow_mc) && (this.glow_mc.parent)))
            {
                this.glow_mc.parent.removeChild(this.glow_mc);
            };
            this.glow_mc = null;
            this.lightingFilter = null;
            filters = null;
            super.dispose();
        }


    }
}//package bagAndInfo.bag

