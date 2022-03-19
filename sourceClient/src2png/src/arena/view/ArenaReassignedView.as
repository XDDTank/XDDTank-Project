// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//arena.view.ArenaReassignedView

package arena.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import ddt.manager.SoundManager;
    import arena.ArenaManager;
    import flash.events.MouseEvent;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ArenaReassignedView extends BaseAlerFrame 
    {

        public static const TIME:int = 10;

        private var _alertInfo:AlertInfo;
        private var _showTxt:FilterFrameText;
        private var _timeTxt:FilterFrameText;
        private var _tick:int;
        private var _ifShow:Boolean = true;
        private var _waiting:Boolean = false;

        public function ArenaReassignedView()
        {
            this.initView();
        }

        public function get ifShow():Boolean
        {
            return (this._ifShow);
        }

        private function initView():void
        {
            this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"));
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this._showTxt = ComponentFactory.Instance.creatComponentByStylename("ddtarena.arenaReassignedView.showTxt");
            this._showTxt.text = LanguageMgr.GetTranslation("ddt.arena.arenareassigned.showtxt");
            addToContent(this._showTxt);
            this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("ddtarena.arenaReassignedView.timeTxt");
            this._timeTxt.htmlText = LanguageMgr.GetTranslation("ddt.arena.arenareassigned.timetxt", 10);
            addToContent(this._timeTxt);
        }

        private function initEvent():void
        {
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__seconds);
        }

        private function __seconds(_arg_1:TimeEvents):void
        {
            this._tick--;
            this._timeTxt.htmlText = LanguageMgr.GetTranslation("ddt.arena.arenareassigned.timetxt", this._tick);
            if (this._tick == 0)
            {
                this._ifShow = false;
                this.hide();
            };
        }

        private function removeEvent():void
        {
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__seconds);
        }

        override protected function __onSubmitClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            super.__onSubmitClick(_arg_1);
            ArenaManager.instance.sendExit();
            ArenaManager.instance.sendEnterScene();
            this.hide();
        }

        override protected function __onCancelClick(_arg_1:MouseEvent):void
        {
            super.__onCancelClick(_arg_1);
            this._ifShow = false;
            this.hide();
        }

        override protected function __onCloseClick(_arg_1:MouseEvent):void
        {
            super.__onCloseClick(_arg_1);
            this._ifShow = false;
            this.hide();
        }

        public function show():void
        {
            if (ArenaManager.instance.model.selfInfo.sceneID == 1)
            {
                return;
            };
            if (((StateManager.currentStateType == StateType.ARENA) && (this.ifShow)))
            {
                LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
                this._tick = TIME;
                this.initEvent();
                this._waiting = false;
            }
            else
            {
                this._waiting = true;
            };
        }

        public function check():void
        {
            if (this._waiting)
            {
                this.show();
            };
        }

        public function hide():void
        {
            this.removeEvent();
            parent.removeChild(this);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            super.dispose();
        }


    }
}//package arena.view

