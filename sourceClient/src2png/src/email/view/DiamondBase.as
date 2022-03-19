// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.view.DiamondBase

package email.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import email.data.EmailInfo;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import email.view.EmaillBagCell;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import bagAndInfo.cell.DragEffect;
    import com.pickgliss.utils.ObjectUtils;

    internal class DiamondBase extends Sprite implements Disposeable 
    {

        private static var CELL_HEIGHT:int = 58;
        private static var CELL_WIDTH:int = 58;

        protected var _info:EmailInfo;
        public var diamondBg:Scale9CornerImage;
        public var chargedImg:Bitmap;
        public var centerMC:ScaleFrameImage;
        public var countTxt:FilterFrameText;
        private var _index:int;
        public var _cell:EmaillBagCell;

        public function DiamondBase()
        {
            this.initView();
            this.addEvent();
        }

        protected function initView():void
        {
            this._cell = new EmaillBagCell();
            this._cell.width = CELL_WIDTH;
            this._cell.height = CELL_HEIGHT;
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("email.cellPos");
            this._cell.x = _local_1.x;
            this._cell.y = _local_1.y;
            this._cell.allowDrag = false;
            addChild(this._cell);
            mouseChildren = false;
            mouseEnabled = false;
            this.diamondBg = ComponentFactory.Instance.creatComponentByStylename("email.DiamondBg");
            addChildAt(this.diamondBg, 0);
            this.centerMC = ComponentFactory.Instance.creat("email.centerMC");
            addChild(this.centerMC);
            this.centerMC.setFrame(1);
            this.centerMC.visible = false;
            this.chargedImg = ComponentFactory.Instance.creatBitmap("asset.email.chargedImg");
            addChild(this.chargedImg);
            this.chargedImg.visible = false;
            this.countTxt = ComponentFactory.Instance.creat("email.diamondTxt");
            addChild(this.countTxt);
        }

        public function get index():int
        {
            return (this._index);
        }

        public function set index(_arg_1:int):void
        {
            if (this._index == _arg_1)
            {
                return;
            };
            this._index = _arg_1;
        }

        public function get info():EmailInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:EmailInfo):void
        {
            this._info = _arg_1;
            if (this._info)
            {
                this.update();
            }
            else
            {
                mouseEnabled = false;
                mouseChildren = false;
                this.centerMC.visible = false;
                this.chargedImg.visible = false;
                this.countTxt.text = "";
                this._cell.visible = false;
            };
        }

        public function forSendedCell():void
        {
            this.centerMC.setFrame(5);
            this.diamondBg.visible = false;
            this.chargedImg.visible = false;
            this.countTxt.visible = false;
        }

        public function dragDrop(_arg_1:DragEffect):void
        {
            this._cell.dragDrop(_arg_1);
        }

        protected function addEvent():void
        {
        }

        protected function removeEvent():void
        {
        }

        protected function update():void
        {
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this.diamondBg)
            {
                ObjectUtils.disposeObject(this.diamondBg);
            };
            this.diamondBg = null;
            if (this.chargedImg)
            {
                ObjectUtils.disposeObject(this.chargedImg);
            };
            this.chargedImg = null;
            if (this.centerMC)
            {
                ObjectUtils.disposeObject(this.centerMC);
            };
            this.centerMC = null;
            if (this.countTxt)
            {
                ObjectUtils.disposeObject(this.countTxt);
            };
            this.countTxt = null;
            if (this._cell)
            {
                ObjectUtils.disposeObject(this._cell);
            };
            this._cell = null;
            this._info = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package email.view

