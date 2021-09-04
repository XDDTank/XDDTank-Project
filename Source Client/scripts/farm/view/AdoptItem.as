package farm.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.BasePlayer;
   import ddt.manager.LanguageMgr;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import petsBag.view.item.PetBigItem;
   
   public class AdoptItem extends Component
   {
      
      public static const ADOPT_PET_ITEM_WIDTH:int = 64;
       
      
      protected var _bg:DisplayObject;
      
      protected var _info:PetInfo;
      
      protected var _petMovieItem:PetBigItem;
      
      private var _nameTxt:FilterFrameText;
      
      private var _hasAdoptTip:Bitmap;
      
      private var _enanble:Boolean;
      
      private var _type:int;
      
      private var _vipFlag:VipLevelIcon;
      
      public function AdoptItem(param1:int)
      {
         super();
         this._type = param1;
         this.initView();
         this.initEvent();
         this.enanble = true;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get info() : PetInfo
      {
         return this._info;
      }
      
      public function set info(param1:PetInfo) : void
      {
         this._info = param1;
         this._petMovieItem.info = this._info;
         this._nameTxt.text = Boolean(this._info) ? this._info.Name : "";
         this._vipFlag.visible = this.isVip && this._enanble;
      }
      
      public function get enanble() : Boolean
      {
         return this._enanble;
      }
      
      public function set enanble(param1:Boolean) : void
      {
         this._enanble = param1;
         this._vipFlag.visible = this.isVip && this._enanble;
         this._hasAdoptTip.visible = !this._enanble;
      }
      
      public function get isVip() : Boolean
      {
         return this._type != 0;
      }
      
      protected function initView() : void
      {
         this.buttonMode = true;
         if(this._type > 0)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("assets.farm.petVIPBg");
            addChild(this._bg);
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatBitmap("assets.farm.petNormalBg");
            addChild(this._bg);
         }
         _width = this._bg.width;
         _height = this._bg.height;
         this._petMovieItem = ComponentFactory.Instance.creat("petsBag.petMovieItem");
         this._petMovieItem.tipStyle = "farm.view.tips.AdoptPetTip";
         addChild(this._petMovieItem);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("farm.adoptItemTxt");
         addChild(this._nameTxt);
         this._vipFlag = ComponentFactory.Instance.creat("farm.adoptView.vipIcon");
         var _loc1_:BasePlayer = new BasePlayer();
         _loc1_.IsVIP = true;
         _loc1_.VIPLevel = 5;
         this._vipFlag.setInfo(_loc1_);
         this._vipFlag.tipData = LanguageMgr.GetTranslation("ddt.farms.adoptVIPPetsTip",_loc1_.VIPLevel);
         addChild(this._vipFlag);
         this._hasAdoptTip = ComponentFactory.Instance.creatBitmap("assets.farm.Adopt.hasAdoptTip");
         addChild(this._hasAdoptTip);
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__selectPet);
      }
      
      protected function __selectPet(param1:MouseEvent) : void
      {
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__selectPet);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._petMovieItem);
         this._petMovieItem = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this._info = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._vipFlag);
         this._vipFlag = null;
         ObjectUtils.disposeObject(this._hasAdoptTip);
         this._hasAdoptTip = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
