package militaryrank.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MilitaryFrameView extends Frame
   {
       
      
      private var _BG:ScaleBitmapImage;
      
      private var _shopBtn:SelectedButton;
      
      private var _ruleBtn:SelectedButton;
      
      private var _rankBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _currentView:Sprite;
      
      private var _footView:FootView;
      
      private var _shopView:ShopView;
      
      private var _ruleView:Sprite;
      
      private var _rankView:RankView;
      
      public function MilitaryFrameView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("militaryrank.view.title");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("militaryrank.bg");
         this._shopBtn = ComponentFactory.Instance.creatComponentByStylename("militaryrank.shopBtn");
         this._ruleBtn = ComponentFactory.Instance.creatComponentByStylename("militaryrank.ruleBtn");
         this._rankBtn = ComponentFactory.Instance.creatComponentByStylename("militaryrank.rankBtn");
         addToContent(this._BG);
         addToContent(this._shopBtn);
         addToContent(this._ruleBtn);
         addToContent(this._rankBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._shopBtn);
         this._btnGroup.addSelectItem(this._ruleBtn);
         this._btnGroup.addSelectItem(this._rankBtn);
         this._btnGroup.selectIndex = 0;
         this._footView = new FootView();
         PositionUtils.setPos(this._footView,"militaryrank.footViewPos");
         addToContent(this._footView);
         this._currentView = this.shopView();
         this._currentView.visible = true;
         addToContent(this._currentView);
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._shopBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._ruleBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._rankBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function __soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __changeHandler(param1:Event) : void
      {
         if(this._currentView)
         {
            this._currentView.visible = false;
         }
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._currentView = this.shopView();
               break;
            case 1:
               this._currentView = this.ruleView();
               break;
            case 2:
               this._currentView = this.rankView();
         }
         this._currentView.visible = true;
         addToContent(this._currentView);
      }
      
      private function shopView() : Sprite
      {
         if(!this._shopView)
         {
            this._shopView = ComponentFactory.Instance.creat("militaryrank.shopView");
         }
         return this._shopView;
      }
      
      private function ruleView() : Sprite
      {
         if(!this._ruleView)
         {
            this._ruleView = ComponentFactory.Instance.creat("militaryrank.ruleView");
         }
         return this._ruleView;
      }
      
      private function rankView() : Sprite
      {
         if(!this._rankView)
         {
            this._rankView = new RankView();
            PositionUtils.setPos(this._rankView,"asset.militaryRankView.Pos");
         }
         return this._rankView;
      }
      
      private function challeView() : void
      {
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._shopBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._ruleBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._rankBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._BG);
         this._BG = null;
         ObjectUtils.disposeObject(this._shopBtn);
         this._shopBtn = null;
         ObjectUtils.disposeObject(this._ruleBtn);
         this._ruleBtn = null;
         ObjectUtils.disposeObject(this._rankBtn);
         this._rankBtn = null;
         ObjectUtils.disposeObject(this._btnGroup);
         this._btnGroup = null;
         ObjectUtils.disposeObject(this._shopView);
         this._shopView = null;
         ObjectUtils.disposeAllChildren(this._ruleView);
         ObjectUtils.disposeObject(this._ruleView);
         this._ruleView = null;
         ObjectUtils.disposeObject(this._rankView);
         this._rankView = null;
         ObjectUtils.disposeObject(this._footView);
         this._footView = null;
         this._currentView = null;
         super.dispose();
      }
   }
}
