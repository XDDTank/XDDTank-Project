// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.BreakGoodsBtn

package bagAndInfo.bag
{
    import com.pickgliss.ui.controls.TextButton;
    import ddt.interfaces.IDragable;
    import bagAndInfo.cell.LockBagCell;
    import flash.filters.ColorMatrixFilter;
    import flash.events.MouseEvent;
    import ddt.manager.DragManager;
    import com.pickgliss.ui.ComponentFactory;
    import bagAndInfo.cell.DragEffect;
    import ddt.interfaces.ICell;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.SoundManager;
    import flash.events.Event;

    public class BreakGoodsBtn extends TextButton implements IDragable 
    {

        private var _dragTarget:LockBagCell;
        private var _enabel:Boolean;
        private var win:BreakGoodsView;
        private var myColorMatrix_filter:ColorMatrixFilter;
        private var lightingFilter:ColorMatrixFilter;


        override protected function init():void
        {
            super.init();
            buttonMode = true;
            this.initEvent();
        }

        private function __mouseClick(_arg_1:MouseEvent):void
        {
            this.dragStart(_arg_1.stageX, _arg_1.stageY);
        }

        public function dragStart(_arg_1:Number, _arg_2:Number):void
        {
            DragManager.startDrag(this, this, ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.breakIconAsset"), _arg_1, _arg_2, DragEffect.MOVE);
        }

        public function dragStop(_arg_1:DragEffect):void
        {
            var _local_2:LockBagCell;
            if (((PlayerManager.Instance.Self.bagLocked) && (_arg_1.target is ICell)))
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (((_arg_1.action == DragEffect.MOVE) && (_arg_1.target is ICell)))
            {
                _local_2 = (_arg_1.target as LockBagCell);
                if (_local_2)
                {
                    if (((_local_2.itemInfo.Count > 1) && (!(_local_2.itemInfo.BagType == 11))))
                    {
                        this._dragTarget = _local_2;
                        SoundManager.instance.play("008");
                        this._dragTarget = _local_2;
                        SoundManager.instance.play("008");
                        this.win = ComponentFactory.Instance.creatComponentByStylename("breakGoodsView");
                        this.win.cell = _local_2;
                        this.win.show();
                    };
                };
            };
        }

        private function breakBack():void
        {
            if (this._dragTarget)
            {
            };
            if (stage)
            {
                this.dragStart(stage.mouseX, stage.mouseY);
            };
        }

        public function getSource():IDragable
        {
            return (this);
        }

        public function getDragData():Object
        {
            return (this);
        }

        private function removeEvents():void
        {
            removeEventListener(MouseEvent.CLICK, this.__mouseClick);
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__mouseClick);
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.__removeFromStage);
        }

        override public function dispose():void
        {
            this.removeEvents();
            if (this._dragTarget)
            {
                this._dragTarget.locked = false;
            };
            PlayerManager.Instance.Self.Bag.unLockAll();
            if (this.win != null)
            {
                this.win.dispose();
            };
            this.win = null;
            super.dispose();
        }

        private function __addToStage(_arg_1:Event):void
        {
        }

        private function __removeFromStage(_arg_1:Event):void
        {
        }

        private function cancelBack():void
        {
            if (this._dragTarget)
            {
                this._dragTarget.locked = false;
            };
        }


    }
}//package bagAndInfo.bag

