package changeColor.view
{
   import baglocked.BaglockedManager;
   import changeColor.ChangeColorCellEvent;
   import changeColor.ChangeColorModel;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ChangeColorRightView extends Sprite implements Disposeable
   {
       
      
      private var _bag:ColorChangeBagListView;
      
      private var _bg1:Scale9CornerImage;
      
      private var _btnBg:Scale9CornerImage;
      
      private var _text1Img:MovieImage;
      
      private var _textImg:FilterFrameText;
      
      private var _shineEffect:IEffect;
      
      private var _changeColorBtn:BaseButton;
      
      private var _model:ChangeColorModel;
      
      public function ChangeColorRightView()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         this.init();
      }
      
      public function dispose() : void
      {
         this._model.removeEventListener(ChangeColorCellEvent.SETCOLOR,this.__updateBtn);
         this._changeColorBtn.removeEventListener(MouseEvent.CLICK,this.__changeColor);
         ObjectUtils.disposeAllChildren(this);
         this._changeColorBtn = null;
         this._bag = null;
         this._model = null;
         EffectManager.Instance.removeEffect(this._shineEffect);
         this._shineEffect = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function set model(param1:ChangeColorModel) : void
      {
         this._model = param1;
         this.dataUpdate();
      }
      
      private function __alertChangeColor(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertChangeColor);
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.totalMoney < ShopManager.Instance.getGoodsByTemplateID(EquipType.COLORCARD).getItemPrice(1).moneyValue)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            this.sendChangeColor();
         }
      }
      
      private function __changeColor(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._model.place != -1)
         {
            this.sendChangeColor();
            this._model.place = -1;
         }
         else if(this.hasColorCard() != -1)
         {
            this._model.place = this.hasColorCard();
            this.sendChangeColor();
            this._model.place = -1;
         }
         else
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("tank.view.changeColor.lackCard",ShopManager.Instance.getGoodsByTemplateID(EquipType.COLORCARD).getItemPrice(1).moneyValue),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__alertChangeColor);
         }
         this._changeColorBtn.enable = false;
      }
      
      private function __updateBtn(param1:Event) : void
      {
         if(!this._model.changed)
         {
            this._changeColorBtn.enable = false;
         }
         else
         {
            this._changeColorBtn.enable = true;
         }
      }
      
      private function dataUpdate() : void
      {
         this._model.addEventListener(ChangeColorCellEvent.SETCOLOR,this.__updateBtn);
         this._bag.setData(this._model.colorEditableBag);
      }
      
      private function hasColorCard() : int
      {
         if(PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(EquipType.COLORCARD) > 0)
         {
            return PlayerManager.Instance.Self.Bag.findFistItemByTemplateId(EquipType.COLORCARD).Place;
         }
         return -1;
      }
      
      private function init() : void
      {
         var _loc1_:Rectangle = null;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.rightViewBgRec");
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("ColorBGAsset4");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.rightViewBgRec1");
         ObjectUtils.copyPropertyByRectangle(this._bg1,_loc1_);
         addChild(this._bg1);
         this._text1Img = ComponentFactory.Instance.creatComponentByStylename("asset.changeColor.label");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.text1ImgRec");
         ObjectUtils.copyPropertyByRectangle(this._text1Img,_loc1_);
         addChild(this._text1Img);
         this._textImg = ComponentFactory.Instance.creatComponentByStylename("asset.changeColor.text2");
         this._textImg.text = LanguageMgr.GetTranslation("tank.view.changeColor.text5");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.textImgRec");
         ObjectUtils.copyPropertyByRectangle(this._textImg,_loc1_);
         addChild(this._textImg);
         this._bag = new ColorChangeBagListView();
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.bagListViewRec");
         ObjectUtils.copyPropertyByRectangle(this._bag,_loc1_);
         addChild(this._bag);
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("changeColor.changeColorBtn.bg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.buttonBgRec");
         ObjectUtils.copyPropertyByRectangle(this._btnBg,_loc1_);
         addChild(this._btnBg);
         this._changeColorBtn = ComponentFactory.Instance.creatComponentByStylename("changeColor.changeColorBtn");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.changeColorBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._changeColorBtn,_loc1_);
         this._changeColorBtn.enable = false;
         addChild(this._changeColorBtn);
         this._changeColorBtn.addEventListener(MouseEvent.CLICK,this.__changeColor);
      }
      
      private function __addToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         var _loc2_:Rectangle = ComponentFactory.Instance.creatCustomObject("changeColor.textImgGlowRec");
         this._shineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this,"asset.changeColor.shine",_loc2_);
         this._shineEffect.stop();
      }
      
      private function sendChangeColor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = BagInfo.EQUIPBAG;
         _loc2_ = this._model.place;
         var _loc3_:int = this._model.currentItem.BagType;
         var _loc4_:int = this._model.currentItem.Place;
         var _loc5_:String = this._model.currentItem.Color;
         var _loc6_:String = this._model.currentItem.Skin;
         var _loc7_:int = EquipType.COLORCARD;
         this._model.initColor = _loc5_;
         this._model.initSkinColor = _loc6_;
         SocketManager.Instance.out.sendChangeColor(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
         this._model.savaItemInfo();
      }
   }
}
