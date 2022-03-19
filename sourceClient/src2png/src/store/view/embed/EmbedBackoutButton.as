// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.embed.EmbedBackoutButton

package store.view.embed
{
    import com.pickgliss.ui.controls.TextButton;
    import ddt.interfaces.IDragable;
    import flash.filters.ColorMatrixFilter;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import bagAndInfo.cell.DragEffect;
    import com.pickgliss.utils.ObjectUtils;

    public class EmbedBackoutButton extends TextButton implements IDragable 
    {

        private var _enabel:Boolean;
        private var _dragTarget:EmbedStoneCell;
        private var myColorMatrix_filter:ColorMatrixFilter;
        private var lightingFilter:ColorMatrixFilter;
        public var isAction:Boolean;

        public function EmbedBackoutButton()
        {
            this.init();
        }

        override protected function init():void
        {
            super.init();
            buttonMode = true;
            this.addBackoutBtnEvent();
            this.myColorMatrix_filter = ComponentFactory.Instance.creatFilters("ddtstore.StoreEmbedBG.MyColorFilter")[0];
            this.lightingFilter = ComponentFactory.Instance.creatFilters("ddtstore.StoreEmbedBG.LightFilter")[0];
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
            this.filters = [this.lightingFilter];
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
            this.filters = null;
        }

        public function dragStop(_arg_1:DragEffect):void
        {
            this.mouseEnabled = true;
            this.isAction = false;
        }

        override public function set enable(_arg_1:Boolean):void
        {
            super.enable = _arg_1;
            buttonMode = _arg_1;
            if (_arg_1)
            {
                this.addBackoutBtnEvent();
                this.filters = null;
            }
            else
            {
                this.removeBackoutBtnEvent();
                this.filters = [this.myColorMatrix_filter];
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

        private function removeBackoutBtnEvent():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        private function addBackoutBtnEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeBackoutBtnEvent();
            if (this._dragTarget)
            {
                ObjectUtils.disposeObject(this._dragTarget);
            };
            this._dragTarget = null;
            this.lightingFilter = null;
            this.myColorMatrix_filter = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.embed

