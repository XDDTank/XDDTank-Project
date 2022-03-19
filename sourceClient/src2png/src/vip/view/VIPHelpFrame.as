// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.VIPHelpFrame

package vip.view
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.MouseEvent;
    import game.view.experience.ExpTweenManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import vip.VipController;

    public class VIPHelpFrame extends Frame 
    {

        private var content:MovieClip;
        private var openVip:BaseButton;
        private var _openFun:Function;
        private var _contentScroll:ScrollPanel;
        private var _buttomBit:ScaleBitmapImage;

        public function VIPHelpFrame()
        {
            this.initFrame();
        }

        private function initFrame():void
        {
            titleText = LanguageMgr.GetTranslation("ddt.vip.helpFrame.title");
            this.content = ComponentFactory.Instance.creat("asset.vip.helpFrame.content");
            this._contentScroll = ComponentFactory.Instance.creatComponentByStylename("viphelpFrame.scroll");
            addToContent(this._contentScroll);
            this._contentScroll.setView(this.content);
            this._buttomBit = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.buttomBG");
            addToContent(this._buttomBit);
            this._buttomBit.y = 372;
            this.openVip = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.openVipBtn");
            addToContent(this.openVip);
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("vipHelpFrame.openBtnPos");
            this.openVip.x = _local_1.x;
            this.openVip.y = _local_1.y;
            StageReferance.stage.focus = this;
            this.openVip.addEventListener(MouseEvent.CLICK, this.__open);
        }

        public function set openFun(_arg_1:Function):void
        {
            this._openFun = _arg_1;
        }

        public function show():void
        {
            if (ExpTweenManager.Instance.isPlaying)
            {
                return;
            };
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        private function __open(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.Grade < 3)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip", 3));
                return;
            };
            if (this._openFun != null)
            {
                this._openFun();
            };
            dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
        }

        override public function dispose():void
        {
            super.dispose();
            if (this.openVip)
            {
                this.openVip.removeEventListener(MouseEvent.CLICK, this.__open);
            };
            if (this.content)
            {
                ObjectUtils.disposeObject(this.content);
            };
            this.content = null;
            if (this.openVip)
            {
                ObjectUtils.disposeObject(this.openVip);
            };
            this.openVip = null;
            this._openFun = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            VipController.instance.helpframeNull();
        }


    }
}//package vip.view

