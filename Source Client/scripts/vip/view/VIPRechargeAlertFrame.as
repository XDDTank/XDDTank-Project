package vip.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import vip.VipController;
   
   public class VIPRechargeAlertFrame extends Frame
   {
       
      
      private var _scrollBg:Bitmap;
      
      private var _content:DisplayObject;
      
      private var _renewalVipBtn:BaseButton;
      
      private var _contentScroll:ScrollPanel;
      
      private var _buttomBit:Scale9CornerImage;
      
      private var _head:VipFrameHead;
      
      private var _dueDataWord:FilterFrameText;
      
      private var _dueData:FilterFrameText;
      
      private var _vipSpreeView:VipSpreeView;
      
      public function VIPRechargeAlertFrame()
      {
         super();
         this.initFrame();
      }
      
      public function set content(param1:DisplayObject) : void
      {
         this._content = param1;
         this._contentScroll.setView(this._content);
      }
      
      private function initFrame() : void
      {
         this._dueDataWord = ComponentFactory.Instance.creat("VipStatusView.dueDate2FontTxt");
         this._dueData = ComponentFactory.Instance.creat("VipStatusView.dueDate2");
         addToContent(this._dueDataWord);
         addToContent(this._dueData);
         this._buttomBit = ComponentFactory.Instance.creatComponentByStylename("VIPRechargeAlert.buttomBG");
         addToContent(this._buttomBit);
         this._renewalVipBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.renewalVipBtn");
         addToContent(this._renewalVipBtn);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("VIPRechargeAlert.renewalVipBtnPos");
         this._renewalVipBtn.x = _loc1_.x;
         this._renewalVipBtn.y = _loc1_.y;
         this._scrollBg = ComponentFactory.Instance.creatBitmap("vip.rechargeLVBg");
         addToContent(this._scrollBg);
         this._contentScroll = ComponentFactory.Instance.creatComponentByStylename("vipRechargeAlertFrame.scroll");
         this._vipSpreeView = ComponentFactory.Instance.creatCustomObject("vip.VipSpreeView");
         PositionUtils.setPos(this._vipSpreeView,"vip.VipSpreeViewPos");
         if(PlayerManager.Instance.Self.VIPLevel <= 2)
         {
            this._vipSpreeView.VIPRechargeView(1);
         }
         else if(PlayerManager.Instance.Self.VIPLevel <= 4)
         {
            this._vipSpreeView.VIPRechargeView(3);
         }
         else if(PlayerManager.Instance.Self.VIPLevel <= 10)
         {
            this._vipSpreeView.VIPRechargeView(6);
         }
         addToContent(this._vipSpreeView);
         this._contentScroll.vScrollProxy = ScrollPanel.AUTO;
         this._contentScroll.hScrollProxy = ScrollPanel.OFF;
         this._contentScroll.vScrollbar.x = 392;
         this._contentScroll.vScrollbar.y = 4;
         this._head = new VipFrameHead(true);
         PositionUtils.setPos(this._head,"vip.VipRechargeFrame.FrameHeadPos");
         addToContent(this._head);
         titleText = LanguageMgr.GetTranslation("ddt.vip.helpFrame.title");
         StageReferance.stage.focus = this;
         this._renewalVipBtn.addEventListener(MouseEvent.CLICK,this.__OK);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         this.updata();
      }
      
      private function updata() : void
      {
         var _loc1_:Date = PlayerManager.Instance.Self.VIPExpireDay as Date;
         this._dueData.text = _loc1_.fullYear + "-" + (_loc1_.month + 1) + "-" + _loc1_.date;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            this._dueDataWord.text = LanguageMgr.GetTranslation("ddt.vip.dueDate2FontTxt");
            this._dueData.visible = true;
         }
         else
         {
            this._dueDataWord.text = "您的VIP已过期";
            this._dueData.visible = false;
         }
      }
      
      private function __OK(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         VipController.instance.show();
         dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._head)
         {
            this._head.dispose();
            this._head = null;
         }
         ObjectUtils.disposeObject(this._scrollBg);
         this._scrollBg = null;
         if(this._dueDataWord)
         {
            ObjectUtils.disposeObject(this._dueDataWord);
            this._dueDataWord = null;
         }
         if(this._dueData)
         {
            ObjectUtils.disposeObject(this._dueData);
            this._dueData = null;
         }
         if(this._renewalVipBtn)
         {
            this._renewalVipBtn.removeEventListener(MouseEvent.CLICK,this.__OK);
         }
         if(this._content)
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
         if(this._renewalVipBtn)
         {
            ObjectUtils.disposeObject(this._renewalVipBtn);
         }
         this._renewalVipBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
