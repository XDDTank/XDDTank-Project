// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//socialContact.copyBitmap.CopyBitmapFrame

package socialContact.copyBitmap
{
    import flash.display.Sprite;
    import __AS3__.vec.Vector;
    import flash.display.Shape;
    import com.pickgliss.ui.controls.BaseButton;
    import flash.geom.Point;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.image.DrawImage;
    import __AS3__.vec.*;

    public class CopyBitmapFrame extends Sprite 
    {

        private var _pointViewArr:Vector.<Sprite>;
        private var _areaView:Sprite;
        private var _bgView:Shape;
        private var _mode:CopyBitmapMode;
        private var _nowPonitView:Sprite;
        private var _copyOkBt:BaseButton;
        private var _copyCancelBt:BaseButton;
        private var _oldPoint:Point;

        public function CopyBitmapFrame(_arg_1:CopyBitmapMode)
        {
            this._mode = _arg_1;
            this._init();
            this._addStartEvt();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, false, LayerManager.NONE_BLOCKGOUND);
        }

        private function _init():void
        {
            this._pointViewArr = new Vector.<Sprite>();
            var _local_1:int;
            while (_local_1 < 8)
            {
                this._pointViewArr[_local_1] = this._buildPointView();
                this._pointViewArr[_local_1].buttonMode = true;
                _local_1++;
            };
            this._bgView = new Shape();
            this._areaView = new Sprite();
            this._areaView.buttonMode = true;
            this._copyOkBt = ComponentFactory.Instance.creatComponentByStylename("CopyBitmap.copyOkBt");
            this._copyCancelBt = ComponentFactory.Instance.creatComponentByStylename("CopyBitmap.copyCanceBt");
            this._upDataView(new Event("*"));
        }

        private function _buildPointView():Sprite
        {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0xFF00FF);
            _local_1.graphics.drawRect(-5, -5, 10, 10);
            return (_local_1);
        }

        private function _addStartEvt():void
        {
            this._mode.addEventListener(CopyBitmapMode.CHANGE_MODE, this._upDataView);
        }

        private function _stageStartDown(_arg_1:MouseEvent):void
        {
            this._mode.startX = (this._mode.endX = StageReferance.stage.mouseX);
            this._mode.startY = (this._mode.endY = StageReferance.stage.mouseY);
            this._mode.ponitID = 3;
            this._nowPonitView = this._pointViewArr[3];
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this._stageStartDown);
            this.addEventListener(Event.ENTER_FRAME, this._thisInFrame);
        }

        private function _stageStartUp(_arg_1:MouseEvent):void
        {
            this.removeEventListener(Event.ENTER_FRAME, this._thisInFrame);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this._stageStartUp);
            this._addEvt();
        }

        private function _addEvt():void
        {
            var _local_1:int;
            while (_local_1 < 8)
            {
                this._pointViewArr[_local_1].addEventListener(MouseEvent.MOUSE_DOWN, this._pointViewDown);
                _local_1++;
            };
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP, this._stageUp);
            this._copyCancelBt.addEventListener(MouseEvent.CLICK, this._clickCancelBt);
            this._copyOkBt.addEventListener(MouseEvent.CLICK, this._clickOkBt);
            this._areaView.addEventListener(MouseEvent.MOUSE_DOWN, this._areaViewDown);
            this._areaView.addEventListener(MouseEvent.MOUSE_UP, this._areaViewUp);
        }

        private function _areaViewDown(_arg_1:MouseEvent):void
        {
            this._oldPoint = new Point();
            this._oldPoint.x = StageReferance.stage.mouseX;
            this._oldPoint.y = StageReferance.stage.mouseY;
            this._areaView.addEventListener(Event.ENTER_FRAME, this._areaViewMove);
        }

        private function _areaViewUp(_arg_1:MouseEvent):void
        {
            this._areaView.removeEventListener(Event.ENTER_FRAME, this._areaViewMove);
        }

        private function _areaViewMove(_arg_1:Event):void
        {
            this._mode.startX = (this._mode.startX + (StageReferance.stage.mouseX - this._oldPoint.x));
            this._mode.endX = (this._mode.endX + (StageReferance.stage.mouseX - this._oldPoint.x));
            this._mode.startY = (this._mode.startY + (StageReferance.stage.mouseY - this._oldPoint.y));
            this._mode.endY = (this._mode.endY + (StageReferance.stage.mouseY - this._oldPoint.y));
            this._oldPoint.x = StageReferance.stage.mouseX;
            this._oldPoint.y = StageReferance.stage.mouseY;
        }

        private function _pointViewDown(_arg_1:MouseEvent):void
        {
            this._mode.ponitID = this._pointViewArr.indexOf(_arg_1.currentTarget);
            this._nowPonitView = Sprite(_arg_1.currentTarget);
            switch (this._mode.ponitID)
            {
                case 0:
                    this._nowPonitView.startDrag(false, new Rectangle(this._nowPonitView.x, 0, 1, StageReferance.stage.height));
                    break;
                case 1:
                    this._nowPonitView.startDrag(false, new Rectangle(0, 0, StageReferance.stage.width, StageReferance.stage.height));
                    break;
                case 2:
                    this._nowPonitView.startDrag(false, new Rectangle(0, this._nowPonitView.y, StageReferance.stage.width, 1));
                    break;
                case 3:
                    this._nowPonitView.startDrag(false, new Rectangle(0, 0, StageReferance.stage.width, StageReferance.stage.height));
                    break;
                case 4:
                    this._nowPonitView.startDrag(false, new Rectangle(this._nowPonitView.x, 0, 1, StageReferance.stage.height));
                    break;
                case 5:
                    this._nowPonitView.startDrag(false, new Rectangle(0, 0, StageReferance.stage.width, StageReferance.stage.height));
                    break;
                case 6:
                    this._nowPonitView.startDrag(false, new Rectangle(0, this._nowPonitView.y, StageReferance.stage.width, 1));
                    break;
                case 7:
                    this._nowPonitView.startDrag(false, new Rectangle(0, 0, StageReferance.stage.width, StageReferance.stage.height));
                    break;
            };
            this.addEventListener(Event.ENTER_FRAME, this._thisInFrame);
        }

        private function _thisInFrame(_arg_1:Event):void
        {
            switch (this._mode.ponitID)
            {
                case 0:
                    this._mode.startY = StageReferance.stage.mouseY;
                    return;
                case 1:
                    this._mode.endX = StageReferance.stage.mouseX;
                    this._mode.startY = StageReferance.stage.mouseY;
                    return;
                case 2:
                    this._mode.endX = StageReferance.stage.mouseX;
                    return;
                case 3:
                    this._mode.endX = StageReferance.stage.mouseX;
                    this._mode.endY = StageReferance.stage.mouseY;
                    return;
                case 4:
                    this._mode.endY = StageReferance.stage.mouseY;
                    return;
                case 5:
                    this._mode.startX = StageReferance.stage.mouseX;
                    this._mode.endY = StageReferance.stage.mouseY;
                    return;
                case 6:
                    this._mode.startX = StageReferance.stage.mouseX;
                    return;
                case 7:
                    this._mode.startX = StageReferance.stage.mouseX;
                    this._mode.startY = StageReferance.stage.mouseY;
                    return;
            };
        }

        private function _stageUp(_arg_1:MouseEvent):void
        {
            this.removeEventListener(Event.ENTER_FRAME, this._thisInFrame);
            if (this._nowPonitView)
            {
                this._nowPonitView.stopDrag();
            };
        }

        private function _upDataView(_arg_1:Event):void
        {
            this._bgView.graphics.clear();
            this._bgView.graphics.beginFill(0, 0.5);
            this._bgView.graphics.drawRect(0, 0, this._mode.startX, StageReferance.stage.height);
            this._bgView.graphics.drawRect(this._mode.startX, 0, (this._mode.endX - this._mode.startX), this._mode.startY);
            this._bgView.graphics.drawRect(this._mode.startX, this._mode.endY, (this._mode.endX - this._mode.startX), (StageReferance.stage.height - this._mode.endY));
            this._bgView.graphics.drawRect(this._mode.endX, 0, (StageReferance.stage.width - this._mode.endX), StageReferance.stage.height);
            addChild(this._bgView);
            this._areaView.graphics.clear();
            this._areaView.graphics.beginFill(0xFFFF, 1);
            this._areaView.graphics.drawRect(this._mode.startX, this._mode.startY, (this._mode.endX - this._mode.startX), (this._mode.endY - this._mode.startY));
            this._areaView.alpha = 0;
            addChild(this._areaView);
            this._pointViewArr[0].x = ((this._mode.startX + this._mode.endX) / 2);
            this._pointViewArr[0].y = this._mode.startY;
            addChild(this._pointViewArr[0]);
            this._pointViewArr[1].x = this._mode.endX;
            this._pointViewArr[1].y = this._mode.startY;
            addChild(this._pointViewArr[1]);
            this._pointViewArr[2].x = this._mode.endX;
            this._pointViewArr[2].y = ((this._mode.startY + this._mode.endY) / 2);
            addChild(this._pointViewArr[2]);
            this._pointViewArr[3].x = this._mode.endX;
            this._pointViewArr[3].y = this._mode.endY;
            addChild(this._pointViewArr[3]);
            this._pointViewArr[4].x = ((this._mode.startX + this._mode.endX) / 2);
            this._pointViewArr[4].y = this._mode.endY;
            addChild(this._pointViewArr[4]);
            this._pointViewArr[5].x = this._mode.startX;
            this._pointViewArr[5].y = this._mode.endY;
            addChild(this._pointViewArr[5]);
            this._pointViewArr[6].x = this._mode.startX;
            this._pointViewArr[6].y = ((this._mode.startY + this._mode.endY) / 2);
            addChild(this._pointViewArr[6]);
            this._pointViewArr[7].x = this._mode.startX;
            this._pointViewArr[7].y = this._mode.startY;
            addChild(this._pointViewArr[7]);
            this._copyCancelBt.x = (((this._mode.endX - this._copyCancelBt.width) > (this._mode.startX - this._copyCancelBt.width)) ? (this._mode.endX - this._copyCancelBt.width) : (this._mode.startX - this._copyCancelBt.width));
            this._copyCancelBt.y = (((this._mode.endY + (this._copyCancelBt.height / 2)) > (this._mode.startY + (this._copyCancelBt.height / 2))) ? (this._mode.endY + (this._copyCancelBt.height / 2)) : (this._mode.startY + (this._copyCancelBt.height / 2)));
            addChild(this._copyCancelBt);
            this._copyOkBt.x = (this._copyCancelBt.x - this._copyOkBt.width);
            this._copyOkBt.y = this._copyCancelBt.y;
            addChild(this._copyOkBt);
        }

        private function _clickCancelBt(_arg_1:MouseEvent):void
        {
            CopyBitmapManager.Instance.close();
        }

        private function _clickOkBt(_arg_1:MouseEvent):void
        {
            this.visible = false;
            CopyBitmapManager.Instance.saveBmp();
        }

        public function dispose():void
        {
            if (this._areaView)
            {
                removeChild(this._areaView);
            };
            this._areaView = null;
            if (this._bgView)
            {
                removeChild(this._bgView);
            };
            this._bgView = null;
            this._nowPonitView = null;
            var _local_1:int;
            while (_local_1 < this._pointViewArr.length)
            {
                if (this._pointViewArr[_local_1] != null)
                {
                    removeChild(this._pointViewArr[_local_1]);
                };
                this._pointViewArr[_local_1] = null;
                _local_1++;
            };
            this._pointViewArr = null;
            if (this._copyOkBt)
            {
                ObjectUtils.disposeObject(this._copyOkBt);
            };
            this._copyOkBt = null;
            if (this._copyCancelBt)
            {
                ObjectUtils.disposeObject(this._copyCancelBt);
            };
            this._copyCancelBt = null;
        }

        private function kelisTest():void
        {
            var kelis:DrawImage;
            var clickKelis:Function;
            clickKelis = function (_arg_1:MouseEvent):void
            {
                kelis.ellipseWidth = (kelis.ellipseWidth + 10);
            };
            kelis = ComponentFactory.Instance.creat("kelisImage");
            addChild(kelis);
            kelis.addEventListener(MouseEvent.CLICK, clickKelis);
        }


    }
}//package socialContact.copyBitmap

