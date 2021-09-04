package vip.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import vip.VipController;
   
   public class VipFrame extends Frame
   {
      
      public static const SELF_VIEW:int = 0;
      
      public static const OTHER_VIEW:int = 1;
       
      
      private var _titleBg:Bitmap;
      
      private var _hBox:HBox;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _giveYourselfOpenBtn:SelectedTextButton;
      
      private var _giveOthersOpenedBtn:SelectedTextButton;
      
      private var _vipSp:Disposeable;
      
      private var _head:VipFrameHead;
      
      private var _discountIcon:Image;
      
      private var _checkBtn:SelectedCheckButton;
      
      public function VipFrame()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._titleBg = ComponentFactory.Instance.creatBitmap("asset.vip.title");
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("ddtvip.btnHbox");
         this._giveYourselfOpenBtn = ComponentFactory.Instance.creatComponentByStylename("vip.giveYourselfOpenBtn");
         this._giveYourselfOpenBtn.text = LanguageMgr.GetTranslation("ddt.vip.table.openSelf");
         this._giveOthersOpenedBtn = ComponentFactory.Instance.creatComponentByStylename("vip.giveOthersOpenedBtn");
         this._giveOthersOpenedBtn.text = LanguageMgr.GetTranslation("ddt.vip.table.openother");
         this._discountIcon = ComponentFactory.Instance.creatComponentByStylename("vip.discountIcon");
         this._head = new VipFrameHead();
         addToContent(this._titleBg);
         addToContent(this._head);
         addToContent(this._hBox);
         this._hBox.addChild(this._giveYourselfOpenBtn);
         this._hBox.addChild(this._giveOthersOpenedBtn);
         this._selectedButtonGroup = new SelectedButtonGroup(false,1);
         this._selectedButtonGroup.addSelectItem(this._giveYourselfOpenBtn);
         this._selectedButtonGroup.addSelectItem(this._giveOthersOpenedBtn);
         this._selectedButtonGroup.selectIndex = 0;
         this.updateView(SELF_VIEW);
         if(VipController.instance.checkVipExpire())
         {
            this._checkBtn = ComponentFactory.Instance.creatComponentByStylename("ddtvip.vipframe.checkButton");
            this._checkBtn.text = LanguageMgr.GetTranslation("ddt.vip.vipViewFrame.checkBtn");
            this._checkBtn.selected = SharedManager.Instance.showVipCheckBtn;
            addToContent(this._checkBtn);
         }
         addToContent(this._discountIcon);
      }
      
      private function updateView(param1:int) : void
      {
         if(this._vipSp)
         {
            this._vipSp.dispose();
         }
         this._vipSp = null;
         switch(param1)
         {
            case SELF_VIEW:
               this._selectedButtonGroup.selectIndex = 0;
               this._vipSp = new GiveYourselfOpenView();
               break;
            case OTHER_VIEW:
               this._selectedButtonGroup.selectIndex = 1;
               this._vipSp = new GiveOthersOpenedView();
         }
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("vip.GiveYourselfOpenViewPos");
         DisplayObject(this._vipSp).x = _loc2_.x;
         DisplayObject(this._vipSp).y = _loc2_.y;
         addToContent(DisplayObject(this._vipSp));
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._selectedButtonGroup.addEventListener(Event.CHANGE,this.__selectedButtonGroupChange);
         if(this._checkBtn)
         {
            this._checkBtn.addEventListener(MouseEvent.CLICK,this.__checkClick);
         }
      }
      
      private function __checkClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.showVipCheckBtn = this._checkBtn.selected;
      }
      
      private function __selectedButtonGroupChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.updateView(this._selectedButtonGroup.selectIndex);
         this._hBox.arrange();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         if(this._selectedButtonGroup)
         {
            this._selectedButtonGroup.removeEventListener(Event.CHANGE,this.__selectedButtonGroupChange);
         }
         if(this._checkBtn)
         {
            this._checkBtn.removeEventListener(MouseEvent.CLICK,this.__checkClick);
         }
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               VipController.instance.hide();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._selectedButtonGroup);
         this._selectedButtonGroup = null;
         ObjectUtils.disposeObject(this._giveYourselfOpenBtn);
         this._giveYourselfOpenBtn = null;
         ObjectUtils.disposeObject(this._giveOthersOpenedBtn);
         this._giveOthersOpenedBtn = null;
         ObjectUtils.disposeObject(this._discountIcon);
         this._discountIcon = null;
         if(this._head)
         {
            this._head.dispose();
            this._head = null;
         }
         ObjectUtils.disposeObject(this._checkBtn);
         this._checkBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}