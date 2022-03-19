// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tryonSystem.TryonPanelFrame

package tryonSystem
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;

    public class TryonPanelFrame extends BaseAlerFrame 
    {

        private var _control:TryonSystemController;
        private var _view:TryonPanelView;

        public function TryonPanelFrame()
        {
            var _local_1:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.tryonSystem.title"), "", "", true, false);
            _local_1.submitLabel = LanguageMgr.GetTranslation("ok");
            _local_1.moveEnable = false;
            info = _local_1;
        }

        public function set controller(_arg_1:TryonSystemController):void
        {
            this._control = _arg_1;
            this.initView();
        }

        public function initView():void
        {
            this._view = new TryonPanelView(this._control);
            PositionUtils.setPos(this._view, "quest.tryon.tryonPanelPos");
            addToContent(this._view);
        }

        override public function dispose():void
        {
            this._view.dispose();
            this._view = null;
            this._control = null;
            super.dispose();
        }


    }
}//package tryonSystem

