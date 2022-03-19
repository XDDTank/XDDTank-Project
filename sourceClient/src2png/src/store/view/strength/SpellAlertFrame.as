// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.SpellAlertFrame

package store.view.strength
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.core.Disposeable;
    import bagAndInfo.cell.BagCell;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.vo.AlertInfo;
    import flash.geom.Point;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import bagAndInfo.cell.CellFactory;
    import ddt.manager.ItemManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;

    public class SpellAlertFrame extends BaseAlerFrame implements Disposeable 
    {

        public static const CLOSE:String = "close";
        public static const SUBMIT:String = "submit";

        private var _cell:BagCell;
        private var _alertText:FilterFrameText;
        private var _alertInfo:AlertInfo;

        public function SpellAlertFrame()
        {
            this.initContainer();
        }

        private function initContainer():void
        {
            var _local_1:Point;
            cancelButtonStyle = "core.simplebt";
            submitButtonStyle = "core.simplebt";
            this._alertInfo = new AlertInfo();
            this._alertInfo.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            this._alertInfo.enterEnable = true;
            this._alertInfo.escEnable = true;
            info = this._alertInfo;
            this._alertText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.view.strength.alertText");
            this._alertText.text = LanguageMgr.GetTranslation("store.view.strength.noneSymble");
            addToContent(this._alertText);
            this._cell = (CellFactory.instance.createPersonalInfoCell(-1, ItemManager.Instance.getTemplateById(11020), true) as BagCell);
            _local_1 = ComponentFactory.Instance.creatCustomObject("ddtstore.view.strength.cellPos");
            this._cell.x = _local_1.x;
            this._cell.y = _local_1.y;
            this._cell.setContentSize(60, 60);
            addToContent(this._cell);
            addEventListener(FrameEvent.RESPONSE, this.__frameEvent);
        }

        private function __frameEvent(_arg_1:FrameEvent):void
        {
            this.dispose();
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    dispatchEvent(new Event(CLOSE));
                    SoundManager.instance.play("008");
                    return;
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    SoundManager.instance.play("008");
                    dispatchEvent(new Event(SUBMIT));
                    return;
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, false, LayerManager.ALPHA_BLOCKGOUND);
        }

        override public function dispose():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            if (this._alertText)
            {
                this._alertText.dispose();
            };
            this._alertText = null;
            if (this._cell)
            {
                this._cell.dispose();
            };
            this._cell = null;
            super.dispose();
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package store.view.strength

