// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//farm.view.FarmCell

package farm.view
{
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.goods.InventoryItemInfo;
    import flash.display.BitmapData;
    import flash.events.MouseEvent;
    import ddt.manager.DragManager;
    import bagAndInfo.cell.DragEffect;
    import flash.ui.Mouse;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import com.pickgliss.utils.ObjectUtils;

    public class FarmCell extends BaseCell 
    {

        private var _bgbmp:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("asset.farm.cropIconBg");
        private var _manureNum:FilterFrameText;
        private var _invInfo:InventoryItemInfo;
        private var _continueDrag:Boolean;
        private var _contentData:BitmapData;

        public function FarmCell()
        {
            buttonMode = true;
            super(this._bgbmp);
            this._bgbmp.buttonMode = true;
            addEventListener(MouseEvent.MOUSE_OVER, this.__overFilter);
            addEventListener(MouseEvent.MOUSE_OUT, this.__outFilter);
        }

        protected function __outFilter(_arg_1:MouseEvent):void
        {
            filters = null;
        }

        protected function __overFilter(_arg_1:MouseEvent):void
        {
            filters = ComponentFactory.Instance.creatFilters("lightFilter");
        }

        override protected function createChildren():void
        {
            super.createChildren();
            this._manureNum = ComponentFactory.Instance.creatComponentByStylename("farm.seedSelect.cropNum");
        }

        override public function get itemInfo():InventoryItemInfo
        {
            return (this._invInfo);
        }

        public function set itemInfo(_arg_1:InventoryItemInfo):void
        {
            super.info = _arg_1;
            this._invInfo = _arg_1;
            if (_arg_1)
            {
                this._manureNum.text = _arg_1.Count.toString();
                addChild(this._manureNum);
            };
        }

        override public function dragStart():void
        {
            if ((((_info) && (stage)) && (_allowDrag)))
            {
                if (DragManager.startDrag(this, this._invInfo, this.createDragImg(), stage.mouseX, stage.mouseY, DragEffect.MOVE, false, false, false, false, false, null, 0, true))
                {
                    Mouse.hide();
                    locked = true;
                };
            };
        }

        override protected function createContentComplete():void
        {
            super.createContentComplete();
            if ((((_pic) && (_pic.width > 0)) && (_pic.height > 0)))
            {
                this._contentData = new BitmapData((_pic.width / _pic.scaleX), (_pic.height / _pic.scaleY), true, 0);
                this._contentData.draw(_pic);
            };
        }

        override public function dragStop(_arg_1:DragEffect):void
        {
            if ((_arg_1.target is FarmFieldBlock))
            {
                this.dragStart();
            };
            if ((!(DragManager.proxy)))
            {
                Mouse.show();
            };
        }

        override protected function createDragImg():DisplayObject
        {
            var _local_1:Bitmap;
            if ((((_pic) && (_pic.width > 0)) && (_pic.height > 0)))
            {
                _local_1 = new Bitmap(this._contentData.clone(), "auto", true);
                _local_1.width = 35;
                _local_1.height = 35;
                return (_local_1);
            };
            return (null);
        }

        override protected function updateSize(_arg_1:Sprite):void
        {
            if (_arg_1)
            {
                _arg_1.width = (_contentWidth - 20);
                _arg_1.height = (_contentHeight - 20);
                if (_picPos != null)
                {
                    _arg_1.x = _picPos.x;
                }
                else
                {
                    _arg_1.x = (Math.abs((_arg_1.width - _contentWidth)) / 2);
                };
                if (_picPos != null)
                {
                    _arg_1.y = _picPos.y;
                }
                else
                {
                    _arg_1.y = (Math.abs((_arg_1.height - _contentHeight)) / 2);
                };
            };
        }

        override protected function updateSizeII(_arg_1:Sprite):void
        {
            _arg_1.x = 13;
            _arg_1.y = 10;
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeObject(this._bgbmp);
            this._bgbmp = null;
            ObjectUtils.disposeObject(this._manureNum);
            this._manureNum = null;
            ObjectUtils.disposeObject(this._contentData);
            this._contentData = null;
            this._invInfo = null;
        }


    }
}//package farm.view

