// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossBuyBuffFrame

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import worldboss.WorldBossManager;
    import worldboss.model.WorldBossBuffInfo;
    import flash.events.Event;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.events.PlayerPropertyEvent;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;
    import road7th.comm.PackageIn;

    public class WorldBossBuyBuffFrame extends Sprite implements Disposeable 
    {

        public static var IsAutoShow:Boolean = true;
        private static var _autoBuyBuffItem:DictionaryData = new DictionaryData();

        private var _notAgainBtn:SelectedCheckButton;
        private var _selectedArr:Array = new Array();
        private var _cartList:VBox;
        private var _cartScroll:ScrollPanel;
        private var _frame:Frame;
        private var _innerBg:Image;
        private var _moneyTip:FilterFrameText;
        private var _moneyBg:Image;
        private var _money:FilterFrameText;
        private var _bottomBg:Image;

        public function WorldBossBuyBuffFrame()
        {
            this.init();
            this.addEvent();
        }

        private function drawFrame():void
        {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuyBuffFrame");
            this._frame.titleText = LanguageMgr.GetTranslation("worldboss.buyBuff.FrameTitle");
            addChild(this._frame);
        }

        private function drawItemCountField():void
        {
            this._notAgainBtn = ComponentFactory.Instance.creatComponentByStylename("worldbossnotAgainBtn");
            this._notAgainBtn.text = LanguageMgr.GetTranslation("worldboss.buyBuff.NotAgain");
            this._notAgainBtn.selected = (!(IsAutoShow));
            this._bottomBg = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuyBuffFrame.bottomBg");
            this._moneyBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.TicketTextBg");
            PositionUtils.setPos(this._moneyBg, "worldboss.buyBuffFrame.moneyBg");
            this._money = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PlayerMoney");
            PositionUtils.setPos(this._money, "worldboss.buyBuffFrame.money");
            this._money.text = PlayerManager.Instance.Self.Money.toString();
            this._moneyTip = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuyBUffFrame.moneyTip");
            this._moneyTip.text = LanguageMgr.GetTranslation("worldboss.buyBuff.moneyTip");
            this._frame.addToContent(this._notAgainBtn);
            this._frame.addToContent(this._bottomBg);
            this._frame.addToContent(this._moneyBg);
            this._frame.addToContent(this._money);
            this._frame.addToContent(this._moneyTip);
        }

        protected function drawPayListField():void
        {
            this._innerBg = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuyBuffFrameBg");
            this._frame.addToContent(this._innerBg);
        }

        protected function init():void
        {
            this._cartList = new VBox();
            this.drawFrame();
            this._cartScroll = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuffItemList");
            this._cartScroll.setView(this._cartList);
            this._cartScroll.vScrollProxy = ScrollPanel.ON;
            this._cartList.spacing = 5;
            this._cartList.strictSize = 80;
            this._cartList.isReverAdd = true;
            this.drawPayListField();
            this._frame.addToContent(this._cartScroll);
            this.drawItemCountField();
            this.setList();
        }

        private function setList():void
        {
            var _local_3:BuffCartItem;
            var _local_1:Array = WorldBossManager.Instance.bossInfo.buffArray;
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                _local_3 = new BuffCartItem();
                _local_3.buffItemInfo = (_local_1[_local_2] as WorldBossBuffInfo);
                this._cartList.addChild(_local_3);
                this._selectedArr.push(_local_3);
                _local_3.selected(_autoBuyBuffItem.hasKey(_local_3.buffID));
                _local_3.addEventListener(Event.SELECT, this.__itemSelected);
                _local_2++;
            };
            this._cartScroll.invalidateViewport();
            this.updatePrice();
        }

        private function addEvent():void
        {
            this._frame.addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._notAgainBtn.addEventListener(Event.SELECT, this.__againChange);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_BUYBUFF, this.__getBuff);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__onPropertyChanged);
        }

        protected function __onPropertyChanged(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties[PlayerInfo.MONEY])
            {
                this._money.text = PlayerManager.Instance.Self.Money.toString();
            };
        }

        private function removeEvent():void
        {
            this._frame.removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._notAgainBtn.removeEventListener(Event.SELECT, this.__againChange);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_BUYBUFF, this.__getBuff);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__onPropertyChanged);
        }

        private function __itemSelected(_arg_1:Event=null):void
        {
            this.updatePrice();
            var _local_2:BuffCartItem = (_arg_1.currentTarget as BuffCartItem);
            if (_local_2.IsSelected)
            {
                _autoBuyBuffItem.add(_local_2.buffID, _local_2.buffID);
            }
            else
            {
                _autoBuyBuffItem.remove(_local_2.buffID);
            };
        }

        private function updatePrice():void
        {
            var _local_2:BuffCartItem;
            var _local_1:int;
            for each (_local_2 in this._selectedArr)
            {
                if (_local_2.IsSelected)
                {
                    _local_1 = (_local_1 + _local_2.price);
                };
            };
        }

        private function __againChange(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            if (this._notAgainBtn.selected)
            {
                IsAutoShow = false;
            }
            else
            {
                IsAutoShow = true;
            };
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.buyBuff.setShowSucess"));
        }

        private function _responseI(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                LeavePageManager.leaveToFillPath();
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    SoundManager.instance.play("008");
                    this.dispose();
                    return;
            };
        }

        private function __getBuff(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:BuffCartItem;
            var _local_2:PackageIn = _arg_1.pkg;
            if (_local_2.readBoolean())
            {
                _local_3 = _local_2.readInt();
                if (_local_3 > 1)
                {
                    this.dispose();
                };
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    _local_5 = _local_2.readInt();
                    for each (_local_6 in this._selectedArr)
                    {
                        if (_local_5 == _local_6.buffID)
                        {
                            WorldBossManager.Instance.bossInfo.myPlayerVO.buffID = _local_5;
                            _local_6.changeStatusBuy();
                        };
                    };
                    _local_4++;
                };
                this.updatePrice();
                dispatchEvent(new Event(Event.CHANGE));
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this._frame);
            ObjectUtils.disposeAllChildren(this);
            this._bottomBg = null;
            this._moneyTip = null;
            this._moneyBg = null;
            this._money = null;
            this._selectedArr = null;
            this._cartList = null;
            this._cartScroll = null;
            this._innerBg = null;
            this._frame = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package worldboss.view

