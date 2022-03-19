// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//liveness.LivenessBubble

package liveness
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import worldboss.WorldBossManager;
    import ddt.manager.SocketManager;
    import consortion.managers.ConsortionMonsterManager;
    import arena.ArenaManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.StateManager;
    import ddt.states.StateType;

    public class LivenessBubble extends Sprite implements Disposeable 
    {

        public static const WORLD_BOSS:uint = 1;
        public static const MONSTER_REFLASH:uint = 2;
        public static const ARENA:uint = 3;

        private var _bubbleBg:Bitmap;
        private var _descTxt:FilterFrameText;
        private var _joinBtn:TextButton;
        private var _btnEnable:Boolean;
        private var _type:uint;
        private var _expeditionAlert:BaseAlerFrame;
        private var _line:ScaleBitmapImage;

        public function LivenessBubble(_arg_1:uint, _arg_2:Boolean)
        {
            this.mouseEnabled = false;
            this._type = _arg_1;
            this._btnEnable = _arg_2;
            this.initView();
        }

        private function initView():void
        {
            this._bubbleBg = ComponentFactory.Instance.creatBitmap("asset.liveness.tipsBG");
            this._descTxt = ComponentFactory.Instance.creatComponentByStylename("liveness.livenessBubbleText");
            this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.bubbleBtn");
            this._joinBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.goTransportBtn.text");
            this._line = ComponentFactory.Instance.creatComponentByStylename("liveness.bubble.line");
            if (this._btnEnable)
            {
                this._joinBtn.addEventListener(MouseEvent.CLICK, this.__clickJoinBtn);
            }
            else
            {
                this.setBtnEnable(false);
            };
            addChild(this._bubbleBg);
            addChild(this._descTxt);
            addChild(this._line);
            addChild(this._joinBtn);
        }

        public function setBtnEnable(_arg_1:Boolean=true):void
        {
            this._joinBtn.enable = _arg_1;
            if (_arg_1)
            {
                this._joinBtn.filters = null;
            }
            else
            {
                this._joinBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
        }

        private function __clickJoinBtn(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.checkExpedition())
            {
                this._expeditionAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                this._expeditionAlert.moveEnable = false;
                this._expeditionAlert.addEventListener(FrameEvent.RESPONSE, this.__expeditionConfirmResponse);
            }
            else
            {
                this.checkEnter();
            };
        }

        private function checkEnter():void
        {
            LivenessBubbleManager.Instance.removeBubble();
            switch (this._type)
            {
                case WORLD_BOSS:
                    if (WorldBossManager.Instance.isOpen)
                    {
                        SocketManager.Instance.out.enterWorldBossRoom();
                    };
                    return;
                case MONSTER_REFLASH:
                    if (ConsortionMonsterManager.Instance.ActiveState)
                    {
                        SocketManager.Instance.out.SendenterConsortion(true);
                    };
                    return;
                case ARENA:
                    if (ArenaManager.instance.open)
                    {
                        ArenaManager.instance.enter();
                    };
                    return;
            };
        }

        private function __expeditionConfirmResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__expeditionConfirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                SocketManager.Instance.out.sendExpeditionCancle();
                this.checkEnter();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        public function setText(_arg_1:String):void
        {
            this._descTxt.text = _arg_1;
        }

        public function show():void
        {
            if (PlayerManager.Instance.Self.Grade >= 13)
            {
                if (((StateManager.currentStateType == StateType.MAIN) || (StateManager.currentStateType == StateType.LOGIN)))
                {
                    LayerManager.Instance.addToLayer(this, LayerManager.GAME_UI_LAYER);
                };
            };
        }

        public function hide():void
        {
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        public function dispose():void
        {
            this._joinBtn.removeEventListener(MouseEvent.CLICK, this.__clickJoinBtn);
            ObjectUtils.disposeObject(this._bubbleBg);
            this._bubbleBg = null;
            ObjectUtils.disposeObject(this._descTxt);
            this._descTxt = null;
            ObjectUtils.disposeObject(this._line);
            this._line = null;
            if (this._expeditionAlert)
            {
                this._expeditionAlert.removeEventListener(FrameEvent.RESPONSE, this.__expeditionConfirmResponse);
                ObjectUtils.disposeObject(this._expeditionAlert);
                this._expeditionAlert = null;
            };
            this.hide();
        }

        public function get type():uint
        {
            return (this._type);
        }


    }
}//package liveness

