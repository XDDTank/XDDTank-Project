package bagAndInfo.info
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.Price;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.utils.PositionUtils;
   
   public class MoneyInfoView extends Component
   {
       
      
      private var _money:ScaleFrameImage;
      
      private var _info:SelfInfo;
      
      private var _moneyText:FilterFrameText;
      
      private var _type:int;
      
      private var _needAlarm:Boolean;
      
      public function MoneyInfoView(param1:int)
      {
         this._type = param1;
         super();
         this.init();
      }
      
      override protected function init() : void
      {
         super.init();
         this._money = ComponentFactory.Instance.creatComponentByStylename("bagView.MoneyView");
         this._moneyText = ComponentFactory.Instance.creatComponentByStylename("BagMoneyFrameText");
         switch(this._type)
         {
            case Price.MONEY:
               this._money.setFrame(1);
               break;
            case Price.DDT_MONEY:
               this._money.setFrame(2);
               break;
            case Price.GOLD:
               this._money.setFrame(3);
               break;
            case Price.ARMY_EXPLOIT:
               this._money.setFrame(5);
               PositionUtils.setPos(this._moneyText,"ddtbagAndInfo.moneyView.moneytextPos2");
               break;
            case Price.MATCH_MEDAL:
               this._money.setFrame(4);
               PositionUtils.setPos(this._moneyText,"ddtbagAndInfo.moneyView.moneytextPos2");
         }
         PositionUtils.setPos(this._money,"MoneyInfoView.moneybg");
         tipStyle = "ddt.view.tips.OneLineTip";
         tipGapV = 6;
         tipGapH = 6;
         tipDirctions = "0,1,2";
         this.addChildAll();
      }
      
      private function addChildAll() : void
      {
         var _loc1_:int = this.getIndexByType(this._type);
         addChild(this._money);
         this._moneyText.setFrame(!!this._needAlarm ? int(1) : int(_loc1_));
         addChild(this._moneyText);
      }
      
      public function setInfo(param1:SelfInfo) : void
      {
         this._info = param1;
         if(this._info)
         {
            this._needAlarm = false;
            switch(this._type)
            {
               case Price.MONEY:
                  this._moneyText.text = String(this._info.Money);
                  tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoldDirections");
                  break;
               case Price.DDT_MONEY:
                  this._moneyText.text = String(this._info.DDTMoney);
                  tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections");
                  break;
               case Price.GOLD:
                  this._moneyText.text = String(this._info.Gold);
                  tipData = LanguageMgr.GetTranslation("tank.view.bagII.MoneyDirections");
                  break;
               case Price.ARMY_EXPLOIT:
                  this._moneyText.text = String(this._info.armyExploit);
                  this._needAlarm = this._info.armyExploit >= ServerConfigManager.instance.getMedalsLimit()[0];
                  tipData = LanguageMgr.GetTranslation("tank.view.bagII.armyExploitTip",ServerConfigManager.instance.getMedalsLimit()[0]);
                  break;
               case Price.MATCH_MEDAL:
                  this._moneyText.text = String(this._info.matchMedal);
                  this._needAlarm = this._info.matchMedal >= ServerConfigManager.instance.getMedalsLimit()[1];
                  tipData = LanguageMgr.GetTranslation("tank.view.bagII.matchMedal",ServerConfigManager.instance.getMedalsLimit()[1]);
                  break;
               default:
                  this._moneyText.text = "0";
            }
            this._moneyText.setFrame(!!this._needAlarm ? int(1) : int(this.getIndexByType(this._type)));
         }
         else
         {
            this._moneyText.text = "0";
         }
      }
      
      private function getIndexByType(param1:int) : int
      {
         switch(param1)
         {
            case Price.MONEY:
               return 2;
            case Price.DDT_MONEY:
               return 3;
            case Price.GOLD:
               return 4;
            case Price.ARMY_EXPLOIT:
               return 7;
            case Price.MATCH_MEDAL:
               return 8;
            default:
               return -1;
         }
      }
      
      override public function dispose() : void
      {
         if(this._money)
         {
            ObjectUtils.disposeObject(this._money);
            this._money == null;
         }
         if(this._moneyText)
         {
            ObjectUtils.disposeObject(this._moneyText);
         }
         this._moneyText = null;
         this._info = null;
         super.dispose();
      }
   }
}
