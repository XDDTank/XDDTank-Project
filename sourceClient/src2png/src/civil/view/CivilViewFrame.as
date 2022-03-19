// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//civil.view.CivilViewFrame

package civil.view
{
    import com.pickgliss.ui.controls.Frame;
    import civil.CivilController;
    import civil.CivilModel;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class CivilViewFrame extends Frame 
    {

        private var _civilLeftView:CivilLeftView;
        private var _civilRightView:CivilRightView;
        private var _controller:CivilController;
        private var _model:CivilModel;
        private var _titleBg:Bitmap;

        public function CivilViewFrame(_arg_1:CivilController, _arg_2:CivilModel)
        {
            this._controller = _arg_1;
            this._model = _arg_2;
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            escEnable = true;
            this._titleBg = ComponentFactory.Instance.creatBitmap("asset.civil.title");
            this._civilLeftView = new CivilLeftView(this._controller, this._model);
            this._civilRightView = new CivilRightView(this._controller, this._model);
            PositionUtils.setPos(this._civilLeftView, "civileLeftView.pos");
            PositionUtils.setPos(this._civilRightView, "civileRightView.pos");
            addToContent(this._titleBg);
            addToContent(this._civilLeftView);
            addToContent(this._civilRightView);
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._civilLeftView)
            {
                this._civilLeftView.dispose();
            };
            this._civilLeftView = null;
            if (this._civilRightView)
            {
                this._civilRightView.dispose();
            };
            this._civilRightView = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package civil.view

