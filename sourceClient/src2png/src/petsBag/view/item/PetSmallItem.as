// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetSmallItem

package petsBag.view.item
{
    import ddt.interfaces.IAcceptDrag;
    import flash.display.DisplayObject;
    import flash.display.Bitmap;
    import ddt.display.BitmapLoaderProxy;
    import pet.date.PetInfo;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.PathManager;
    import ddt.manager.PetBagManager;
    import com.pickgliss.ui.ComponentFactory;
    import petsBag.event.UpdatePetInfoEvent;
    import ddt.events.CellEvent;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import petsBag.event.PetItemEvent;
    import flash.events.Event;
    import flash.display.BitmapData;
    import com.pickgliss.ui.ShowTipManager;
    import bagAndInfo.cell.DragEffect;

    public class PetSmallItem extends PetBaseItem implements IAcceptDrag 
    {

        protected var _bg:DisplayObject;
        protected var _stateFlag:Bitmap;
        protected var _petIcon:BitmapLoaderProxy;
        private var _cellMouseOverBg:Bitmap;
        private var _cellMouseOverFormer:Bitmap;
        private var _mouseMoveEffect:Boolean;
        private var _dragImg:Bitmap;

        public function PetSmallItem(_arg_1:DisplayObject=null, _arg_2:PetInfo=null, _arg_3:Boolean=false, _arg_4:Boolean=false, _arg_5:Boolean=false)
        {
            _info = _arg_2;
            this._bg = _arg_1;
            canDrag = _arg_3;
            this._mouseMoveEffect = _arg_4;
            _showState = _arg_5;
            super();
            tipDirctions = "6,7,4,5";
            tipStyle = "ddt.view.tips.PetInfoTip";
        }

        public function get mouseMoveEffect():Boolean
        {
            return (this._mouseMoveEffect);
        }

        public function set mouseMoveEffect(_arg_1:Boolean):void
        {
            this._mouseMoveEffect = _arg_1;
        }

        override public function set info(_arg_1:PetInfo):void
        {
            super.info = _arg_1;
            tipData = _info;
            ObjectUtils.disposeObject(this._stateFlag);
            this._stateFlag = null;
            if (_info)
            {
                if ((((!(_info)) || (!(_lastInfo))) || (!(_info.TemplateID == _lastInfo.TemplateID))))
                {
                    if (this._petIcon)
                    {
                        this._petIcon.removeEventListener(BitmapLoaderProxy.LOADING_FINISH, this.__fixPetIconPostion);
                    };
                    ObjectUtils.disposeObject(this._petIcon);
                    this._petIcon = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagManager.instance().getPicStr(_info)), null, true);
                    this._petIcon.addEventListener(BitmapLoaderProxy.LOADING_FINISH, this.__fixPetIconPostion);
                    addChildAt(this._petIcon, 2);
                };
                if (_showState)
                {
                    if (_info.IsEquip)
                    {
                        this._stateFlag = ComponentFactory.Instance.creatBitmap("asset.petsBag.petListView.fightFlag");
                    }
                    else
                    {
                        if (_info.IsActive)
                        {
                            this._stateFlag = ComponentFactory.Instance.creatBitmap("asset.petsBag.petListView.activeFlag");
                        };
                    };
                    if (this._stateFlag)
                    {
                        addChild(this._stateFlag);
                    };
                };
            }
            else
            {
                if (this._petIcon)
                {
                    this._petIcon.removeEventListener(BitmapLoaderProxy.LOADING_FINISH, this.__fixPetIconPostion);
                };
                ObjectUtils.disposeObject(this._petIcon);
                this._petIcon = null;
            };
            dispatchEvent(new UpdatePetInfoEvent(UpdatePetInfoEvent.UPDATE, _info));
        }

        override public function get width():Number
        {
            return (this._bg.width);
        }

        override public function get height():Number
        {
            return (this._bg.height);
        }

        override public function set locked(_arg_1:Boolean):void
        {
            super.locked = _arg_1;
            this.updateLockState();
            dispatchEvent(new CellEvent(CellEvent.LOCK_CHANGED));
        }

        override protected function initView():void
        {
            this._bg = ((this._bg) ? this._bg : this.getDefaultBack());
            this._cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
            this._cellMouseOverBg.visible = false;
            addChild(this._cellMouseOverBg);
            if (_info)
            {
                this._petIcon = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagManager.instance().getPicStr(_info)), null, true);
                this._petIcon.addEventListener(BitmapLoaderProxy.LOADING_FINISH, this.__fixPetIconPostion);
                addChild(this._petIcon);
            };
            this._cellMouseOverFormer = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverShareBG");
            this._cellMouseOverFormer.visible = false;
            addChild(this._cellMouseOverFormer);
        }

        private function getDefaultBack():DisplayObject
        {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0, 0);
            _local_1.graphics.drawRect(0, 0, 46, 46);
            _local_1.graphics.endFill();
            return (_local_1);
        }

        override protected function initEvent():void
        {
            super.initEvent();
            addEventListener(MouseEvent.ROLL_OVER, this.__rollOverHandler);
            addEventListener(MouseEvent.ROLL_OUT, this.__rollOutHandler);
            addEventListener(PetItemEvent.MOUSE_DOWN, this.__mouseDown);
            addEventListener(PetItemEvent.ITEM_CLICK, this.__itemClick);
            addEventListener(PetItemEvent.DOUBLE_CLICK, this.__doubleClick);
        }

        protected function __mouseDown(_arg_1:Event):void
        {
            if (((locked) || (!(canDrag))))
            {
                _arg_1.stopImmediatePropagation();
            };
        }

        protected function __itemClick(_arg_1:Event):void
        {
            if (((locked) || (!(canDrag))))
            {
                _arg_1.stopImmediatePropagation();
            };
        }

        protected function __doubleClick(_arg_1:Event):void
        {
            if (((locked) || (!(canDrag))))
            {
                _arg_1.stopImmediatePropagation();
            };
        }

        private function __fixPetIconPostion(_arg_1:Event):void
        {
            var _local_2:Number;
            _arg_1.stopImmediatePropagation();
            if (this._petIcon)
            {
                _local_2 = Math.min(((this._bg.width * 0.75) / this._petIcon.width), ((this._bg.height * 0.75) / this._petIcon.height));
                this._petIcon.scaleX = _local_2;
                this._petIcon.scaleY = _local_2;
                this._petIcon.x = ((this._bg.width - this._petIcon.width) >> 1);
                this._petIcon.y = ((this._bg.height - this._petIcon.height) >> 1);
            };
        }

        private function __rollOverHandler(_arg_1:MouseEvent):void
        {
            if (((this._mouseMoveEffect) && (this._cellMouseOverBg)))
            {
                this.updateBgVisible(true);
            };
        }

        private function __rollOutHandler(_arg_1:MouseEvent):void
        {
            if (((this._mouseMoveEffect) && (this._cellMouseOverBg)))
            {
                this.updateBgVisible(false);
            };
        }

        protected function updateBgVisible(_arg_1:Boolean):void
        {
            if (this._cellMouseOverBg)
            {
                this._cellMouseOverBg.visible = ((_arg_1) || (isSelected));
                this._cellMouseOverFormer.visible = ((_arg_1) || (isSelected));
                setChildIndex(this._cellMouseOverFormer, (numChildren - 1));
            };
        }

        private function changePosition(_arg_1:PetSmallItem, _arg_2:PetSmallItem):void
        {
            var _local_3:PetInfo = _arg_1.info;
            _arg_1.info = _arg_2.info;
            _arg_2.info = _local_3;
        }

        private function updateLockState():void
        {
            if (locked)
            {
                filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
                filters = null;
            };
        }

        override protected function createDragImg():DisplayObject
        {
            ObjectUtils.disposeObject(this._dragImg);
            this._dragImg = null;
            if ((((this._petIcon) && (this._petIcon.width > 0)) && (this._petIcon.height > 0)))
            {
                this._dragImg = new Bitmap(new BitmapData((this._petIcon.width / this._petIcon.scaleX), (this._petIcon.height / this._petIcon.scaleY), true, 0));
                this._dragImg.bitmapData.draw(this._petIcon);
            };
            return (this._dragImg);
        }

        override protected function removeEvent():void
        {
            super.removeEvent();
            if (this._petIcon)
            {
                this._petIcon.removeEventListener(BitmapLoaderProxy.LOADING_FINISH, this.__fixPetIconPostion);
            };
            removeEventListener(MouseEvent.ROLL_OVER, this.__rollOverHandler);
            removeEventListener(MouseEvent.ROLL_OUT, this.__rollOutHandler);
            removeEventListener(PetItemEvent.MOUSE_DOWN, this.__mouseDown);
            removeEventListener(PetItemEvent.ITEM_CLICK, this.__itemClick);
            removeEventListener(PetItemEvent.DOUBLE_CLICK, this.__doubleClick);
        }

        override public function dispose():void
        {
            super.dispose();
            ShowTipManager.Instance.removeTip(this);
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._petIcon);
            this._petIcon = null;
            ObjectUtils.disposeObject(this._stateFlag);
            this._stateFlag = null;
            ObjectUtils.disposeObject(this._cellMouseOverBg);
            this._cellMouseOverBg = null;
            ObjectUtils.disposeObject(this._cellMouseOverFormer);
            this._cellMouseOverFormer = null;
            ObjectUtils.disposeObject(this._dragImg);
            this._dragImg = null;
        }

        override public function set isSelected(_arg_1:Boolean):void
        {
            super.isSelected = _arg_1;
            this.updateBgVisible(false);
        }

        public function dragDrop(_arg_1:DragEffect):void
        {
            if (locked)
            {
                return;
            };
        }


    }
}//package petsBag.view.item

