// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.MultiShootAlertFrame

package room.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import ddt.manager.SharedManager;
    import com.pickgliss.utils.ObjectUtils;

    public class MultiShootAlertFrame extends BaseAlerFrame 
    {

        private var _scroll:ScrollPanel;
        private var _sBtn:SelectedCheckButton;

        public function MultiShootAlertFrame()
        {
            this.initEvent();
            var _local_1:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"));
            _local_1.autoDispose = true;
            _local_1.showCancel = false;
            info = _local_1;
        }

        override protected function init():void
        {
            super.init();
            this._scroll = ComponentFactory.Instance.creat("ddtDungeonRoomView.multiShootAlertFrame.scroll");
            this._scroll.setView(ComponentFactory.Instance.creat("ddtroom.dungeon.multiShootExplainMc"));
            addToContent(this._scroll);
            this._sBtn = ComponentFactory.Instance.creat("ddtDungeonRoomView.multiShootAlertFrame.selectedBtn");
            this._sBtn.text = LanguageMgr.GetTranslation("room.dungeon.multishootAlert.noTip");
            this._sBtn.selected = false;
            addToContent(this._sBtn);
        }

        private function initEvent():void
        {
            this._sBtn.addEventListener(Event.SELECT, this.__selectedChanged);
        }

        protected function __selectedChanged(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
        }

        private function removeEvent():void
        {
            if (this._sBtn)
            {
                this._sBtn.removeEventListener(Event.SELECT, this.__selectedChanged);
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._sBtn)
            {
                SharedManager.Instance.isShowMultiAlert = (!(this._sBtn.selected));
                SharedManager.Instance.save();
            };
            ObjectUtils.disposeObject(this._scroll);
            this._scroll = null;
            ObjectUtils.disposeObject(this._sBtn);
            this._sBtn = null;
            super.dispose();
        }


    }
}//package room.view

