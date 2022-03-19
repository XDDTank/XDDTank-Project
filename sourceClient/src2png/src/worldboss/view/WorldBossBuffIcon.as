// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossBuffIcon

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import worldboss.WorldBossManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SharedManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.utils.ObjectUtils;

    public class WorldBossBuffIcon extends Sprite implements Disposeable 
    {

        private var _moneyBtn:SimpleBitmapButton;
        private var _bindMoneyBtn:SimpleBitmapButton;
        private var _buffIcon:WorldBossBuffItem;

        public function WorldBossBuffIcon()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            var _local_1:int = WorldBossManager.Instance.bossInfo.addInjureBuffMoney;
            var _local_2:int = WorldBossManager.Instance.bossInfo.addInjureValue;
            this._moneyBtn = ComponentFactory.Instance.creat("worldbossRoom.money.buffBtn");
            this._bindMoneyBtn = ComponentFactory.Instance.creat("worldbossRoom.bindMoney.buffBtn");
            this._moneyBtn.tipData = LanguageMgr.GetTranslation("worldboss.money.buffBtn.tip", _local_1, _local_2);
            this._buffIcon = new WorldBossBuffItem();
            PositionUtils.setPos(this._buffIcon, "worldboss.RoomView.BuffIconPos");
            addChild(this._moneyBtn);
            addChild(this._buffIcon);
        }

        private function addEvent():void
        {
            this._moneyBtn.addEventListener(MouseEvent.CLICK, this.buyBuff);
        }

        private function buyBuff(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            SoundManager.instance.playButtonSound();
            if (_arg_1.currentTarget == this._moneyBtn)
            {
                _local_2 = 1;
            }
            else
            {
                _local_2 = 2;
            };
            if (SharedManager.Instance.isWorldBossBuyBuff)
            {
                WorldBossManager.Instance.buyNewBuff();
                return;
            };
            var _local_3:WorldBossBuyBuffConfirmFrame = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuff.confirmFrame");
            _local_3.show(_local_2);
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:WorldBossBuyBuffConfirmFrame = (_arg_1.currentTarget as WorldBossBuyBuffConfirmFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
            };
        }

        private function removeEvent():void
        {
            this._moneyBtn.removeEventListener(MouseEvent.CLICK, this.buyBuff);
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                this.parent.removeChild(this);
            };
            this._moneyBtn = null;
            this._bindMoneyBtn = null;
            this._buffIcon = null;
        }


    }
}//package worldboss.view

