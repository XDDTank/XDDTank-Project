// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossBuyBuffConfirmFrame

package worldboss.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import worldboss.WorldBossManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import ddt.manager.SharedManager;
    import com.pickgliss.utils.ObjectUtils;

    public class WorldBossBuyBuffConfirmFrame extends BaseAlerFrame 
    {

        protected var _alertTips:FilterFrameText;
        protected var _alertTips2:FilterFrameText;
        protected var _buyBtn:SelectedCheckButton;

        public function WorldBossBuyBuffConfirmFrame()
        {
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.title = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.title");
            _local_1.bottomGap = 15;
            _local_1.buttonGape = 65;
            this.info = _local_1;
            this.initView();
            this.initEvent();
        }

        protected function initView():void
        {
            this._alertTips = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuffFrame.text");
            addToContent(this._alertTips);
            this._alertTips2 = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuffFrame.text2");
            addToContent(this._alertTips2);
            this._alertTips2.text = "";
            this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuffFrame.selectBtn");
            addToContent(this._buyBtn);
            this._buyBtn.text = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.noAlert");
        }

        public function show(_arg_1:int=1):void
        {
            var _local_2:int = WorldBossManager.Instance.bossInfo.addInjureBuffMoney;
            var _local_3:int = WorldBossManager.Instance.bossInfo.addInjureValue;
            if (_arg_1 == 1)
            {
                this._alertTips.text = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.desc", _local_2, _local_3);
            }
            else
            {
                this._alertTips.text = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.desc2", _local_2, _local_3);
            };
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        protected function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__framePesponse);
            this._buyBtn.addEventListener(Event.SELECT, this.__noAlertTip);
        }

        protected function __noAlertTip(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            SharedManager.Instance.isWorldBossBuyBuff = this._buyBtn.selected;
            SharedManager.Instance.save();
        }

        protected function __framePesponse(_arg_1:FrameEvent):void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__framePesponse);
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    break;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    WorldBossManager.Instance.buyNewBuff();
                    break;
            };
            this.dispose();
        }

        protected function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__framePesponse);
        }

        override public function dispose():void
        {
            if (this._buyBtn)
            {
                ObjectUtils.disposeObject(this._buyBtn);
                this._buyBtn = null;
            };
            if (this._alertTips2)
            {
                ObjectUtils.disposeObject(this._alertTips2);
                this._alertTips2 = null;
            };
            if (this._alertTips)
            {
                ObjectUtils.disposeObject(this._alertTips);
                this._alertTips = null;
            };
            super.dispose();
        }


    }
}//package worldboss.view

