package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemLeftView extends Sprite implements Disposeable
   {
       
      
      private var _windowView:TotemLeftWindowView;
      
      private var _forwardBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _currentPage:int = 1;
      
      private var _totalPage:int = 1;
      
      private var _totemTitleBg:Bitmap;
      
      private var _totemTitleFrameBmp:ScaleFrameImage;
      
      private var _honorUpIcon:HonorUpIcon;
      
      private var _propertyBG:Bitmap;
      
      private var _propertyList:Vector.<TotemRightViewTxtTxtCell>;
      
      private var _totalHonorBmp:Bitmap;
      
      private var _totalExpBmp:Bitmap;
      
      private var _totalHonorTxt:FilterFrameText;
      
      private var _totalExpTxt:FilterFrameText;
      
      private var _totemLvBmp:Bitmap;
      
      private var _totemLvTxt:FilterFrameText;
      
      private var _totalHonorComponent:TitleComponent;
      
      private var _totalExpComponent:TitleComponent;
      
      private var _tipView:TotemLeftWindowChapterTipView;
      
      public function TotemLeftView()
      {
         super();
         this.initView();
         this.createPropDisplay();
         this.createChapterTip();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:TotemDataVo = null;
         this._windowView = ComponentFactory.Instance.creatCustomObject("totemLeftWindowView");
         this._forwardBtn = ComponentFactory.Instance.creatComponentByStylename("totem.leftView.page.forwardBtn");
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("totem.leftView.page.nextBtn");
         this._totemTitleBg = ComponentFactory.Instance.creatBitmap("asset.totem.totemTitleBg");
         this._totemTitleFrameBmp = ComponentFactory.Instance.creatComponentByStylename("totem.totemTitle");
         _loc1_ = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
         this._totalHonorComponent = new TitleComponent();
         this._totalHonorComponent.tipData = LanguageMgr.GetTranslation("ddt.totem.rightView.honorTipTxt");
         this._totalExpComponent = new TitleComponent();
         this._totalExpComponent.tipData = LanguageMgr.GetTranslation("ddt.totem.rightView.expTipTxt");
         this._totalHonorBmp = ComponentFactory.Instance.creatBitmap("asset.totem.totalHonor");
         this._totalExpBmp = ComponentFactory.Instance.creatBitmap("asset.totem.totalExp");
         this._totalHonorComponent.addChild(this._totalHonorBmp);
         this._totalExpComponent.addChild(this._totalExpBmp);
         PositionUtils.setPos(this._totalHonorComponent,"totem.totalHonorPos");
         PositionUtils.setPos(this._totalExpComponent,"totem.totalExpPos");
         this._totemLvBmp = ComponentFactory.Instance.creatBitmap("asset.totem.displayLv");
         this._totemLvTxt = ComponentFactory.Instance.creatComponentByStylename("totem.currentLvTxt");
         this.upTotemLvTxt();
         this._honorUpIcon = ComponentFactory.Instance.creatCustomObject("totem.honorUpIcon");
         this._honorUpIcon.addEventListener(Event.CLOSE,this.showUserGuilde);
         this._totalHonorTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totalHonorTxt");
         this._totalExpTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totalExpTxt");
         this.propertyChangeHandler(null);
         if(!_loc1_)
         {
            this._currentPage = 5;
         }
         else
         {
            this._currentPage = _loc1_.Page;
         }
         this.showPage();
         addChild(this._windowView);
         addChild(this._totemTitleBg);
         addChild(this._totemTitleFrameBmp);
         addChild(this._forwardBtn);
         addChild(this._nextBtn);
         addChild(this._honorUpIcon);
         addChild(this._totalHonorComponent);
         addChild(this._totalExpComponent);
         addChild(this._totalHonorTxt);
         addChild(this._totalExpTxt);
         addChild(this._totemLvBmp);
         addChild(this._totemLvTxt);
      }
      
      private function upTotemLvTxt() : void
      {
         if(PlayerManager.Instance.Self.totemId <= 10000)
         {
            this._totemLvTxt.text = "LV0";
         }
         else
         {
            this._totemLvTxt.text = "LV" + Math.floor((PlayerManager.Instance.Self.totemId - 10000) / 7);
         }
      }
      
      private function createChapterTip() : void
      {
         this._tipView = new TotemLeftWindowChapterTipView();
         this._tipView.visible = false;
         LayerManager.Instance.addToLayer(this._tipView,LayerManager.GAME_TOP_LAYER);
      }
      
      private function createPropDisplay() : void
      {
         var _loc2_:TotemRightViewTxtTxtCell = null;
         this._propertyBG = ComponentFactory.Instance.creatBitmap("asset.totem.propBG");
         addChild(this._propertyBG);
         this._propertyList = new Vector.<TotemRightViewTxtTxtCell>();
         var _loc1_:int = 1;
         while(_loc1_ <= 7)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("TotemRightViewTxtTxtCell" + _loc1_);
            _loc2_.show(_loc1_);
            _loc2_.x = 100 + (_loc1_ - 1) * 108;
            _loc2_.y = 432;
            addChild(_loc2_);
            this._propertyList.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         this._forwardBtn.addEventListener(MouseEvent.CLICK,this.changePage);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.changePage);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.propertyChangeHandler);
         this._totemTitleFrameBmp.addEventListener(MouseEvent.MOUSE_OVER,this._showTip);
         this._totemTitleFrameBmp.addEventListener(MouseEvent.MOUSE_OUT,this._hideTip);
      }
      
      private function _showTip(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         _loc2_ = this.localToGlobal(new Point(this.mouseX + 5,this.mouseY));
         this._tipView.x = _loc2_.x + 20;
         this._tipView.y = _loc2_.y;
         this._tipView.show(this._currentPage);
         this._tipView.visible = true;
      }
      
      private function _hideTip(param1:MouseEvent) : void
      {
         this._tipView.visible = false;
      }
      
      private function changePage(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:SimpleBitmapButton = param1.currentTarget as SimpleBitmapButton;
         switch(_loc2_)
         {
            case this._forwardBtn:
               --this._currentPage;
               if(this._currentPage < 1)
               {
                  this._currentPage = 1;
               }
               break;
            case this._nextBtn:
               ++this._currentPage;
               if(this._currentPage > this._totalPage)
               {
                  this._currentPage = this._totalPage;
               }
         }
         TotemManager.instance.isUpgrade = false;
         this.showPage();
      }
      
      public function refreshView(param1:Boolean) : void
      {
         var _loc2_:TotemDataVo = null;
         var _loc3_:int = 0;
         var _loc4_:TotemDataVo = null;
         if(param1)
         {
            _loc2_ = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
            if(_loc2_ && _loc2_.Page != 1 && _loc2_.Layers == 1 && _loc2_.Location == 1)
            {
               this._windowView.refreshView(_loc2_,this.openSuccessAutoNextPage);
               this.upTotemLvTxt();
            }
            else
            {
               this._windowView.refreshView(_loc2_);
               this.refreshPageBtn();
               this.upTotemLvTxt();
            }
            _loc3_ = 0;
            while(_loc3_ < 7)
            {
               this._propertyList[_loc3_].refresh();
               _loc3_++;
            }
         }
         else
         {
            _loc4_ = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
            this._windowView.openFailHandler(_loc4_);
         }
      }
      
      private function openSuccessAutoNextPage() : void
      {
         ++this._currentPage;
         this.showPage();
      }
      
      private function refreshPageBtn() : void
      {
         var _loc1_:int = TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId);
         this._totalPage = _loc1_ / 70 + 1;
         this._totalPage = this._totalPage > 5 ? int(5) : int(this._totalPage);
         if(this._currentPage == this._totalPage)
         {
            this._nextBtn.enable = false;
         }
         else
         {
            this._nextBtn.enable = true;
         }
         if(this._currentPage == 1)
         {
            this._forwardBtn.enable = false;
         }
         else
         {
            this._forwardBtn.enable = true;
         }
      }
      
      private function showPage() : void
      {
         this.refreshPageBtn();
         this._windowView.show(this._currentPage,TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId),true);
         this._totemTitleFrameBmp.setFrame(this._currentPage);
      }
      
      private function propertyChangeHandler(param1:PlayerPropertyEvent) : void
      {
         this._totalHonorTxt.text = TotemManager.instance.getDisplayNum(PlayerManager.Instance.Self.totemScores);
         this._totalExpTxt.text = TotemManager.instance.getDisplayNum(TotemManager.instance.usableGP);
         var _loc2_:TotemDataVo = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
         if(_loc2_ && PlayerManager.Instance.Self.totemScores < _loc2_.ConsumeHonor)
         {
            this._totalHonorTxt.setTextFormat(new TextFormat(null,null,16711680));
         }
         else if(this._totalHonorTxt.textColor == 16711680)
         {
            this._totalHonorTxt.setTextFormat(new TextFormat(null,null,16499031));
         }
         if(_loc2_ && TotemManager.instance.usableGP < _loc2_.ConsumeExp)
         {
            this._totalExpTxt.setTextFormat(new TextFormat(null,null,16711680));
         }
         else if(this._totalExpTxt.textColor == 16711680)
         {
            this._totalExpTxt.setTextFormat(new TextFormat(null,null,16499031));
         }
      }
      
      private function removeEvent() : void
      {
         this._forwardBtn.removeEventListener(MouseEvent.CLICK,this.changePage);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.changePage);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.propertyChangeHandler);
         this._totemTitleFrameBmp.removeEventListener(MouseEvent.MOUSE_OVER,this._showTip);
         this._totemTitleFrameBmp.removeEventListener(MouseEvent.MOUSE_OUT,this._hideTip);
         this._honorUpIcon.removeEventListener(Event.CLOSE,this.showUserGuilde);
      }
      
      public function showUserGuilde(param1:Event = null) : void
      {
         this._windowView.showUserGuilde();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._windowView = null;
         this._totemTitleBg = null;
         this._forwardBtn = null;
         this._nextBtn = null;
         this._propertyList = null;
         this._totemTitleFrameBmp = null;
         this._honorUpIcon = null;
         this._totalExpBmp = null;
         this._totalExpTxt = null;
         this._totalHonorBmp = null;
         this._totalHonorTxt = null;
         ObjectUtils.disposeObject(this._tipView);
         this._tipView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
