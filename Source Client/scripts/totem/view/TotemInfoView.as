package totem.view
{
   import bagAndInfo.bag.PlayerPersonView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemInfoView extends Sprite implements Disposeable
   {
       
      
      private var _playerBgMc:MovieClip;
      
      private var _info:PlayerInfo;
      
      private var _pageTitle:ScaleFrameImage;
      
      private var _levelTxtList:Vector.<FilterFrameText>;
      
      private var _txtArray:Array;
      
      private var _currentLevel:int;
      
      private var _currentPage:int;
      
      private var _tipView:TotemLeftWindowChapterTipView;
      
      private var _personView:PlayerPersonView;
      
      public function TotemInfoView(param1:PlayerInfo)
      {
         super();
         this._info = param1;
         this.initView();
         this.initPropTxt();
         this.initEvent();
         this.createChapterTip();
         this.createPersonView();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         this._playerBgMc = ClassUtils.CreatInstance("totem.viewInfoMC");
         PositionUtils.setPos(this._playerBgMc,"totem.playerInfoMcPos");
         this._pageTitle = ComponentFactory.Instance.creatComponentByStylename("totem.viewInfo.Title");
         addChild(this._playerBgMc);
         addChild(this._pageTitle);
         this._currentLevel = TotemManager.instance.getCurrentLv(TotemManager.instance.getTotemPointLevel(this._info.totemId));
         this._currentPage = TotemManager.instance.getCurInfoById(this._info.totemId).Page;
         this._currentPage = this._currentPage == 0 ? int(1) : int(this._currentPage);
         this._pageTitle.setFrame(this._currentPage);
         if(this._info.totemId < 10007)
         {
            _loc1_ = (this._info.totemId - 10000) % 7 + 1;
         }
         else
         {
            _loc1_ = 8;
         }
         this._playerBgMc.gotoAndStop(_loc1_);
      }
      
      private function initEvent() : void
      {
         this._pageTitle.addEventListener(MouseEvent.MOUSE_OVER,this._showTip);
         this._pageTitle.addEventListener(MouseEvent.MOUSE_OUT,this._hideTip);
      }
      
      private function createChapterTip() : void
      {
         this._tipView = new TotemLeftWindowChapterTipView();
         this._tipView.visible = false;
         LayerManager.Instance.addToLayer(this._tipView,LayerManager.GAME_TOP_LAYER);
      }
      
      private function createPersonView() : void
      {
         this._personView = ComponentFactory.Instance.creat("bagAndInfo.PlayerPersonView");
         PositionUtils.setPos(this._personView,"totemInfoView.PlayerPersonView.pos");
         this._personView.info = this._info;
         this._personView.setHpVisble(false);
         addChild(this._personView);
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
      
      private function initPropTxt() : void
      {
         var _loc5_:FilterFrameText = null;
         var _loc1_:String = LanguageMgr.GetTranslation("ddt.totem.sevenProperty");
         this._txtArray = _loc1_.split(",");
         this._levelTxtList = new Vector.<FilterFrameText>();
         var _loc2_:TotemDataVo = TotemManager.instance.getCurInfoById(this._info.totemId);
         _loc2_.ID += 1;
         var _loc3_:Array = TotemManager.instance.getCurrentLvList(TotemManager.instance.getTotemPointLevel(this._info.totemId),this._currentPage,_loc2_);
         var _loc4_:int = 1;
         while(_loc4_ <= 7)
         {
            _loc5_ = ComponentFactory.Instance.creatComponentByStylename("totem.totemWindow.propertyName" + _loc4_);
            this._levelTxtList.push(_loc5_);
            PositionUtils.setPos(_loc5_,"totem.viewInfoPropTxtPos" + _loc4_);
            _loc5_.text = LanguageMgr.GetTranslation("ddt.totem.totemWindow.propertyLvTxt",_loc3_[_loc4_ - 1],this._txtArray[_loc4_ - 1] + "+" + TotemManager.instance.getAddValue(_loc4_,TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(this._info.totemId))));
            addChild(_loc5_);
            _loc4_++;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._pageTitle.removeEventListener(MouseEvent.MOUSE_OVER,this._showTip);
         this._pageTitle.removeEventListener(MouseEvent.MOUSE_OUT,this._hideTip);
         this._playerBgMc = null;
         this._pageTitle = null;
         this._info = null;
         this._levelTxtList = null;
         ObjectUtils.disposeObject(this._tipView);
         this._tipView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
