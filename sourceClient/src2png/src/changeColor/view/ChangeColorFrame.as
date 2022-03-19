// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//changeColor.view.ChangeColorFrame

package changeColor.view
{
    import com.pickgliss.ui.controls.Frame;
    import changeColor.ChangeColorController;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.LayerManager;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import changeColor.ChangeColorCellEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;

    public class ChangeColorFrame extends Frame 
    {

        private var _changeColorController:ChangeColorController;
        private var _changeColorLeftView:ChangeColorLeftView;
        private var _changeColorRightView:ChangeColorRightView;


        public function set changeColorController(_arg_1:ChangeColorController):void
        {
            this._changeColorController = _arg_1;
        }

        override public function dispose():void
        {
            this.remvoeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._changeColorLeftView = null;
            this._changeColorRightView = null;
            this._changeColorController.changeColorModel.clear();
            super.dispose();
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this._changeColorLeftView.model = this._changeColorController.changeColorModel;
            this._changeColorRightView.model = this._changeColorController.changeColorModel;
        }

        override protected function init():void
        {
            var _local_1:Rectangle;
            super.init();
            this._changeColorLeftView = new ChangeColorLeftView();
            addToContent(this._changeColorLeftView);
            this._changeColorRightView = new ChangeColorRightView();
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.rightViewRec");
            ObjectUtils.copyPropertyByRectangle(this._changeColorRightView, _local_1);
            addToContent(this._changeColorRightView);
            this.addEvent();
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._changeColorRightView.addEventListener(ChangeColorCellEvent.CLICK, this.__cellClickHandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_COLOR_CARD, this.__useCardHandler);
        }

        private function remvoeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    SoundManager.instance.play("008");
                    this._changeColorController.close();
                    return;
            };
        }

        private function __cellClickHandler(_arg_1:ChangeColorCellEvent):void
        {
            if (_arg_1.data != null)
            {
                this._changeColorLeftView.setCurrentItem(_arg_1.data);
            };
        }

        private function __useCardHandler(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            if (_local_2)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.success"));
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.failed"));
            };
        }


    }
}//package changeColor.view

