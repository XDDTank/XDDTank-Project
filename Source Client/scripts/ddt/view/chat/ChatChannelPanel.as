package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.VBox;
   import ddt.data.EquipType;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ChatChannelPanel extends ChatBasePanel
   {
       
      
      private var _bg:Bitmap;
      
      private var _channelBtns:Vector.<BaseButton>;
      
      private var _vbox:VBox;
      
      private var _currentChannel:Object;
      
      private const chanelMap:Array = [15,0,2,3,4,5];
      
      public function ChatChannelPanel()
      {
         this._channelBtns = new Vector.<BaseButton>();
         this._currentChannel = new Object();
         super();
      }
      
      private function __itemClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new ChatEvent(ChatEvent.INPUT_CHANNEL_CHANNGED,this._currentChannel[(param1.target as BaseButton).backStyle]));
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.chat.ChannelPannelBg");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("chat.channelPanel.vbox");
         if(ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_CBUGLE))
         {
            this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_CrossBuggleBtn"));
         }
         if(ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_BBUGLE))
         {
            this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_BigBuggleBtn"));
         }
         if(ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_SBUGLE))
         {
            this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_SmallBuggleBtn"));
         }
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_PrivateBtn"));
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_ConsortiaBtn"));
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_TeamBtn"));
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_CurrentBtn"));
         addChild(this._bg);
         addChild(this._vbox);
         var _loc1_:uint = 0;
         while(_loc1_ < this._channelBtns.length)
         {
            this._channelBtns[_loc1_].addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            this._currentChannel[this._channelBtns[_loc1_].backStyle] = this.chanelMap[6 - this._channelBtns.length + _loc1_];
            this._vbox.addChild(this._channelBtns[_loc1_]);
            _loc1_++;
         }
         this._bg.height = 18 * this._channelBtns.length + 10;
      }
      
      public function get btnLen() : int
      {
         return this._channelBtns.length;
      }
   }
}
