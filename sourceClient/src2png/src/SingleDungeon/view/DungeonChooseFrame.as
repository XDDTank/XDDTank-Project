// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.view.DungeonChooseFrame

package SingleDungeon.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.geom.Point;
    import com.pickgliss.ui.image.MovieImage;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.DisplayUtils;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.ui.ComponentSetting;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class DungeonChooseFrame extends Frame 
    {

        private var _bg:ScaleBitmapImage;
        private var _singleIconPoint:Point;
        private var _multiIconPoint:Point;
        private var _singleEnterBtn:MovieImage;
        private var _multiEnterBtn:MovieImage;

        public function DungeonChooseFrame()
        {
            escEnable = true;
            this.initEvent();
        }

        override protected function init():void
        {
            super.init();
            titleText = LanguageMgr.GetTranslation("singleDungeon.DungeonChooseFrame.title");
            this._singleEnterBtn = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.singleEnterBtn");
            this._multiEnterBtn = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.multiEnterBtn");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.goldlinebg");
            this._singleIconPoint = ComponentFactory.Instance.creatCustomObject("singledungeon.enter.singlePoint");
            this._multiIconPoint = ComponentFactory.Instance.creatCustomObject("singledungeon.enter.multiPoint");
            DisplayUtils.setDisplayPos(this._singleEnterBtn, this._singleIconPoint);
            DisplayUtils.setDisplayPos(this._multiEnterBtn, this._multiIconPoint);
            addToContent(this._singleEnterBtn);
            addToContent(this._multiEnterBtn);
            addToContent(this._bg);
            this._singleEnterBtn.setFrame(2);
            this._multiEnterBtn.setFrame(1);
            this._multiEnterBtn.buttonMode = true;
            this._singleEnterBtn.buttonMode = true;
            this._bg.mouseChildren = false;
            this._bg.mouseEnabled = false;
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
            this._singleEnterBtn.addEventListener(MouseEvent.CLICK, this.__onSingleClick);
            this._singleEnterBtn.addEventListener(MouseEvent.MOUSE_OVER, this.__onSingleOver);
            this._multiEnterBtn.addEventListener(MouseEvent.MOUSE_OVER, this.__onSingleOver);
            this._multiEnterBtn.addEventListener(MouseEvent.CLICK, this.__onMultiClick);
        }

        private function __onSingleOver(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget == this._singleEnterBtn)
            {
                this._singleEnterBtn.setFrame(2);
                this._multiEnterBtn.setFrame(1);
            };
            if (_arg_1.currentTarget == this._multiEnterBtn)
            {
                this._singleEnterBtn.setFrame(1);
                this._multiEnterBtn.setFrame(2);
            };
        }

        private function __onSingleClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._singleEnterBtn.setFrame(4);
            StateManager.setState(StateType.SINGLEDUNGEON);
            this.dispose();
        }

        private function __onMultiClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._multiEnterBtn.setFrame(4);
            if (PlayerManager.Instance.checkExpedition())
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.doing"));
                return;
            };
            StateManager.setState(StateType.DUNGEON_LIST);
            ComponentSetting.SEND_USELOG_ID(4);
            this.dispose();
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__response);
            this._singleEnterBtn.removeEventListener(MouseEvent.CLICK, this.__onSingleClick);
            this._singleEnterBtn.removeEventListener(MouseEvent.MOUSE_OVER, this.__onSingleOver);
            this._multiEnterBtn.removeEventListener(MouseEvent.MOUSE_OVER, this.__onSingleOver);
            this._multiEnterBtn.removeEventListener(MouseEvent.CLICK, this.__onMultiClick);
        }

        private function __response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    this.dispose();
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
            this.removeEvent();
            super.dispose();
        }


    }
}//package SingleDungeon.view

