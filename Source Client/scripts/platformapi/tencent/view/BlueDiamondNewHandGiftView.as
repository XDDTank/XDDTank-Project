package platformapi.tencent.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DailyAwardType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import platformapi.tencent.DiamondManager;
   import platformapi.tencent.DiamondType;
   
   public class BlueDiamondNewHandGiftView extends BaseAlerFrame
   {
       
      
      private var _newHandBigTitle:Bitmap;
      
      private var _newHandSmallTitle:Bitmap;
      
      private var _cellBG:Scale9CornerImage;
      
      private var _textBG:Scale9CornerImage;
      
      private var _explainTxt:FilterFrameText;
      
      private var _hbox:HBox;
      
      private var _cells:Vector.<MemberDiamondGiftCell>;
      
      private var _openBtn:SimpleBitmapButton;
      
      private var _getBtn:SimpleBitmapButton;
      
      public function BlueDiamondNewHandGiftView()
      {
         super();
         this.initEvent();
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:AlertInfo = new AlertInfo("","","",false,false);
         this._explainTxt = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.BlueDiamondNewHandGiftView.explainText");
         if(DiamondManager.instance.pfType == DiamondType.MEMBER_DIAMOND)
         {
            this._newHandBigTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.memberQPlusNewHandBigTitle");
            this._newHandSmallTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.memberQPlusNewHandsmallTitle");
            this._openBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.LeftOpenBtnII");
            this._getBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.leftgetBtnII");
            this._explainTxt.text = LanguageMgr.GetTranslation("memberDiamondGift.view.MemberDiamondNewHandGiftView.explainTxtII");
         }
         else
         {
            this._newHandBigTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.BluenewHandBigTitle");
            this._newHandSmallTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.BluenewHandsmallTitle");
            this._openBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.LeftOpenBtnI");
            this._getBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.leftgetBtnI");
            this._explainTxt.text = LanguageMgr.GetTranslation("memberDiamondGift.view.MemberDiamondNewHandGiftView.explainTxtI");
         }
         info = _loc1_;
         this._cellBG = ComponentFactory.Instance.creatComponentByStylename("BlueDiamondNewHandGiftView.core.scale9CornerImage22");
         this._textBG = ComponentFactory.Instance.creatComponentByStylename("BlueDiamondNewHandGiftView.core.answerBG");
         this._hbox = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.BlueDiamondNewHandGiftView.Hbox");
         addToContent(this._newHandBigTitle);
         addToContent(this._cellBG);
         addToContent(this._newHandSmallTitle);
         addToContent(this._textBG);
         addToContent(this._hbox);
         addToContent(this._explainTxt);
         addToContent(this._openBtn);
         addToContent(this._getBtn);
         this.createCell();
         this.update();
      }
      
      private function initEvent() : void
      {
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__onOpenBtnClick);
         this._getBtn.addEventListener(MouseEvent.CLICK,this.__ongetBtnClick);
         DiamondManager.instance.model.addEventListener(Event.CHANGE,this.__onUpdate);
         addEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
      }
      
      private function removeEvent() : void
      {
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__onOpenBtnClick);
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.__ongetBtnClick);
         DiamondManager.instance.model.removeEventListener(Event.CHANGE,this.__onUpdate);
         removeEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
      }
      
      protected function __onUpdate(param1:Event) : void
      {
         this.update();
      }
      
      private function __ongetBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendDiamondAward(DailyAwardType.BlueMemberDimondNewHandAward);
         PlayerManager.Instance.Self.isGetNewHandPack = true;
      }
      
      private function __onOpenBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         DiamondManager.instance.openMemberDiamond();
      }
      
      private function createCell() : void
      {
         var _loc2_:MemberDiamondGiftCell = null;
         this._cells = new Vector.<MemberDiamondGiftCell>();
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new MemberDiamondGiftCell(0);
            _loc2_.nameTextStyle = "memberDiamondGift.view.MemberDiamondGiftRightView.cellTextII";
            this._hbox.addChild(_loc2_);
            this._cells.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function clearItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this._cells[_loc1_].dispose();
            this._cells[_loc1_] = null;
            _loc1_++;
         }
      }
      
      private function update() : void
      {
         var _loc1_:Array = DiamondManager.instance.model.newHandAwardList.list;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this._cells[_loc2_].setInfo(_loc1_[_loc2_]);
            _loc2_++;
         }
         if(PlayerManager.Instance.Self.MemberDiamondLevel > 0 && PlayerManager.Instance.Self.isYellowVip)
         {
            this._openBtn.visible = false;
            this._getBtn.visible = true;
         }
         else
         {
            this._openBtn.visible = true;
            this._getBtn.visible = false;
         }
         this._getBtn.enable = !PlayerManager.Instance.Self.isGetNewHandPack;
      }
      
      protected function __onFrameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               break;
            case FrameEvent.SUBMIT_CLICK:
         }
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearItem();
         ObjectUtils.disposeObject(this._newHandBigTitle);
         addChild(this._newHandBigTitle);
         ObjectUtils.disposeObject(this._newHandSmallTitle);
         addChild(this._newHandSmallTitle);
         ObjectUtils.disposeObject(this._cellBG);
         addChild(this._cellBG);
         ObjectUtils.disposeObject(this._textBG);
         addChild(this._textBG);
         ObjectUtils.disposeObject(this._explainTxt);
         addChild(this._explainTxt);
         ObjectUtils.disposeObject(this._hbox);
         addChild(this._hbox);
         ObjectUtils.disposeObject(this._openBtn);
         addChild(this._openBtn);
         ObjectUtils.disposeObject(this._getBtn);
         addChild(this._getBtn);
         super.dispose();
      }
   }
}
