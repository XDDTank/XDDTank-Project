// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatChannelPanel

package ddt.view.chat
{
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.container.VBox;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.BaseButton;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.ShopManager;
    import ddt.data.EquipType;
    import __AS3__.vec.*;

    public class ChatChannelPanel extends ChatBasePanel 
    {

        private var _bg:Bitmap;
        private var _vbox:VBox;

        private var _channelBtns:Vector.<BaseButton> = new Vector.<BaseButton>();
        private var _currentChannel:Object = new Object();
        private const chanelMap:Array = [15, 0, 2, 3, 4, 5];


        private function __itemClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            dispatchEvent(new ChatEvent(ChatEvent.INPUT_CHANNEL_CHANNGED, this._currentChannel[(_arg_1.target as BaseButton).backStyle]));
        }

        override protected function init():void
        {
            super.init();
            this._bg = ComponentFactory.Instance.creatBitmap("asset.chat.ChannelPannelBg");
            this._vbox = ComponentFactory.Instance.creatComponentByStylename("chat.channelPanel.vbox");
            if (ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_CBUGLE))
            {
                this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_CrossBuggleBtn"));
            };
            if (ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_BBUGLE))
            {
                this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_BigBuggleBtn"));
            };
            if (ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_SBUGLE))
            {
                this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_SmallBuggleBtn"));
            };
            this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_PrivateBtn"));
            this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_ConsortiaBtn"));
            this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_TeamBtn"));
            this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_CurrentBtn"));
            addChild(this._bg);
            addChild(this._vbox);
            var _local_1:uint;
            while (_local_1 < this._channelBtns.length)
            {
                this._channelBtns[_local_1].addEventListener(MouseEvent.CLICK, this.__itemClickHandler);
                this._currentChannel[this._channelBtns[_local_1].backStyle] = this.chanelMap[((6 - this._channelBtns.length) + _local_1)];
                this._vbox.addChild(this._channelBtns[_local_1]);
                _local_1++;
            };
            this._bg.height = ((18 * this._channelBtns.length) + 10);
        }

        public function get btnLen():int
        {
            return (this._channelBtns.length);
        }


    }
}//package ddt.view.chat

