package ddt.view
{
   import bagAndInfo.bag.RichesButton;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   
   public class CommonMoneyView extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _money:ScaleFrameImage;
      
      private var _info:SelfInfo;
      
      private var _goldText:FilterFrameText;
      
      private var _moneyText:FilterFrameText;
      
      private var _giftText:FilterFrameText;
      
      private var _medalText:FilterFrameText;
      
      private var _goldButton:RichesButton;
      
      private var _giftButton:RichesButton;
      
      private var _moneyButton:RichesButton;
      
      private var _medalButton:RichesButton;
      
      private var _type:int;
      
      public function CommonMoneyView(param1:int)
      {
         super();
         this._type = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("CommonMoneyView.moneyViewBG");
         addChild(this._bg);
         this._money = ComponentFactory.Instance.creatComponentByStylename("bagView.MoneyView");
         this._moneyText = ComponentFactory.Instance.creatComponentByStylename("BagMoneyInfoText");
         this._goldText = ComponentFactory.Instance.creatComponentByStylename("BagGoldInfoText");
         this._giftText = ComponentFactory.Instance.creatComponentByStylename("BagGiftInfoText");
         this._goldButton = ComponentFactory.Instance.creatCustomObject("CommonMoneyView.GoldButton");
         this._giftButton = ComponentFactory.Instance.creatCustomObject("CommonMoneyView.GiftButton");
         this._moneyButton = ComponentFactory.Instance.creatCustomObject("CommonMoneyView.MoneyButton");
         this._medalButton = ComponentFactory.Instance.creatCustomObject("CommonMoneyView.MedalButton");
         PositionUtils.setPos(this._bg,"MoneyInfoView.bg");
         PositionUtils.setPos(this._money,"MoneyInfoView.moneybg");
         PositionUtils.setPos(this._moneyText,"CommonMoneyView.text");
         PositionUtils.setPos(this._goldText,"CommonMoneyView.text");
         PositionUtils.setPos(this._giftText,"CommonMoneyView.text");
         PositionUtils.setPos(this._goldButton,"MoneyInfoView.tip");
         PositionUtils.setPos(this._giftButton,"MoneyInfoView.tip");
         PositionUtils.setPos(this._moneyButton,"MoneyInfoView.tip");
         this.addChildAll();
      }
      
      private function addChildAll() : void
      {
         if(this._type == 1)
         {
            this._money.setFrame(1);
            addChild(this._money);
            addChild(this._moneyText);
            addChild(this._goldButton);
            this._goldButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoldDirections");
         }
         else if(this._type == 2)
         {
            this._money.setFrame(2);
            addChild(this._money);
            addChild(this._giftText);
            addChild(this._giftButton);
            this._giftButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections");
         }
         else if(this._type == 3)
         {
            this._money.setFrame(3);
            addChild(this._money);
            addChild(this._goldText);
            addChild(this._moneyButton);
            this._moneyButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.MoneyDirections");
         }
      }
      
      public function setInfo(param1:SelfInfo) : void
      {
         this._info = param1;
         if(this._info)
         {
            this._goldText.text = String(this._info.Gold);
            this._moneyText.text = String(this._info.Money);
            this._giftText.text = String(this._info.DDTMoney);
         }
         else
         {
            this._goldText.text = this._moneyText.text = this._giftText.text = "";
         }
      }
      
      public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg == null;
         }
         if(this._money)
         {
            ObjectUtils.disposeObject(this._money);
            this._money == null;
         }
         if(this._goldText)
         {
            ObjectUtils.disposeObject(this._goldText);
         }
         this._goldText = null;
         if(this._moneyText)
         {
            ObjectUtils.disposeObject(this._moneyText);
         }
         this._moneyText = null;
         if(this._giftText)
         {
            ObjectUtils.disposeObject(this._giftText);
         }
         this._giftText = null;
         if(this._goldButton)
         {
            ObjectUtils.disposeObject(this._goldButton);
         }
         this._goldButton = null;
         if(this._giftButton)
         {
            ObjectUtils.disposeObject(this._giftButton);
         }
         this._giftButton = null;
         if(this._moneyButton)
         {
            ObjectUtils.disposeObject(this._moneyButton);
         }
         this._moneyButton = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
