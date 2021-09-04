package platformapi.tencent.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MemberDiamondFrame extends Frame
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _memberDiamondNewHandGiftView:MemberDiamondNewHandGiftView;
      
      private var _memberDiamondGiftView:MemberDiamondGiftView;
      
      private var _memberDiamondRepaymentView:MemberDiamondRepaymentFrame;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _newHandBtn:SelectedButton;
      
      private var _giftBtn:SelectedButton;
      
      private var _repaymentBtn:SelectedButton;
      
      public function MemberDiamondFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("memberDiamondFrame.title");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("memberDiamondFrame.bg");
         this._newHandBtn = ComponentFactory.Instance.creatComponentByStylename("memberDiamondFrame.newHandBtn");
         this._giftBtn = ComponentFactory.Instance.creatComponentByStylename("memberDiamondFrame.giftBtn");
         this._repaymentBtn = ComponentFactory.Instance.creatComponentByStylename("memberDiamondFrame.repaymentBtn");
         addToContent(this._bg);
         addToContent(this._newHandBtn);
         addToContent(this._giftBtn);
         addToContent(this._repaymentBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._newHandBtn);
         this._btnGroup.addSelectItem(this._giftBtn);
         this._btnGroup.addSelectItem(this._repaymentBtn);
         this._btnGroup.selectIndex = 0;
         this.__changeHandler(null);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._newHandBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._giftBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._repaymentBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
      }
      
      private function __changeHandler(param1:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this.showNewHandView();
               break;
            case 1:
               this.showGiftView();
               break;
            case 2:
               this.showRepaymentView();
         }
      }
      
      private function showNewHandView() : void
      {
         if(!this._memberDiamondNewHandGiftView)
         {
            this._memberDiamondNewHandGiftView = ComponentFactory.Instance.creatCustomObject("MemberDiamondFrame.newHandGiftView");
            addToContent(this._memberDiamondNewHandGiftView);
         }
         this.setVisible(0);
      }
      
      private function showGiftView() : void
      {
         if(!this._memberDiamondGiftView)
         {
            this._memberDiamondGiftView = ComponentFactory.Instance.creatCustomObject("MemberDiamondFrame.giftView");
            addToContent(this._memberDiamondGiftView);
         }
         this.setVisible(1);
      }
      
      private function showRepaymentView() : void
      {
         if(!this._memberDiamondRepaymentView)
         {
            this._memberDiamondRepaymentView = ComponentFactory.Instance.creatCustomObject("MemberDiamondFrame.repaymentView");
            addToContent(this._memberDiamondRepaymentView);
         }
         this.setVisible(2);
      }
      
      private function setVisible(param1:int) : void
      {
         if(this._memberDiamondNewHandGiftView)
         {
            this._memberDiamondNewHandGiftView.visible = param1 == 0 ? Boolean(true) : Boolean(false);
         }
         if(this._memberDiamondGiftView)
         {
            this._memberDiamondGiftView.visible = param1 == 1 ? Boolean(true) : Boolean(false);
         }
         if(this._memberDiamondRepaymentView)
         {
            this._memberDiamondRepaymentView.visible = param1 == 2 ? Boolean(true) : Boolean(false);
         }
      }
      
      private function __soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function show(param1:int) : void
      {
         this._btnGroup.selectIndex = param1;
         this.__changeHandler(null);
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._newHandBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._giftBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._repaymentBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         super.dispose();
      }
   }
}
